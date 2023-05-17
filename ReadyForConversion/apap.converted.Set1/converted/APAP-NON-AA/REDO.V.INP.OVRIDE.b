SUBROUTINE REDO.V.INP.OVRIDE
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This subroutine would show a override message, which would deliver
* the user a message if the option for the field, STOPPAYMENT.STATUS has been
* selected as Non-Confirmed OR CONFIRMED
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 25-Nov-2009 SHANKAR RAJU Initial Creation
*------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PAYMENT.STOP
    $INSERT I_F.FUNDS.TRANSFER

*------------------------------MAIN------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------

*------------------------------INIT------------------------------------------
INIT:

    POS=''
    CURR.NO=''
    POS.STOPPAYMENT.STATUS=''
    FN.PAYMENT.STOP='F.PAYMENT.STOP'
    FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER'
    F.PAYMENT.STOP=''
    F.FUNDS.TRANSFER=''
    CALL OPF(FN.PAYMENT.STOP,F.PAYMENT.STOP)
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    R.PAYMENT.STOP=''
RETURN
*----------------------------------------------------------------------------

*----------------------------------------------------------------------------
PROCESS:

    CALL GET.LOC.REF('PAYMENT.STOP','L.PS.STP.PMT.ST',POS)
    POS.STOPPAYMENT.STATUS=POS
    CHEQUE.NO=R.NEW(FT.CHEQUE.NUMBER)

    IF CHEQUE.NO NE '' THEN

        DEBT.AC.NO=R.NEW(FT.DEBIT.ACCT.NO)
        CALL F.READ(FN.PAYMENT.STOP,DEBT.AC.NO,R.PAYMENT.STOP,F.PAYMENT.STOP,ERR.PS)

        FIRST.CHEQUE.NOS=R.PAYMENT.STOP<AC.PAY.FIRST.CHEQUE.NO>
        LAST.CHEQUE.NOS=R.PAYMENT.STOP<AC.PAY.LAST.CHEQUE.NO>
        COUNT.PAY.STOP=DCOUNT(FIRST.CHEQUE.NOS,@VM)

        FOR COUNTER.LOOP=1 TO COUNT.PAY.STOP
            FIRST.CHQ.NO=FIRST.CHEQUE.NOS<1,COUNTER.LOOP>
            LAST.CHQ.NO=LAST.CHEQUE.NOS<1,COUNTER.LOOP>

            IF CHEQUE.NO EQ FIRST.CHQ.NO THEN

                GOSUB DISPLAY.MESSAGE

            END ELSE

                IF CHEQUE.NO GT FIRST.CHQ.NO AND CHEQUE.NO LT LAST.CHQ.NO THEN

                    GOSUB DISPLAY.MESSAGE

                END
            END
        NEXT COUNTER.LOOP
    END

RETURN
*-----------------------------------------------------------------------------------------------------
DISPLAY.ERROR:


    ETEXT='EB-DESC.CHEQUE.STATUS':@FM:CHEQUE.NO
    CALL STORE.END.ERROR
    GOSUB END.ROU

RETURN
*----------------------------------------------------------------------------------------------------
DISPLAY.OVERRIDE:

    TEXT='STATUS.OF.CHEQUE':@FM:CHEQUE.NO
    CALL STORE.OVERRIDE(CURR.NO+1)
    GOSUB END.ROU
RETURN
*---------------------------------------------------------------------------------------------------
DISPLAY.MESSAGE:

    CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),@VM)

    IF R.PAYMENT.STOP<AC.PAY.LOCAL.REF,POS.STOPPAYMENT.STATUS,COUNTER.LOOP> EQ 'NONCONFIRMED' THEN


        GOSUB DISPLAY.OVERRIDE

    END ELSE
        IF R.PAYMENT.STOP<AC.PAY.LOCAL.REF,POS.STOPPAYMENT.STATUS,COUNTER.LOOP> EQ 'CONFIRMED' THEN

            GOSUB DISPLAY.ERROR
        END
    END
RETURN

*---------------------------------------------------------------------------------------------------
END.ROU:

END
*-----------------------------------------------------------------------------------------------------
