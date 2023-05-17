*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TFS.WAIVE.CHARGE.NO
*----------------------------------------------
*Description: This routine is to defaulte the WAIVE.CHARGE field as NO when it is null.
*----------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.T24.FUND.SERVICES

  GOSUB PROCESS
  RETURN
*----------------------------------------------
PROCESS:
*----------------------------------------------
  Y.TRANSACTION = R.NEW(TFS.TRANSACTION)
  Y.TXN.CNT = DCOUNT(Y.TRANSACTION,VM)
  Y.VAR1 = 1
  LOOP
  WHILE Y.VAR1 LE Y.TXN.CNT

    IF R.NEW(TFS.WAIVE.CHARGE)<1,Y.VAR1> EQ '' THEN
      R.NEW(TFS.WAIVE.CHARGE)<1,Y.VAR1> = 'NO'
    END
    Y.VAR1++
  REPEAT

  IF AF EQ TFS.DO.CASH.BACK THEN
    IF COMI EQ 'YES' THEN
      GOSUB SET.NET.ENTRY     ;* If DO CASHBACK is set to YES then we need to set Net entry as Credit.
    END
  END

  RETURN
*----------------------------------------------
SET.NET.ENTRY:
*----------------------------------------------
* If DO CASHBACK is set as YES, then Netting needs to be done. cos we will have more than one transaction in TFS.

  R.NEW(TFS.NET.ENTRY) = 'CREDIT'

  RETURN
END
