*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.AA.UNC.PENDING.LOAD
*-------------------------------------------------
*Description:
*-------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AA.UNC.PENDING
    $INSERT I_REDO.B.AA.UNC.PENDING.COMMON

    GOSUB PROCESS

    RETURN


PROCESS:
*-------

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.REDO.AA.UNC.PENDING = 'F.REDO.AA.UNC.PENDING'
    F.REDO.AA.UNC.PENDING = ''

    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)
    CALL OPF(FN.REDO.AA.UNC.PENDING,F.REDO.AA.UNC.PENDING)

    RETURN
END