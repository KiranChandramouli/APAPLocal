*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE TEST.REDO.NOF.INSURANCE.DETAILS

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.CHARGE
$INSERT I_F.AA.ACCOUNT
$INSERT I_F.AA.CUSTOMER

MAIN:

  GOSUB OPENFILES
  GOSUB PROCESS
  GOSUB PROGRAM.END

OPENFILES:

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)


  RETURN

PROCESS:

  SEL.CMD = 'SELECT ':FN.AA.ARRANGEMENT

  LOCATE "POL.INTIAL.DATE" IN D.FIELDS<1> SETTING POSITION.ONE THEN
    POL.INTIAL.DATE   = D.RANGE.AND.VALUE<POSITION.ONE>
    
  END

  LOCATE "POL.TYPE" IN D.FIELDS<1> SETTING POSITION.TWO THEN
    POL.TYPE         = D.RANGE.AND.VALUE<POSITION.TWO>
  END

  LOCATE "POL.CLASS" IN D.FIELDS<1> SETTING POSITION.THREE THEN
    POL.CLASS        = D.RANGE.AND.VALUE<POSITION.THREE>
  END

  LOCATE "CLAIM.STATUS" IN D.FIELDS<1> SETTING POSITION.FOUR THEN
    CLAIM.STATUS     = D.RANGE.AND.VALUE<POSITION.FOUR>
  END


  RETURN

PROGRAM.END:

END