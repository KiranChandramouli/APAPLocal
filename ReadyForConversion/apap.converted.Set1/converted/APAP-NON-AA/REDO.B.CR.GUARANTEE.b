SUBROUTINE REDO.B.CR.GUARANTEE(Y.FINAL.ARR)
*-----------------------------------------------------------------------------
*
* Developed By            : Vijayarani G
*
* Developed On            : 30-SEP-2013
*
* Development Reference   : 786711(FS-200-DE03)
*
* Development Description : A report containing information on the Collaterals that support the various
*                           Loans reported by the Bank will be developed.
*
* Attached To             : BATCH>BNK/REDO.B.CR.GUARANTEE
*
* Attached As             : COB Routine
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*-----------------------------------------------------------------------------------------------------------------
* PACS00353058          Ashokkumar.V.P                  11/11/2014           Changes the fields based on new mapping
* PACS00460181          Ashokkumar.V.P                  26/05/2015           Changes the fields based on new mapping
* PACS00460181          Ashokkumar.V.P                  02/06/2015           Changes the fields based on new mapping
* PACS00460181          Ashokkumar.V.P                  10/06/2015           Changes the fields based on new mapping
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.COLLATERAL.TYPE
    $INSERT I_REDO.B.CR.GUARANTEE.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS


* </region>
*-----------------------------------------------------------------------------
*
    GOSUB MAIN.PROCESS
RETURN
*
*--------------
MAIN.PROCESS:
**-----------
    Y.AA.ARR.ID = Y.FINAL.ARR
    ARR.ERR       = ""; R.AA.ARRANGEMENT = ""
    CALL AA.GET.ARRANGEMENT(Y.AA.ARR.ID,R.AA.ARRANGEMENT,ARR.ERR)
    Y.IN.DATE  = ""; Y.OUT.DATE = ""; COLLATERAL.ID = ''; C$SPARE(451) = ''
    ARR.ID     = Y.AA.ARR.ID
    Y.MAIN.ARR.STATUS = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
    YSTART.DTE = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
    Y.PROD.GUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.AA.PROD = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>

    IF YSTART.DTE GE YL.TODAY THEN
        RETURN
    END
    IF Y.MAIN.ARR.STATUS NE 'CURRENT' AND Y.MAIN.ARR.STATUS NE 'EXPIRED' THEN
        RETURN
    END
    PROP.CLASS = 'TERM.AMOUNT';    PROP.NAME  = ''; returnConditions = ''; RET.ERR = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID,PROP.CLASS,PROP.NAME,'','',returnConditions,ERR.COND)
    R.AA.TERM.AMOUNT = RAISE(returnConditions)
    COLLATERAL.ID = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,L.AA.COL.POS>
    IF NOT(COLLATERAL.ID) THEN
        GOSUB RAISE.ERR.C.22
        RETURN
    END
    ARRAY.VAL = ''; Y.LOAN.STATUS = ''; Y.CLOSE.LN.FLG = 0
    CALL REDO.RPT.CLSE.WRITE.LOANS(Y.AA.ARR.ID,R.AA.ARRANGEMENT,ARRAY.VAL)
    Y.LOAN.STATUS = ARRAY.VAL<1>
    Y.CLOSE.LN.FLG = ARRAY.VAL<2>
    IF Y.LOAN.STATUS EQ "Write-off" THEN
        RETURN
    END
    IF Y.CLOSE.LN.FLG NE 1 THEN
        GOSUB GET.COMMON.FIELDS
        GOSUB FETCH.COLLATERAL.ID
    END
RETURN

*-----------------
GET.COMMON.FIELDS:
*-----------------
*
    Y.LINKED.APPL    = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL>
    Y.LINKED.APPL.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>

    LOCATE "ACCOUNT" IN Y.LINKED.APPL<1,1> SETTING Y.LINKED.POS THEN
        CHANGE @VM TO @FM IN Y.LINKED.APPL.ID
        Y.NROPRESTAMO  = Y.LINKED.APPL.ID<Y.LINKED.POS>
    END
    Y.ACCT.ID = Y.NROPRESTAMO
    ERR.ACCOUNT = ''; R.ACCOUNT = ''; Y.PREV.ACCOUNT = ''; Y.ALT.ACCT.TYPE= '';Y.ALT.ACCT.ID=''
    Y.ARRAY.VAL = ''; YCONT.DATE = ''; ERR.AA.ACCOUNT.DETAILS = ''; R.AA.ACCOUNT.DETAILS = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    IF ERR.ACCOUNT THEN
        RETURN
    END

    YACCT.GRP = R.ACCOUNT:"###":R.AA.ARRANGEMENT
    CALL REDO.RPT.ACCT.ALT.LOANS(YACCT.GRP,Y.PREV.ACCOUNT)
    IF NOT(Y.PREV.ACCOUNT) THEN
        Y.PREV.ACCOUNT = Y.NROPRESTAMO
        CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR.AA.ACCOUNT.DETAILS)
        YCONT.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.CONTRACT.DATE>
    END ELSE
        YCONT.DATE = R.AA.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE>
    END
    C$SPARE(451) = Y.PREV.ACCOUNT
    GOSUB GET.COMMON.FIELDS.1
