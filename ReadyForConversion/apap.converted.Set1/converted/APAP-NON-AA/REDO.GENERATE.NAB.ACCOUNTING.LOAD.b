SUBROUTINE REDO.GENERATE.NAB.ACCOUNTING.LOAD

*DESCRIPTION:
*------------
* This is the COB routine for CR-41.
*
* This will process the selected Arrangement IDs from the REDO.UPDATE.NAB.HISTORY file with STATUS is STARTED.
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
    $INSERT I_REDO.GENERATE.NAB.ACCOUNTING.COMMON

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

    FN.REDO.AA.NAB.HISTORY = 'F.REDO.AA.NAB.HISTORY'
    F.REDO.AA.NAB.HISTORY = ''
    CALL OPF (FN.REDO.AA.NAB.HISTORY, F.REDO.AA.NAB.HISTORY)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF (FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)

    FN.REDO.NAB.ACCOUNTING = 'F.REDO.NAB.ACCOUNTING'
    F.REDO.NAB.ACCOUNTING  = ''
    CALL OPF (FN.REDO.NAB.ACCOUNTING, F.REDO.NAB.ACCOUNTING)

RETURN
*--------------------------------------------------------------------------------------------------------------------
*
*
END
