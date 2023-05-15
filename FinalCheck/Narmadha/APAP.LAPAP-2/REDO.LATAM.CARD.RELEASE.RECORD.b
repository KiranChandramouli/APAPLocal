* @ValidationCode : MjotMjA3Njk5MDcxNTpDcDEyNTI6MTY4MTg4OTk1MDQ0MDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 13:09:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
