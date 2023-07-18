*-----------------------------------------------------------------------------
* <Rating>10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.CRE.ARR.AUTH.SPLIT(Y.OFS.SOURCE.ID)
*------------------------------------------------------------------------------------------------------------------
* Developer    : hpasquel@temenos.com
* Date         : 2011-01-11
* Description  : REDO.CREATE.ARRANGEMENT application, AUTHORISE stage
*                - Create LIMIT and its LIMIT PARENT
*                - Create COLLATERAL.RIGHT and its COLLATERAL related to the child LIMIT
*                - Kept on R.OFS.REC.REV the OFS statements to do the reverse
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
*      Y.OFS.SOURCE.ID              Ofs.Source ID to pass to BULK.MANAGER
*      R.NEW                        Common Variable with current Application Info
* Out :
*      E         (common)  a message error
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : DYN.TO.OFS
*             REDO.CRE.ARR.AUTH.GET.LIM.COLL
* Called By : REDO.CREATE.ARRANGEMENT.AUTHORISE
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.0            2011-01-11      hpasquel          First Version
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON
*
    $INSERT I_F.LIMIT
    $INSERT I_F.COLLATERAL.RIGHT
    $INSERT I_F.COLLATERAL
    $INSERT I_F.OFS.SOURCE
*
    $INSERT RAD.BP I_RAPID.APP.DEV.COMMON
*
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
*
    GOSUB INITIALISE
    CALL REDO.CRE.ARR.AUTH.GET.LIM.COLL
    IF END.ERROR THEN
        CALL OCOMO("OMMITING PROCESSING")
        RETURN
    END
    GOSUB PROCESS
    RETURN
*------------------------------------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------------------------------------
* LIMITS
    FN.LIMIT = 'F.LIMIT'
    F.LIMIT = ''
    CALL OPF(FN.LIMIT,F.LIMIT)
    R.OFS.REC.REV = ''
    Y.VER.LIMIT = "APAP"
    Y.VER.COLL.RIGHT = "APAP"
    COMP.SEP = ','
    SUB.COMP.SEP = '/'
*      Y.OFS.SOURCE = "APAP.B.180.OFS"
* This helps to determine if was called from BULK.MANAGER
    Y.BM.CAN.BE.USED = OFS$SOURCE.REC  AND OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> MATCHES 'TELNET'
*
    RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS:
* Main Process
*------------------------------------------------------------------------------------------------------------------
*
    Y.RETRY.NEXT.LIM.SEQ = '1'          ;* If the parent.limit already exists, and this is in a different currency, then try to use the next sequence
    E = ''
    Y.APPLICATION = 'LIMIT'
    LOOP
        GOSUB CHECK.LIMIT.CREATION
    WHILE Y.RETRY.NEXT.LIM.SEQ EQ '1' AND E = ''
    REPEAT
*
    IF E NE '' THEN
        RETURN
    END

    GOSUB CHECK.COLL.CREATION
    IF E NE '' THEN
        RETURN
    END
*

    RETURN
*------------------------------------------------------------------------------------------------------------------
CHECK.LIMIT.CREATION:
* Create OFS.MESSAGE for LIMIT application
*------------------------------------------------------------------------------------------------------------------
*
    ADDNL.INFO.INP = ""
    ADDNL.INFO.INP<1,1> = Y.VER.LIMIT
    ADDNL.INFO.INP<1,2> = "I"
    ADDNL.INFO.INP<2,1> = "PROCESS"
    ADDNL.INFO.INP<2,6> = "0"
*
    ADDNL.INFO.REV = ""
    ADDNL.INFO.REV<1,1> = Y.VER.LIMIT
    ADDNL.INFO.REV<1,2> = "R"
    ADDNL.INFO.REV<2,1> = "PROCESS"
    ADDNL.INFO.REV<2,6> = "0"
*
    R.LIMIT = ''
    YERR = ''
