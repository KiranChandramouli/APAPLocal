*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.TFS.DEALSLIP

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.USER
$INSERT I_F.T24.FUND.SERVICES
$INSERT I_DEAL.SLIP.COMMON
$INSERT I_GTS.COMMON


  IF OFS$OPERATION EQ 'PROCESS' THEN
    Y.OVRS = R.NEW(TFS.OVERRIDE)
    Y.OVRS = CHANGE(Y.OVRS, SM, '*')
    Y.OVR.COMM.VAR = OFS$OVERRIDES

    GOSUB OPEN.FILES
    GOSUB GET.OVR.STATUS
  END

  RETURN
*-----------------------------------------------
OPEN.FILES:
*---------

  FN.USER = 'F.USER'
  F.USER = ''
  CALL OPF(FN.USER, F.USER)


  RETURN
*-----------------------------------------------
GET.OVR.STATUS:
*------------

  Y.OPERATOR = OPERATOR
  R.USER.REC = ''
  Y.READ.ERR = ''
  CALL F.READ(FN.USER, Y.OPERATOR, R.USER.REC, F.USER, Y.READ.ERR)

  Y.OVR.CLASSES = R.USER.REC<EB.USE.OVERRIDE.CLASS>

  Y.LOOP.CNT = 1
  LOOP
    REMOVE Y.OVR.MSG FROM Y.OVRS SETTING Y.OVR.POS
  WHILE Y.OVR.MSG:Y.OVR.POS

    IF INDEX( Y.OVR.MSG, '*',1) THEN
      Y.FOUND = FIELD(Y.OVR.MSG, '*', 2, 1)

      Y.ACCEPTED = Y.OVR.COMM.VAR<2,Y.LOOP.CNT>

      LOCATE Y.FOUND IN Y.OVR.CLASSES<1,1> SETTING Y.CLASS.LOC.POS ELSE
        Y.INAO.RAISE = 'TRUE'
      END

    END
    Y.LOOP.CNT++
  REPEAT

  IF Y.INAO.RAISE NE 'TRUE' AND Y.ACCEPTED EQ 'YES' THEN
    OFS$DEAL.SLIP.PRINTING = 1
    CALL PRODUCE.DEAL.SLIP('REDO.DEP.TFS')
  END

  RETURN
*-----------------------------------------------
END
