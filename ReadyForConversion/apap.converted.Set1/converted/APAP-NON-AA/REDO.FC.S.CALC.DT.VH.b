*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.S.CALC.DT.VH
* ============================================================================
*
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose : VALIDATION TYPE.RATE.REV
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Jorge Valarezo (jvalarezoulloa@temenos.com) - TAM Latin America
* Date            : DEC 10 2012
*
*============================================================================

******************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CREATE.ARRANGEMENT
$INSERT I_System
$INSERT I_GTS.COMMON
******************************************************************************

  GOSUB INITIALISE

  RETURN

* =========
INITIALISE:
* =========

  CAMPO.ACTUAL = OFS$HOT.FIELD
  NOMBRE.CAMPO = "...VAL.DATE.VS..."

  IF CAMPO.ACTUAL MATCH NOMBRE.CAMPO THEN
    Y.FECHA.REV = COMI
    Y.POS = AV
    GOSUB PROCESS
  END
  ELSE

    Y.NUM.COL = DCOUNT (R.NEW (REDO.FC.VAL.DATE.VS),VM)
    FOR Y.POS = 1 TO Y.NUM.COL
      Y.FECHA.REV = R.NEW (REDO.FC.VAL.DATE.VS)<1,Y.POS>
      GOSUB PROCESS
    NEXT Y.NUM.COL
  END





  RETURN
*
* ======
PROCESS:
* ======
*
  IF  Y.FECHA.REV EQ '' THEN
    RETURN
  END

  Y.MONTH = R.NEW(REDO.FC.FREC.REV.VS)<1,Y.POS>
  IF LEN(Y.MONTH) EQ 1 THEN
    Y.MONTH = '0':Y.MONTH
  END


  Y.COMI = COMI
  Y.DAY  = SUBSTRINGS (Y.FECHA.REV,7,8)

  COMI = Y.FECHA.REV : "M":Y.MONTH:Y.DAY
  CALL CFQ
  Y.DATE = COMI[1,8]
  COMI = Y.COMI

  R.NEW (REDO.FC.MATUR.DATE.VS)<1,Y.POS>= Y.DATE

  RETURN
END