*
    Y.CUSTOMER.ID  = R.NEW(REDO.FC.CUSTOMER)
    Y.INTRNL.AMT = R.NEW(REDO.FC.INTRNL.AMT)
    Y.LIM.EXP.DATE = R.NEW(REDO.FC.LIM.EXP.DATE)
    Y.LIMIT.REF.ID = R.NEW(REDO.FC.LIMIT)
    Y.APPVL.DATE = R.NEW(REDO.FC.APPRVL.DATE)
    Y.OFFER.UNTIL = R.NEW(REDO.FC.OFFRD.UNTIL)
    Y.NOTES = R.NEW(REDO.FC.NOTES)
    Y.INTRNL.AMT = R.NEW(REDO.FC.INTRNL.AMT)
    Y.MAX.TOTAL  = R.NEW(REDO.FC.MAX.TOTAL)
    Y.AVAIL.MKR  = R.NEW(REDO.FC.AVAIL.MKR)
    Y.COLL.CODE  = R.NEW(REDO.FC.COLL.CODE)       ;* This indicate if we have or not create a collateral
    Y.CURRENCY   = R.NEW(REDO.FC.LOAN.CURRENCY)
*
********* CREATE PARENT LIMIT
*
    Y.LIMIT.SEQ    = Y.LIMIT.REF.ID[".",2,1]
    Y.LIMIT.ID     = Y.LIMIT.REF.ID[".",1,1]
    Y.LIMIT.ID     = Y.LIMIT.ID[1,LEN(Y.LIMIT.ID)-2]
    Y.LIMIT.ID     = FMT(Y.LIMIT.ID : "00.","7'0'R")
    Y.LIMIT.ID     = Y.CUSTOMER.ID : "." : Y.LIMIT.ID : Y.LIMIT.SEQ
    CALL F.READ(FN.LIMIT, Y.LIMIT.ID, R.LIMIT, F.LIMIT, YERR)
    IF R.LIMIT NE '' THEN
* The current limit was granted for a different Currency, then try with the next available sequence
        IF R.LIMIT<LI.LIMIT.CURRENCY> NE Y.CURRENCY THEN
            Y.LIMIT.SEQ ++
            R.NEW(REDO.FC.LIMIT) = R.NEW(REDO.CR.LIMIT)[".",1,1] : "." : Y.LIMIT.SEQ
            RETURN  ;* Please try again WITH the NEXT sequence on LIMIT.REFERENCE, I can not use GOTO
        END
* Parent Limit already exists then update the INTERNAL.AMOUNT
        R.LIMIT.INP = ''
        R.LIMIT.INP<LI.INTERNAL.AMOUNT>  = R.LIMIT<LI.INTERNAL.AMOUNT> + Y.INTRNL.AMT
        R.LIMIT.INP<LI.MAXIMUM.TOTAL>    = R.LIMIT<LI.INTERNAL.AMOUNT> + Y.INTRNL.AMT
        IF R.LIMIT<LI.EXPIRY.DATE> LT Y.LIM.EXP.DATE THEN
            R.LIMIT.INP<LI.EXPIRY.DATE>   = Y.LIM.EXP.DATE
        END
        Y.OFS.MESSAGE = DYN.TO.OFS(R.LIMIT.INP, "LIMIT", ADDNL.INFO.INP)
        IF ETEXT NE '' THEN
            E = ETEXT
            RETURN
        END
        GOSUB PROCESS.OFS
        IF E NE "" THEN
            RETURN
        END