RETURN

GET.COMMON.FIELDS.1:
********************
* Get DEBTOR details
    Y.L.CU.DEBTOR.COM = ''
    LOCATE "PRODUCT.GROUP" IN Y.FIELD.NME.ARR<1,1> SETTING PRD.POS THEN
        Y.PRD.VAL.ARR = Y.FIELD.VAL.ARR<1,PRD.POS>
        Y.PRD.DIS.ARR = Y.DISP.TEXT.ARR<1,PRD.POS>
    END
    Y.PRD.VAL.ARR = CHANGE(Y.PRD.VAL.ARR,@SM,@VM)
    Y.PRD.DIS.ARR = CHANGE(Y.PRD.DIS.ARR,@SM,@VM)
    LOCATE Y.PROD.GUP IN Y.PRD.VAL.ARR<1,1> SETTING C.PRD.POS THEN
        Y.L.CU.DEBTOR.COM = Y.PRD.DIS.ARR<1,C.PRD.POS>
    END
    Y.DEBTOR.COMS = ''
RETURN
*----------------------
FETCH.COLLATERAL.ID:
*----------------------
*
* Fetch collateral Ids to process
    COLLATERAL.CNT = DCOUNT(COLLATERAL.ID,@SM)
    LOOP
        REMOVE Y.COLLATERAL.ID FROM COLLATERAL.ID SETTING COLL.POS
    WHILE Y.COLLATERAL.ID:COLL.POS
        Y.CUSTOMER.ID = FIELD(Y.COLLATERAL.ID,".",1)
        CALL F.READ(FN.COLLATERAL,Y.COLLATERAL.ID,R.COLLATERAL,F.COLLATERAL,ERR.COLLATERAL)
        IF R.COLLATERAL THEN
            YCOLL.EXP.DTE = ''; Y.COLLATERAL.CODE = ''; C$SPARE(452) = ''; C$SPARE(453) = ''; C$SPARE(454) = ''; C$SPARE(455) = ''
            C$SPARE(456) = ''; C$SPARE(457) = ''; C$SPARE(458) = ''; C$SPARE(459) = ''; C$SPARE(460) = ''
            C$SPARE(461) = ''; C$SPARE(462) = ''; C$SPARE(463) = ''; C$SPARE(464) = ''; C$SPARE(465) = ''
            C$SPARE(466) = ''; C$SPARE(467) =''; C$SPARE(468) = ''; C$SPARE(469) = ''; C$SPARE(470) = ''
            Y.COLLATERAL.CODE = R.COLLATERAL<COLL.COLLATERAL.CODE>
            YCOLL.EXP.DTE = R.COLLATERAL<COLL.EXPIRY.DATE>
            IF YCOLL.EXP.DTE EQ '' OR YCOLL.EXP.DTE GE TODAY THEN
                GOSUB FETCH.FIELD.VALUES
                GOSUB MAP.RCL.VALUES
            END
        END
        Y.START.CNT += 1
    REPEAT
RETURN
*
*------------------
FETCH.FIELD.VALUES:
*------------------
*--------------------------------------------------------------------
* Fetching the Collateral Description  C(15) and Guarantor Type  C(2)
*--------------------------------------------------------------------
    Y.GUAR.TYPE = ""; Y.COL.DESC = ''; YL.COL.GUAR.ID = ''
    Y.CUST.NAME = ''; Y.CUST.GN.NAME = ''
    Y.COL.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.SEC.IDEN.POS>
    YL.COL.GUAR.ID = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GUAR.ID.POS>
    IF Y.COLLATERAL.CODE EQ "970" THEN
