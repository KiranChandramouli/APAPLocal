*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-4</Rating>
*-----------------------------------------------------------------------------
    PROGRAM LAPAP.UPDATE.FIELD.BCR
*-----------------------------------------------------------------------------
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE TAM.BP I_F.REDO.BCR.REPORT.EXEC
*-----------------------------------------------------------------------------
*-- Modification History:
*-----------------
*-- Date        Name                Reference       Version
* ------        ----                ---------       -------
*-- 11/07/2018  Anthony Martinez    CN008777        update field REP.TIME.RANGE in table REDO.BCR.REPORT.EXEC

    FN.REDO.BCR.REPORT.EXEC = 'F.REDO.BCR.REPORT.EXEC'
    F.REDO.BCR.REPORT.EXEC  = ''
    Y.BRC.ID = 'BCR001'
    R.DATA<REDO.BCR.REP.EXE.REP.TIME.RANGE> = '20180716'

    CALL OPF(FN.REDO.BCR.REPORT.EXEC, F.REDO.BCR.REPORT.EXEC)
    CALL F.WRITE(FN.REDO.BCR.REPORT.EXEC, Y.BRC.ID, R.DATA)
    CALL JOURNAL.UPDATE('')

    RETURN
