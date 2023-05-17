*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.SELECT.DATE(ENQ.DATA)
*----------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Description   : This subroutine is attached as a Build routine in the Enquiry REDO.E.AA.ARR.ACTIVITY
*
* Linked with   : Enquiry REDO.E.AA.ARR.ACTIVITY  as build routine
* In Parameter  : ENQ.DATA
* Out Parameter : none
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10.07.2010  PRABHU N     ODR-2010-08-0017   INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
  GOSUB PROCESS
  RETURN
*-------
PROCESS:
*-------
  LOCATE "ID.COMP.3" IN ENQ.DATA<2,1> SETTING VAR.COMP.POS THEN
    VAR.DATE.VAL = ENQ.DATA<4,VAR.COMP.POS>
    ENQ.DATA<3,VAR.COMP.POS>='LK'
    ENQ.DATA<4,VAR.COMP.POS>=VAR.DATE.VAL:'...'
  END
  RETURN
END
