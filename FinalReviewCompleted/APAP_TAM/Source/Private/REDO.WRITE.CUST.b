$PACKAGE APAP.TAM
SUBROUTINE REDO.WRITE.CUST

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CUST.PRD.LIST

* Routine to update the PROCESS.DATE from last multi value of DATE field (multi value field).
* To avoid performance, a new field PROCESS.DATE is introduced

** 19-04-2023 R22 Auto Conversion
** 19-04-2023 Skanda R22 Manual Conversion - No changes

    FN.REDO.CUST.PRD.LIST = 'F.REDO.CUST.PRD.LIST'
    F.REDO.CUST.PRD.LIST = ''
    CALL OPF(FN.REDO.CUST.PRD.LIST, F.REDO.CUST.PRD.LIST)

    SEL.CMD = 'SELECT ':FN.REDO.CUST.PRD.LIST
    PRINT SEL.CMD
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NOR,RECT.CODE)
    PRINT 'Total Record Selected ...' : NOR

    I.VAR = 1 ;* R22 Auto conversion
    LOOP
    WHILE I.VAR LE NOR ;* R22 Auto conversion
        Y.ID = SEL.LIST<I.VAR> ;* R22 Auto conversion
        CALL F.READ(FN.REDO.CUST.PRD.LIST, Y.ID, R.REDO.CUST.PRD.LIST, F.REDO.CUST.PRD.LIST, Y.REDO.ERR)
        Y.DATE.TOT = R.REDO.CUST.PRD.LIST<PRD.DATE>

*        Y.DATE.CNT = DCOUNT(Y.DATE.TOT,VM)
*        Y.DATE = Y.DATE.TOT<1,Y.DATE.CNT>

        Y.MAX = MAXIMUM(Y.DATE.TOT)
        R.REDO.CUST.PRD.LIST<PRD.PROCESS.DATE> = Y.MAX
        CALL F.WRITE(FN.REDO.CUST.PRD.LIST, Y.ID, R.REDO.CUST.PRD.LIST)
        I.VAR += 1 ;* R22 Auto conversion
        PRINT 'Processing ... ': Y.ID
        CALL JOURNAL.UPDATE(Y.ID)
    REPEAT

RETURN
END
