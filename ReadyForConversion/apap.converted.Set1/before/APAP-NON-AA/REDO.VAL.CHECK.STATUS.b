*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.CHECK.STATUS

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.VAL.CHECK.STATUS
*-------------------------------------------------------------------------
* Description: This routine is attached as validation routine to the versions REDO.CLEARING.INWARD, REFER
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter :
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0148                Initial Creation
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.APAP.CLEARING.INWARD

  GOSUB PROCESS
  RETURN

PROCESS:
  VAL.STATUS = COMI
  IF VAL.STATUS NE 'REFERRED' THEN
    ETEXT = "EB-INVALID.STATUS"
    CALL STORE.END.ERROR
  END

  IF VAL.STATUS EQ 'REJECTED' THEN
    VAR.CURR.STATUS = R.NEW(CLEAR.CHQ.STATUS)
    IF VAL.STATUS NE VAR.CURR.STATUS THEN
      ETEXT = "EB-INVALID.STATUS"
      CALL STORE.END.ERROR
    END
  END
  IF VAL.STATUS EQ 'REJECTED' THEN
    ETEXT = "EB-INVALID.STATUS"
    CALL STORE.END.ERROR
*R.NEW(CLEAR.CHQ.REJECT.TYPE) = 'MANUAL'
  END
  RETURN
END
