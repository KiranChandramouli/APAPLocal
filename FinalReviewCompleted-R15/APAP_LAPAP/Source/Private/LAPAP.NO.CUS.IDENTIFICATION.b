* @ValidationCode : MjotMTUzNDUxMzYxNzpVVEYtODoxNjg5NzQ5NjU1NzE5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:15
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.NO.CUS.IDENTIFICATION
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,FM to @FM
* 13-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER ;*R22 Auto Conversion - END

    Y.IDEN.ID     = ""
    Y.DATA          = O.DATA

    Y.DATA                = CHANGE(Y.DATA,".",@FM)
    Y.IDEN.ID           = Y.DATA<2>

    O.DATA                = Y.IDEN.ID

RETURN

END
