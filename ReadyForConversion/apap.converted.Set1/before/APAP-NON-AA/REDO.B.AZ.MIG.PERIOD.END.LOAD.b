*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.AZ.MIG.PERIOD.END.LOAD
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.AZ.MIG.PERIOD.END.LOAD
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the initialisation of the batch job

* Linked with   : None
* In Parameter  : None
* Out Parameter : None
*--------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.AZ.MIG.PERIOD.END.COMMON

  FN.AZACCOUNT='F.AZ.ACCOUNT'
  F.AZACCOUNT=''
  CALL OPF(FN.AZACCOUNT,F.AZACCOUNT)

  RETURN
END
