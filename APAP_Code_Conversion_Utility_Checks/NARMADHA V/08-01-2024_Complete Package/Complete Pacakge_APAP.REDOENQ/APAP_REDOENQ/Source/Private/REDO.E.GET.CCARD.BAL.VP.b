* @ValidationCode : MjoxMTIzMTIyMDg3OkNwMTI1MjoxNjg0ODUxOTc0NzcyOklUU1M6LTE6LTE6LTY3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -67
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.CCARD.BAL.VP(DATA.RECORD)
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.04.2013
* Description  : Routine for obtaining Credit Card Information
* Type         : NOFILE Routine
* Attached to  : ENQUIRY > AI.REDO.CCARD.BAL
* Dependencies :
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN and FM to @FM
* 11-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*-----------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_ENQUIRY.COMMON
    $USING APAP.TAM

* </region>
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
    Y.CHANNEL = ''
    Y.MON.CHANNEL = ''

    CREDIT.CARD.ID = System.getVariable('CURRENT.CARD.ID')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CREDIT.CARD.ID = ""
    END
    CREDIT.CARD = FMT(CREDIT.CARD.ID, 'R%19')

RETURN

***********************
* Open Files
OPEN.FILES:
***********************
RETURN

***********************
* Main Process
PROCESS:
***********************
    IF CREDIT.CARD.ID MATCHES "...CURRENT.CARD.ID..." NE 1 THEN
        GOSUB INVOKE.VP.WS.CB
    END

RETURN

**************************************************
* Invoke VP Web Service 'CONSULTA_BALANCE'
INVOKE.VP.WS.CB:
**************************************************
    ACTIVATION = 'WS_T24_VPLUS'

    WS.DATA = ''
    WS.DATA<1> = 'CONSULTA_BALANCE'
    WS.DATA<2> = CREDIT.CARD
    WS.DATA<3> = 'ITB'

* Invoke VisionPlus Web Service
    APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA);*R22 Manual Conversion

* Credit Card exits - Info obtained OK
    IF WS.DATA<1> EQ 'OK' THEN
        GOSUB GET.CREDIT.CARD.DATA
    END ELSE
* 'ERROR/OFFLINE'
        ENQ.ERROR<1> = WS.DATA<2>
    END

RETURN

***********************
* Get Credit Card Data
GET.CREDIT.CARD.DATA:
***********************
    CCARD.DATA = ''

* Prev Bal USD
    CCARD.DATA<1> = WS.DATA<19>
* Prev Bal DOP
    CCARD.DATA<2> = WS.DATA<18>
* Fecha Ult Corte (Ult Estado Cta)
    CCARD.DATA<3> = WS.DATA<34>
* Fecha Limite Pago
    CCARD.DATA<4> = WS.DATA<8>
* Min. Payment USD
    CCARD.DATA<5> = WS.DATA<7>
* Min. Payment DOP
    CCARD.DATA<6> = WS.DATA<6>
* Last Payment USD
    CCARD.DATA<7> = WS.DATA<21>
* Last Payment DOP
    CCARD.DATA<8> = WS.DATA<20>
* Last Payment Date USD
    CCARD.DATA<9> = WS.DATA<23>
* Last Payment Date DOP
    CCARD.DATA<10> = WS.DATA<22>
* Cuotas Vencidas USD
    CCARD.DATA<11> = WS.DATA<25>
* Cuotas Vencidas DOP
    CCARD.DATA<12> = WS.DATA<24>
* Due Amt (Importe) USD
    CCARD.DATA<13> = WS.DATA<27>
* Due Amt (Importe) DOP
    CCARD.DATA<14> = WS.DATA<26>
* Current Bal USD
    CCARD.DATA<15> = WS.DATA<29>
* Current Bal DOP
    CCARD.DATA<16> = WS.DATA<28>
* Available Bal USD
    CCARD.DATA<17> = WS.DATA<31>
* Avaiable Bal DOP
    CCARD.DATA<18> = WS.DATA<30>
* Overdraft USD
    CCARD.DATA<19> = WS.DATA<33>
* Overdraft DOP
    CCARD.DATA<20> = WS.DATA<32>

    CHANGE @FM TO "*" IN CCARD.DATA
    DATA.RECORD<-1> = CCARD.DATA

RETURN

* </region>

END
