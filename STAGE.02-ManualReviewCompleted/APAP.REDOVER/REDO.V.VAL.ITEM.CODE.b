* @ValidationCode : MjoxMDM2OTczMDQyOkNwMTI1MjoxNjgxNzI5MDkzMzUxOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 16:28:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.ITEM.CODE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.VAL.ITEM.CODE
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is validation routine to ACCOUNT.2 or CREDIT.ACCOUNT
* in below versions,
* FUNDS.TRANSFER,CHQ.TAX
* FUNDS.TRANSFER,CHQ.NO.TAX
* FUNDS.TRANSFER,OTHERS
* TELLER,CHQ.NO.TAX
* TELLER,CHQ.TAX
*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*19.02.2010  H GANESH     ODR-2009-12-0285  INITIAL CREATION
*18-02.2010  KAVITHA      ODR-2009-12-0285  HD1054080
*13-06-2011  GANESH H     13-06-2011        PACS00036499
*16-07-2011  Marimuthu                      PACS00062902
*26-12-2011  Jeeva T                        PACS00172267
*16-03-2012  Jeeva T
*----------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,TNO TO C$T24.SESSION.NO
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.H.ADMIN.CHEQUES
    $INSERT I_F.REDO.H.INVENTORY.PARAMETER
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.ITEM.STOCK.BY.DATE
    $INSERT I_F.REDO.ITEM.STOCK
    $INSERT I_F.REDO.H.REORDER.LEVEL
    $INSERT I_F.DATES
    $INSERT I_F.USER

    Y.CURR.NO = ''
    Y.CURR.NO = R.OLD(FT.CURR.NO)

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB READ.FILE
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB MAIN.PROCESS
    END

RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    Y.ITEM.CODE=''
    Y.NO.INVENTORY = ''

    FN.REDO.ADMIN.CHQ.PARAM='F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM=''

    FN.REDO.H.ADMIN.CHEQUES='F.REDO.H.ADMIN.CHEQUES'
    F.REDO.H.ADMIN.CHEQUES=''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''

    FN.REDO.H.INVENTORY.PARAMETER = 'F.REDO.H.INVENTORY.PARAMETER'
    F.REDO.H.INVENTORY.PARAMETER = ''

    FN.REDO.H.DEPOSIT.RECEIPTS = 'F.REDO.H.DEPOSIT.RECEIPTS'
    F.REDO.H.DEPOSIT.RECEIPTS = ''

    FN.REDO.ITEM.STOCK.BY.DATE = 'F.REDO.ITEM.STOCK.BY.DATE'
    F.REDO.ITEM.STOCK.BY.DATE = ''

    FN.REDO.ITEM.SERIES = 'F.REDO.ITEM.SERIES'
    F.REDO.ITEM.SERIES = ''

    FN.REDO.ITEM.STOCK = 'F.REDO.ITEM.STOCK'
    F.REDO.ITEM.STOCK = ''

    FN.REDO.H.REORDER.LEVEL = 'F.REDO.H.REORDER.LEVEL'
    F.REDO.H.REORDER.LEVEL  = ''
    CALL OPF(FN.REDO.H.REORDER.LEVEL,F.REDO.H.REORDER.LEVEL)

    Y.ITEM.CODE           = '' ; REORDER.LEVEL          = ''
    Y.COUNT.FMT           = '' ; Y.CODE.DEPT            = ''
    R.REDO.ITEM.STOCK.BK  = '' ; R.REDO.ITEM.STOCK      = ''
    R.REDO.ITEM.STOCK     = '' ; Y.VALU                 = V$FUNCTION
    R.PASS.INV            = '' ; LOC.REF.POS            = ''
    Y.CODE.DEPT           = '' ; R.REDO.ACCT.ITEM       = ''
    PGM.FLAG              = '' ; Y.OFS.VAL              = OFS$OPERATION

    GOSUB GET.LOCAL.FIELDS

