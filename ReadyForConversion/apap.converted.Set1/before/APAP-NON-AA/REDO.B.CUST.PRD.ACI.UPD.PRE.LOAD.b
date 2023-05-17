*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CUST.PRD.ACI.UPD.PRE.LOAD
*-------------------------------------------------------------------
* New Subroutine
* spliting REDO.B.CUST.PRD.ACI.UPD.select routine as a multi-thread rtn
*


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.ACCOUNT.CREDIT.INT
$INSERT I_F.BASIC.INTEREST
$INSERT I_F.DATES
$INSERT I_F.REDO.CUST.PRD.LIST
$INSERT I_F.REDO.ACC.CR.INT
$INSERT I_REDO.B.CUST.PRD.ACI.UPD.COMMON


  CALL REDO.B.CUST.PRD.ACI.UPD.LOAD



  RETURN
