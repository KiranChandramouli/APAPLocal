* @ValidationCode : MjotMTc1NTA1NzkzMTpDcDEyNTI6MTY4MDcxNTk4NDU3NTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
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
SUBROUTINE REDO.GEN.AC.MASK.OFS.SELECT
*--------------------------------------------------------------
* Description : This routine is to select the record for masking
*--------------------------------------------------------------
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14.08.2011  PRABHU N      PACS00055362         INITIAL CREATION
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

    SEL.CMD = 'SELECT ':FN.REDO.AC.PRINT.MASK
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
