*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.MTH.DETAILS(DATE1,DATE2,OUT.MONTH,OUT.DATE,OUT.COUNT,OUT.MTH.DATE)
*----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.NOF.INVST.RPT
*----------------------------------------------------------------------------
*DESCRIPTION : REDO.GET.MTH.DETAILS is an call  routine, this routine will give the range of dates
*              if two dates has been passed as INPUT parameters
*Attached To : REDO.NOF.INVST.RPT
*Attached As : Call Routine
*Arguments-IN : DATE1.DATE2
*Arguments-OUT :OUT.MONTH,OUT.DATE,OUT.COUNT
*----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
MAIN.PARA:
*==========
  GOSUB INIT.PARA
  GOSUB PROCESS.PARA

  RETURN

INIT.PARA:
*==========
  Y.DATE1.FIN  = DATE1[1,6]
  Y.DATE2.FIN  = DATE2[1,6]

  Y.DATE1.MON = Y.DATE1.FIN[5,2]
  Y.DATE1.YR = Y.DATE1.FIN[1,4]
  Y.DATE2.MON = Y.DATE2.FIN[5,2]
  Y.DATE2.YR  = Y.DATE2.FIN[1,4]
  MONTH = "JAN*FEB*MAR*APR*MAY*JUN*JUL*AUG*SEP*OCT*NOV*DEC"

  RETURN

PROCESS.PARA:
*=============
  LOOP
  WHILE Y.DATE1.FIN LE Y.DATE2.FIN

    IF Y.DATE1.YR LE Y.DATE2.YR THEN
      GOSUB FETCH.DETAILS
    END
  REPEAT

  RETURN
FETCH.DETAILS:
*=============

  IF Y.DATE1.MON LE 12 THEN
    Y.MONTH = FIELD(MONTH,'*',Y.DATE1.MON)
    OUT.MONTH<-1> = Y.MONTH:' ':Y.DATE1.YR
**********************************************
    OUT.MTH.DATE<-1> = Y.DATE1.YR:Y.DATE1.MON
***********************************************
    OUT.DATE<-1> = Y.DATE1.YR:Y.MONTH
    OUT.COUNT = DCOUNT(OUT.DATE,FM)
    Y.DATE1.MON++
    Y.DATE1.MON = FMT(Y.DATE1.MON,'R%2')
    Y.DATE1.FIN = Y.DATE1.YR:Y.DATE1.MON
  END ELSE
    IF Y.DATE1.MON GT 12 THEN
      Y.DATE1.YR++
      Y.DATE1.MON = '01'
      Y.DATE1.FIN = Y.DATE1.YR:Y.DATE1.MON
    END
  END

  RETURN

END
