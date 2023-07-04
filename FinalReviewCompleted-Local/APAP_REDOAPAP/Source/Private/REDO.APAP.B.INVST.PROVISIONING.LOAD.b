* @ValidationCode : Mjo0OTA2Njk0OTpDcDEyNTI6MTY4MTIxMzc5NDEyNzphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 17:19:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.B.INVST.PROVISIONING.LOAD
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.B.INVST.PROVISIONING.LOAD
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.B.INVST.PROVISIONING.LOAD is the load routine to load all the variables
*                    required for the process
*Linked With       : Batch BNK/REDO.B.INVST.PROVISIONING
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.H.CUSTOMER.PROVISION      As              I               Mode
*                    SC.TRADING.POSITION            As              I               Mode
*                    SECURITY.MASTER                As              I               Mode
*                    CUSTOMER                       As              I               Mode
*                    EB.RATING                      As              I               Mode
*                    LMM.ACCOUNT.BALANCES           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date                 Who                    Reference                  Description
*   ------               -----                 -------------               -------------
* 27 Sep 2010        Shiva Prasad Y        ODR-2010-09-0167 B.23B         Initial Creation
* 14 May 2011        Sudharsanan S           PACS00061656                 Parameter table - @ID Changed to "SYSTEM"
* 26.05.2011           RIYAS                   PACS00061656                    Fix
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SC.TRADING.POSITION
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.RATING
    $INSERT I_F.LMM.ACCOUNT.BALANCES
    $INSERT I_F.REDO.H.CUSTOMER.PROVISION
    $INSERT I_F.REDO.H.CUST.WRITE.PROV
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_REDO.APAP.B.INVST.PROVISIONING.COMMON
    $INSERT I_F.MM.MONEY.MARKET
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
    GOSUB FIND.MULTI.LOCAL.REF

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.REDO.H.CUSTOMER.PROVISION = 'F.REDO.H.CUSTOMER.PROVISION'
    F.REDO.H.CUSTOMER.PROVISION = ''
    CALL OPF(FN.REDO.H.CUSTOMER.PROVISION,F.REDO.H.CUSTOMER.PROVISION)

    FN.REDO.H.CUST.WRITE.PROV='F.REDO.H.CUST.WRITE.PROV'
    F.REDO.H.CUST.WRITE.PROV=''
    CALL OPF(FN.REDO.H.CUST.WRITE.PROV,F.REDO.H.CUST.WRITE.PROV)

    FN.REDO.H.CUST.WRITE.PROV.HIS = 'F.REDO.H.CUST.WRITE.PROV$HIS'
    F.REDO.H.CUST.WRITE.PROV.HIS  = ''
    CALL OPF(FN.REDO.H.CUST.WRITE.PROV.HIS,F.REDO.H.CUST.WRITE.PROV.HIS)

    FN.REDO.H.CUSTOMER.PROVISION$HIS = 'F.REDO.H.CUSTOMER.PROVISION$HIS'
    F.REDO.H.CUSTOMER.PROVISION$HIS = ''
    CALL OPF(FN.REDO.H.CUSTOMER.PROVISION$HIS,F.REDO.H.CUSTOMER.PROVISION$HIS)

    FN.REDO.H.PROVISION.PARAMETER = 'F.REDO.H.PROVISION.PARAMETER'
    F.REDO.H.PROVISION.PARAMETER = ''
    CALL OPF(FN.REDO.H.PROVISION.PARAMETER,F.REDO.H.PROVISION.PARAMETER)

    FN.SC.TRADING.POSITION = 'F.SC.TRADING.POSITION'
    F.SC.TRADING.POSITION = ''
    CALL OPF(FN.SC.TRADING.POSITION,F.SC.TRADING.POSITION)

    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER = ''
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.EB.RATING = 'F.EB.RATING'
    F.EB.RATING = ''
    CALL OPF(FN.EB.RATING,F.EB.RATING)

    FN.LMM.ACCOUNT.BALANCES = 'F.LMM.ACCOUNT.BALANCES'
    F.LMM.ACCOUNT.BALANCES = ''
    CALL OPF(FN.LMM.ACCOUNT.BALANCES,F.LMM.ACCOUNT.BALANCES)

    FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET'
    F.MM.MONEY.MARKET = ''
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
*PACS00061656 - S
    REDO.H.PROVISION.PARAMETER.ID = "SYSTEM"
    GOSUB READ.REDO.H.PROVISION.PARAMETER
*PACS00061656 - E

    Y.NEXT.RUN.DATE = R.REDO.H.PROVISION.PARAMETER<PROV.NEXT.RUN.DATE>

RETURN
*--------------------------------------------------------------------------------------------------------
********************************
READ.REDO.H.PROVISION.PARAMETER:
********************************
    REDO.H.PROVISION.PARAMETER.ER  = ''
    CALL CACHE.READ(FN.REDO.H.PROVISION.PARAMETER,REDO.H.PROVISION.PARAMETER.ID,R.REDO.H.PROVISION.PARAMETER,REDO.H.PROVISION.PARAMETER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'CUSTOMER'
    FLD.ARRAY  = 'L.CU.PRO.RATING'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.CU.PRO.RATING.POS =  FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