*PACS00036499-S
    IF  PGM.VERSION EQ ',CHQ.NO.TAX.SAP' OR PGM.VERSION EQ ',CHQ.OTHERS.SAP' THEN
        IF NOT(R.NEW(FT.CREDIT.THEIR.REF)) THEN
            PGM.FLAG=1
        END
    END

*PACS00036499-E
    PROCESS.GOAHEAD = 1
RETURN
*----------------------------------------------------------------------
GET.LOCAL.FIELDS:
*----------------------------------------------------------------------
    LOC.REF.APPLICATION="FUNDS.TRANSFER":@FM:"USER"
    LOC.REF.FIELDS='TRANSACTION.REF':@FM:'L.US.IDC.BR':@VM:'L.US.IDC.CODE'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    TR.REF.POS = LOC.REF.POS<1,1>
    POS.BR.VAL =LOC.REF.POS<2,1>
    POS.DETP.VAL = LOC.REF.POS<2,2>

    Y.BRANCH.LIST = R.USER<EB.USE.LOCAL.REF,POS.BR.VAL>
    Y.DEPT.LIST = R.USER<EB.USE.LOCAL.REF,POS.DETP.VAL>

    LOCATE ID.COMPANY IN Y.BRANCH.LIST<1,1,1> SETTING POS.BR THEN
        Y.CODE.DEPT = Y.DEPT.LIST<1,1,POS.BR>
    END
RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)
    CALL OPF(FN.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.REDO.H.INVENTORY.PARAMETER,F.REDO.H.INVENTORY.PARAMETER)
    CALL OPF(FN.REDO.H.DEPOSIT.RECEIPTS,F.REDO.H.DEPOSIT.RECEIPTS)
    CALL OPF(FN.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE)
    CALL OPF(FN.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES)
    CALL OPF(FN.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK)
RETURN
*----------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*----------------------------------------------------------------------
    IF V$FUNCTION EQ "D" THEN
        IF R.NEW(FT.LOCAL.REF)<1,TR.REF.POS> THEN
            GOSUB REVERSAL.PROCESS
        END
    END
    IF V$FUNCTION EQ "R" THEN
        PROCESS.GOAHEAD = ''
    END
RETURN
*----------------------------------------------------------------------
REVERSAL.PROCESS:
*----------------------------------------------------------------------
    Y.NEXT.AVAILABLE.ID = R.NEW(FT.LOCAL.REF)<1,TR.REF.POS>
    CALL F.READU(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.AVAILABLE.ID,R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,ERR,"")
    IF R.REDO.H.ADMIN.CHEQUES THEN
        CALL F.READU(FN.REDO.ITEM.SERIES,APPLICATION,R.REDO.ITEM.SERIES.APP1,F.REDO.ITEM.SERIES,Y.ERR.APP,'')
        Y.APP.LIST  = FIELDS(R.REDO.ITEM.SERIES.APP1,"*",1,1)
        Y.INV.LIST  = FIELDS(R.REDO.ITEM.SERIES.APP1,"*",2,1)
        Y.DATE.LIST = FIELDS(R.REDO.ITEM.SERIES.APP1,"*",3,1)
        LOCATE ID.NEW IN Y.APP.LIST SETTING POS.APP THEN
            DEL R.REDO.ITEM.SERIES.APP1<POS.APP>
*Y.ID.SERIES = Y.INV.LIST<POS.APP>
            Y.DATE.VAL = Y.DATE.LIST<POS.APP>
            CALL F.WRITE(FN.REDO.ITEM.SERIES,APPLICATION,R.REDO.ITEM.SERIES.APP1)
        END
        GOSUB STOCK.UPD.REV
        GOSUB STOCK.UPD.DATE.REV
        GOSUB ADMIN.TABLE.REV

        PROCESS.GOAHEAD = ''
    END
