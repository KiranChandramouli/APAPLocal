* @ValidationCode : MjotMjA3ODQwNjYwNTpDcDEyNTI6MTY4MDc1NTk3MzI0MjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 10:09:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
** 06-04-2023 R22 Auto Conversion no changes
** 06-04-2023 Skanda R22 Manual Conversion - No changes
$PACKAGE APAP.TAM
SUBROUTINE REDO.FMT.ACH.REV.FT.ID

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.FT.REV.ID


    CALL JULDATE(GREGORIAN.DATE,JULIAN.DATE)
    JULIAN.DATE=JULIAN.DATE[3,7]
    Y.ID.FILE=COMI
    Y.LEN    =LEN(COMI)
    COMI     ='FT':JULIAN.DATE:Y.ID.FILE[11,Y.LEN]
RETURN

END
