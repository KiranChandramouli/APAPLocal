* @ValidationCode : MjotNTk1NjgzMDA4OlVURi04OjE2ODkyNTQ3NjAwODA6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 18:56:00
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
SUBROUTINE LAPAP.NO.CUS.TIME
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 13-07-2023    Narmadha V             R22 Manaula Conversion  No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ST.LAPAP.OCC.CUSTOMER ;*R22 Auto Conversion - END

    Y.HORA          = ""
    Y.MINUTOS       = ""
    Y.TIME          = ""
    Y.DATA          = O.DATA

    Y.HORA1          = Y.DATA[7,8]
    Y.HORA          = Y.HORA1[1,2]
    Y.MINUTOS       = Y.DATA[9,10]

    Y.TIME          = Y.HORA:":":Y.MINUTOS

    O.DATA          = Y.TIME

RETURN
END
