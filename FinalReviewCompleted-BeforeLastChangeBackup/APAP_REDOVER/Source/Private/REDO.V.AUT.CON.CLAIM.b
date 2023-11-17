* @ValidationCode : MjotMTAxMDQ2MDQ4MzpDcDEyNTI6MTY4MjQxMjMzMzcxNDpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.CON.CLAIM
*---------------------------------------------------------------------------------
*This is an ANC routine for the version REDO.ISSUE.CLAIMS,OPEN
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : PRadeep S
* Program Name  : REDO.V.AUT.CON.CLAIM
* ODR NUMBER    :
* HD Reference  : PACS00071941
* LINKED WITH   : REDO.ISSUE.CLAIMS
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
* MODIFICATION DETAILS:
* Who               Who              Reference                        Description
* 12-05-2011        Pradeep S        PACS00071941                   Initial Creation
*06-04-2023       Conversion Tool     R22 Auto Code conversion          FM TO @FM, IF CONDITION ADDED
*06-04-2023       Samaran T           R22 Manual Code Conversion         No Changes
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.REDO.ISSUE.CLAIMS

    GOSUB PROCESS
RETURN

PROCESS:
    Y.CURRENT.REC=System.getVariable("CURRENT.REC")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION
        Y.CURRENT.REC = ""   ;*R22 AUTO CODE CONVERSION
    END  ;*R22 AUTO CODE CONVERSION

    CHANGE '*##' TO @FM IN Y.CURRENT.REC
    MATPARSE R.NEW FROM Y.CURRENT.REC

    R.NEW(ISS.CL.OPENING.DATE) = TODAY
    Y.TIME = OCONV(TIME(), 'MTS')
    R.NEW(ISS.CL.RECEPTION.TIME) = Y.TIME

RETURN
END
