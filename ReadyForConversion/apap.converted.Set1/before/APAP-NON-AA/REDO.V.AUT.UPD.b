*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUT.UPD
*-----------------------------------------------------------------------------

*------------
*DESCRIPTION:
*-----------------------------------------------------------------------------------------
*  This routine is attached as a authorization routine for the version
*  EB.SECURE.MESSAGE,MSG.REV and it will update REDO.T.MSG.DET with customer id as @ID
*------------------------------------------------------------------------------------------

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 10-FEB-2010       Prabhu.N       ODR-2009-12-0279    Initial Creation

*------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.EB.SECURE.MESSAGE

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*------
INIT:
*------
  FN.REDO.T.MSG.DET='F.REDO.T.MSG.DET'
  F.REDO.T.MSG.DET=''
  CALL OPF(FN.REDO.T.MSG.DET,F.REDO.T.MSG.DET)
  RETURN
*-------
PROCESS:
*-------
  Y.CUSTOMER.ID=R.NEW(EB.SM.TO.CUSTOMER)
  R.MSG.DET=ID.NEW
  CALL F.WRITE(FN.REDO.T.MSG.DET,Y.CUSTOMER.ID,R.MSG.DET)
  RETURN
END
