*-------------------------------------------------------------------------
* <Rating>-30</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.DS.REPAY.DEPOSIT(Y.MULTI)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation
*-------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.EB.LOOKUP
$INSERT I_System
$INSERT I_F.AZ.ACCOUNT
  GOSUB INITIALSE
  GOSUB CHECK.NOTES

  RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~


  RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~
  Y.CURRENT.VALUE.DATE = 'FECHA:':System.getVariable("CURRENT.VALUE.DATE")
  Y.CURRENT.TITLE = ' A NOMBRE DE ':System.getVariable("CURRENT.TITLE")
  Y.CURRENT.ACCT.NO = 'CUENTA:':System.getVariable("CURRENT.ACCT.NO"):Y.CURRENT.TITLE
  Y.CURRENT.TOTAL.AMOUNT = 'MONTO:':System.getVariable("CURRENT.TOTAL.AMOUNT")
  Y.CURRENT.TOTAL.AMOUNT2 = System.getVariable("CURRENT.TOTAL.AMOUNT")
  Y.PRINCIPAL =  System.getVariable("CURRENT.PRINCIPAL")
  Y.CURRENT.CATEGORY.DESC = System.getVariable("CURRENT.CATEGORY.DESC")
  Y.CURRENT.NAME = System.getVariable("CURRENT.NAME")
  Y.CURRENT.TITLE2 =  System.getVariable("CURRENT.TITLE2")
  Y.CONCEPT = 'CONCEPTO:  APERTURA DE ':Y.CURRENT.CATEGORY.DESC:' NUMERO ':Y.CURRENT.NAME:' A NOMBRE DE '
  Y.CONCEPT1 = Y.CURRENT.TITLE2:' POR LA SUMA DE ':Y.PRINCIPAL
  Y.MULTI = VM:Y.CURRENT.VALUE.DATE:VM:' ':VM:Y.CURRENT.ACCT.NO:VM:' ':VM:Y.CURRENT.TOTAL.AMOUNT:VM:' ':VM:Y.CONCEPT:VM:Y.CONCEPT1
  Y.CUS.SIGNATURE = 'FIRMA:_______________'
  Y.STOP.REQUES = 'NO. IDENTIFICACION: _____________________'
  Y.AUT.SIGNATURE = 'FECHA:_________________________________'
  Y.MULTI :=VM:' ':VM:' ':VM:' ':VM:Y.CUS.SIGNATURE:VM:' ':VM:Y.STOP.REQUES:VM:' ':VM:Y.AUT.SIGNATURE

  RETURN
*-------------------------------------------------------------------------
END