* In case of reverse we have to restore Limit.Amount and Expiry Data
        R.LIMIT.REV = ''
        R.LIMIT.REV<LI.INTERNAL.AMOUNT>  = R.LIMIT<LI.INTERNAL.AMOUNT>
        R.LIMIT.REV<LI.MAXIMUM.TOTAL>    = R.LIMIT<LI.INTERNAL.AMOUNT>
        R.LIMIT.REV<LI.EXPIRY.DATE>      = R.LIMIT<LI.EXPIRY.DATE>
        ADDNL.INFO.INP<2,4> = Y.LIMIT.ID
        Y.OFS.MESSAGE = DYN.TO.OFS(R.LIMIT.REV, "LIMIT", ADDNL.INFO.INP)
        IF ETEXT NE '' THEN
            E = ETEXT
            RETURN
        END
        INS Y.OFS.MESSAGE BEFORE R.OFS.REC.REV<1>
    END ELSE
* Create a Parent Limit
        Y.IS.CHILD.LIMIT = 0
        GOSUB CREATE.LIMIT.OFS
    END

    IF E NE "" THEN
        RETURN
    END
*
********* CREATE LIMIT
*
    Y.IS.CHILD.LIMIT = 1
    Y.LIMIT.ID = Y.CUSTOMER.ID : "." : FMT(R.NEW(REDO.FC.LIMIT),"10'0'R")
    GOSUB CREATE.LIMIT.OFS
    IF E NE '' THEN
        RETURN
    END

    Y.RETRY.NEXT.LIM.SEQ = '0'          ;* Process Finish, don't re-try

    Y.LIMIT.CHILD.ID =  Y.LIMIT.ID      ;* Id of the Child Limit

    RETURN
*------------------------------------------------------------------------------------------------------------------
CREATE.LIMIT.OFS:
* Write OFS.MESSAGE to create a LIMIT
*------------------------------------------------------------------------------------------------------------------
    R.LIMIT.INP = ''
    R.LIMIT.INP<LI.LIMIT.CURRENCY> = Y.CURRENCY
    R.LIMIT.INP<LI.APPROVAL.DATE>  = Y.APPVL.DATE
    R.LIMIT.INP<LI.OFFERED.UNTIL>  = Y.OFFER.UNTIL
    R.LIMIT.INP<LI.EXPIRY.DATE>    = Y.LIM.EXP.DATE
    R.LIMIT.INP<LI.INTERNAL.AMOUNT>  = Y.INTRNL.AMT
    R.LIMIT.INP<LI.MAXIMUM.TOTAL>    = Y.MAX.TOTAL
    R.LIMIT.INP<LI.NOTES>            = Y.NOTES
    R.LIMIT.INP<LI.AVAILABLE.MARKER> = Y.AVAIL.MKR
    GOSUB GET.REVIEW.DATE

* It's a child limit ? the limit must be a secured limit ?
    IF Y.IS.CHILD.LIMIT AND R.NEW(REDO.FC.SECURED) EQ 'Yes' THEN
        R.LIMIT.INP<LI.FIXED.VARIABLE>   = 'FIXED'
        R.LIMIT.INP<LI.COLLATERAL.CODE> = Y.COLL.CODE
        R.LIMIT.INP<LI.MAXIMUM.SECURED>  = Y.MAX.TOTAL
    END

    ADDNL.INFO.INP<2,4> = Y.LIMIT.ID
    ADDNL.INFO.REV<2,4> = Y.LIMIT.ID

    Y.OFS.MESSAGE = DYN.TO.OFS(R.LIMIT.INP, "LIMIT", ADDNL.INFO.INP)
    IF ETEXT NE '' THEN
        E = ETEXT
        RETURN
    END
    GOSUB PROCESS.OFS
    IF E NE "" THEN
        RETURN
    END
*
    R.LIMIT.REV = ''
    R.LIMIT.REV<LI.EXPIRY.DATE>    = Y.LIM.EXP.DATE
    Y.OFS.MESSAGE = DYN.TO.OFS(R.LIMIT.REV, "LIMIT", ADDNL.INFO.REV)
    IF ETEXT NE '' THEN
        E = ETEXT
        RETURN
    END
    INS Y.OFS.MESSAGE BEFORE R.OFS.REC.REV<1>
    RETURN
