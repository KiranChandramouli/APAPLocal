*
*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RCL.LOAN.DSN.CONV.RTN
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.AA.ACCOUNT
$INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON
$INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON

  DEST.OF.FUNDS = ''
  R.AA.ARRANGEMENT = RCL$COMM.LOAN(1)
** Get SECTOR
** IF SEC.VAL EQ '03.01.99' THEN
  ArrangementID = COMI
  effectiveDate = ''
  idPropertyClass = 'ACCOUNT'
  idProperty = ''
  returnIds = ''
  returnConditions = ''
  returnError = ''
  CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
  R.AA.ARR.ACCOUNT = RAISE(returnConditions)
*    IF R.AA.ARR.ACCOUNT<1> EQ 'LENDING-TAKEOVER-ARRANGEMENT' OR R.AA.ARR.ACCOUNT<1> EQ 'LENDING-NEW-ARRANGEMENT' THEN
  DEST.OF.FUNDS = R.AA.ARR.ACCOUNT<AA.AC.LOCAL.REF,L.AA.LOAN.DSN.POS>
*    END
*END ELSE
*DEST.OF.FUNDS = ''
*END
*
  IF DEST.OF.FUNDS THEN
    COMI = DEST.OF.FUNDS
  END
*
  RETURN
END
