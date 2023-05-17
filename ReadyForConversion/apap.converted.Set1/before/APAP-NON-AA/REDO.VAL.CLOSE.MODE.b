*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.CLOSE.MODE
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : JEEVA T
* Program Name : REDO.VAL.CLOSE.MODE
*----------------------------------------------------------

* Description   :
* Linked with   :
* In Parameter  : None
* Out Parameter : None
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.10.2010   JEEVA T      ODR-2010-08-0031   INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.ACCOUNT.CLOSURE

  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

  R.NEW(AC.ACL.CLOSE.MODE) = 'TELLER'
  RETURN
*-----------------------------------------------------------------------------
END
