*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.SET.ROUTINE

************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.V.INP.SET.ROUTINE
*----------------------------------------------------------

* Description   : This subroutine will set the FT Routine field
* Linked with   :
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STANDING.ORDER
  R.NEW(STO.FT.ROUTINE)="@REDO.FT.UPDATE.ACH.PARAMETER"
  RETURN
END
