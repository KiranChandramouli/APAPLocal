SUBROUTINE REDO.V.VAL.AC.VERI.PEND.CHG
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*---------------------------------------------------------------------------------

*DESCRIPTION       :Account closure validation to check any pending charge exist.

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date        who                 Reference           Description
* 23-JUL-2015   Prabhu.N            ODR-2010-11-0211    Initial Creation
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.REDO.PENDING.CHARGE

    IF V$FUNCTION NE 'I'  THEN
        RETURN
    END

    GOSUB INIT
    GOSUB PROCESS
RETURN
INIT:
    FN.REDO.PENDING.CHARGE='F.REDO.PENDING.CHARGE'
    F.REDO.PENDING.CHARGE =''
    CALL OPF(FN.REDO.PENDING.CHARGE,F.REDO.PENDING.CHARGE)
RETURN

PROCESS:

    Y.ID.NEW=ID.NEW
    CALL F.READ(FN.REDO.PENDING.CHARGE,Y.ID.NEW,R.REDO.PENDING.CHARGE,F.REDO.PENDING.CHARGE,Y.ERR)
    IF R.REDO.PENDING.CHARGE THEN
        TEXT    = "REDO.ACCT.PEND.CHG"
        CURR.NO = DCOUNT(R.NEW(AC.ACL.OVERRIDE),'VM') + 1
        CALL STORE.OVERRIDE(CURR.NO)
    END
RETURN
END
