SUBROUTINE AI.REDO.DELETE.MSG
*-----------------------------------------------------------------------------
*Company   Name     : APAP
*Developed By       : Martin Macias
*Program   Name     : AI.REDO.DELETE.MSG
*-----------------------------------------------------------------------------
*Functionality      : Next Command
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_EQUATE

    NEXT.COMMAND = 'OVERRIDE,AI.REDO.DEL.MSG S AI.REDO.DEL.MSG'
    CALL EB.SET.NEXT.TASK(NEXT.COMMAND)

END
