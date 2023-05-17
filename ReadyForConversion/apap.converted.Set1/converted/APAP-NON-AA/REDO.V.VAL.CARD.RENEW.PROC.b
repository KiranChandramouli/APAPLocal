SUBROUTINE REDO.V.VAL.CARD.RENEW.PROC
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*------------------------------------------------------------------------------

*Description  : This routine is validation routine attached to version CARD.TYPE,REDO.CARD.TYPE to validate RENEW PROC valueentered
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : CARD.TYPE

*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 31-01-2011     SWAMINATHAN            ODR-2010-03-0400          Initial Creation
* 24-11-2011     KAVITHA                PACS00164142              FIX
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CARD.TYPE



    LF.APP = 'CARD.TYPE'
    LF.FLD = 'L.CT.CHARGE.FQ':@VM:'L.CT.RENEW.PROC'
    LF.POS = ''
    CALL MULTI.GET.LOC.REF(LF.APP,LF.FLD,LF.POS)
    LOC.CHG.FRQ = LF.POS<1,1>
    LOC.REN.FRQ = LF.POS<1,2>

    Y.RENEW.PROC = R.NEW(CARD.TYPE.LOCAL.REF)<1,LOC.REN.FRQ>
    Y.LEN.VAL = LEN(Y.RENEW.PROC)
    Y.LAST.VAL = Y.RENEW.PROC[Y.LEN.VAL,1]
    IF (Y.LAST.VAL EQ 'D') OR (Y.LAST.VAL EQ 'M') OR (Y.LAST.VAL EQ 'Y') ELSE
        AF = CARD.TYPE.LOCAL.REF
        AV = LOC.REN.FRQ
        ETEXT= "EB-RENEW.PROC"
        CALL STORE.END.ERROR
    END

*PACS00164142-S
    CHARGE.FREQUENCY.LIST = R.NEW(CARD.TYPE.LOCAL.REF)<1,LOC.CHG.FRQ>
    FQU.COUNT = DCOUNT(CHARGE.FREQUENCY.LIST,@SM)
    CHANGE @SM TO @FM IN CHARGE.FREQUENCY.LIST

    LOOP.CNTR = 1
    LOOP
    WHILE LOOP.CNTR LE FQU.COUNT

        CHARGE.FREQUENCY = CHARGE.FREQUENCY.LIST<LOOP.CNTR>
        CHG.FREQ.LEN = LEN(CHARGE.FREQUENCY)
        CHG.FREQ.LAST.VAL = CHARGE.FREQUENCY[CHG.FREQ.LEN,1]

        IF (CHG.FREQ.LAST.VAL EQ 'D') OR (CHG.FREQ.LAST.VAL EQ 'M') OR (CHG.FREQ.LAST.VAL EQ 'Y') ELSE

            AF = CARD.TYPE.LOCAL.REF
            AV = LOC.CHG.FRQ
            AS = LOOP.CNTR
            ETEXT= "EB-RENEW.PROC"
            CALL STORE.END.ERROR
        END

        LOOP.CNTR += 1
    REPEAT

*PACS00164142-E

RETURN
END
