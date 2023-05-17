*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: PRABHU N
* PROGRAM NAME: REDO.GET.CURR.STO.DUP.FREQ
* ODR NO      :PACS00125978
*----------------------------------------------------------------------
  SUBROUTINE REDO.GET.CURR.STO.DUP.FREQ
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STANDING.ORDER
$INSERT I_F.REDO.APAP.STO.DUPLICATE


  GOSUB INIT
  GOSUB PROCESS
  RETURN

*****
INIT:
****

  ST.DATE=R.NEW(REDO.SO.STO.START.DATE)
  START.DATE = ST.DATE
  START.DAY = ST.DATE[7,2]
  END.DATE=R.NEW(REDO.SO.CURRENT.END.DATE)
  FREQ.MTH='M01'
  Y.OLD.COMI = COMI
*    COMI = START.DATE:FREQ.MTH:START.DAY
  CALL CFQ
  END.CFQ.DATE = COMI[1,8]
*    COMI = Y.OLD.COMI

  RETURN
********
PROCESS:
********



  IF END.DATE LE START.DATE THEN
    AF = REDO.SO.CURRENT.END.DATE
    ETEXT = 'EB-DATE.GT.THAN.TODAY'
    CALL STORE.END.ERROR

  END

  IF END.DATE LT END.CFQ.DATE THEN
    AF = REDO.SO.CURRENT.END.DATE
    ETEXT = 'EB-1ST.MONTH'
    CALL STORE.END.ERROR

  END

  RETURN
END
