*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BLD.ACC.FUNDS.INTRANSIT(ENQ.DATA)

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Sudharsanan S
* Program Name : REDO.BLD.ACC.FUNDS.INTRANSIT
*---------------------------------------------------------

* Description : This build routine is used to get the customer id value based on L.FT.AZ.ACC.REF value
*----------------------------------------------------------
* Linked With :
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.CLEARING.OUTWARD
$INSERT I_System

  FN.REDO.CLEARING.OUTWARD = 'F.REDO.CLEARING.OUTWARD'
  F.REDO.CLEARING.OUTWARD  = ''
  CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)

  Y.VAR.ACCOUNT = System.getVariable('CURRENT.ACCT.NO')
 
  ENQ.DATA<2,-1> = 'CHQ.STATUS'
  ENQ.DATA<3,-1> = 'EQ'
  ENQ.DATA<4,-1> = 'DEPOSITED'

  ENQ.DATA<2,-1> = 'ACCOUNT'
  ENQ.DATA<3,-1> = 'EQ'
  ENQ.DATA<4,-1> = Y.VAR.ACCOUNT

  RETURN

END
