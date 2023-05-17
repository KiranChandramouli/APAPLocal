SUBROUTINE REDO.INP.OUTWARD.RETURN
*---------------------------------------------------------
*Description: This routine is to raise override in case if the cheque is already cleared
*              and return file has arrived
*---------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CLEARING.OUTWARD

    GOSUB PROCESS
RETURN
*---------------------------------------------------------
PROCESS:
*---------------------------------------------------------

    IF R.NEW(CLEAR.OUT.CHQ.STATUS) EQ 'CLEARED' AND R.NEW(CLEAR.OUT.TFS.REFERENCE) NE 'PAYMENT' THEN
        CURR.NO = 1
        TEXT = 'EB-REDO.CHQ.CLEARED'
        CALL STORE.OVERRIDE(CURR.NO)

    END
RETURN

END
