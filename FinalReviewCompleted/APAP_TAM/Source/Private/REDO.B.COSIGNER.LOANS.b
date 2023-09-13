* @ValidationCode : MjotOTQ3ODY4MjgwOkNwMTI1MjoxNjkzOTIzODQxMzc0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Sep 2023 19:54:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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
* CN008155               Ashokkumar                     15/01/2018            Added new field to display Currency and amended the Tipo de Operacion field.

*
* Date             Who                   Reference      Description
* 24.04.2023       Conversion Tool       R22            Auto Conversion     - INSERT file folder name removed T24.BP,LAPAP.BP & TAM.BP, FM TO @FM, VM TO @VM, SM TO @SM, ++ TO += 1
* 05.09.2023       VICTORIA S            R22            Manual Conversion   - Add call routine prefix
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON                                 ;** R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.ACCT.MRKWOF.HIST
    $INSERT I_REDO.B.COSIGNER.LOANS.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON              ;** R22 Auto conversion - End
	$USING APAP.LAPAP

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
*CALL REDO.RPT.CLSE.WRITE.LOANS(Y.AA.ARR.ID,R.ARRANGEMENT,ARRAY.VAL)
    APAP.TAM.redoRptClseWriteLoans(Y.AA.ARR.ID,R.ARRANGEMENT,ARRAY.VAL);* R22 Manual conversion
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
    Y.ROLE.CNT = DCOUNT(Y.ROLE,@VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.ROLE.CNT
        Y.ROLE.ID = Y.ROLE<1,Y.CNT>
        IF Y.ROLE.ID EQ 'CO-SIGNER' THEN
            Y.CUSTOMER.ID = Y.OTHER.PARTY<1,Y.CNT>
            GOSUB FORM.ARRAY
        END
        Y.CNT += 1                                         ;** R22 Auto conversion - ++ TO += 1
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
*CALL REDO.RPT.ACCT.ALT.LOANS(YACCT.GRP,Y.PREV.ACCOUNT)
    APAP.TAM.redoRptAcctAltLoans(YACCT.GRP,Y.PREV.ACCOUNT);* R22 Manual conversion
    IF NOT(Y.PREV.ACCOUNT) THEN
        Y.PREV.ACCOUNT = Y.LOAN.CODE
    END
    GOSUB GET.LN.CODE.5.1
* CALL REDO.S.REG.CUSTOMER.EXTRACT(Y.CUSTOMER.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)
** R22 Manual conversion
    APAP.LAPAP.redoSRegCustomerExtract(Y.CUSTOMER.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)
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
*CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    APAP.LAPAP.redoConduitLinearTranslation(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG) ;*R22 MANUAL CONVERSION
    CALL F.WRITE(FN.DR.REG.DE04.WORKFILE,Y.AA.ARR.ID,R.RETURN.MSG)
RETURN

*---------------
GET.LN.CODE.5.1:
*---------------
**Verificar si tiene id alteno 4
    IF Y.LOAN.CODE EQ Y.PREV.ACCOUNT THEN
        ID.ALTENO4 = '' ; Y.ALT.TYPE = ''
        Y.ALT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
        CHANGE @VM TO @FM IN Y.ALT.TYPE
        CHANGE @SM TO @FM IN Y.ALT.TYPE
        LOCATE "ALTERNO2" IN Y.ALT.TYPE<1> SETTING EYPO.POS THEN
            ID.ALTENO4  = R.ACCOUNT<AC.ALT.ACCT.ID,EYPO.POS,1>
            FINDSTR "VI" IN ID.ALTENO4 SETTING Ap, Vp THEN
                Y.PREV.ACCOUNT = ID.ALTENO4[3,LEN(ID.ALTENO4)]
            END
        END
    END
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
    IF Y.PRODUCT.GROUP EQ "COMERCIAL" THEN
        C$SPARE(456) = Y.L.CU.DEBTOR
    END
RETURN

*----------------------------------------------------------End Of Record-----------------------------------------------
END