*------------------------------------------------------------------------------------------------------------------
CHECK.COLL.CREATION:
* Create OFS.MESSAGE for COLLATERAL INFO application
*------------------------------------------------------------------------------------------------------------------
    Y.COL.RIGHT.ID = R.NEW(REDO.FC.COLL.RIGHT.ID)
    Y.COL.CODE = R.NEW(REDO.FC.COLL.CODE)
    Y.VALIDITY.DT = R.NEW(REDO.FC.VALIDITY.DT)
    Y.EXPIRY.DT = R.NEW(REDO.FC.CRIGHT.EXP.DT)
    Y.LIMIT = R.NEW(REDO.FC.LIMIT)
    Y.CUSTOMER.ID  = R.NEW(REDO.FC.CUSTOMER)
*    Y.SEC.HOLD.IDEN = R.NEW(REDO.FC.SEC.HOLD.IDEN)
    Y.REVIEW.DT.FQU = R.NEW(REDO.FC.REVIEW.DT.FQU)

    IF R.NEW(REDO.FC.SECURED) NE 'Yes' THEN       ;* Collateral has not be created ?
        RETURN
    END
*
    ADDNL.INFO.INP = ""
    ADDNL.INFO.INP<1,1> = Y.VER.COLL.RIGHT
    ADDNL.INFO.INP<1,2> = "I"
    ADDNL.INFO.INP<2,1> = "PROCESS"
    ADDNL.INFO.INP<2,6> = "0"
*
    ADDNL.INFO.REV = ""
    ADDNL.INFO.REV<1,1> = Y.VER.COLL.RIGHT
    ADDNL.INFO.REV<1,2> = "R"
    ADDNL.INFO.REV<2,1> = "PROCESS"
    ADDNL.INFO.REV<2,6> = "0"
*
    R.COLL.RIGHT = ''
    R.COLL.RIGHT<COLL.RIGHT.COLLATERAL.CODE> = Y.COL.CODE
    R.COLL.RIGHT<COLL.RIGHT.VALIDITY.DATE>   = Y.VALIDITY.DT
    R.COLL.RIGHT<COLL.RIGHT.EXPIRY.DATE>     = Y.EXPIRY.DT
    R.COLL.RIGHT<COLL.RIGHT.LIMIT.REFERENCE> = Y.LIMIT.CHILD.ID
    R.COLL.RIGHT<COLL.RIGHT.CUSTOMER> = Y.CUSTOMER.ID       ;* The limit was create for this customer automatically

    ADDNL.INFO.INP<2,4> = Y.COL.RIGHT.ID
    Y.OFS.MESSAGE = DYN.TO.OFS(R.COLL.RIGHT, "COLLATERAL.RIGHT", ADDNL.INFO.INP)
    IF ETEXT NE '' THEN
        E = ETEXT
        RETURN
    END
    Y.APPLICATION = 'COLLATERAL.RIGHT'
    GOSUB PROCESS.OFS
    IF E NE "" THEN
        RETURN
    END
*
    R.COLL.RIGHT.REV = ''
    ADDNL.INFO.REV<2,4> = Y.COL.RIGHT.ID
    R.COLL.RIGHT.REV<COLL.RIGHT.COLLATERAL.CODE> = Y.COL.CODE
    Y.OFS.MESSAGE = DYN.TO.OFS(R.COLL.RIGHT.REV, "COLLATERAL.RIGHT", ADDNL.INFO.REV)
    IF ETEXT NE '' THEN
        E = ETEXT
        RETURN
    END
    INS Y.OFS.MESSAGE BEFORE R.OFS.REC.REV<1>
*
* << This was taken from ORIGINAL code from REDO.CREATE.ARRANGEMENT.AUTHORISE
    Y.SECURITY.NUM = R.NEW(REDO.FC.SEC.NO)
