SUBROUTINE REDO.CALL.UTIL.RTN

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.REPRINT.INAO.TT

    NEW.CMD = '##UTILITY.ROUTINE##:'      ;* Instruction to run a Utility Routine
    NEW.CMD := 'REDO.UTIL.CHQ.PRINTING:'  ;* Name of the Utility Routine
    NEW.CMD := '###':R.NEW(REDO.TT.INAO.HOLD.CTRL.ID)         ;* Get the record id
    CALL EB.SET.NEW.TASK(NEW.CMD)
RETURN
