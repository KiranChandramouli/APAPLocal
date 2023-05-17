*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.LY.V.EXP.TYPE
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.LY.PROGRAM table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.EXP.TYPE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243       UPDATE
* -----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LY.PROGRAM

  IF VAL.TEXT THEN
    VAR.EXP.TYPE = R.NEW(REDO.PROG.EXP.TYPE)
  END ELSE
    VAR.EXP.TYPE = COMI
  END

  GOSUB PROCESS

  RETURN

*-------
PROCESS:
*-------

  IF VAL.TEXT EQ '' THEN
    VAL.TEXT = 'VALIDATED'
    CALL REDO.V.AVAIL.PROGRAM
    CALL REDO.V.DISDELAY
    CALL REDO.LY.DIS.FIELDS.T
    CALL REDO.LY.DIS.FIELDS.P
    CALL REDO.LY.DIS.FIELDS.P2
    CALL REDO.V.TXN.INT
    VAL.TEXT = ''
  END ELSE
    CALL REDO.V.AVAIL.PROGRAM
    CALL REDO.V.DISDELAY
    CALL REDO.LY.DIS.FIELDS.T
    CALL REDO.LY.DIS.FIELDS.P
    CALL REDO.LY.DIS.FIELDS.P2
    CALL REDO.V.TXN.INT
  END

  IF VAR.EXP.TYPE EQ 'POR.DIAS' THEN
    T(REDO.PROG.EXP.DATE)<3> = 'NOINPUT'
  END ELSE
    T(REDO.PROG.DAYS.EXP)<3> = 'NOINPUT'
  END

  RETURN

*------------------------------------------------------------------------------------
END
