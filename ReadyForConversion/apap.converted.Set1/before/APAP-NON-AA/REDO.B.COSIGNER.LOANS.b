*-----------------------------------------------------------------------------
* <Rating>-62</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.COSIGNER.LOANS(Y.ID)
*-----------------------------------------------------------------------------------------------------------------
* Description           : This routine is used to form write a fianl array into the work file REDO.REPORT.TEMP
*
* Developed By          : Saranraj S
*
* Development Reference : DE04
*
* Attached To           : BATCH>BNK/REDO.B.COSIGNER.LOANS
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00325162           Ashokkumar.V.P                 04/11/2014            Additional AA product and fixed field issue
* PACS00459395           Ashokkumar.V.P                 10/06/2015            New mapping changes.
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT TAM.BP I_F.REDO.ACCT.MRKWOF.HIST
    $INSERT TAM.BP I_REDO.B.COSIGNER.LOANS.COMMON
    $INSERT TAM.BP I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT

    GOSUB INITIALIZE
    GOSUB PROCESS
    RETURN

*----------
INITIALIZE:
*----------
    Y.AA.ARR.ID = ''; YF.LCONS = 0; YF.LCOM = 0
    C$SPARE(451) = ''; C$SPARE(452) = ''; C$SPARE(453) = ''
    C$SPARE(454) = ''; C$SPARE(455) = ''; C$SPARE(456) = ''
    Y.AA.ARR.ID = Y.ID
    RETURN

*-------
PROCESS:
*-------
    CALL AA.GET.ARRANGEMENT(Y.AA.ARR.ID,R.ARRANGEMENT,ARR.ERR)
    Y.PRODUCT        = R.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.PRODUCT.LINE   = R.ARRANGEMENT<AA.ARR.PRODUCT.LINE>
    Y.ARR.STATUS     = R.ARRANGEMENT<AA.ARR.ARR.STATUS>
    Y.PRODUCT.GROUP  = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.LINKED.APPL    = R.ARRANGEMENT<AA.ARR.LINKED.APPL>
    Y.LINKED.APPL.ID = R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    YSTART.DTE = R.ARRANGEMENT<AA.ARR.START.DATE>

    IF YSTART.DTE GE YL.TODAY THEN
        RETURN
    END
    IF Y.ARR.STATUS NE 'CURRENT' AND Y.ARR.STATUS NE 'EXPIRED' THEN
        RETURN
    END

    IF (Y.PRODUCT.GROUP EQ "LINEAS.DE.CREDITO") THEN
        Y.PRD.POS = ''
        FINDSTR 'CONS' IN Y.PRODUCT SETTING Y.PRD.POS THEN
            YF.LCONS = 1
        END ELSE
            RETURN
        END
        Y.PRD.POS = ''
        FINDSTR 'COM' IN Y.PRODUCT SETTING Y.PRD.POS THEN
            YF.LCOM = 1
        END ELSE
            RETURN
        END
    END
    ARRAY.VAL = ''; Y.LOAN.STATUS = ''; Y.CLOSE.LN.FLG = 0
    CALL REDO.RPT.CLSE.WRITE.LOANS(Y.AA.ARR.ID,R.ARRANGEMENT,ARRAY.VAL)
    Y.LOAN.STATUS = ARRAY.VAL<1>
    Y.CLOSE.LN.FLG = ARRAY.VAL<2>
    IF Y.LOAN.STATUS EQ "Write-off" THEN
        RETURN
    END
    IF Y.CLOSE.LN.FLG NE 1 THEN
        GOSUB CHK.AA.CUSTOMER
    END
    RETURN

