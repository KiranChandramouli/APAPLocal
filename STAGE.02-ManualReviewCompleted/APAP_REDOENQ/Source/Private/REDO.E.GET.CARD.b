* @ValidationCode : MjoxMDc1ODQ4Njk6Q3AxMjUyOjE2ODE5OTU5ODY3NjE6SVRTUzotMTotMTotMzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Apr 2023 18:36:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -3
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.CARD
*---------------------------------------------------------------------------------
* This is aenquiry for listing all the credit cards of the customer
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
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*3.12.2010     ODR-2010-11-0211       Prabhu N                Initial creation

* 13-APR-2023     Conversion tool    R22 Auto conversion       IF Condition added
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    O.DATA=System.getVariable('CURRENT.CARD.NO')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion-START
        O.DATA = ""
    END					;*R22 Auto conversion-END

RETURN
END
*------------------------------*END OF SUBROUTINE*--------------------------------
