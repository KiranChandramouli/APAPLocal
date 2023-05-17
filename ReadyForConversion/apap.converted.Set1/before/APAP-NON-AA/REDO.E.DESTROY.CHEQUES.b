*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.DESTROY.CHEQUES(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.E.DESTROY.CHEQUES
*-------------------------------------------------------------------------
* Description: This routine is a build routine used to format the selection criteria value
*
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 15-09-10          ODR-2010-08-0179                 Initial Creation
*------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  GOSUB PROCESS

  RETURN
*-------
PROCESS:
*-----------------------------------------
* Main enquiry process is carried on here
*-----------------------------------------

  LOCATE "DATE.TIME" IN ENQ.DATA<2,1> SETTING Y.OPR.POS THEN
    VAL.OPERAND = ENQ.DATA<4,Y.OPR.POS>
    VAR.OPERAND = VAL.OPERAND[3,6]
    ENQ.DATA<4,Y.OPR.POS> = VAR.OPERAND
  END
  RETURN
END