*      Y.COLLATERAL.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC)
    Y.APPLN.ID = R.NEW(REDO.FC.APPLN.ID)
    Y.EXECUTION.VALUE = R.NEW(REDO.FC.SEC.EXE.VAL)
    Y.COLLATERAL.CODE = R.NEW(REDO.FC.COLL.CODE)
*
    Y.CREATE.DATE = R.NEW(REDO.FC.SEC.CREATE.DT)
    Y.GRANTING.DATE = R.NEW(REDO.FC.GRANTING.DT)
    Y.EXEC.DATE = R.NEW(REDO.FC.EXECUTING.DT)
    Y.COL.EXP.DATE = R.NEW(REDO.FC.COLL.EXP.DT)
    Y.SEC.IDENT = R.NEW(REDO.FC.SEC.IDENT)
    Y.DESIGN.NO = R.NEW(REDO.FC.DESIGNATION.NO)
    Y.SOLOR.NO = R.NEW(REDO.FC.SOLAR.NO)
    Y.BLOCK.NO = R.NEW(REDO.FC.BLOCK.NO)
    Y.CADAS.DIST = R.NEW(REDO.FC.CADASTRAL.DIST)
    Y.COUNTRY = R.NEW(REDO.FC.COUNTRY)
*Y.PROVINCES = R.NEW(REDO.FC.PROVINCES)
    Y.CITY = R.NEW(REDO.FC.CITY)
    Y.SECTOR = R.NEW(REDO.FC.SECTOR)
    Y.ADDRESS = R.NEW(REDO.FC.ADDRESS)
    Y.PROP.DESC = R.NEW(REDO.FC.PROP.DESCR)
    Y.PROP.DESC2 = R.NEW(REDO.FC.PROP.DESC.2)
    Y.INSUR.POLICY = R.NEW(REDO.FC.INSUR.POLICY)
*    Y.POLICY.DUE.DATE = R.NEW(REDO.FC.POLICY.DUE.DT)
    Y.SEC.HOLD.IDENT = R.NEW(REDO.FC.SEC.HOLD.IDEN)
    Y.COL.VAL.DATE = R.NEW(REDO.FC.VAL.DATE)
    Y.SEC.STATUS = R.NEW(REDO.FC.SEC.STATUS)
    Y.SEC.VALUE = R.NEW(REDO.FC.SEC.VALUE)
    Y.SEC.EXE.VAL = R.NEW(REDO.FC.SEC.EXE.VAL)
    Y.GEN.LEDGER.VAL = R.NEW(REDO.FC.GEN.LEDGER.VAL)
    Y.LAND.AREA = R.NEW(REDO.FC.LAND.AREA)
    Y.LAND.UNIT.VALUE = R.NEW(REDO.FC.LAND.UNIT.VAL)
    Y.TOTAL.LAND.VALUE = R.NEW(REDO.FC.TOTAL.LAND.VAL)
    Y.BUILDING.AREA = R.NEW(REDO.FC.BUILDING.AREA)
    Y.BUILD.UNI.VAL = R.NEW(REDO.FC.BUILD.UNI.VAL)
    Y.TOT.BUILD.AREA = R.NEW(REDO.FC.TOT.BUILD.AREA)
    Y.YRS.OF.BUILD = R.NEW(REDO.FC.YRS.OF.BUILD)
    Y.TOT.DEPRIC = R.NEW(REDO.FC.TOT.DEPRIC)
    Y.DEPRIC.VAL = R.NEW(REDO.FC.DEPRIC.VAL)
*Y.TOT.VALUATION = R.NEW(REDO.FC.TOT.VALUATION)
    Y.ENCUMBRANCE.VAL = R.NEW(REDO.FC.ENCUMB.VAL)
    Y.LOAN.MAX.PERC = R.NEW(REDO.FC.LOAN.MAX.PERC)
