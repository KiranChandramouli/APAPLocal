* @ValidationCode : MjoxODIxMTk2MTQ5OlVURi04OjE2ODU1MzA0NzA1Nzk6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 16:24:30
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.CARD.LIST(Y.FINAL.ARRAY)

*---------------------------------------------------------------------------------
* This is an enquiry for listing all the credit cards of the customer
*this enquiry will fetch the data from sunnel interface
*---------------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : Prabhu N
* Program Name   : REDO.E.GET.CARD.LIST
* ODR NUMBER     : SUNNEL-CR
* LINKED WITH    : ENQUIRY-REDO.CCARD.LIST
*---------------------------------------------------------------------------------
*IN = N/A
*OUT = Y.FINAL.ARRAY
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
* DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
* 3.12.2010     PACS00036498           Prabhu N                Initial creation
* 21-04-2011    PACS00032454           GANESH H                 MODIFICATION
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN , VM to @VM and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $USING APAP.TAM

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*---------------------------------------------------------------------------------
INITIALISE:
*---------------------------------------------------------------------------------

    Y.CUSTOMER.ID = System.getVariable('EXT.CUSTOMER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CUSTOMER.ID = ""
    END

    ACTIVATION = 'WS_T24_VPLUS'
    WS.DATA = ''
    WS.DATA<1> = 'ADICIONALES_CLIENTE'
    WS.DATA<2> = Y.CUSTOMER.ID

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

* Invoke VisionPlus Web Service
    APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA);*R22 Manual Conversion

* Credit Card exits - Info obtained OK
    IF WS.DATA<1> EQ 'OK' THEN

        Y.ADDITI0NAL.LIST = WS.DATA<2>
        Y.ADDITI0NAL.LIST = CHANGE(Y.ADDITI0NAL.LIST,'*',@VM)

        Y.TOT.LIST = DCOUNT(Y.ADDITI0NAL.LIST,@VM)
        Y.CNT = 1
        IF WS.DATA<7,Y.TOT.LIST> EQ '' THEN
            Y.TOT.LIST -= 1
        END

        LOOP
        WHILE Y.CNT LE Y.TOT.LIST
            Y.ADD.CARD = Y.ADDITI0NAL.LIST<1,Y.CNT>
            Y.FINAL.ARRAY<-1> = Y.ADD.CARD:'###':Y.CNT
            Y.CNT += 1
        REPEAT
    END ELSE
* 'ERROR/OFFLINE'
        ENQ.ERROR<1> = ''
    END

RETURN
END
*------------------------------*END OF SUBROUTINE*--------------------------------