*----------------
CHK.AA.CUSTOMER:
*----------------
    PROP.CLASS = 'CUSTOMER'
    PROP.NAME  = ''
    RET.ERR    = ''
    R.AA.CUSTOMER = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.AA.ARR.ID,PROP.CLASS,PROP.NAME,'','',returnConditions,RET.ERR)
    R.AA.CUSTOMER = RAISE(returnConditions)
    Y.ROLE        = R.AA.CUSTOMER<AA.CUS.ROLE>
    Y.OTHER.PARTY = R.AA.CUSTOMER<AA.CUS.OTHER.PARTY>
    IF NOT(Y.ROLE) THEN
        RETURN
    END
    Y.ROLE.CNT = DCOUNT(Y.ROLE,VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.ROLE.CNT
        Y.ROLE.ID = Y.ROLE<1,Y.CNT>
        IF Y.ROLE.ID EQ 'CO-SIGNER' THEN
            Y.CUSTOMER.ID = Y.OTHER.PARTY<1,Y.CNT>
            GOSUB FORM.ARRAY
        END
        Y.CNT ++
    REPEAT
    RETURN

*----------
FORM.ARRAY:
*----------
    LOCATE "ACCOUNT" IN Y.LINKED.APPL<1,1> SETTING Y.POS THEN
        Y.LOAN.CODE = Y.LINKED.APPL.ID<1,Y.POS>
    END

    ERR.ACCOUNT = ''; R.ACCOUNT = ''; Y.PREV.ACCOUNT = ''; Y.ALT.ACCT.TYPE= '';Y.ALT.ACCT.ID=''
    CALL F.READ(FN.ACCOUNT,Y.LOAN.CODE,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    IF ERR.ACCOUNT THEN
        RETURN
    END
    Y.ARRAY.VAL = ''
    YACCT.GRP = R.ACCOUNT:"###":R.ARRANGEMENT
    CALL REDO.RPT.ACCT.ALT.LOANS(YACCT.GRP,Y.PREV.ACCOUNT)
    IF NOT(Y.PREV.ACCOUNT) THEN
        Y.PREV.ACCOUNT = Y.LOAN.CODE
    END

    CALL REDO.S.REP.CUSTOMER.EXTRACT(Y.CUSTOMER.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)
    Y.CUST.IDEN = OUT.ARR<1>
    Y.CUST.TYPE = OUT.ARR<2>
    Y.CUST.NAME = OUT.ARR<3>
    Y.CUST.GN.NAME = OUT.ARR<4>
    Y.CREDIT.TYPE = OUT.ARR<5>

    C$SPARE(451) = Y.PREV.ACCOUNT
    C$SPARE(452) = Y.CUST.IDEN
    C$SPARE(453) = Y.CUST.TYPE
    C$SPARE(454) = Y.CUST.NAME
    C$SPARE(455) = Y.CUST.GN.NAME
    C$SPARE(456) = Y.CREDIT.TYPE
    GOSUB GET.CUST.DET

    MAP.FMT   = "MAP"
    ID.RCON.L = "REDO.RCL.DE04"
    APP       = FN.AA.ARRANGEMENT
    R.APP     = R.ARRANGEMENT
    ID.APP    = Y.AA.ARR.ID
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    CALL F.WRITE(FN.DR.REG.DE04.WORKFILE,Y.AA.ARR.ID,R.RETURN.MSG)
    RETURN

GET.CUST.DET:
*************
    R.CUSTOMER = ''; CUS.ERR = ''; Y.L.CU.DEBTOR = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.L.CU.DEBTOR = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.DEBTOR.POS>
    IF (Y.PRODUCT.GROUP EQ "LINEAS.DE.CREDITO") AND YF.LCOM EQ 1 THEN
        C$SPARE(456) = Y.L.CU.DEBTOR
    END
    IF (Y.PRODUCT.GROUP EQ "LINEAS.DE.CREDITO") AND YF.LCONS EQ 1 THEN
        C$SPARE(456) = "O"
    END
    RETURN

*--------------
RAISE.ERR.C.22:
*--------------
*Handling error process
*---------------
    MON.TP = "04"
    Y.ERR.MSG = "Record not found"
    REC.CON = "DE04-":Y.AA.ARR.ID:Y.ERR.MSG
    DESC = "DE04-":Y.AA.ARR.ID:Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO   = ''
    BAT.TOT  = ''
    INFO.OR  = ''
    INFO.DE  = ''
    ID.PROC  = ''
    EX.USER  = ''
    EX.PC    = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    RETURN
*----------------------------------------------------------End Of Record-----------------------------------------------
END
