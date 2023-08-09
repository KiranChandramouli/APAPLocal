*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.A.SEND.RCPT.RT
***********************************************************
*----------------------------------------------------------
*
* COMPANY NAME    : APAP
* DEVELOPED BY    : J.Q.
*
*----------------------------------------------------------
*
* DESCRIPTION     : AUTHORISATION routine to be used in FT,FX (*.FIM) versions
*                   to store TXN ID on ST.LAPAP.DIGI.DSLIP.REPRINT and start de process of gettin HOLD.CONTROL.ID
*                   and send it to an external interface
*------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO             REFERENCE       DESCRIPTION
* 2022-11-28         J.Q.                           CREATE
*----------------------------------------------------------------------
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_F.TELLER
    $INSERT BP I_F.ST.LAPAP.DIGI.DSLIP.REPRINT

    GOSUB DO.CHECK.PREMLIM.COND
    MSG<-1> = 'Valor de Y.SHOULD.EXECUTE = ' : Y.SHOULD.EXECUTE
    MSG<-1> = 'Valor de Y.VERSION.NAME.ARR => ' : Y.VERSION.NAME.ARR
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
    IF Y.SHOULD.EXECUTE EQ 'true' THEN
        GOSUB OPEN.FILES
        GOSUB SAVE.INITIAL.DATA
    END

    RETURN
*----------------------------------------------------------------------------------------------------------
OPEN.FILES:
*~~~~~~~~~~
*
*FN.REPRINT = 'F.REDO.APAP.H.REPRINT.SEQ'
*F.REPRINT = ''

*CALL OPF(FN.REPRINT, F.REPRINT);

*FN.HOLD = '&HOLD&'
*F.HOLD = ''
*CALL OPF(FN.HOLD, F.HOLD);

    FN.DIGI.REPRINT = 'F.ST.LAPAP.DIGI.DSLIP.REPRINT'
    F.DIGI.REPRINT = ''
    CALL OPF(FN.DIGI.REPRINT, F.DIGI.REPRINT);

*
    RETURN

SAVE.INITIAL.DATA:
    Y.TRANS.ID                          = ID.NEW;
    Y.APP.NAME                          = "ST.LAPAP.DIGI.DSLIP.REPRINT";
    Y.VER.NAME                          = Y.APP.NAME :",RAD";
    Y.FUNC                              = "I";
    Y.PRO.VAL                           = "PROCESS";
    Y.GTS.CONTROL                       = "";
    Y.NO.OF.AUTH                        = "0";
    FINAL.OFS                           = "";

    R.DIGI = ''
    R.DIGI<ST.LAP62.SENT.STATUS> = 'PENDING'

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.DIGI,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'','GENOFS','')

    MSG<-1> = ''
    MSG<-1> = 'OFS enviado ' : FINAL.OFS
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

    RETURN
*-----------------------------------------------------------------------------------------------------------
DO.CHECK.PREMLIM.COND:
    Y.VERSION.NAME.ARR = PGM.VERSION
    CHANGE '.' TO @VM IN Y.VERSION.NAME.ARR

    FINDSTR 'FIM' IN Y.VERSION.NAME.ARR SETTING v.Fld, v.Val THEN
*CRT "Field : " : v.Fld, "Position : " : v.Val
        Y.SHOULD.EXECUTE = 'true'
    END ELSE
        Y.SHOULD.EXECUTE = 'false'
    END
    RETURN

END
