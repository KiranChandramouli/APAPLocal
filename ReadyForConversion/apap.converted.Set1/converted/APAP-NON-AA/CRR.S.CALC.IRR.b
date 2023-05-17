SUBROUTINE CRR.S.CALC.IRR(NPV.VAL,CASH.FLOWS,TERM,IRR.RATE)
*-----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* This is a subroutine to calculate the IRR value
*
*-----------------------------------------------------------------------------
* IN Args :
*~~~~~~~~~~~~
* NPV.VAL - Net Present value of the future cash flows
* CASH.FLOWS - Cash Flow Amounts with FM seperator
* TERM - Number of terms
*
* OUT Args :
*~~~~~~~~~~~~
* IRR.RATE - Calculated IRR rate
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                Reference          Description
* 02-Jan-2010    Mohan .N            ODR-2009-10-0304   Initial Version
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
*

    GOSUB INITIALIZE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
*Intialize the maximum IRR as 100 and initialize all necessary variables
*Use the incomming argument TERM as terms
*
    LAST.NPV = 0
    IRR.CHECK = 0
    START.COUNT = 0
    NPV.VALUE = NPV.VAL
    FINAL.COUNT = 100
    INC.FLAG = 1
    FIRST.FLAG = 1
    CASH.FLOW = CASH.FLOWS
    NOF.TERM = TERM
    ADD.FLAG =''

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*IRR rate can be between 0 to 100 hence the first loop will be executed from 0 to 100
*Second loop will be executed based on the number of term's value
*
    LOOP
    WHILE IRR.CHECK LE FINAL.COUNT
        TOT.SUM = 0
        INNER.COUNT = 1
        GOSUB CALC.TOTAL.SUM
        NPV = NPV.VALUE - TOT.SUM
*
* If the NPV is greater than zero the IRR could be between LAST.IRR.CHK to next rate
* So we can divide the increament counter by 10 to find the IRR similarly it will go till
* IRR value found
*
*
        IF OLD.IRR.CHECK EQ IRR.CHECK AND IRR.CHECK EQ FINAL.COUNT THEN
            GOSUB PROG.END
        END
        OLD.IRR.CHECK = IRR.CHECK

        IF NPV EQ 0 THEN
            GOSUB PROG.END
        END
        IF NPV LT 0 AND NOT(FIRST.FLAG) THEN
            INC.FLAG = INC.FLAG/10
            FIRST.FLAG = 1
            ADD.FLAG = ''
        END
* If NPV is GT 0 then assign the start count as final count value - increament flag
* The increament flag could be 0.1,0.01,0.001 ... till IRR found
*
        IF NPV GT 0 THEN
            GOSUB REASSIGN.START.COUNT
            ADD.FLAG = 1
        END
        APP.NPV = FIELD(NPV,'.',1)
        IF APP.NPV EQ 0 THEN
            APP.NPV = FIELD(NPV,'.',2)
            APP.NPV = APP.NPV[1,6]
            IF APP.NPV EQ 0 OR APP.NPV EQ '' OR INC.FLAG EQ 0 THEN
                GOSUB PROG.END
            END
        END
        IF NOT(ADD.FLAG) THEN
            IRR.CHECK += INC.FLAG
        END
    REPEAT

    IRR.RATE = IRR.CHECK

RETURN
*-----------------------------------------------------------------------------
CALC.TOTAL.SUM:
*-----------------------------------------------------------------------------
*
    LOOP
    WHILE INNER.COUNT LE NOF.TERM
        TOT.SUM = TOT.SUM + (CASH.FLOW<INNER.COUNT>/PWR((1+IRR.CHECK),INNER.COUNT))
        INNER.COUNT += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------
REASSIGN.START.COUNT:
*-----------------------------------------------------------------------------
*
    IF FIRST.FLAG THEN
        INC.FLAG = INC.FLAG/10
        START.COUNT = IRR.CHECK - INC.FLAG
        FINAL.COUNT = IRR.CHECK
        IRR.CHECK = START.COUNT
        FIRST.FLAG = 0
    END ELSE
        FINAL.COUNT = START.COUNT
        START.COUNT -= INC.FLAG
        IRR.CHECK = START.COUNT
    END

RETURN
*-----------------------------------------------------------------------------
PROG.END:

    IRR.RATE = IRR.CHECK

END
