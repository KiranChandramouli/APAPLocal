* @ValidationCode : MjotMTA2MjkzMTQ2NTpDcDEyNTI6MTY4MDYwMzE2NzcwMTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:42:47
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

** 04-04-2023 R22 Auto Conversion – no changes
** 04-04-2023 Skanda R22 Manual Conversion - No changes

$PACKAGE APAP.TAM
SUBROUTINE REDO.CALL.UTIL.RTN

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.REPRINT.INAO.TT

    NEW.CMD = '##UTILITY.ROUTINE##:'      ;* Instruction to run a Utility Routine
    NEW.CMD := 'REDO.UTIL.CHQ.PRINTING:'  ;* Name of the Utility Routine
    NEW.CMD := '###':R.NEW(REDO.TT.INAO.HOLD.CTRL.ID)         ;* Get the record id
    CALL EB.SET.NEW.TASK(NEW.CMD)
RETURN
