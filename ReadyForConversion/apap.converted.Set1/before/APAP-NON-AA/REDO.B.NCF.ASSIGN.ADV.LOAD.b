*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.NCF.ASSIGN.ADV.LOAD

*DESCRIPTION:
*------------
*This Routine will select arrangements to generate NCF for the remaining amount
*in advance payment
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 25-MAR-2010        Prabhu.N       ODR-2009-10-0321     Initial Creation
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.SCHEDULED.ACTIVITY
$INSERT I_REDO.B.NCF.ASSIGN.ADV.COMMON

  FN.REDO.AA.REPAY='F.REDO.AA.REPAY'
  F.REDO.AA.REPAY=''
  CALL OPF(FN.REDO.AA.REPAY,F.REDO.AA.REPAY)

  FN.AA.BILL.DETAILS='F.AA.BILL.DETAILS'
  F.AA.BILL.DETAILS=''
  CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

  FN.REDO.L.NCF.STOCK='F.REDO.L.NCF.STOCK'
  F.REDO.L.NCF.STOCK=''
  CALL OPF(FN.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK)

  FN.REDO.NCF.ISSUED='F.REDO.NCF.ISSUED'
  F.REDO.NCF.ISSUED=''
  CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)

  FN.REDO.L.NCF.UNMAPPED='F.REDO.L.NCF.UNMAPPED'
  F.REDO.L.NCF.UNMAPPED=''
  CALL OPF(FN.REDO.L.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED)

  FN.REDO.L.NCF.STATUS='F.REDO.L.NCF.STATUS'
  F.REDO.L.NCF.STATUS=''
  CALL OPF(FN.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS)

  FN.AA.SCHEDULED.ACTIVITY='F.AA.SCHEDULED.ACTIVITY'
  F.AA.SCHEDULED.ACTIVITY=''
  CALL OPF(FN.AA.SCHEDULED.ACTIVITY,F.AA.SCHEDULED.ACTIVITY)

  FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
  F.AA.ACCOUNT.DETAILS=''
  CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

  RETURN
END
