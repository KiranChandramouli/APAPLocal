*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.UPD.CUS.ACTANAC(Y.CUS.ID)

* Correction routine to update the file F.CUSTOMER.L.CU.ACTANAC
*

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_REDO.S.UPD.CUS.ACTANAC.COMMON

  GOSUB PROCESS

  RETURN

**********
PROCESS:
*********
** Section to get the Actanac value
  R.CUS = ''
  CALL F.READ(FN.CUS,Y.CUS.ID,R.CUS,F.CUS,CUS.ERR)
  IF R.CUS THEN
    Y.ACT.ID = R.CUS<EB.CUS.LOCAL.REF,ACT.LRF.POS>
    GOSUB UPD.FILE
  END

  RETURN

**********
UPD.FILE:
**********
* Section to update the file F.CUSTOMER.L.CU.ACTANAC

  R.ACT.ID = ''
  CALL F.READ(FN.CUS.ACTANAC,Y.ACT.ID,R.ACT.ID,F.CUS.ACTANAC,ACT.ERR)
  IF ACT.ERR THEN
    R.VALUE = R.CUS<EB.CUS.COMPANY.BOOK>:"*":Y.CUS.ID
    CALL F.WRITE(FN.CUS.ACTANAC,Y.ACT.ID,R.VALUE)
  END

  RETURN

END
