* @ValidationCode : MjoxMjg3NDM3NzIwOkNwMTI1MjoxNjg0ODUxOTc0NjI4OklUU1M6LTE6LTE6LTIwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -20
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.ADD.CCARD.DETAILS(Y.FINAL.ARRAY)

*---------------------------------------------------------------------------------
* This is aenquiry for list the details of credit card
*this enquiry will fetch the data from sunnel interface
*---------------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : Prabhu N
* Program Name   : REDO.E.GET.ADD.CCARD.DETAILS
* ODR NUMBER     : SUNNEL-CR
* LINKED WITH    : ENQUIRY-AI.REDO.CCARD.DETAILS
*---------------------------------------------------------------------------------
*IN = N/A
*OUT = Y.FINAL.ARRAY
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*3.12.2010     ODR-2010-11-0211      Prabhu N                Initial creation
*02/11/2010    PACS00146408          PRABHUN                 MODIFICATION
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN , VM to @VM
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
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN    ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CUSTOMER.ID = ""
    END
    Y.POSITION = System.getVariable('CURRENT.Y.POSITION')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN	   ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.POSITION = ""
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

        WS.DATA = CHANGE(WS.DATA,'*',@VM)
        Y.AMT = '0.00':'*':WS.DATA<5,Y.POSITION>

        Y.FINAL.ARRAY = WS.DATA<2,Y.POSITION>:'*':WS.DATA<3,Y.POSITION>:'*':WS.DATA<4,Y.POSITION>:'*':Y.AMT:'*':WS.DATA<9,Y.POSITION>:'*':WS.DATA<7,Y.POSITION>:'*':Y.CUSTOMER.ID<1>:'*':WS.DATA<8,Y.POSITION>:'*':WS.DATA<6,Y.POSITION>

    END ELSE
        ENQ.ERROR<1> = ''
    END

RETURN

*------------------------------*END OF SUBROUTINE*--------------------------------
