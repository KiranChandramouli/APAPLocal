*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RATE.CHANGE.INT
*----------------------------------------------------------------
* DESCRIPTION: This routine is a validation routine to make margin Field as no-inputtable

*----------------------------------------------------------------
* Modification History :
*
*  DATE             WHO          REFERENCE           DESCRIPTION
* 12-Jul-2011     H GANESH     PACS00055012 - B.16  INITIAL CREATION
*----------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.RATE.CHANGE.CRIT

  GOSUB PROCESS
  RETURN

*----------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------
  IF COMI EQ '' THEN
    RETURN
  END ELSE
    GOSUB CHECK.COND
  END

  RETURN
*----------------------------------------------------------------
CHECK.COND:
*----------------------------------------------------------------

  IF R.NEW(RATE.CHG.PROP.SPRD.CHG)<1,AV> NE '' THEN
    ETEXT = 'EB-REDO.MARGIN.NOT.ALLW'
    CALL STORE.END.ERROR
    RETURN
  END
  RETURN
END
