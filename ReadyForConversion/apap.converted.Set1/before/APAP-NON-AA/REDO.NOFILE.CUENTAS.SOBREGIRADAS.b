*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOFILE.CUENTAS.SOBREGIRADAS(Y.OUT.ARRAY)
*-------------------------------------------------------------------
*Description: This routine is a nofile enquiry routine for account that are overdrawn.
*-------------------------------------------------------------------
*Input   Arg: N/A
*Output  Arg: Y.OUT.ARRAY
*Linked With: SS>NOFILE.REDO.CUENTAS.SOBREGIRADAS, ENQUIRY>REDO.CUENTAS.SOBREGIRADAS

*-------------------------------------------------------------------
* Modification History:
*-------------------------------------------------------------------
* Date             Ref                    Who
* 02 May 2012   PACS00194856 - CR.22    H Ganesh
*-------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_ENQUIRY.COMMON

  GOSUB PROCESS
  RETURN
*-------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------
  FN.ACCOUNT.OVERDRAWN = 'F.ACCOUNT.OVERDRAWN'
  F.ACCOUNT.OVERDRAWN = ''
  CALL OPF(FN.ACCOUNT.OVERDRAWN,F.ACCOUNT.OVERDRAWN)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  Y.OUT.ARRAY = ''
  FILE.NAME = FN.ACCOUNT.OVERDRAWN

  CALL REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.CMD)


  IF D.RANGE.AND.VALUE ELSE
    SEL.CMD.NEW = SEL.CMD:" WITH  (@ID LIKE ...0100....) OR  (LIMIT.NARRATIVE EQ NULL)"   ;* This line is to replace the model bank build routine E.MB.ACCT.OVER.DRAWN.
  END


  CALL EB.READLIST(SEL.CMD,ID.LST,'',NO.OF.REC,SEL.ERR)
  CALL EB.READLIST(SEL.CMD.NEW,ID.LST.NEW,'',NO.OF.REC.NEW,SEL.ERR)

  Y.VAR1 = 1
  LOOP
  WHILE Y.VAR1 LE NO.OF.REC
    Y.AC.NO = ID.LST<Y.VAR1>
    R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,Y.AC.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN
      IF R.ACCOUNT<AC.ARRANGEMENT.ID> ELSE
        Y.OUT.ARRAY<-1>= Y.AC.NO:'*':R.ACCOUNT<AC.CUSTOMER>
      END

    END ELSE
      LOCATE Y.AC.NO IN ID.LST.NEW<1> SETTING POS THEN
        Y.OUT.ARRAY<-1>= Y.AC.NO:'*':R.ACCOUNT<AC.CUSTOMER>
      END
    END
    Y.VAR1++
  REPEAT

  RETURN
END