*        Y.GUAR.TYPE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GUAR.TYPE.POS>
        Y.COL.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GUR.LEGID.POS>
    END
    IF YL.COL.GUAR.ID THEN
        Y.PROD.GRP = ""; Y.REL.CODE = ""
        CALL REDO.S.REP.CUSTOMER.EXTRACT(YL.COL.GUAR.ID,Y.PROD.GRP,Y.REL.CODE,Y.OUT.ARR)
        Y.GUAR.TYPE = Y.OUT.ARR<2>
        Y.CUST.NAME = Y.OUT.ARR<3>
        Y.CUST.GN.NAME = Y.OUT.ARR<4>
    END
    C$SPARE(452) = Y.COL.DESC
    C$SPARE(453) = Y.GUAR.TYPE
*
*----------------------------------
* Fetching the Collateral Type  C(2)
*----------------------------------
    LOCATE Y.COLLATERAL.CODE IN Y.COLL.VAL.ARR<1,1> SETTING C.COLL.POS THEN
        C$SPARE(454) = Y.COLL.DIS.ARR<1,C.COLL.POS>
    END
    GOSUB FETCH.FIELD.VALUES.1
RETURN

FETCH.FIELD.VALUES.1:
*********************
*----------------------------------------------------------------------------------------------------------
* Fetching the Collateral Description  C(250), Constitution Date C(10), Date formalization Collateral C(10)
*----------------------------------------------------------------------------------------------------------
*
    Y.COL.ACT.DESC = ''; Y.COLLAT.DESC = ''; Y.COL.EXE.DATE = ''; Y.L.COL.GT.DATE = ''
    Y.L.COL.INVST.TYE = ''; Y.COLLATERAL.TYPE = ''
    Y.COLLAT.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.SEC.DESC.POS>
    Y.L.COL.INVST.TYE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.INVST.TYE.POS>
    Y.COL.ACT.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.PRO.DESC2.POS>
    CHANGE @SM TO ' ' IN Y.COL.ACT.DESC

    IF NOT(Y.COL.ACT.DESC) AND Y.COLLATERAL.CODE NE '100' THEN
        Y.COLLATERAL.TYPE = R.COLLATERAL<COLL.COLLATERAL.TYPE>
        R.COLLATERAL.TYPE = ''; ERR.COLLATERAL.TYPE = ''
        CALL F.READ(FN.COLLATERAL.TYPE,Y.COLLATERAL.TYPE,R.COLLATERAL.TYPE,F.COLLATERAL.TYPE,ERR.COLLATERAL.TYPE)
        Y.COL.ACT.DESC = R.COLLATERAL.TYPE<COLL.TYPE.DESCRIPTION>
    END

    IF Y.COLLATERAL.CODE EQ '100' THEN
        Y.COL.ACT.DESC = Y.L.COL.INVST.TYE
    END

    LOCATE Y.COLLATERAL.CODE IN Y.FETCH.VAL.ARR<1,1> SETTING C.FETC.POS THEN
        Y.IN.DATE = YCONT.DATE
        GOSUB DATE.CONV
        Y.COL.EXE.DATE = Y.OUT.DATE
        Y.L.COL.GT.DATE = Y.OUT.DATE
    END ELSE
        GOSUB GET.VAL.FLD7.8
    END

    Y.IN.DATE  = ""; Y.OUT.DATE = ""
*
    C$SPARE(455) = Y.COL.ACT.DESC
    C$SPARE(456) = Y.L.COL.GT.DATE
    C$SPARE(457) = Y.COL.EXE.DATE
    GOSUB FETCH.FIELD.VALUES.2
RETURN

GET.VAL.FLD7.8:
***************
    Y.IN.DATE  = ""; Y.OUT.DATE = ""
    Y.COL.EXE.DATE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.EXE.DATE.POS>
    Y.IN.DATE = Y.COL.EXE.DATE
    GOSUB DATE.CONV
    Y.COL.EXE.DATE = Y.OUT.DATE
*
    Y.IN.DATE  = ""; Y.OUT.DATE = ""
    Y.L.COL.GT.DATE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GT.DATE.POS>
    Y.IN.DATE = Y.L.COL.GT.DATE
    GOSUB DATE.CONV
    Y.L.COL.GT.DATE = Y.OUT.DATE
    Y.IN.DATE  = ""; Y.OUT.DATE = ""
RETURN