RETURN
*----------------------------------------------------------------------
STOCK.UPD.REV:
*----------------------------------------------------------------------
    CALL F.READ(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK,Y.ER.ST)
    Y.LIST.ITM = R.REDO.ITEM.STOCK<ITEM.REG.ITEM.CODE>
    Y.ITEM.CODE = FIELD(Y.ID.SERIES,".",2)
    LOCATE Y.ITEM.CODE IN Y.LIST.ITM<1,1> SETTING POS THEN
        R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> = R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> + 1
    END
    CALL F.WRITE(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK)
RETURN
*----------------------------------------------------------------------
ADMIN.TABLE.REV:
*----------------------------------------------------------------------
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS> = "AVAILABLE"
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DATE.UPDATED> = Y.DATE.VAL
    CALL F.WRITE(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.AVAILABLE.ID,R.REDO.H.ADMIN.CHEQUES)
RETURN
*----------------------------------------------------------------------
STOCK.UPD.DATE.REV:
*----------------------------------------------------------------------
    CALL F.READ(FN.REDO.ITEM.STOCK.BY.DATE,Y.ID.SERIES,R.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE,Y.ER.ST1)
    Y.DATE.RPT = TODAY
    IF R.REDO.ITEM.STOCK.BY.DATE THEN
        LOCATE Y.DATE.RPT IN R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,1> SETTING POS.RPT THEN
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT>            =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT> - 1
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT>           =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT> + 1
        END
        CALL F.WRITE(FN.REDO.ITEM.STOCK.BY.DATE,Y.ID.SERIES,R.REDO.ITEM.STOCK.BY.DATE)
    END
    R.REDO.ITEM.SERIES.NEW = ''
    CALL F.READ(FN.REDO.ITEM.SERIES,Y.ID.SERIES,R.REDO.ITEM.SERIES.NEW,F.REDO.ITEM.SERIES,Y.ER.SR)
    R.REDO.ITEM.SERIES.NEW<-1> = R.NEW(FT.CREDIT.THEIR.REF):"*AVAILABLE*":Y.NEXT.AVAILABLE.ID:"*":Y.DATE.VAL
    IF R.REDO.ITEM.SERIES.NEW THEN
        CALL F.WRITE(FN.REDO.ITEM.SERIES,Y.ID.SERIES,R.REDO.ITEM.SERIES.NEW)
    END
RETURN
*----------------------------------------------------------------------
FT.PROCESS:
*----------------------------------------------------------------------
    IF V$FUNCTION  EQ 'A' THEN
        Y.NEXT.ID = R.NEW(FT.LOCAL.REF)<1,TR.REF.POS>
        CALL F.READ(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.ID,R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,ERR)
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.AUTHORISER>= C$T24.SESSION.NO:'_':OPERATOR     ;*R22 AUTO CODE CONVERSION
        CALL F.WRITE(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.ID,R.REDO.H.ADMIN.CHEQUES)
        RETURN
    END


    IF Y.OFS.VAL EQ 'PROCESS' THEN
        GOSUB CHECK.FOR.NEXT.AVALIABLE
        IF NOT(R.NEW(FT.CREDIT.THEIR.REF)) AND NOT(Y.CHE.FOUND) AND NOT(Y.CURR.NO) THEN
            AF = FT.CREDIT.THEIR.REF
            ETEXT = 'EB-REDO.NO.SERIAL'
            CALL STORE.END.ERROR
            RETURN
        END
    END

RETURN
*----------------------------------------------------------------------
READ.FILE:
*----------------------------------------------------------------------
    Y.ACCOUNT=R.NEW(FT.CREDIT.ACCT.NO)
    Y.PARAM.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,Y.PARAM.ID,R.REDO.ADMIN.CHQ.PARAM,PARAM.ERR)

    LOCATE Y.ACCOUNT IN R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,1> SETTING POS1 THEN
        Y.ITEM.CODE=R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ITEM.CODE,POS1>
    END
    IF Y.CODE.DEPT THEN
        Y.ITEM.STOCK.ID = ID.COMPANY:"-":Y.CODE.DEPT
        Y.ITEM.STOCK.ID1 = ID.COMPANY:"-":Y.CODE.DEPT:".":Y.ITEM.CODE
        Y.ID.SERIES = ID.COMPANY:'-':Y.CODE.DEPT:'.':Y.ITEM.CODE
    END ELSE
        Y.ITEM.STOCK.ID = ID.COMPANY
        Y.ITEM.STOCK.ID1 = ID.COMPANY:".":Y.ITEM.CODE
        Y.ID.SERIES = ID.COMPANY:'.':Y.ITEM.CODE
    END
