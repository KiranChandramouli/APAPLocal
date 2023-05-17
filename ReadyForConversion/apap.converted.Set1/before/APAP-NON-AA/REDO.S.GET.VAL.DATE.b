*-------------------------------------------------------------------------
* <Rating>-20</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.S.GET.VAL.DATE
*-------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.GET.VAL.DATE
*Reference Number  :ODR-2010-04-0424
*-------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Opening date from Acco
*                   record and Value date from the AZ account record
*
*LINKED WITH       :
* ------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.ACCOUNT.CLOSURE
$INSERT I_F.DATES
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ENQUIRY

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
  REC.ID=O.DATA
  APPLN=R.ENQ<ENQ.FILE.NAME>
  IF APPLN EQ "AZ.ACCOUNT" THEN

    CALL F.READ(FN.AZ.ACCOUNT,REC.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
    VAR.DATE=R.AZ.ACCOUNT<AZ.VALUE.DATE>
    VAR.DATE=ICONV(VAR.DATE,"D2")
    O.DATA=OCONV(VAR.DATE,"D2")
  END
  ELSE
    IF APPLN EQ "ACCOUNT.CLOSURE" THEN
      CALL F.READ(FN.ACCOUNT,REC.ID,R.ACCOUNT,F.ACCOUNT,AC.ERR)
      VAR.DATE=R.ACCOUNT<AC.OPENING.DATE>
      VAR.DATE=ICONV(VAR.DATE,"D2")
      O.DATA=OCONV(VAR.DATE,"D2")
    END
  END

  RETURN

END
