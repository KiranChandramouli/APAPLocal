SUBROUTINE REDO.GET.OVERDUE.COND
*------------------------------------------------
*Description: This routine is a conversion routine for enquiry REDO.PART.TT.PROCESS.LIST.
*------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.OVERDUE

    GOSUB PROCESS
RETURN
*------------------------------------------------
PROCESS:
*------------------------------------------------

    LOC.REF.APPLICATION = "AA.PRD.DES.OVERDUE"
    LOC.REF.FIELDS      = 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.LOAN.STATUS.1 = LOC.REF.POS<1,1>
    POS.L.LOAN.COND     = LOC.REF.POS<1,2>

    Y.ACC.NO = O.DATA
    IN.ARR.ID = ''
    Y.AA.ID = ''
    CALL REDO.CONVERT.ACCOUNT(Y.ACC.NO,IN.ARR.ID,Y.AA.ID,ERR.TEXT)

    IF Y.AA.ID ELSE
        O.DATA = ''
        RETURN
    END

    EFF.DATE    = ''
    PROP.CLASS  = 'OVERDUE'
    PROPERTY    = ''
    R.CONDITION = ''
    ERR.MSG     = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)

    Y.LOAN.COND   = R.CONDITION<AA.OD.LOCAL.REF,POS.L.LOAN.COND,1>
    Y.LOAN.STATUS = R.CONDITION<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1,1>
    IF Y.LOAN.COND OR Y.LOAN.STATUS THEN
        O.DATA = Y.LOAN.STATUS:'*':Y.LOAN.COND
    END ELSE
        O.DATA = ''
    END

RETURN
END
