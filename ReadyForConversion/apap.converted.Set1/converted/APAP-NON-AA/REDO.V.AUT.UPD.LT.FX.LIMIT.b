SUBROUTINE REDO.V.AUT.UPD.LT.FX.LIMIT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.V.AUT.UPD.LT.FX.LIMIT
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is the authorisation routine for the versions of FX;
*                    the routine is used to up-date the local template REDO.APAP.FX.LIMIT
*In Parameter      : NA
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                            Reference                      Description
*   ------         ------                         -------------                    -------------
*  09/11/2010   Jeyachandran                      ODR-2010-07-0075                Initial Creation
*  11/11/2010   SabariKumar A
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.FX.LIMIT
    $INSERT I_F.FOREX

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*--------------------------------------------------------------------------------------------------------
OPENFILES:
*--------------------------------------------------------------------------------------------------------
* Initialise/Open all necessary variables/files

    Y.FUNCTION = ''
    Y.CURR.NO = ''
    Y.REC.STATUS = ''
    Y.SELL.AMOUNT = ''
    Y.FX.ID = ID.NEW

    FN.REDO.APAP.FX.LIMIT = 'F.REDO.APAP.FX.LIMIT'
    F.REDO.APAP.FX.LIMIT = ''
    CALL OPF(FN.REDO.APAP.FX.LIMIT,F.REDO.APAP.FX.LIMIT)

    FN.FOREX = 'F.FOREX'
    F.FOREX = ''
    CALL OPF(FN.FOREX,F.FOREX)
RETURN

*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------
* The section post OFS message to the REDO.APAP.FX.LIMIT and creates record based
* on certain conditions

    Y.FUNCTION = V$FUNCTION
    Y.CURR.NO = R.NEW(FX.CURR.NO)
    Y.REC.STATUS = R.NEW(FX.RECORD.STATUS)
    Y.SELL.AMOUNT = R.NEW(FX.AMOUNT.SOLD)
    Y.SELL.CCY = R.NEW(FX.CURRENCY.SOLD)

    IF Y.REC.STATUS EQ 'INAU' AND Y.FUNCTION EQ 'A' THEN
        OUTREC = 'REDO.APAP.FX.LIMIT,SETT.RISK/I/PROCESS,':'/':'/':ID.COMPANY:',':ID.NEW
        OUTREC := ',RISK.AMT=':Y.SELL.AMOUNT
        OUTREC := ',RISK.CCY=':Y.SELL.CCY
        GOSUB OFS.POST
    END

    IF Y.REC.STATUS EQ 'RNAU' AND Y.FUNCTION EQ 'A' THEN
        CALL F.READ(FN.REDO.APAP.FX.LIMIT,Y.FX.ID,R.FX.LIMIT,F.REDO.APAP.FX.LIMIT,F.ERR)
        IF R.FX.LIMIT THEN
            OUTREC = 'REDO.APAP.FX.LIMIT,SETT.RISK/R/PROCESS,':'/':'/':ID.COMPANY:',':ID.NEW
            GOSUB OFS.POST
        END
    END
RETURN
*--------------------------------------------------------------------------------------------------------
OFS.POST:
*--------------------------------------------------------------------------------------------------------
* Calls OFS.POST.MESSAGE to post transaction based on themessage formed and updates
* OFS.MESSAGE.QUEUE

    OFS.SOURCE.ID = 'REDO.APAP.FX.LMT'
    CALL OFS.POST.MESSAGE(OUTREC,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
RETURN

****************************************************************************
END
