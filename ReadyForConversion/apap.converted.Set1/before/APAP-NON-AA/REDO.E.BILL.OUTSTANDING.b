*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BILL.OUTSTANDING
*****************************************
* This is a conversion routine
* This routine accepts Bill Id(with or without Sim Ref)
* and returns OS.TOTAL.AMOUNT from the sum of all OS.PROP.AMOUNT
*
*****************************************
*MODIFICATION HISTORY
*
* 05/01/09 - BG_100021512
*            Arguments changed for SIM.READ.
*
*****************************************
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AA.BILL.DETAILS
*****************************************
*
  O.DATA = SUM(R.RECORD<AA.BD.OS.PROP.AMOUNT>)
*
  RETURN
