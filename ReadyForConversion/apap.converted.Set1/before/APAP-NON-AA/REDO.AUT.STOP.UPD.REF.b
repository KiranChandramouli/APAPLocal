*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AUT.STOP.UPD.REF
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This service is used to stop all the cheques of in PAYMENT.STOP
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*-----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.PAYMENT.STOP
$INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT
*-----------------------------------------------------------------------
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------

  Y.ID.CUR.CHRG = ''
  FN.PAYMENT.STOP.STMT = 'F.PAYMENT.STOP.STMT'
  F.PAYMENT.STOP.STMT  = ''
  CALL OPF(FN.PAYMENT.STOP.STMT,F.PAYMENT.STOP.STMT)
  LREF.APPLN="PAYMENT.STOP"
  LREF.FIELDS="L.PS.STOP.REF"
  LREF.POS=''
  CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FIELDS,LREF.POS)
  POS.L.PS.STOP.REF = LREF.POS<1,1>
  RETURN
**********
PROCESS:
**********
  Y.STMT.ID = R.NEW(AC.PAY.STMT.NOS)<1,1>
  CALL F.READ(FN.PAYMENT.STOP.STMT,Y.STMT.ID,R.PAYMENT.STOP.STMT,F.PAYMENT.STOP.STMT,PAYMENT.STOP.STMT.ERR)
  R.PAYMENT.STOP.STMT<-1> = R.NEW(AC.PAY.LOCAL.REF)<1,POS.L.PS.STOP.REF>
  CALL F.WRITE(FN.PAYMENT.STOP.STMT,Y.STMT.ID,R.PAYMENT.STOP.STMT)
  RETURN
END
