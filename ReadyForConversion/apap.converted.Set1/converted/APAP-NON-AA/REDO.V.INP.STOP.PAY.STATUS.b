SUBROUTINE REDO.V.INP.STOP.PAY.STATUS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This subroutine would serve as a cross validation level validation routine
* The purpose of this routine is to check the field STOPPAYMENT.STATUS if the
* value is specified as a CONFIRMED and authorised the value cannot be changed
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

*------------------------------MAIN-------------------------------------
    GOSUB INIT
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------

*------------------------------INIT-------------------------------------
INIT:

    POS=''
    POS.STOPPAYMENT.STATUS=''
    FN.PAYMENT.STOP='F.PAYMENT.STOP'
    F.PAYMENT.STOP=''
    VALUE.NEW = ''

    CALL OPF(FN.PAYMENT.STOP,F.PAYMENT.STOP)

RETURN
*-----------------------------------------------------------------------

*-----------------------------------------------------------------------
PROCESS:

    CALL GET.LOC.REF('PAYMENT.STOP','L.PS.STP.PMT.ST',POS)
    POS.STOPPAYMENT.STATUS=POS

    STATUS.NOS = DCOUNT(R.NEW(AC.PAY.LOCAL.REF)<1,POS.STOPPAYMENT.STATUS>,@SM)

    START.COUNT = 1

    LOOP
    WHILE START.COUNT LE STATUS.NOS

        IF R.OLD(AC.PAY.LOCAL.REF)<1,POS.STOPPAYMENT.STATUS,START.COUNT> EQ 'CONFIRMED' THEN

            VALUE.NEW = R.NEW(AC.PAY.LOCAL.REF)<1,POS.STOPPAYMENT.STATUS,START.COUNT>

            IF VALUE.NEW EQ 'NONCONFIRMED' THEN

                T(AC.PAY.FIRST.CHEQUE.NO)<3> = "NOCHANGE"

                T(AC.PAY.LAST.CHEQUE.NO)<3> = "NOCHANGE"

                ETEXT = 'EB-STATUS'
                AF=AC.PAY.LOCAL.REF
                AV=POS.STOPPAYMENT.STATUS
                AS = START.COUNT
                CALL STORE.END.ERROR

            END
        END

        START.COUNT += 1

    REPEAT

RETURN
*-----------------------------------------------------------------------

END
*-----------------------------------------------------------------------
