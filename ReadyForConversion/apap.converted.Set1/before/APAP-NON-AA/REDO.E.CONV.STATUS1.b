*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CONV.STATUS1

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.EB.LOOKUP
$INSERT I_ENQUIRY.COMMON

  Y.ID = O.DATA

  FN.EB.LOOKUP = 'F.EB.LOOKUP'
  F.EB.LOOKUP = ''
  CALL OPF(FN.EB.LOOKUP, F.EB.LOOKUP)

  IF Y.ID THEN
    Y.LOOKUP.ID = 'L.AC.STATUS1*':Y.ID
    CALL F.READ(FN.EB.LOOKUP, Y.LOOKUP.ID, R.LOOKUP, F.EB.LOOKUP, Y.READ.ERR)

    Y.RETURN.VAL = R.LOOKUP<EB.LU.DESCRIPTION,LNGG>

    IF NOT(Y.RETURN.VAL ) THEN
      Y.RETURN.VAL = R.LOOKUP< EB.LU.DESCRIPTION ,1>
    END

    O.DATA = Y.RETURN.VAL

  END

  RETURN
END
