SUBROUTINE REDO.V.AUTH.ADJ.SUSP.BAL
*********************************************************************
*Company Name  : APAP
*First Release : R15 Upgrade
*Developed for : APAP
*Developed by  : Edwin Charles D
*Date          : 21/06/2017
*--------------------------------------------------------------------------------------------
*
* Subroutine Type       : PROCEDURE
* Attached to           : VERSION  - AA.ARRANGEMENT.ACTIVITY,ADJ.AUTH
* Attached as           : ID ROUTINE
* Primary Purpose       : When a transaction is authorised, we are replacing the arrangement status
* Modified              : R15 Upgrade
*--------------------------------------------------------------------------------------------
* Modification Details:
*--------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.AA.UNC.PENDING

*
*************************************************************************

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
*----
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
    FN.REDO.AA.UNC.PENDING = 'F.REDO.AA.UNC.PENDING'
    F.REDO.AA.UNC.PENDING = ''
    CALL OPF(FN.REDO.AA.UNC.PENDING, F.REDO.AA.UNC.PENDING)

RETURN

PROCESS:
*-------
    R.AA.ARRANGEMENT = ''
    ARR.ERR = ''
    AA.ARR.ID = ''
    AA.ARR.ID = R.NEW(AA.ARR.ACT.ARRANGEMENT)
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    CALL F.READ(FN.REDO.AA.UNC.PENDING,AA.ARR.ID,R.REDO.AA.UNC.PENDING,F.REDO.AA.UNC.PENDING,UNC.ERR)
    IF AA.ARR.ID AND R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS> EQ 'CURRENT' AND R.REDO.AA.UNC.PENDING<AA.UN.ARR.STATUS> EQ 'PENDING.CLOSURE' THEN
        R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS> = 'PENDING.CLOSURE'
        CALL F.WRITE(FN.AA.ARRANGEMENT,AA.ARR.ID,R.AA.ARRANGEMENT)
    END
    CALL F.DELETE(FN.REDO.AA.UNC.PENDING,AA.ARR.ID)
RETURN
END