FETCH.FIELD.VALUES.2:
********************
*----------------------------------
* Fetching the Valuation Date C(10) / Valuation Amount N(15,2) / Encumbrance Grade N(1)
*----------------------------------
*
    Y.L.COL.VAL.DATE = ""; Y.L.COL.TOT.VALUA = ""; Y.ECN.NUMBER = ""
    LOCATE Y.COLLATERAL.CODE IN Y.VALUDTE.VAL.ARR<1,1> SETTING C.VALD.POS THEN
        Y.L.COL.VAL.DATE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.VAL.DATE.POS>
        Y.IN.DATE  = ""; Y.OUT.DATE = ""
        Y.IN.DATE = Y.L.COL.VAL.DATE
        GOSUB DATE.CONV
        Y.L.COL.VAL.DATE = Y.OUT.DATE
        Y.IN.DATE  = ""; Y.OUT.DATE = ""
    END

    LOCATE Y.COLLATERAL.CODE IN Y.VALUAMT.VAL.ARR<1,1> SETTING C.VALA.POS THEN
        Y.L.COL.TOT.VALUA = R.COLLATERAL<COLL.NOMINAL.VALUE>
        Y.ECN.NUMBER = R.COLLATERAL<COLL.LOCAL.REF,L.ECN.NUMBER.POS>
    END
    IF Y.ECN.NUMBER EQ '' OR Y.ECN.NUMBER EQ 0 THEN
        Y.ECN.NUMBER = "1"
    END
    IF Y.COLLATERAL.CODE EQ "970" THEN
        Y.ECN.NUMBER = 0
    END

    C$SPARE(458) = Y.L.COL.VAL.DATE
    C$SPARE(459) = Y.L.COL.TOT.VALUA
    C$SPARE(460) = Y.ECN.NUMBER
    GOSUB FETCH.FIELD.VALUES.3
RETURN

FETCH.FIELD.VALUES.3:
*********************
*----------------------------------------
* Fetching the Title Collateral Type N(3)
*----------------------------------------
    LOCATE Y.COLLATERAL.CODE IN Y.COLLTYP.VAL.ARR<1,1> SETTING C.INV.POS THEN
        C$SPARE(461) = Y.L.COL.INVST.TYE
    END
*----------------------------------------
* Fetching the Issuer Id C(15)
*----------------------------------------
    Y.COL.NAT.TAX = ""
    LOCATE Y.COLLATERAL.CODE IN Y.ISSID.VAL.ARR<1,1> SETTING C.ISSD.POS THEN
        Y.COL.NAT.TAX = R.COLLATERAL<COLL.LOCAL.REF,L.COL.NAT.TAX.POS>
    END
    IF Y.COL.NAT.TAX THEN
        Y.COL.NAT.TAX = FMT(Y.COL.NAT.TAX, "R(#-##-#####-#)")
    END
    C$SPARE(462) = Y.COL.NAT.TAX
*
*----------------------------------------
* Fetching the Assured Collateral C(1)
*----------------------------------------
*
    Y.COL.INS.PLCY = ''
    Y.COL.INS.PLCY = R.COLLATERAL<COLL.LOCAL.REF,L.COL.INS.PLCY.POS>
    IF Y.COL.INS.PLCY THEN
*----Start---------Changed from "Y" to "S"---------28/10/2013--------**
*Y.L.COL.INS.PLCY = "Y"
        Y.L.COL.INS.PLCY = "S"
*----End-----------Changed from "Y" to "S"---------28/10/2013--------**
    END ELSE
        Y.L.COL.INS.PLCY = "N"
    END
    C$SPARE(463) = Y.L.COL.INS.PLCY
*
    GOSUB FETCH.VALUES
RETURN
*
*------------
FETCH.VALUES:
*------------
*-----------------------------------------------
* Fetching the Insurance Expiry Date C(10)
*-----------------------------------------------
    Y.COL.POL.DATE = ""
    IF Y.COL.INS.PLCY THEN
        Y.COL.POL.DATE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.POL.DATE.POS>
*
        Y.IN.DATE = Y.COL.POL.DATE
        GOSUB DATE.CONV
        Y.COL.POL.DATE = Y.OUT.DATE

        Y.IN.DATE  = ""; Y.OUT.DATE = ""
    END
    C$SPARE(464) = Y.COL.POL.DATE
*
*----------------------------------------
* Fetching the Customer Name C(60)
*----------------------------------------
*    Y.GUAR.TYPE.1 = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GUAR.TYPE.POS>
*    Y.GUAR.NAME = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GUAR.NAME.POS>
*    Y.CUST.NAME = ''; Y.CUST.GN.NAME = ''
*    IF Y.GUAR.TYPE.1 THEN
*        Y.PROD.GRP = ""; Y.REL.CODE = ""; Y.OUT.ARR = ''
*        CALL REDO.S.REP.CUSTOMER.EXTRACT(Y.CUSTOMER.ID,Y.PROD.GRP,Y.REL.CODE,Y.OUT.ARR)
*        Y.CUST.NAME = Y.OUT.ARR<3>
*        Y.CUST.GN.NAME = Y.OUT.ARR<4>
*    END
    C$SPARE(465) = Y.CUST.NAME
