*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.WOF.MIG
*----------------------------------------------------
*Description: This is the input routine for WOF account creation version.
*----------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.AA.ARRANGEMENT

  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN
*----------------------------------------------------
OPEN.FILES:
*----------------------------------------------------
  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT  = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  R.AA.ARRANGEMENT = ''
  AA.ERR           = ''
  RETURN
*----------------------------------------------------
PROCESS:
*----------------------------------------------------

  Y.DETAILS = R.NEW(AC.ACCOUNT.TITLE.2)
  Y.AA.ID   = FIELD(Y.DETAILS,'*',1)
  Y.AA.TYPE = FIELD(Y.DETAILS,'*',2)
  CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
  IF R.AA.ARRANGEMENT EQ '' AND AA.ERR NE '' THEN
    AF = AC.ACCOUNT.TITLE.2
    ETEXT = 'EB-AA.ID.NT.ENTERED'
    CALL STORE.END.ERROR
  END ELSE
    Y.LOAN.AC = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
  END

  IF Y.AA.TYPE NE 'PRINCIPLE' AND Y.AA.TYPE NE 'INTEREST' THEN

    AF = AC.ACCOUNT.TITLE.2
    ETEXT = 'Account type not mentioned'
    CALL STORE.END.ERROR
  END

  RETURN
END
