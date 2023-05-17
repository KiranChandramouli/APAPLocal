*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.SECURITY.TAG

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER.DEFAULT


INITIALISE:
*---------
*

  FN.TELLER.DEFAULT = 'F.TELLER.DEFAULT'
  F.TELLER.DEFAULT  = ''
  CALL OPF(FN.TELLER.DEFAULT, F.TELLER.DEFAULT)

  R.TELLER.DEFAULT = ''
  TT.DEF.ID        = ''


PROCESS:
*-------
*

  TT.DEF.ID = COMI
  CALL F.READ(FN.TELLER.DEFAULT, TT.DEF.ID, R.TELLER.DEFAULT, F.TELLER.DEFAULT, TD.ERR)

*** Check Record already exists
**
  IF NOT(TD.ERR) OR R.TELLER.DEFAULT THEN
    PREV.REF = R.TELLER.DEFAULT<TT.DEF.ADDITIONAL.DATA.1>
    ETEXT    = "TT-REDO.SEC.TAG.PROCESSED" : FM : PREV.REF
  END

  RETURN
END