RETURN
*----------------------------------------------------------------------
MAIN.PROCESS:
*----------------------------------------------------------------------

    Y.PARAM.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,Y.PARAM.ID,R.REDO.ADMIN.CHQ.PARAM,PARAM.ERR)

    IF APPLICATION EQ 'FUNDS.TRANSFER' AND NOT(PGM.FLAG) THEN
        GOSUB FT.PROCESS
        GOSUB MIN.LEVEL.CHECK
    END
RETURN
*-------------------------------------------------------------------------------------
SERIES.ASSIGN:
*-------------------------------------------------------------------------------------
    CALL F.READ(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.ID,R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,ERR)
    IF R.REDO.H.ADMIN.CHEQUES THEN
        Y.NEXT.AVAILABLE.ID = R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.SERIAL.NO>
        R.NEW(FT.CREDIT.THEIR.REF) = Y.NEXT.AVAILABLE.ID
        R.NEW(FT.LOCAL.REF)<1,TR.REF.POS> = Y.NEXT.ID
        GOSUB UPDATE.ADMIN.TABLE
    END
RETURN
*-------------------------------------------------------------------------------------
UPDATE.ADMIN.TABLE:
*-------------------------------------------------------------------------------------
    Y.INV.DATE = R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DATE.UPDATED>
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.TRANS.REF> = ID.NEW
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS>= 'ISSUED'
    CURR.NO.VALUE = R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.CURR.NO>
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.CURR.NO>= CURR.NO.VALUE + 1
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.ACCOUNT.NO> = Y.ACCOUNT
    INPUTTER = C$T24.SESSION.NO:'_':OPERATOR     ;*R22 AUTO CODE CONVERSION
    AUTHORISER = C$T24.SESSION.NO:'_':OPERATOR     ;*R22 AUTO CODE CONVERSION
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME
    CHECK.DATE = DATE()
    DATE.TIME = OCONV(CHECK.DATE,"DY2"):OCONV(CHECK.DATE,"DM"):OCONV(CHECK.DATE,"DD"):TEMPTIME
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.INPUTTER>= INPUTTER
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DATE.TIME>= DATE.TIME
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.USER> = OPERATOR
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.AUTHORISER>= C$T24.SESSION.NO:'_':OPERATOR     ;*R22 AUTO CODE CONVERSION
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DATE.UPDATED> = TODAY
    GOSUB INV.STOCK.UPDT
    GOSUB INV.STOCK.UPDT.VAL
    CALL F.WRITE(FN.REDO.H.ADMIN.CHEQUES,Y.NEXT.ID,R.REDO.H.ADMIN.CHEQUES)
    Y.SER.ID = APPLICATION
    CALL F.READ(FN.REDO.ITEM.SERIES,Y.SER.ID,R.REDO.ITEM.SERIES.APP,F.REDO.ITEM.SERIES,Y.ERR)
    R.REDO.ITEM.SERIES.APP<-1> = ID.NEW:'*':Y.NEXT.ID:"*":Y.INV.DATE
    CALL F.WRITE(FN.REDO.ITEM.SERIES,Y.ID.SERIES,R.REDO.ITEM.SERIES)
    CALL F.WRITE(FN.REDO.ITEM.SERIES,Y.SER.ID,R.REDO.ITEM.SERIES.APP)


