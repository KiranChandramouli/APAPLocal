SUBROUTINE REDO.AUT.WOF.MIG
*----------------------------------------------------
*Description: This is the input routine for WOF account creation version.
*----------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*----------------------------------------------------
OPEN.FILES:
*----------------------------------------------------

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.CONCAT.ACC.WOF = 'F.REDO.CONCAT.ACC.WOF'
    F.REDO.CONCAT.ACC.WOF  = ''
    CALL OPF(FN.REDO.CONCAT.ACC.WOF,F.REDO.CONCAT.ACC.WOF)


RETURN
*----------------------------------------------------
PROCESS:
*----------------------------------------------------

    Y.DETAILS = R.NEW(AC.ACCOUNT.TITLE.2)
    Y.AA.ID   = FIELD(Y.DETAILS,'*',1)
    Y.AA.TYPE = FIELD(Y.DETAILS,'*',2)
    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)

    Y.LOAN.AC = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    R.REDO.CONCAT.ACC.WOF = ''
    CALL F.READU(FN.REDO.CONCAT.ACC.WOF,Y.LOAN.AC,R.REDO.CONCAT.ACC.WOF,F.REDO.CONCAT.ACC.WOF,CON.ERR,'R 10 10')

    IF Y.AA.TYPE EQ 'PRINCIPLE' THEN
        R.REDO.CONCAT.ACC.WOF<1> = ID.NEW
    END
    IF Y.AA.TYPE EQ 'INTEREST' THEN
        R.REDO.CONCAT.ACC.WOF<2> = ID.NEW
    END
    CALL F.WRITE(FN.REDO.CONCAT.ACC.WOF,Y.LOAN.AC,R.REDO.CONCAT.ACC.WOF)
RETURN
END
