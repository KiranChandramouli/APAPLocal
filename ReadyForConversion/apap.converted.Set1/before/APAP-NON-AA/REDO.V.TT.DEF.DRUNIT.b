*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.TT.DEF.DRUNIT

$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_F.TELLER

  GOSUB INIT
  GOSUB PROCESS

  RETURN

*****
INIT:
*****

  RETURN

********
PROCESS:
********
*

  IF R.NEW(TT.TE.CURRENCY.1) EQ R.NEW(TT.TE.CURRENCY.2) THEN

    BEGIN CASE
    CASE R.NEW(TT.TE.DR.CR.MARKER) EQ 'DEBIT'
      R.NEW(TT.TE.DR.UNIT) = R.NEW(TT.TE.UNIT)

    CASE R.NEW(TT.TE.DR.CR.MARKER) EQ 'CREDIT'
      R.NEW(TT.TE.UNIT) = R.NEW(TT.TE.DR.UNIT)
    END CASE

  END

  RETURN

END