*Y.LOAN.MAX.VALUE = R.NEW(REDO.FC.LOAN.MAX.VALUE)
    Y.CURRENCY = R.NEW(REDO.FC.COLL.CURRENCY)
    Y.NOTES = R.NEW(REDO.FC.REMARKS)
    Y.SEC.CLASSIFY = R.NEW(REDO.FC.SEC.CLASSIFY)
    Y.INSMNT.ISS.ENTY = R.NEW(REDO.FC.INSMNT.ISS.ENTY)
*Y.TYPE.OF.INSMNT = R.NEW(REDO.FC.TYPE.OF.INSMNT)
    Y.INSMNT.NO = R.NEW(REDO.FC.INSMNT.NO)
    Y.NATIONAL.TAXPYR = R.NEW(REDO.FC.NATIONAL.TAXPYR)
    Y.INSMNT.DUE.DT = R.NEW(REDO.FC.INSMNT.DUE.DT)
    Y.SEC.HOLD.NAME = R.NEW(REDO.FC.SEC.HOLD.NAME)
    Y.ISSUR.ENT.INMNT = R.NEW(REDO.FC.ISSUR.ENT.INMNT)
    Y.SEC.REGISTER = R.NEW(REDO.FC.SEC.REGISTER)
    Y.SEC.DESC = R.NEW(REDO.FC.SEC.DESCRIPT)
    Y.VALUATOR.NAME = R.NEW(REDO.FC.VALUATOR.NAME)
    Y.VALUATN.DUE.DT = R.NEW(REDO.FC.VALUATN.DUE.DT)
    Y.LN.DEBTOR.ID = R.NEW(REDO.FC.LN.DEBTOR.ID)
    Y.LN.DEBTOR.NAME = R.NEW(REDO.FC.LN.DEBTOR.NAME)
    Y.LN.DEBTR.LGL.ID = R.NEW(REDO.FC.LN.DEBTR.LGL.ID)
    Y.GUARNTR.ID = R.NEW(REDO.FC.GUARNTR.ID)
    Y.GUARNTR.NAME = R.NEW(REDO.FC.GUARNTR.NAME)
    Y.GUARNTR.LGL.ID = R.NEW(REDO.FC.GUARNTR.LGL.ID)
    Y.TYPE.OF.GUARNTR = R.NEW(REDO.FC.TYP.OF.GUARNTR)

    OFS.STR.COL =  'COLLATERAL,APAP/I/PROCESS//0,/,':Y.SECURITY.NUM:',COLLATERAL.TYPE:1:1:=':Y.SEC.CLASSIFY:',APPLICATION.ID:1:1:=':Y.APPLN.ID:',EXECUTION.VALUE:1:1:=':Y.EXECUTION.VALUE:',COLLATERAL.CODE:1:1:=':Y.COLLATERAL.CODE
    OFS.STR.COL := ',VALUE.DATE:1:1:=':Y.CREATE.DATE
    OFS.STR.COL := ',L.COL.GT.DATE:1:1:=':Y.GRANTING.DATE:',L.COL.EXE.DATE:1:1:=':Y.EXEC.DATE:',EXPIRY.DATE:1:1:=':Y.COL.EXP.DATE
    OFS.STR.COL := ',L.COL.SEC.IDEN:1:1:=':Y.SEC.IDENT:',L.COL.DESG.NO:1:1:=':Y.DESIGN.NO:',L.COL.SOLAR.NO:1:1:=':Y.SOLOR.NO
    OFS.STR.COL := ',L.COL.BLOCK.NO:1:1:=':Y.BLOCK.NO:',L.COL.CAD.DIST:1:1:=':Y.CADAS.DIST:',COUNTRY:1:1:=':Y.COUNTRY
    OFS.STR.COL := ',L.COL.CITY:1:1:=':Y.CITY:',L.COL.SECTOR:1:1:=':Y.SECTOR:',ADDRESS:1:1:=':Y.ADDRESS
    OFS.STR.COL := ',L.COL.PROP.DESC:1:1:=':Y.PROP.DESC:',L.COL.PRO.DESC2:1:1:=':Y.PROP.DESC2:',L.COL.INS.PLCY:1:1:=':Y.INSUR.POLICY
    OFS.STR.COL := ',L.COL.SEC.HOLD:1:1:=':Y.SEC.HOLD.IDENT:',L.COL.VAL.DATE:1:1:=':Y.COL.VAL.DATE
    OFS.STR.COL := ',L.COL.REVIEW.DT:1:1:=':Y.REVIEW.DT.FQU:',L.COL.SEC.STA:1:1:=':Y.SEC.STATUS:',NOMINAL.VALUE:1:1:=':Y.SEC.VALUE
    OFS.STR.COL := ',EXECUTION.VALUE:1:1:=':Y.EXECUTION.VALUE:',L.COL.GEN.LED:1:1:=':Y.GEN.LEDGER.VAL
    OFS.STR.COL := ',L.COL.LAND.AREA:1:1:=':Y.LAND.AREA:',L.COL.LAND.VAL:1:1:=':Y.LAND.UNIT.VALUE:',L.COL.TO.LND.VA:1:1:=':Y.TOTAL.LAND.VALUE
    OFS.STR.COL := ',L.COL.BLD.AREA:1:1:=':Y.BUILDING.AREA:',L.COL.BLD.VALUE:1:1:=':Y.BUILD.UNI.VAL:',L.COL.TOT.BD.AR:1:1:=':Y.TOT.BUILD.AREA
    OFS.STR.COL := ',L.COL.YR.BLDING:1:1:=':Y.YRS.OF.BUILD:',L.COL.TOTAL.DEP:1:1:=':Y.TOT.DEPRIC:',L.COL.DEP.VALUE:1:1:=':Y.TOT.DEPRIC
    OFS.STR.COL := ',L.COL.ENCUM.VAL:1:1:=':Y.ENCUMBRANCE.VAL:',L.COL.LN.MX.PER:1:1:=':Y.LOAN.MAX.PERC
    OFS.STR.COL := ',CURRENCY:1:1:=':Y.CURRENCY:',NOTES:1:1:=':Y.NOTES
    OFS.STR.COL := ',L.COL.SEC.CLASS:1:1:=':Y.SEC.CLASSIFY:',L.COL.ISS.ENTY:1:1:=':Y.INSMNT.ISS.ENTY
    OFS.STR.COL := ',L.COL.INVST.NO:1:1:=':Y.INSMNT.NO:',L.COL.NAT.TAX:1:1:=':Y.NATIONAL.TAXPYR:',APPLICATION.ID:1:1:=':Y.APPLN.ID
    OFS.STR.COL := ',L.COL.INVST.DT:1:1:=':Y.INSMNT.DUE.DT:',L.COL.SE.HLD.NA:1:1:=':Y.SEC.HOLD.NAME
    OFS.STR.COL := ',L.COL.ENTY.INS:1:1:=':Y.ISSUR.ENT.INMNT:',L.COL.SEC.REG:1:1:=':Y.SEC.REGISTER:',L.COL.SEC.DESC:1:1:=':Y.SEC.DESC
    OFS.STR.COL := ',L.COL.VALU.NAM:1:1:=':Y.VALUATOR.NAME:',L.COL.DEBTOR.ID:1:1:=':Y.LN.DEBTOR.ID
    OFS.STR.COL := ',L.COL.DEBTOR.NA:1:1:=':Y.LN.DEBTOR.NAME:',L.COL.DBR.LEGID:1:1:=':Y.LN.DEBTR.LGL.ID:',L.COL.GUAR.ID:1:1:=':Y.GUARNTR.ID
    OFS.STR.COL := ',L.COL.GUAR.NAME:1:1:=':Y.GUARNTR.NAME:',L.COL.GUR.LEGID:1:1:=':Y.GUARNTR.LGL.ID:',L.COL.GUAR.TYPE:1:1:=':Y.TYPE.OF.GUARNTR
