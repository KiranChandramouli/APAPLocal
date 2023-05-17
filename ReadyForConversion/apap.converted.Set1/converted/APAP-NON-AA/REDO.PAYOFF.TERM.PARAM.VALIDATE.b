SUBROUTINE REDO.PAYOFF.TERM.PARAM.VALIDATE
*------------------------------------------------------------------------------
*This routine is validation routine for the field term.
*------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 31-01-2012        S.MARIMUTHU    PACS00146863        Initial Creation
*------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.PAYOFF.TERM.PARAM

MAIN:


    Y.TERM = R.NEW(RE.POFF.TERM)
    Y.CNT = DCOUNT(Y.TERM,@VM)
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.TR = Y.TERM<1,FLG>
        Y.LEN = LEN(Y.TR)
        IF Y.TR[Y.LEN,-1] EQ 'D' OR Y.TR[Y.LEN,-1] EQ 'W' OR Y.TR[Y.LEN,-1] EQ 'M' OR Y.TR[Y.LEN,-1] EQ 'Y' THEN
            IF NOT(NUM(Y.TR[1,Y.LEN-1])) THEN
                AF = RE.POFF.TERM
                AV = FLG
                ETEXT = 'EB-TERM.INVALID'
                CALL STORE.END.ERROR
            END
        END ELSE
            AF = RE.POFF.TERM
            AV = FLG
            ETEXT = 'EB-TERM.INVALID'
            CALL STORE.END.ERROR
        END
        Y.CNT -= 1
    REPEAT

RETURN

END
