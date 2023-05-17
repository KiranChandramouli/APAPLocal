SUBROUTINE REDO.B.NEW.NAB.ACCOUNTING.LOAD
*--------------------------------------------------------
*Description: This is load routine of the batch REDO.B.NEW.NAB.ACCOUNTING to create
* and raise the accounting entries for NAB accounting
*--------------------------------------------------------
*Input Arg  : N/A
*Out   Arg  : N/A
*Deals With : NAB Accounting
*--------------------------------------------------------
* Date           Name        Dev Ref.                         Comments
* 16 Oct 2012   H Ganesh     NAB Accounting-PACS00202156     Initial Draft
*--------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.NEW.NAB.ACCOUNTING.COMMON

    GOSUB PROCESS
RETURN
*--------------------------------------------------------
PROCESS:
*--------------------------------------------------------


    FN.REDO.AA.NAB.HISTORY = 'F.REDO.AA.NAB.HISTORY'
    F.REDO.AA.NAB.HISTORY  = ''
    CALL OPF(FN.REDO.AA.NAB.HISTORY,F.REDO.AA.NAB.HISTORY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB  = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.REDO.AA.INT.CLASSIFICATION = 'F.REDO.AA.INT.CLASSIFICATION'
    F.REDO.AA.INT.CLASSIFICATION  = ''
    CALL OPF(FN.REDO.AA.INT.CLASSIFICATION,F.REDO.AA.INT.CLASSIFICATION)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)


    FN.AA.SCH.ACT = 'F.AA.SCHEDULED.ACTIVITY'
    F.AA.SCH.ACT = ''
    CALL OPF(FN.AA.SCH.ACT,F.AA.SCH.ACT)

    Y.ID = 'SYSTEM'
*  CALL F.READ(FN.REDO.AA.INT.CLASSIFICATION,Y.ID,R.REDO.AA.INT.CLASSIFICATION,F.REDO.AA.INT.CLASSIFICATION,CLS.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.AA.INT.CLASSIFICATION,Y.ID,R.REDO.AA.INT.CLASSIFICATION,CLS.ERR) ; * Tus End

    LOC.REF.APPLICATION = "ACCOUNT"
    LOC.REF.FIELDS      = 'L.LOAN.STATUS':@VM:'L.OD.STATUS':@VM:'L.OD.STATUS.2':@VM:'L.AC.AV.BAL':@VM:'ORIGEN.RECURSOS'
    LOC.REF.POS         = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.LOAN.STATUS = LOC.REF.POS<1,1>
    POS.L.OD.STATUS   = LOC.REF.POS<1,2>
    POS.L.OD.STATUS.2 = LOC.REF.POS<1,3>
    POS.AV.BAL = LOC.REF.POS<1,4>
    POS.OR.RE = LOC.REF.POS<1,5>

RETURN
END
