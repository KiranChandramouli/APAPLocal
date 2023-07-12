*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.ACC.CO.CODE(ACCOUNT.VAL,Y.ACC.CO.CODE)
*----------------------------------------------------------------
* Description: This call routine will return company code of account or alternate id passed.

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT


  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
  F.ALTERNATE.ACCOUNT  = ''
  CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

  Y.ACC.CO.CODE = ''
  Y.ACC.ID = ACCOUNT.VAL
  CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
  IF R.ACC THEN
    Y.ACC.CO.CODE = R.ACC<AC.CO.CODE>
  END ELSE
    Y.ALT.ID = FMT(Y.ACC.ID,'11"0"R')
    CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.ALT.ID,R.ALTERNATE.ACC,F.ALTERNATE.ACCOUNT,ALT.ERR)
    IF R.ALTERNATE.ACC THEN
*      Y.ACC.ID = R.ALTERNATE.ACC<1>
* Tus Start
Y.ACC.ID = R.ALTERNATE.ACC<AAC.GLOBUS.ACCT.NUMBER>
* Tus End
      CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
      IF R.ACC THEN
        Y.ACC.CO.CODE = R.ACC<AC.CO.CODE>
      END ELSE
        Y.ACC.CO.CODE = ID.COMPANY
      END
    END ELSE
      Y.ACC.CO.CODE = ID.COMPANY
    END

  END
  RETURN
END
