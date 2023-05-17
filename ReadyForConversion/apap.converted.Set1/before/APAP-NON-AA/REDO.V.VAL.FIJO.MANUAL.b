*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.FIJO.MANUAL
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Sivakumar K
* Program Name  : REDO.V.VAL.FIJO.MANUAL
* ODR NUMBER    :
*----------------------------------------------------------------------------------
* Description   : This VALIDATION routine will do check if TYPE.RATE.REV is "FIJO"
*                 then assign the value for the field FORM.REVIEW as "MANUAL" else
*                 assign as "AUTOMATIC".
*
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 12-Mar-2013      Sivakumar K        PACS00254290      Initial creation
*----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CREATE.ARRANGEMENT

  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN

*----------------------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------------------


  FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
  F.REDO.CREATE.ARRANGEMENT = ''
  CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

  RETURN

*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

  IF COMI EQ 'FIJO' THEN
    R.NEW(REDO.FC.FORM.REVIEW) = "MANUAL"
  END ELSE
    IF COMI EQ 'BACK.TO.BACK' THEN
      R.NEW(REDO.FC.FORM.REVIEW) = "AUTOMATICA"
    END
  END

  RETURN
END
