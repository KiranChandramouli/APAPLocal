*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE AI.REDO.CONVERT.PERIOD.TO.MONTHS
*-----------------------------------------------------------------------------
* Company Name :        ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :        Martin Macias
* Program Name :        AI.REDO.CONVERT.PERIOD.TO.MONTHS
*-----------------------------------------------------------------------------
* Description    :  This routine will convert a period of time in month
* Linked with    :      ARC-IB / Loan - Deatil Page
* In Parameter   :      Period of time
* Out Parameter  :      Period of time in month
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  GOSUB INITIALISE
  GOSUB PROCESS

  RETURN

*----------*
INITIALISE:
*----------*

  PERIOD.STR = O.DATA
  PERIOD.IN.MONTH = 0
  RETURN

*--------*
PROCESS:
*--------*

  PERIOD.FREQ = PERIOD.STR[LEN(PERIOD.STR),1]
  Y.PERIOD = PERIOD.STR[1,LEN(PERIOD.STR)-1]

  BEGIN CASE
  CASE PERIOD.FREQ EQ "Y"
    PERIOD.IN.MONTH = Y.PERIOD * 12
  CASE PERIOD.FREQ EQ "M"
    PERIOD.IN.MONTH = Y.PERIOD
  CASE PERIOD.FREQ EQ "W"
    PERIOD.IN.MONTH = DROUND (Y.PERIOD/4,2)
  CASE PERIOD.FREQ EQ "D"
    PERIOD.IN.MONTH = DROUND (Y.PERIOD/30,2)
  CASE OTHERWISE
    PERIOD.IN.MONTH = PERIOD.STR
  END CASE

  O.DATA = PERIOD.IN.MONTH

  RETURN

END
