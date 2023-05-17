*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GT.EXP.DATE
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.GT.EXP.DATE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to Get the Exposure date and check whether it is greater than old
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CLEARING.OUTWARD

  GOSUB PROCESS
  RETURN

PROCESS:
*Get the Exposure date and check whether it is greater than old

  VAR.NEW.EXP.DATE = R.NEW(CLEAR.OUT.EXPOSURE.DATE)
  VAR.OLD.EXP.DATE = R.OLD(CLEAR.OUT.EXPOSURE.DATE)
  IF VAR.OLD.EXP.DATE GT VAR.NEW.EXP.DATE THEN
    AF = CLEAR.OUT.EXPOSURE.DATE
    ETEXT = "EB-REDO.GT.EXP.DATE"
    CALL STORE.END.ERROR
  END
  RETURN
END
