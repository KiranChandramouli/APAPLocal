*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: PRABHU N
* PROGRAM NAME: REDO.VAL.STO.LOC.REF
* ODR NO      :PACS00125978
*----------------------------------------------------------------------
  SUBROUTINE REDO.VAL.STO.LOC.REF
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STANDING.ORDER


  GOSUB INIT

  RETURN

*****
INIT:
****
  LOC.APP='STANDING.ORDER'
  APP.FIELD='L.STO.START.DTE'
  STO.FREQ.POS = ''

  CALL MULTI.GET.LOC.REF(LOC.APP,APP.FIELD,STO.FREQ.POS)


  START.DATE = COMI
!R.NEW(STO.LOCAL.REF)<1,STO.FREQ.POS> = COMI
!!!

  IF START.DATE LE TODAY THEN
    AF = STO.LOCAL.REF
    AV=STO.FREQ.POS
    ETEXT = 'EB-DATE.G..TODAY'
    CALL STORE.END.ERROR

  END

  START.DAY=START.DATE[7,2]
  FREQ.MTH='M01'
  END.DATE=R.NEW(STO.CURRENT.END.DATE)

  IN.FREQ=START.DATE:FREQ.MTH:START.DAY
  CALL EB.CONVERT.FQU.FORMAT(IN.FREQ,OUT.FREQ,ERR.MSG)
  R.NEW(STO.CURRENT.FREQUENCY)=OUT.FREQ
!    START.DATE.1=R.NEW(STO.LOCAL.REF)<1,STO.FREQ.POS>

!!!




  RETURN
END
