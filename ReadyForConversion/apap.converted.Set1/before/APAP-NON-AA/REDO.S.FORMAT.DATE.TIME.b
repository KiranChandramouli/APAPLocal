*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FORMAT.DATE.TIME(SYS.DATE.TIME)

*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine is attached in DEAL.SLIP.FORMAT to format date and time
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : KAVITHA
* PROGRAM NAME : REDO.S.FORMAT.DATE.TIME
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 8-Apr-2011       S KAVITHA           ODR-2010-03-0400    INITIAL CREATION
* -----------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE

  TEMPTIME = SYS.DATE.TIME[7,4]
  TEMPTIME = TEMPTIME[1,2]:":":TEMPTIME[3,2]

  CHECK.DATE = SYS.DATE.TIME[1,6]
  CHECK.DATE = ICONV(CHECK.DATE,"D2")
  SYS.DATE=OCONV(CHECK.DATE,"D4")

  SYS.DATE.TIME = SYS.DATE

  RETURN
