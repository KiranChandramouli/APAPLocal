*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GENERATE.WOF.ACCOUNTING.LOAD

*DESCRIPTION:
*------------
* This is the COB routine for CR-43.
*
* This will process the selected Arrangement IDs from the REDO.UPDATE.NAB.HISTORY file with WOF eq 'TODAY'
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
* 26 Feb 2012    Ravikiran AV              CR.43                 Initial Creation
*
*-------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.GENERATE.WOF.ACCOUNTING.COMMON

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

  FN.REDO.WOF.ACCOUNTING = 'F.REDO.WOF.ACCOUNTING'
  F.REDO.WOF.ACCOUNTING  = ''
  CALL OPF (FN.REDO.WOF.ACCOUNTING, F.REDO.WOF.ACCOUNTING)

  RETURN
*--------------------------------------------------------------------------------------------------------------------
*
*
END
