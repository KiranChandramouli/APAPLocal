*---------------------------------------------------------------------------
* <Rating>-20</Rating>
*---------------------------------------------------------------------------
  SUBROUTINE REDO.E.BUILD.AZ.REPRINT(ENQ.DATA)
*---------------------------------------------------------------------------
*---------------------------------------------------------------------------
*Description       : This routine is a build routine to display the given AZ Account number is approval for reprint
*Linked With       :
*Linked File       :
*--------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.REDO.APAP.H.REPRINT.DEP
  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN
*-----------
OPENFILES:
*-----------
  FN.APAP.H.REPRINT.DEP = 'F.REDO.APAP.H.REPRINT.DEP'
  F.APAP.H.REPRINT.DEP  = ''
  CALL OPF(FN.APAP.H.REPRINT.DEP,F.APAP.H.REPRINT.DEP)

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
  RETURN
*----------
PROCESS:
*----------

  LOCATE "@ID" IN ENQ.DATA<2,1> SETTING POS1 THEN
    VAR.AZ.ID =  ENQ.DATA<4,POS1>
  END

  CALL F.READ(FN.AZ.ACCOUNT,VAR.AZ.ID,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR)

  VAR.AZ.VALUE.DATE = R.AZ.ACC<AZ.VALUE.DATE>

  VAR.ID = VAR.AZ.ID:"-":VAR.AZ.VALUE.DATE

  CALL F.READ(FN.APAP.H.REPRINT.DEP,VAR.ID,R.APAP.H.REPRINT,F.APAP.H.REPRINT.DEP,APAP.H.ERR)

  IF NOT(R.APAP.H.REPRINT) THEN
    ENQ.DATA<4,POS1> = 'ZZZZ'
  END ELSE
    VAR.FLAG = R.APAP.H.REPRINT<REDO.REP.DEP.REPRINT.FLAG>
    IF VAR.FLAG NE 'YES' THEN
      ENQ.DATA<4,POS1> = 'ZZZZ'
    END
  END
  RETURN
*-------------------------
END
