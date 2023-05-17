*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.PREVALANCE.STATUS.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION: This routine performs initialisation and gets the details from the parameter table REDO.LY.MODALITY
*  and stores it in the common variable
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date           who           Reference            Description
* 03-MAY-2010   S.Jeyachandran  ODR-2010-08-0490      Initial Creation
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.PREVALANCE.STATUS.COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.REDO.PREVALANCE.STATUS

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB GOEND
  RETURN

*********
INIT:
*********

  Y.APPICATION = 'ACCOUNT'
  Y.FIELDS = 'L.AC.STATUS1':VM:'L.AC.STATUS2':VM:'L.AC.STATUS'
  Y.POS = ''
  CALL MULTI.GET.LOC.REF(Y.APPICATION,Y.FIELDS,Y.POS)
  Y.L.AC.STATUS1.POS = Y.POS<1,1>
  Y.L.AC.STATUS2.POS = Y.POS<1,2>
  Y.L.AC.STATUS.POS = Y.POS<1,3>
  RETURN

**********
OPENFILES:
**********

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.REDO.PREVALANCE.STATUS = 'F.REDO.PREVALANCE.STATUS'
  F.REDO.PREVALANCE.STATUS = ''
  CALL OPF(FN.REDO.PREVALANCE.STATUS,F.REDO.PREVALANCE.STATUS)
  Y.ID1 = "SYSTEM"
  CALL CACHE.READ(FN.REDO.PREVALANCE.STATUS,Y.ID1,R.REDO.PREVALANCE.STATUS,F.ERR)
  RETURN

*********
GOEND:
*********
END
