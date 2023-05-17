SUBROUTINE REDO.GET.ACI.HIS(R.ACI,Y.CUR,Y.RATE)

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.GET.HIGH.ACI
*--------------------------------------------------------------------------------
* Description: This is a call routine to get the highest rate of ACI record.
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 17-SEP-2012    MARIMUTHU S   PACS00217602      INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CREDIT.INT


    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    Y.RATE=0
    Y.TOTAL.BASIC=''

    IF SUM(R.ACI<IC.ACI.CR.BASIC.RATE>) THEN
        GOSUB CHECK.BASIC.RATE
    END
    Y.INT.IDS=R.ACI<IC.ACI.CR.INT.RATE>
    CHANGE @VM TO @FM IN Y.INT.IDS
    Y.FINAL.IDS=Y.TOTAL.BASIC:@FM:Y.INT.IDS
    Y.RATE=MAXIMUM(Y.FINAL.IDS)

RETURN
*---------------------------------------------------------------------------------
CHECK.BASIC.RATE:
*---------------------------------------------------------------------------------
    Y.BASIC.IDS=R.ACI<IC.ACI.CR.BASIC.RATE>
    Y.BASIC.ID.CNT=DCOUNT(Y.BASIC.IDS,@VM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.BASIC.ID.CNT
        IF Y.BASIC.IDS<1,Y.VAR1> THEN
            Y.BASIC.AND.CURR=Y.BASIC.IDS<1,Y.VAR1>:Y.CUR:TODAY
            CALL EB.GET.INTEREST.RATE(Y.BASIC.AND.CURR, BASIC.INT.RATE)
            Y.TOTAL.BASIC<-1>=BASIC.INT.RATE
        END
        Y.VAR1 += 1
    REPEAT

RETURN
END
