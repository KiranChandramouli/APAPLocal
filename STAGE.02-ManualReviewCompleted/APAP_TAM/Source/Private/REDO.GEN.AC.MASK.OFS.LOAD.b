* @ValidationCode : MjotMTAyMDYyNzIzNzpDcDEyNTI6MTY4MDcxNTk4NDU3MDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 23:03:04
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
$PACKAGE APAP.TAM

SUBROUTINE REDO.GEN.AC.MASK.OFS.LOAD
*--------------------------------------------------------------
* Description : This routine is to generate ofs message for AC.PRINT.MASK.
*
*--------------------------------------------------------------
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*23.08.2011  Prabhu N      PACS00055362         INITIAL CREATION
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*----------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.GEN.AC.MASK.OFS.COMMON

    GOSUB PROCESS
RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------
    FN.REDO.AC.PRINT.MASK='F.REDO.AC.PRINT.MASK'
    F.REDO.AC.PRINT.MASK=''
    CALL OPF(FN.REDO.AC.PRINT.MASK,F.REDO.AC.PRINT.MASK)

    FN.AC.PRINT.MASK='F.AC.PRINT.MASK'
    F.AC.PRINT.MASK=''
    CALL OPF(FN.AC.PRINT.MASK,F.AC.PRINT.MASK)

RETURN
END
