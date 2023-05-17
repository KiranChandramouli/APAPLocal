*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.SUM.AZ.ACCRUED.INT
*******************************************************************************************
*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : REDO.SUM.AZ.ACCREUED.INT
*------------------------------------------------------------------------------------------
*Description       : Used to get accrued interest
*Linked With       : ARCPDF
*In  Parameter     : ENQ.DATA
*Out Parameter     : ENQ.DATA
*ODR  Number:

*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*---------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.SCHEDULES


  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT  = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  FN.AZ.SCHEDULES = 'F.AZ.SCHEDULES'
  F.AZ.SCHEDULES  = ''
  CALL OPF(FN.AZ.SCHEDULES,F.AZ.SCHEDULES)

  LREF.APP = 'ACCOUNT':FM:'AZ.ACCOUNT'
  LREF.FIELDS = 'L.AC.AV.BAL':FM:'L.TYPE.INT.PAY'
  LREF.POS=''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
  POS.L.AC.AV.BAL        = LREF.POS<1,1>
  POS.L.TYPE.INT.PAY.POS = LREF.POS<2,1>


  CALL F.READ(FN.AZ.ACCOUNT,O.DATA,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)
  Y.DEP.TYPE       = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.TYPE.INT.PAY.POS>
  Y.ORIG.PRINCIPAL = R.AZ.ACCOUNT<AZ.ORIG.PRINCIPAL>

  IF Y.DEP.TYPE EQ 'Reinvested' THEN
    Y.INTEREST.LIQU.ACCT  = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>

    CALL F.READ(FN.ACCOUNT,O.DATA,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.DEP.CR.AMOUNT = R.ACCOUNT<AC.ACCR.CR.AMOUNT>

    CALL F.READ(FN.ACCOUNT,Y.INTEREST.LIQU.ACCT,R.INT.LIQ.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.INT.CR.AMOUNT = R.INT.LIQ.ACCOUNT<AC.ACCR.CR.AMOUNT>
    O.DATA = Y.INT.CR.AMOUNT + Y.DEP.CR.AMOUNT
    IF NOT(O.DATA) THEN
      O.DATA = '0.00'
    END
  END ELSE
    CALL F.READ(FN.ACCOUNT,O.DATA,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    O.DATA = R.ACCOUNT<AC.ACCR.CR.AMOUNT>
    IF NOT(O.DATA) THEN
      O.DATA = '0.00'
    END
  END

  RETURN
END
