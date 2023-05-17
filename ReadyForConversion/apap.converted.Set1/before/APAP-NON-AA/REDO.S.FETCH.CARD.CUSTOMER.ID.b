*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FETCH.CARD.CUSTOMER.ID(IN.PARAM)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :KAVITHA
*Program   Name    :REDO.S.FETCH.CARD.CUSTOMER.ID
*-------------------------------------------------------------------------------

*DESCRIPTION       :This subroutine is used to get the value of CUSTOMER ID
*
* ----------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* Revision History
*-------------------------
*    Date             Who               Reference       Description
* 01-JUL-2011        KAVITHA            PACS00062260    Initial creation
*----------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.LATAM.CARD.ORDER

  FN.CUST='F.CUSTOMER'
  F.CUST=''
  CALL OPF(FN.CUST,F.CUST)

  IN.PARAM = R.NEW(CARD.IS.CUSTOMER.NO)<1,1>


  RETURN
END
