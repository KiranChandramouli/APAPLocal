*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.NOF.CUST.CC(Y.CARD.LIST)

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.E.NOF.CUST.CC
*--------------------------------------------------------------------------------
* Description: This Enquiry nofile routine is to bring all the credit cards from
* sunne that llinked to the customer
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE         WHO         REFERENCE         DESCRIPTION
* 24-May-2011   Pradeep S   PACS00071066      INITIAL CREATION
*
*----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.FRONT.REQUESTS

  GOSUB INIT
  GOSUB PROCESS

  RETURN

INIT:
******

  RETURN

PROCESS:
*********
  LOCATE "CUST.ID" IN D.FIELDS SETTING CUS.POS THEN
    Y.CUST.ID = D.RANGE.AND.VALUE<CUS.POS>
  END

  D.FIELDS = 'CLIENT.ID':FM:'COMPANY.CODE'
  D.RANGE.AND.VALUE   = Y.CUST.ID:FM:'1'
  D.LOGICAL.OPERANDS  = '1':FM:'1'

  CALL REDO.CREDIT.CUSTOMER.POSITION.VP(Y.CC.LIST)

  Y.CARD.LIST = FIELDS(Y.CC.LIST,'*',5,1)

  RETURN
END