* << hpasquel Code. START
    Y.OFS.MESSAGE = OFS.STR.COL
    Y.APPLICATION = 'COLLATERAL'
    GOSUB PROCESS.OFS

*     Y.OFS.MESSAGE = 'COLLATERAL,APAP/R/PROCESS//0,/,':Y.SECURITY.NUM
*     INS Y.OFS.MESSAGE BEFORE R.OFS.REC.REV<1>

* >>
    RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS.OFS:
* Execute Valina OFS Message trhoug GLOBUS.MANAGER
* and check if the TXN was success, otherwise reverse their dependences
*------------------------------------------------------------------------------------------------------------------
    IF Y.BM.CAN.BE.USED THEN
        options = Y.OFS.SOURCE.ID : FM : "OFS"
        theRequest = Y.OFS.MESSAGE
        txnCommitted = ''
        Y.OFS.MESSAGE = ''
        CALL OFS.CALL.BULK.MANAGER(options, theRequest, Y.OFS.MESSAGE, txnCommitted)
    END ELSE
        E = ''
        GOSUB COMMON.SAVE
        CALL OFS.GLOBUS.MANAGER(Y.OFS.SOURCE.ID, Y.OFS.MESSAGE)
        GOSUB COMMON.RESTORE
        FIRST.MSG.BIT = Y.OFS.MESSAGE[COMP.SEP,1,1]
        SUCCESS.FAIL = FIRST.MSG.BIT[SUB.COMP.SEP,3,1]
        IF SUCCESS.FAIL NE '1' THEN
            GOSUB ADD.RESPONSE.ANSWER
            GOSUB COMMON.SAVE
            LOOP
                REMOVE Y.OFS.MESSAGE FROM R.OFS.REC.REV SETTING Y.MARK
            WHILE Y.MARK : Y.OFS.MESSAGE
                CALL OFS.GLOBUS.MANAGER(Y.OFS.SOURCE.ID, Y.OFS.MESSAGE)
            REPEAT
            GOSUB COMMON.RESTORE
            E = "ST-REDO.CRE.ARR.CREATING.LIMIT.COLL" : VM : "LIMIT OR COLLATERAL COULD NOT BE CREATED, CHECK LOG"
        END
    END
    RETURN

