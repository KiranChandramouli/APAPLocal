*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CONV.STATUS2

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.EB.LOOKUP
$INSERT I_ENQUIRY.COMMON

  Y.ID = O.DATA

  FN.EB.LOOKUP = 'F.EB.LOOKUP'
  F.EB.LOOKUP = ''
  CALL OPF(FN.EB.LOOKUP, F.EB.LOOKUP)

  IF Y.ID THEN

    Y.ID = CHANGE(Y.ID,';',FM)

    LOOP
      REMOVE Y.GET.LOOKUP.ID FROM Y.ID SETTING Y.LOOKUP.POS
    WHILE Y.GET.LOOKUP.ID:Y.LOOKUP.POS

      Y.LOOKUP.ID = 'L.AC.STATUS2*':Y.GET.LOOKUP.ID
      CALL F.READ(FN.EB.LOOKUP, Y.LOOKUP.ID, R.LOOKUP, F.EB.LOOKUP, Y.READ.ERR)

      Y.LOOKUP.TRANS = R.LOOKUP<EB.LU.DESCRIPTION,LNGG>

      IF NOT(Y.LOOKUP.TRANS) THEN
        Y.LOOKUP.TRANS = R.LOOKUP<EB.LU.DESCRIPTION,1>
      END
      Y.RETURN.VAL<-1> = Y.LOOKUP.TRANS
    REPEAT

    Y.RETURN.VAL = CHANGE(Y.RETURN.VAL,FM,';')
    O.DATA = Y.RETURN.VAL
  END

  RETURN
END
