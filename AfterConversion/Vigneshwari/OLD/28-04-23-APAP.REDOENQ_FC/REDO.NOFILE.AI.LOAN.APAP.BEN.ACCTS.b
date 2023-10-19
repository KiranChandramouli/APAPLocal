* @ValidationCode : MjotMTU0MTI5NDY5MjpDcDEyNTI6MTY4MjYwMTg5NDAxMDp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Apr 2023 18:54:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.AI.LOAN.APAP.BEN.ACCTS(FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name REDO.NOFILE.AI.LOAN.APAP.BEN.ACCTS
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry REDO.SAV.ACCOUNT.LIST
* Linked with : Enquiry REDO.SAV.ACCOUNT.LIST  as BUILD routine
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*01/11/11       PACS00146410            PRABHU N                MODIFICAION
*
* 13-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM, IF condition added
* 13-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.AI.REDO.ARCIB.ALIAS.TABLE
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER
    $USING APAP.TAM

    GOSUB INITIALISE
    GOSUB FORM.ACCT.ARRAY

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------


    F.CUSTOMER.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'

    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    CALL OPF(FN.ACC,F.ACC)

    FN.BENEFICIARY = 'F.BENEFICIARY'
    F.BENEFICIARY = ''
    CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

    FN.AI.REDO.ARCIB.ALIAS.TABLE = 'F.AI.REDO.ARCIB.ALIAS.TABLE'
    F.AI.REDO.ARCIB.ALIAS.TABLE = ''
    CALL OPF(FN.AI.REDO.ARCIB.ALIAS.TABLE,F.AI.REDO.ARCIB.ALIAS.TABLE)

    FN.AI.REDO.ACCT.RESTRICT.PARAMETER = 'F.AI.REDO.ACCT.RESTRICT.PARAMETER'
    F.AI.REDO.ACCT.RESTRICT.PARAMETER  = ''
    CALL OPF(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,F.AI.REDO.ACCT.RESTRICT.PARAMETER)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.PRODUCT = 'F.AA.PRODUCT'
    F.AA.PRODUCT = ''
    CALL OPF(FN.AA.PRODUCT,F.AA.PRODUCT)

    Y.VAR.EXT.CUSTOMER = ''
    Y.VAR.EXT.ACCOUNTS=''
    FN.CATEGORY = "F.CATEGORY"
    F.CATEGORY = ''


    Y.FIELD.COUNT = ''
    R.ACCT.REC = ''
    LOAN.FLG = ''
    DEP.FLG = ''
    R.AZ.REC = ''
    R.ACC = ''
    LREF.POS = ''
    LREF.APP='ACCOUNT':@FM:'BENEFICIARY':@FM:'AA.PRD.DES.OVERDUE'
    LREF.FIELDS='L.AC.STATUS1':@VM:'L.AC.AV.BAL':@VM:'L.AC.NOTIFY.1':@VM:'L.AC.STATUS2':@FM:'L.BEN.CUST.NAME':@VM:'L.BEN.CEDULA':@VM:'L.BEN.BANK':@VM:':L.BEN.OWN.ACCT':@FM:'L.LOAN.STATUS.1':@VM:'L.LOAN.COND'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    ACCT.STATUS.POS  = LREF.POS<1,1>
    ACCT.OUT.BAL.POS = LREF.POS<1,2>
    NOTIFY.POS       = LREF.POS<1,3>
    ACCT.STATUS2.POS = LREF.POS<1,4>
    POS.L.BEN.CUST.NAME = LREF.POS<2,1>
    POS.L.BEN.CEDULA    = LREF.POS<2,2>
    POS.L.BEN.BANK      = LREF.POS<2,3>
    POS.L.BEN.OWN.ACCT  = LREF.POS<2,4>
    POS.L.LOAN.STATUS   = LREF.POS<3,1>
    POS.L.LOAN.COND     = LREF.POS<3,2>

    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion-START
        CUSTOMER.ID = ""
    END					;*R22 Auto conversion-END

    CALL CACHE.READ(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,'SYSTEM',R.AI.REDO.ACCT.RESTRICT.PARAMETER,RES.ERR)
    Y.PARAM.LOAN.STATUS =  R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.LOAN.ACCT.STATUS>

RETURN
******************
FORM.ACCT.ARRAY:
*****************


    SEL.CMD = "SELECT ":FN.BENEFICIARY:" WITH L.BEN.ACCOUNT EQ '' AND OWNING.CUSTOMER EQ ":CUSTOMER.ID:"  AND L.BEN.PROD.TYPE EQ 'LOAN'"

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.REC)
    LOOP
        REMOVE BEN.ID FROM SEL.LIST SETTING BEN.POS
    WHILE BEN.ID:BEN.POS

        ACC.ERR= ''
        CHECK.CATEG=''
        SAV.FLG=''
        CURR.FLG=''
        CALL CACHE.READ(FN.BENEFICIARY, BEN.ID, R.BENEFICIARY, BENEFICIARY.ERR) ;*R22 Auto conversion
        IF NOT(BENEFICIARY.ERR) THEN
            ACCT.ID = R.BENEFICIARY<ARC.BEN.BEN.ACCT.NO>
            Y.NICKNAME = R.BENEFICIARY<ARC.BEN.NICKNAME>
            Y.ALIAS.NAME = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.CUST.NAME>
        END
        CALL F.READ(FN.ACC,ACCT.ID,R.ACC,F.ACC,ACC.ERR)

        ACC.ID =  ACCT.ID
        PROP.CLASS = 'OVERDUE'
        PROPERTY = ''
        R.Condition = ''
        ERR.MSG = ''
        EFF.DATE = ''
        CALL APAP.TAM.redoConvertAccount(ACC.ID,Y.ARR.ID,ARR.ID,ERR.TEXT);*Manual R22 conversion
        CALL APAP.TAM.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG);*Manual R22 conversion
        LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF, POS.L.LOAN.STATUS>
        LOAN.COND = R.Condition<AA.OD.LOCAL.REF,POS.L.LOAN.COND>
        Y.LOOP.CONTINUE=''
        IF LOAN.STATUS THEN
            LOCATE LOAN.STATUS IN Y.PARAM.LOAN.STATUS SETTING LOAN.ACCT.POS THEN
                Y.LOOP.CONTINUE=1
            END
        END
        IF NOT(Y.LOOP.CONTINUE) THEN
            Y.CURRENCY = R.ACC<AC.CURRENCY>
            Y.ARRANGEMENT.ID  = R.ACC<AC.ARRANGEMENT.ID>
            CALL F.READ(FN.AI.REDO.ARCIB.ALIAS.TABLE,ACCCT.ID,R.AI.REDO.ARCIB.ALIAS.TABLE,F.AI.REDO.ARCIB.ALIAS.TABLE,ALIAS.ERR)
            IF NOT(ALIAS.ERR) THEN
                Y.ALIAS.NAME = R.AI.REDO.ARCIB.ALIAS.TABLE<AI.ALIAS.ALIAS.NAME>
            END


            GOSUB ARRANGEMENT.DESC.PARA

            GOSUB CHECK.ACTIVE.STATUS
        END

    REPEAT

RETURN

***********************
ARRANGEMENT.DESC.PARA:
***********************
    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)
    Y.ARR.PRODUCT = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    CALL CACHE.READ(FN.AA.PRODUCT, Y.ARR.PRODUCT, R.AA.PRODUCT, AA.PRODUCT.ERR) ;*R22 Auto conversion
    Y.DESC = R.AA.PRODUCT<AA.PDT.DESCRIPTION,LNGG>
    IF NOT(Y.DESC) THEN
        Y.DESC  = R.AA.PRODUCT<AA.PDT.DESCRIPTION,1>
    END
RETURN
*******************
CHECK.ACTIVE.STATUS:
*******************


    FIN.ARR<-1> = ACCT.ID:"@":Y.ALIAS.NAME:"@":Y.DESC:"@":Y.CURRENCY

RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
