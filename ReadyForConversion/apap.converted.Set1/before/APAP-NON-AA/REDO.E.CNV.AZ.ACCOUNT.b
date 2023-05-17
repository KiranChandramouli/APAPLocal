*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.AZ.ACCOUNT
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System

  Y.DATA = O.DATA
  ACCT.ID = System.getVariable("CURRENT.ACCT.NO")
  IF Y.DATA NE ACCT.ID THEN
    O.DATA = ACCT.ID
  END
  RETURN
END
