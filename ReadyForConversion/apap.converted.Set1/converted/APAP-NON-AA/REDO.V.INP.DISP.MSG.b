SUBROUTINE REDO.V.INP.DISP.MSG
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This subroutine would show a override message, which would deliver
* the user a message if the option for the field, STOPPAYMENT.STATUS has been
* selected as Non-Confirmed
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
** Dependencies:
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
    $INSERT I_F.OVERRIDE
    $INSERT I_F.PAYMENT.STOP

*------------------------------MAIN------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------

*------------------------------INIT------------------------------------------
INIT:

    POS=''
    CURR.NO=''
    TOTAL.MSG=''
    POS.STOPPAYMENT.STATUS=''
    FN.PAYMENT.STOP='F.PAYMENT.STOP'
    F.PAYMENT.STOP=''
    CALL OPF(FN.PAYMENT.STOP,F.PAYMENT.STOP)
RETURN
*----------------------------------------------------------------------------
*----------------------------------------------------------------------------
PROCESS:
    CALL GET.LOC.REF('PAYMENT.STOP','L.PS.STP.PMT.ST',POS)
* Single GET.LOC.REF need not be changed - Updated by TUS-Convert
    POS.STOPPAYMENT.STATUS=POS
    STATUS.PAY = R.NEW(AC.PAY.LOCAL.REF)<1,POS.STOPPAYMENT.STATUS>
    STATUS.COUNT = DCOUNT(STATUS.PAY,@SM)

    LOOP
    WHILE START.COUNT LE STATUS.COUNT
        IF R.NEW(AC.PAY.LOCAL.REF)<1,POS.STOPPAYMENT.STATUS,START.COUNT> EQ 'NONCONFIRMED' THEN
            OVERRIDE.FLAG = 1

* GOSUB OVERRIDE.MESSAGE
        END
        START.COUNT += 1
    REPEAT

    IF OVERRIDE.FLAG THEN

        CNT=DCOUNT(R.NEW(AC.PAY.OVERRIDE),@VM)
        GOSUB OVERRIDE.MESSAGE
    END

RETURN
*******************
OVERRIDE.MESSAGE:
********************
    TEXT = 'OVERRIDE1'
    CALL STORE.OVERRIDE(CNT+1)
    TEXT = 'OVERRIDE2'
    CALL STORE.OVERRIDE(CNT+2)
    TEXT = 'OVERRIDE3'
    CALL STORE.OVERRIDE(CNT+3)
    TEXT = 'OVERRIDE4'
    CALL STORE.OVERRIDE(CNT+4)
    TEXT = 'OVERRIDE5'
    CALL STORE.OVERRIDE(CNT+5)
    TEXT = 'OVERRIDE6'
    CALL STORE.OVERRIDE(CNT+6)
    TEXT = 'OVERRIDE7'
    CALL STORE.OVERRIDE(CNT+7)
RETURN
*----------------------------------------------------------------------------
END
