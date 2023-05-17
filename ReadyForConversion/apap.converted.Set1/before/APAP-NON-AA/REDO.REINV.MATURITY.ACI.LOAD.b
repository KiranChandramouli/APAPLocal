*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.REINV.MATURITY.ACI.LOAD
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.MATURITY.ACI.LOAD
*--------------------------------------------------------------------------------
* Description: This Batch routine is to create a ACI for interest Liq account
* for the deposit with zero rate.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO           REFERENCE          DESCRIPTION
* 18-Jul-2011    H GANESH      PACS00072695_N.11  INITIAL CREATION
*
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.REINV.MATURITY.ACI.COMMON


  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  RETURN
END
