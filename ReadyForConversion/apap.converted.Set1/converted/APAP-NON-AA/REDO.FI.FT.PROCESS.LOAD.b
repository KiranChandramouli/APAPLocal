SUBROUTINE REDO.FI.FT.PROCESS.LOAD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_REDO.FI.FT.PROCESS.COMMON


    GOSUB INIT
RETURN
*----
INIT:
*----

    FN.REDO.TEMP.FI.CONTROL='F.REDO.TEMP.FI.CONTROL'
    F.REDO.TEMP.FI.CONTROL =''
    CALL OPF(FN.REDO.TEMP.FI.CONTROL,F.REDO.TEMP.FI.CONTROL)

    FN.REDO.INTERFACE.PARAM='F.REDO.INTERFACE.PARAM'
    F.REDO.INTERFACE.PARAM =''
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
RETURN
END