RETURN
*-------------------------------------------------------------------------------------
CHECK.FOR.NEXT.AVALIABLE:
*-------------------------------------------------------------------------------------

    Y.CHE.FOUND = 1
    LOOP
    WHILE Y.CHE.FOUND EQ 1
        CALL F.READU(FN.REDO.ITEM.SERIES,Y.ID.SERIES,R.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES,Y.ERR,'')
        IF Y.ERR EQ 'RECORD NOT FOUND' THEN
            Y.CHE.FOUND = ''
            Y.NO.INVENTORY  = 1
            RETURN
        END
        IF NOT(Y.ERR) THEN
            Y.CHE.FOUND = ''
        END
        IF R.REDO.ITEM.SERIES AND NOT(Y.ERR) THEN

            Y.SERIES.LIST = FIELDS(R.REDO.ITEM.SERIES,'*',1,1)
            Y.DATE.UPD.LIST = FIELDS(R.REDO.ITEM.SERIES,'*',4,1)

            GOSUB GET.ALL.SERIES

            Y.SORT.VAL = SORT(Y.DATE.VAL.NEW.LIST)
            Y.FINAL.VAL.CH = Y.SORT.VAL<1>
            Y.LEN.FN.VAL = LEN(Y.FINAL.VAL.CH)
            IF Y.LEN.FN.VAL GT 8 THEN
                Y.FINAL.VAL.CH = Y.FINAL.VAL.CH[9,Y.LEN.FN.VAL]
            END
            Y.FINAL.VAL.CH = TRIM(Y.FINAL.VAL.CH,'0','L')
            SEL.LIST1 = ''
            LOCATE Y.FINAL.VAL.CH IN Y.SERIES.LIST SETTING POS.SE THEN
                Y.SEL.LIST = FIELDS(R.REDO.ITEM.SERIES,'*',3,1)
                Y.NEXT.ID = Y.SEL.LIST<POS.SE>
                DEL R.REDO.ITEM.SERIES<POS.SE>
            END
            R.REDO.H.ADMIN.CHEQUES = ''
            GOSUB SERIES.ASSIGN
        END
    REPEAT
RETURN
*-------------------------------------------------------------------------------------
INV.STOCK.UPDT:
*-------------------------------------------------------------------------------------
    R.REDO.ITEM.STOCK = ''
    CALL F.READ(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK,Y.ERR)

    Y.LIST.ITM = R.REDO.ITEM.STOCK<ITEM.REG.ITEM.CODE>

    LOCATE Y.ITEM.CODE IN Y.LIST.ITM<1,1> SETTING POS THEN
        R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> = R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> - 1
    END
    IF R.REDO.ITEM.STOCK<ITEM.REG.BAL,POS> GT 0 THEN
        CALL F.WRITE(FN.REDO.ITEM.STOCK,Y.ITEM.STOCK.ID,R.REDO.ITEM.STOCK)
    END

RETURN
*-------------------------------------------------------------------------------------
INV.STOCK.UPDT.VAL:
*-------------------------------------------------------------------------------------
    Y.DATE.RPT = TODAY
    CALL F.READ(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.ID1,R.REDO.ITEM.STOCK.BY.DATE,F.REDO.ITEM.STOCK.BY.DATE,Y.ERR.FLA)
    IF R.REDO.ITEM.STOCK.BY.DATE THEN
        LOCATE Y.DATE.RPT IN R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,1> SETTING POS.RPT THEN
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT>            =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,POS.RPT> + 1
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT>           =   R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,POS.RPT> - 1
        END ELSE
            Y.DATE.COUNT1 = DCOUNT(R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE>,@VM)
            Y.DATE.COUNT = Y.DATE.COUNT1 + 1

            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.DATE,Y.DATE.COUNT>                = Y.DATE.RPT
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ITEM.CODE,Y.DATE.COUNT>           = Y.ITEM.CODE
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.INITIAL.STOCK,Y.DATE.COUNT>       = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1>
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,Y.DATE.COUNT>            = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.ASSIGNED,Y.DATE.COUNT> + 1
            R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT>           = R.REDO.ITEM.STOCK.BY.DATE<ITEM.RPT.AVALIABLE,Y.DATE.COUNT1> - 1
        END
        CALL F.WRITE(FN.REDO.ITEM.STOCK.BY.DATE,Y.ITEM.STOCK.ID1,R.REDO.ITEM.STOCK.BY.DATE)
    END
