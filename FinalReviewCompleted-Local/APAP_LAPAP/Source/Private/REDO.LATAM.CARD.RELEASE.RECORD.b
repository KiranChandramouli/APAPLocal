* @ValidationCode : MjotMjA3Njk5MDcxNTpDcDEyNTI6MTY4NDIyMjgzMjY4MTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:32
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
$PACKAGE APAP.LAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.LATAM.CARD.RELEASE.RECORD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LATAM.CARD.RELEASE

    IF R.OLD(CRD.REL.CARD.NUMBER) EQ R.NEW(CRD.REL.CARD.NUMBER) THEN
        R.NEW(CRD.REL.CARD.NUMBER)=''
    END


RETURN
