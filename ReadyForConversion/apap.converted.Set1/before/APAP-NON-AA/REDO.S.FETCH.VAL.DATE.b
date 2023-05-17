*-----------------------------------------------------------------------------
* <Rating>-25</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FETCH.VAL.DATE(VAL.DATE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.FETCH.VAL.DATE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Opening date from Account Closure
*                   record and Value date from the AZ account record
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.ACCOUNT.CLOSURE
$INSERT I_F.DATES

  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN

OPEN.FILES:

  FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
  F.AZ.ACCOUNT=''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  FN.ACCOUNT.CLOSURE='F.ACCOUNT.CLOSURE'
  F.ACCOUNT.CLOSURE=''
  CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  RETURN

PROCESS:
  REC.ID=ID.NEW
  APPLN=APPLICATION
  IF APPLN EQ "AZ.ACCOUNT" THEN

    CALL F.READ(FN.AZ.ACCOUNT,REC.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
    VAR.DATE=R.AZ.ACCOUNT<AZ.VALUE.DATE>
    VAR.DATE=ICONV(VAR.DATE,"D2")
    VAL.DATE=OCONV(VAR.DATE,"D4")
  END
  ELSE
    IF APPLN EQ "ACCOUNT.CLOSURE" THEN
      CALL F.READ(FN.ACCOUNT,REC.ID,R.ACCOUNT,F.ACCOUNT,AC.ERR)
      VAR.DATE=R.ACCOUNT<AC.OPENING.DATE>
      VAR.DATE=ICONV(VAR.DATE,"D2")
      VAL.DATE=OCONV(VAR.DATE,"D4")
    END
  END
*    TEMP.COMI = COMI ; TEMP.N1=N1 ; TEMP.T1 = T1
*    COMI= VAR.DATE ; N1=8 ; T1=".D"
*    CALL IN2D(N1,T1)
*    SYS.DATE = V$DISPLAY
*    COMI = TEMP.COMI ; N1 = TEMP.N1 ; T1 = TEMP.T1

  RETURN

END
