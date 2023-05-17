*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.CARDS.EXPIRY.DATE
************************************************************
*----------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Description   : This subroutine is attached as a conversion routine in the Enquiry REDO.CUR.ACCT.DET
*                 to get the no of associated card with the account
* Linked with   : Enquiry  REDO.CUR.ACCT.DET as conversion routine
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.07.2010  PRABHU N      ODR-2010-08-0031   INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System

  O.DATA =System.getVariable('CURRENT.CARD')
  RETURN
END