RETURN
*-------------------------------------------------------------------------------------
GET.ALL.SERIES:
*-------------------------------------------------------------------------------------

    Y.VAL.CK = ''
    Y.MAX = MAXIMUM(Y.SERIES.LIST)
    Y.LEN = LEN(Y.MAX)
    Y.FMT = 'R%':Y.LEN
    Y.CNT.FMT = 1
    Y.COUNT.FMT = DCOUNT(Y.SERIES.LIST,@FM)
    LOOP
    WHILE Y.CNT.FMT LE Y.COUNT.FMT
        Y.VAL.CK = Y.SERIES.LIST<Y.CNT.FMT>
        Y.SERIES.NEW.LIST<-1> = Y.DATE.UPD.LIST<Y.CNT.FMT>:FMT(Y.SERIES.LIST<Y.CNT.FMT>,Y.FMT)
        IF Y.VAL.CK THEN
            Y.FMT.CHCK.VAL = FMT(Y.SERIES.LIST<Y.CNT.FMT>,Y.FMT)
            Y.DATE.VAL.NEW.LIST<-1> = Y.DATE.UPD.LIST<Y.CNT.FMT>:Y.FMT.CHCK.VAL
        END
        Y.CNT.FMT += 1
    REPEAT
    Y.SORT.VALUE.NEW  = Y.DATE.VAL.NEW.LIST
RETURN
*-------------------------------------------------------------------------------------
MIN.LEVEL.CHECK:
*-------------------------------------------------------------------------------------
*CALL F.READ(FN.REDO.H.REORDER.LEVEL,ID.COMPANY,R.REDO.H.REORDER,F.REDO.H.REORDER.LEVEL,REORDER.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.H.REORDER.LEVEL,ID.COMPANY,R.REDO.H.REORDER,REORDER.ERR) ;*Tus End
    Y.CODE.LIST = R.REDO.H.REORDER<RE.ORD.CODE>
    Y.INIT = 1
    Y.COUNT = DCOUNT(Y.CODE.LIST,@VM)
    LOOP
        REMOVE Y.CODE.ID FROM Y.CODE.LIST SETTING Y.COD.POS
    WHILE Y.INIT LE Y.COUNT
        IF Y.CODE.ID EQ Y.CODE.DEPT THEN
            Y.ITEM.LIST = R.REDO.H.REORDER<RE.ORD.ITEM.VALUE>
            Y.ITEM.LIST = R.REDO.H.REORDER<RE.ORD.ITEM.VALUE,Y.INIT>
            LOCATE Y.ITEM.CODE IN Y.ITEM.LIST<1,1,1> SETTING Y.IT.POS THEN
                Y.REORDER.LEVEL = R.REDO.H.REORDER<RE.ORD.REORDER.LEVEL,Y.INIT,Y.IT.POS>
            END
        END
        Y.INIT += 1
    REPEAT
    IF NOT(Y.CURR.NO) AND NOT(Y.NO.INVENTORY) THEN
        R.REC = DCOUNT(Y.SORT.VALUE.NEW,@FM)
        IF R.REC LE Y.REORDER.LEVEL THEN
            TEXT = 'REDO.MIN.INVENT.LEVEL'
            Y.CUR.CNT = DCOUNT(R.NEW(FT.LOCAL.REF),@VM)
            CALL STORE.OVERRIDE(Y.CUR.CNT+1)
        END
    END
RETURN
*---------------------------------------------------------------------------------------
END
