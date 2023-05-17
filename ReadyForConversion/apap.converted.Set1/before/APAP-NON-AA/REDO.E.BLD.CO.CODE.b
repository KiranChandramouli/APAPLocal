*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.CO.CODE(ENQ.DATA)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.E.BLD.CO.CODE
*-------------------------------------------------------------------------

* Description : This is a Build routine which will be executed to display the
* reversing of certified cheques only to the Company which has been currently logged in
* This Routine will be attached to the Following Enquiry ENQ.CERT.CHEQ.STOCK.REV,ENQ.CERT.CHEQ.STOCK,ENQ.CERT.CHEQ.DETAILS

* In parameter : ENQ.DATA
* out parameter : ENQ.DATA
* Linked with : Build routine for the enquiry ENQ.CERT.CHEQ.STOCK.REV
*-------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ENQUIRY
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CERTIFIED.CHEQUE.STOCK
$INSERT I_F.CERTIFIED.CHEQUE.DETAILS
  GOSUB INIT
  GOSUB PROCESS
  RETURN
INIT:
  FN.CERTIFIED.CHEQUE.STOCK='F.CERTIFIED.CHEQUE.STOCK'
  F.CERTIFIED.CHEQUE.STOCK=''
  CALL OPF(FN.CERTIFIED.CHEQUE.STOCK,F.CERTIFIED.CHEQUE.STOCK)
  FN.CERTIFIED.CHEQUE.DETAILS='F.CERTIFIED.CHEQUE.DETAILS'
  F.CERTIFIED.CHEQUE.DETAILS=''
  CALL OPF(FN.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS)
  Y.COMPANY.CODE=''
  RETURN
PROCESS:

  Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,VM)

  Y.COMPANY.CODE = ID.COMPANY
  ENQ.DATA<2,Y.FIELD.COUNT+1> = 'COMP.CODE'
  ENQ.DATA<3,Y.FIELD.COUNT+1> = 'EQ'
  ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.COMPANY.CODE
  RETURN
END