*------------------------------------------------------------------------------------------------------------------
COMMON.SAVE:
*------------------------------------------------------------------------------------------------------------------
    CALL COMMON.SAVE
    RETURN

*------------------------------------------------------------------------------------------------------------------
COMMON.RESTORE:
*------------------------------------------------------------------------------------------------------------------
    CALL COMMON.RESTORE
    RETURN
*------------------------------------------------------------------------------------------------------------------
ADD.RESPONSE.ANSWER:
* Show to the user the real error message
*------------------------------------------------------------------------------------------------------------------
    Y.RESP = Y.OFS.MESSAGE[",",2,99]
    IF Y.RESP EQ '' THEN
        Y.RESP = Y.OFS.MESSAGE
    END
    TEXT = Y.APPLICATION : '-' : Y.RESP
    CALL REM
    RETURN
*------------------------------------------------------------------------------------------------------
GET.REVIEW.DATE:
* By default the REVIEW.DATE is one year after today
*------------------------------------------------------------------------------------------------------
    Y.MAT.DATE = "1Y"
    R.LIMIT.INP<LI.REVIEW.FREQUENCY> = ''
    CALL CALENDAR.DAY(TODAY,'+',Y.MAT.DATE)
    IF Y.MAT.DATE GT R.LIMIT.INP<LI.EXPIRY.DATE> THEN
        R.LIMIT.INP<LI.REVIEW.FREQUENCY> = R.LIMIT.INP<LI.EXPIRY.DATE> : "M0101"
    END
    RETURN
*------------------------------------------------------------------------------------------------------------------
END
