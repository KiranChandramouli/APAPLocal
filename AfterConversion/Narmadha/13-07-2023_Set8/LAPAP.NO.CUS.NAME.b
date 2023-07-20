* @ValidationCode : MjotNzY2NDY2NDk0OlVURi04OjE2ODkyNTQ3MDUwOTU6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 18:55:05
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
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.NO.CUS.NAME
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,FM to @FM
* 13-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER ;*R22 Auto Conversion - End

    Y.CUS.NAME      = ""
    Y.DATA          = O.DATA

    Y.DATA                = CHANGE(Y.DATA,".",@FM)
    Y.CUS.NAME            = Y.DATA<3>

    O.DATA                = Y.CUS.NAME

RETURN

END
