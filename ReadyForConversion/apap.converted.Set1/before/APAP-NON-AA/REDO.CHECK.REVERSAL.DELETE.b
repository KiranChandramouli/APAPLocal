*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.CHECK.REVERSAL.DELETE
*-----------------------------------------------------------------
*Description: This routine is to restrict the user from delete the RNAU TFS record when
*             underlying TT record is in RNAU. As per TFS module, in order to do reversal deletion,
*             we need to first delete the underlying RNAU TT record by setting the REVERSAL.MARK as R,
*             then it will move the TT RNAU record to LIVE. then we need to delete the TFS record.


    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.TELLER
    $INCLUDE USPLATFORM.BP I_F.T24.FUND.SERVICES


    IF V$FUNCTION EQ "D" THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END

    RETURN
*-----------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------

    FN.TELLER$NAU = "F.TELLER$NAU"
    F.TELLER$NAU  = ""
    CALL OPF(FN.TELLER$NAU,F.TELLER$NAU)


    RETURN
*-----------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------

    Y.UNDERLYING.TXNS = R.NEW(TFS.UNDERLYING)
    Y.UNDERLYING.CNT  = DCOUNT(Y.UNDERLYING.TXNS,VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.UNDERLYING.CNT
        Y.TT.ID = Y.UNDERLYING.TXNS<1,Y.VAR1>
        CALL F.READ(FN.TELLER$NAU,Y.TT.ID,R.TELLER.NAU,F.TELLER$NAU,TT.ERR)
        IF R.TELLER.NAU<TT.TE.RECORD.STATUS>[1,2] EQ "RN" THEN
            AF = TFS.UNDERLYING
            AV = Y.VAR1
            ETEXT = "EB-REDO.TFS.TT.RNAU"
            CALL STORE.END.ERROR
            Y.VAR1 = Y.UNDERLYING.CNT+1 ;* Instead of break statement.
        END
        Y.VAR1++
    REPEAT

    RETURN
END