*
*------------------------------------------
* Fetching the Customer SurName C(30)
*------------------------------------------
*
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
    C$SPARE(466) = Y.CUST.GN.NAME
*
*------------------------------------------
* Fetching the  Credit Type C(1)
*------------------------------------------
*
    GOSUB FETCH.VALUES.1
RETURN

FETCH.VALUES.1:
***************
    Y.L.AA.MMD.PYME = ''; Y.L.CU.DEBTOR = ''
    Y.L.AA.MMD.PYME = R.CUSTOMER<EB.CUS.LOCAL.REF,L.AA.MMD.PYME.POS>
    IF Y.PROD.GUP EQ "COMERCIAL" THEN
        GOSUB GET.DEBT.VAL
    END ELSE
        Y.L.CU.DEBTOR = Y.L.CU.DEBTOR.COM
    END

    IF Y.PROD.GUP EQ "LINEAS.DE.CREDITO" THEN
        FINDSTR "COM" IN Y.AA.PROD SETTING YFM,YSM,YVM THEN
            GOSUB GET.DEBT.VAL
        END
        LOCATE Y.AA.PROD IN Y.PRDSB.VAL.ARR<1,1> SETTING C.PRDSB.POS THEN
            Y.L.CU.DEBTOR = Y.PRDSB.DIS.ARR<1,C.PRDSB.POS>
        END
    END

    C$SPARE(467) = Y.L.CU.DEBTOR
*-------------------------------------------------------
* Fetching the Title Customer Admissible Collateral C(19)
*-------------------------------------------------------
*
    Y.CENT.BANK.VALUE = ""
    Y.CENT.BANK.VALUE = R.COLLATERAL<COLL.CENTRAL.BANK.VALUE>
    C$SPARE(468) = Y.CENT.BANK.VALUE
*
*---------------------------------------------------------
* Fetching the Title Building Year / Construction Year C(4)
*---------------------------------------------------------
*
    BULD.YR = ''
*    IF Y.COLLATERAL.CODE EQ "450" THEN
*        Y.L.COL.YR.BLDING = R.COLLATERAL<COLL.LOCAL.REF,L.COL.YR.BLDING.POS>
*        Y.TODAY = TODAY
*        Y.TODAY.YR = TODAY[1,4]
*        BULD.YR = SSUB(Y.TODAY.YR,Y.L.COL.YR.BLDING)
*    END ELSE
    IF Y.COLLATERAL.CODE EQ "350" THEN
        BULD.YR = Y.COLLAT.DESC
    END
*    END
    C$SPARE(469) = BULD.YR
    C$SPARE(470) = Y.COLLATERAL.ID
RETURN
*
GET.DEBT.VAL:
*************
    IF Y.L.AA.MMD.PYME[1,2] EQ '1B' OR Y.L.AA.MMD.PYME[1,2] EQ '1C' THEN
        Y.L.CU.DEBTOR = 'M'
    END
    IF Y.L.AA.MMD.PYME[1,2] EQ '1A' THEN
        Y.L.CU.DEBTOR = 'C'
    END
RETURN
*-------------------------------------------------
MAP.RCL.VALUES:
*------------------------------------------------
* Pass arguments to RCL and get the return message
*-------------------------------------------------
    R.RETURN.MSG = ""
    RCL.ID  = Y.RCL.ID
    MAP.FMT = "MAP"
    APP     = FN.AA.ARRANGEMENT
    R.APP   = R.AA.ARRANGEMENT
    CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT,RCL.ID,APP,Y.AA.ARR.ID,R.APP,R.RETURN.MSG,ERR.MSG)
    CALL F.WRITE(FN.DR.REG.DE03.WORKFILE,Y.AA.ARR.ID,R.RETURN.MSG)
RETURN
*-----------------------------------------------------------------------------------------------------------------
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling Fatal error to halt the process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP    = "03"
    Y.ERR.MSG = "Record not found"
    REC.CON   = "DE03-":Y.AA.ARR.ID:Y.ERR.MSG
    DESC      = "DE03-":Y.AA.ARR.ID:Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
RETURN
*------------------------------------------------------------------Final End-------------------------------------------
*---------
DATE.CONV:
*---------
    IF Y.IN.DATE THEN
        Y.DATE.YY = Y.IN.DATE[1,4]
        Y.DATE.MM = Y.IN.DATE[5,2]
        Y.DATE.DT = Y.IN.DATE[7,2]
        Y.OUT.DATE = Y.DATE.DT:"/":Y.DATE.MM:"/":Y.DATE.YY
    END
RETURN
*
END
