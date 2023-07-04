* @ValidationCode : MjotMTQ3OTMwNzM3NjpDcDEyNTI6MTY4MDY3MTc1Nzg4MjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:45:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

** 05-04-2023 R22 Auto Conversion no changes
** 05-04-2023 Skanda R22 Manual Conversion - No changes

$PACKAGE APAP.TAM
SUBROUTINE REDO.CHQ.CHANGE.VER

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    Y.VER = O.DATA

    IF Y.VER EQ 'TELLER,REDO.OVERPYMT.CHEQUE' THEN
        O.DATA = 'TELLER,REDO.OVERPYMT.CQ.DUP'
    END

RETURN

END
