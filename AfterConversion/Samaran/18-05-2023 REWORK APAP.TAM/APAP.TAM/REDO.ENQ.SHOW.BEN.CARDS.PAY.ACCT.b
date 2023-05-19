* @ValidationCode : MjoxMjI0Nzc1NzAxOkNwMTI1MjoxNjg0Mzg2NzUyOTgxOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 May 2023 10:42:32
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
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          FM TO @FM, VM TO @VM,F.READ TO CACHE.READ, IF CONDITION ADDED
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION         CALL routine format modified
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.ENQ.SHOW.BEN.CARDS.PAY.ACCT(CARDS.DET)

*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name REDO.NOFILE.AI.LIST.APAP.BEN.ACCTS
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
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER

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

    Y.VAR.EXT.CUSTOMER = ''
    Y.VAR.EXT.ACCOUNTS=''
    FN.CATEGORY = "F.CATEGORY"
    F.CATEGORY = ''

    FN.CUS.BEN.LIST = 'F.CUS.BEN.LIST'
    F.CUS.BEN.LIST  = ''
    CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)

    Y.FIELD.COUNT = ''
    R.ACCT.REC = ''
    LOAN.FLG = ''
    DEP.FLG = ''
    Y.FLAG = ''
    R.AZ.REC = ''
    R.ACC = ''
    LREF.POS = ''
    LREF.APP='BENEFICIARY'
    LREF.FIELDS = 'L.BEN.CUST.NAME':@VM:'L.BEN.CEDULA':@VM:'L.BEN.BANK':@VM:':L.BEN.OWN.ACCT':@VM:'L.BEN.PROD.TYPE':@VM:'L.BEN.EMAIL':@VM:'L.BEN.ACH.ARCIB':@VM:'L.BEN.ACCOUNT'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    POS.L.BEN.CUST.NAME = LREF.POS<1,1>
    POS.L.BEN.CEDULA    = LREF.POS<1,2>
    POS.L.BEN.BANK      = LREF.POS<1,3>
    POS.L.BEN.OWN.ACCT  = LREF.POS<1,4>
    POS.L.BEN.PROD.TYPE = LREF.POS<1,5>
    POS.L.BEN.EMAIL = LREF.POS<1,6>
    POS.L.BEN.ACH.ARCIB = LREF.POS<1,7>
    POS.L.BEN.ACCOUNT  = LREF.POS<1,8>
    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
        CUSTOMER.ID = ""
    END ;*AUTO R22 CODE CONVERSION - END

    Y.CUSTOMER.BEN.ID = CUSTOMER.ID:'-OWN'

RETURN
******************
FORM.ACCT.ARRAY:
*****************

    CALL CACHE.READ(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,'SYSTEM',R.AI.REDO.ACCT.RESTRICT.PARAMETER,RES.ERR)
    Y.RESTRICT.ACCT.TYPE = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.RESTRICT.ACCT.TYPE>
    CHANGE @VM TO @FM IN Y.RESTRICT.ACCT.TYPE


    CALL F.READ(FN.CUS.BEN.LIST,Y.CUSTOMER.BEN.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ERR)

    LOOP
        REMOVE BEN.ID FROM R.CUS.BEN.LIST SETTING BEN.POS
    WHILE BEN.ID:BEN.POS

        BEN.PART.ID = FIELD(BEN.ID,'*',2)
        CALL CACHE.READ(FN.BENEFICIARY, BEN.PART.ID, R.BENEFICIARY, BENEFICIARY.ERR) ;*AUTO R22 CODE CONVERSION
        IF R.BENEFICIARY THEN
            Y.BEN.PROD.TYPE = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.PROD.TYPE>
            IF Y.BEN.PROD.TYPE EQ 'CARDS' THEN
                ACCT.ID = R.BENEFICIARY<ARC.BEN.BEN.ACCT.NO>
                Y.NICKNAME = R.BENEFICIARY<ARC.BEN.NICKNAME>
                Y.TRANSACTION.TYPE = R.BENEFICIARY<ARC.BEN.TRANSACTION.TYPE>
                Y.L.BEN.CUST.NAME = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.CUST.NAME>
                Y.L.BEN.CEDULA    = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.CEDULA>
                Y.L.BEN.BANK      = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.BANK>
                Y.L.BEN.OWN.ACCT  = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.OWN.ACCT>
                Y.L.BEN.EMAIL     = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.EMAIL>
                Y.L.BEN.ACH.ARCIB = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.ACH.ARCIB>
                Y.L.BEN.ACCOUNT   = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.ACCOUNT>
                Y.L.BEN.OWN.ACCOUNT = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.OWN.ACCT>
                GOSUB GET.CCARD.INFO
                CARDS.DET<-1> = BEN.PART.ID:"@@@":Y.NICKNAME:"@@@":ACCT.ID:"@@@":Y.L.BEN.CUST.NAME:"@@@":Y.L.BEN.CEDULA:"@@@":Y.L.BEN.BANK:"@@@":Y.TRANSACTION.TYPE:"@@@":Y.L.BEN.ACCOUNT:"@@@":Y.L.BEN.OWN.ACCOUNT:"@@@":Y.RESPONSE
            END

        END
    REPEAT
RETURN


GET.CCARD.INFO:

    ACTIVATION = 'WS_T24_VPLUS'

    WS.DATA = ''
    WS.DATA<1> = 'CONSULTA_BALANCE'
    WS.DATA<2> = FMT(ACCT.ID,'R%19')
    TRANS.CODE = '' ; Y.CHANNEL = '' ; Y.MON.CHANNEL = ''
    WS.DATA<3> = 'ITB'

* Invoke VisionPlus Web Service

*CALL APAP.TAM.REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA) ;*MANUAL R22 CODE CONVERSION
    Y.RESPONSE = ''

    Y.GET.CC.CODE = FIELD(WS.DATA<12>,'/',1)
    Y.GET.CC.CODE = TRIM(Y.GET.CC.CODE,'0','L')

    Y.RESPONSE = WS.DATA<3>[4,16]:'###':WS.DATA<11>:'###':Y.GET.CC.CODE

RETURN

*-----------------------------------------------------------------------------
END
