SUBROUTINE REDO.RAISE.NAB.ACCOUNTING.LOAD

*DESCRIPTION:
*------------
* This is the COB routine for CR-41.
*
* This will process the selected IDs from the REDO.NAB.ACCOUNTING file.
* This will raise a Consolidated Accounting Entry for NAB Contracts
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
* 05 Dec 2011    Ravikiran AV              CR.41                 Initial Creation
*
*-------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.RAISE.NAB.ACCOUNTING.COMMON

*------------------------------------------------------------------------------------------------------------------
*
*
MAIN:

    GOSUB OPEN.FILES

RETURN
*--------------------------------------------------------------------------------------------------------------------
*
*
OPEN.FILES:

    FN.REDO.NAB.ACCOUNTING = 'F.REDO.NAB.ACCOUNTING'
    F.REDO.NAB.ACCOUNTING = ''
    CALL OPF (FN.REDO.NAB.ACCOUNTING, F.REDO.NAB.ACCOUNTING)

    FN.REDO.AA.INT.CLASSIFICATION = 'F.REDO.AA.INT.CLASSIFICATION'
    F.REDO.AA.INT.CLASSIFICATION = ''
    CALL OPF(FN.REDO.AA.INT.CLASSIFICATION, F.REDO.AA.INT.CLASSIFICATION)

    FN.REDO.AA.NAB.HISTORY = 'F.REDO.AA.NAB.HISTORY'
    F.REDO.AA.NAB.HISTORY = ''
    CALL OPF(FN.REDO.AA.NAB.HISTORY, F.REDO.AA.NAB.HISTORY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    APP = 'ACCOUNT'
    LOC.FLD = 'L.LOAN.STATUS'
    LOC.FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APP, LOC.FLD, LOC.FLD.POS)
    L.LOAN.STATUS.POS = LOC.FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------------------
*
*
END
