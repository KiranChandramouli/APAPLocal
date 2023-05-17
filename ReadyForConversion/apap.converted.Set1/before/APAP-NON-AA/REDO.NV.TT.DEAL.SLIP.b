*-----------------------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NV.TT.DEAL.SLIP
*-------------------------------------------------
*Description: This routine is attached to version control TELLER to trigger a deal slip.

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_DEAL.SLIP.COMMON
$INSERT I_RC.COMMON
$INSERT I_F.REDO.MULTITXN.VERSIONS

  GOSUB PROCESS
  RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------

  IF OFS$SOURCE.ID EQ 'FASTPATH' OR APPLICATION NE 'TELLER' THEN      ;* During authorisation Fast path enq is used, so exit.
    RETURN
  END
  IF OFS$OPERATION EQ 'PROCESS' ELSE    ;* During Commit it needs to genarate deal slip.
    RETURN
  END
  Y.DEAL.SLIP.NAME = ''
  GOSUB GET.DEAL.SLIP.NAME
  IF Y.DEAL.SLIP.NAME ELSE    ;* If there is no defined deal slip for this version then exit
    RETURN
  END
  Y.OVER.LIST = OFS$OVERRIDES
  IF Y.OVER.LIST THEN         ;* Deal slip should be popped up only when txn commits sucessfully.
    IF Y.OVER.LIST<2,1> EQ 'YES' THEN
      OFS$DEAL.SLIP.PRINTING = 1
      CALL PRODUCE.DEAL.SLIP(Y.DEAL.SLIP.NAME)
    END
  END ELSE
    OFS$DEAL.SLIP.PRINTING = 1
    CALL PRODUCE.DEAL.SLIP(Y.DEAL.SLIP.NAME)
  END
  RETURN
*-------------------------------------------------
GET.DEAL.SLIP.NAME:
*-------------------------------------------------
  FN.REDO.MULTITXN.VERSIONS = 'F.REDO.MULTITXN.VERSIONS'
  F.REDO.MULTITXN.VERSIONS = ''
  CALL OPF(FN.REDO.MULTITXN.VERSIONS,F.REDO.MULTITXN.VERSIONS)

  SEL.CMD = 'SELECT ':FN.REDO.MULTITXN.VERSIONS:' WITH VERSION.NAME EQ ':APPLICATION:PGM.VERSION
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
  Y.MUL.TXN.ID = SEL.LIST<1>
  CALL F.READ(FN.REDO.MULTITXN.VERSIONS,Y.MUL.TXN.ID,R.REDO.MULTITXN.VERSIONS,F.REDO.MULTITXN.VERSIONS,MULTXN.ERR)
  IF R.REDO.MULTITXN.VERSIONS THEN
    Y.DEAL.SLIP.NAME =  R.REDO.MULTITXN.VERSIONS<RMV.D.SLIP.NAME>

  END
  RETURN
END
