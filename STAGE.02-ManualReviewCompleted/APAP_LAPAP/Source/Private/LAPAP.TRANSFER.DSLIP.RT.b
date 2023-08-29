* @ValidationCode : Mjo5MTg4OTEyNjQ6Q3AxMjUyOjE2OTI5NDY2NDU0NjE6SVRTUzotMTotMToxMDQ1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Aug 2023 12:27:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1045
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>192</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*23-08-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED,FM TO @FM
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.TRANSFER.DSLIP.RT
    $INSERT I_EQUATE ;*R22 MANUAL CONVERSION START
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.APAP.H.REPRINT.SEQ
    $INSERT I_F.ST.LAPAP.DIGI.DSLIP.REPRINT ;*R22 MANUAL CONVERSION END

    GOSUB INITIALIZE
    GOSUB DO.SELECT
RETURN

*File openers and initial vars
INITIALIZE:
    FN.DIGI.REPRINT = 'F.ST.LAPAP.DIGI.DSLIP.REPRINT'
    F.DIGI.REPRINT = ''
    CALL OPF(FN.DIGI.REPRINT, F.DIGI.REPRINT);

    FN.REPRINT = 'F.REDO.APAP.H.REPRINT.SEQ'
    F.REPRINT = ''
    CALL OPF(FN.REPRINT, F.REPRINT);

    FN.HOLD = '&HOLD&'
    F.HOLD = ''
    CALL OPF(FN.HOLD, F.HOLD);

    FN.TT = 'F.TELLER'
    F.TT = ''
    CALL OPF(FN.TT,F.TT);

    APPL.NAME.ARR = "TELLER"
    FLD.NAME.ARR = "L.BOL.DIVISA" : @VM : "L.NOM.DIVISA"

    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    Y.L.BOL.DIVISA.POS = FLD.POS.ARR<1,1>
    Y.L.NOM.DIVISA.POS = FLD.POS.ARR<1,2>

*
    IF ( GETENV('T24_HOME', t24_home) ) THEN NULL;
    V.DIR.OUT = t24_home:'/': 'FIMSDT.REPRINT'
    CALL OCOMO('T24 HOME =':t24_home)

    IF ( GETENV('SEND_DSLIP_TO_SDT', should_send_dslip) ) THEN NULL;
    IF ( GETENV('SEND_DSLIP_TO_SDT', send_flag) ) THEN NULL;
    V.SHOULD.SEND.DSLIP = should_send_dslip
RETURN

*Form select statement like: F.ST.LAPAP.DIGI.DSLIP.REPRINT WITH SENT.STATUS EQ PENDING
DO.SELECT:
    NO.OF.REC = ''; SEL.ERR = ''; Y.COUNT.COM = ''; COM.POS = ''
    SEL.CMD = "SELECT " : FN.DIGI.REPRINT : " WITH SENT.STATUS EQ PENDING";
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR);
    Y.COUNT = DCOUNT(SEL.LIST,@FM); ;*R22 MANUAL CONVERSION
    CALL OCOMO('Total rec to process: ' : Y.COUNT)
    IF (NO.OF.REC GT 0) THEN
        GOSUB DO.PROCESS
    END
RETURN


DO.PROCESS:
    CALL OCOMO('Send DEALSLIP TO SDT FLAG = ' : should_send_dslip)
    CALL OCOMO('Send flag =':send_flag)
    LOOP
        REMOVE T.TT.ID FROM SEL.LIST SETTING TAG
    WHILE T.TT.ID:TAG
        GOSUB READ.REPRINT.SEQ
    REPEAT
RETURN

*Read F.REDO.APAP.H.REPRINT.SEQ to get HOLD.CTRL.ID
READ.REPRINT.SEQ:
    CALL F.READ(FN.REPRINT,T.TT.ID,R.REPRINT,F.REPRINT,ERR.REPRINT)
    IF T.TT.ID THEN
        Y.HOLD.CONTROL.ID = R.REPRINT<REDO.REP.SEQ.HOLD.CTRL.ID>
        GOSUB DO.MOVE.FILE
    END
RETURN

*Not moving file actually, but reading HOLD then proceed to write to the specified path
DO.MOVE.FILE:
    CALL F.READ(FN.HOLD,Y.HOLD.CONTROL.ID,R.HOLD,F.HOLD,ERR.HOLD)
    IF (R.HOLD) THEN
        V.FILE.OUT =  Y.HOLD.CONTROL.ID
        OPENSEQ V.DIR.OUT, V.FILE.OUT TO F.FILE.OUT THEN NULL

        LOOP
            REMOVE V.DATA FROM R.HOLD SETTING V.STATUS
            T.MSG = V.DATA
            WRITESEQ T.MSG APPEND TO F.FILE.OUT ELSE
                CALL OCOMO('Write error')
                STOP
            END
        UNTIL V.STATUS EQ 0
        REPEAT
        CALL OCOMO('Hold = ' : Y.HOLD.CONTROL.ID : ', wrote to path: ': V.DIR.OUT)
        GOSUB DO.SEND.EXT

    END
RETURN

*We call JAVA API to send the file as Multipart attachment via rabbitMQ
DO.SEND.EXT:
    IF V.SHOULD.SEND.DSLIP EQ 'true' THEN
        GOSUB DO.READ.TT
        GOSUB DO.SEND.EXTERNAL.ITF
    END ELSE
        Y.SENT.STATUS = 'FINALIZED'
    END
    GOSUB DO.UPDATE.DIGI.REPRINT
RETURN

DO.READ.TT:


    CALL F.READ(FN.TT,T.TT.ID,R.TT,F.TT,ERR.TT)
    Y.BOL.DIVISA = R.TT<TT.TE.LOCAL.REF,Y.L.BOL.DIVISA.POS,1>


RETURN

DO.SEND.EXTERNAL.ITF:
    V.EB.API.ID = 'ITF.SEND.DSLIP.SDT'
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Y.SDT.ID = 'null'
    Y.ID.REQUERIMIENTO = '1'
    Y.DESCRIPCION = 'COMPROBANTE CAJA TRANSACCION ' : T.TT.ID
    IF Y.BOL.DIVISA THEN
        Y.DEALTICKET.ID = Y.BOL.DIVISA
    END ELSE
        Y.DEALTICKET.ID = ''
    END
    Y.FILE.PATH = V.DIR.OUT:'/':Y.HOLD.CONTROL.ID
    Y.FILE.NAME = T.TT.ID
    Y.PARAMETRO.ENVIO = Y.DESCRIPCION : '::' : Y.DEALTICKET.ID : '::' : Y.FILE.PATH : '::' : Y.FILE.NAME
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CALL OCOMO('Parametro envio = ':Y.PARAMETRO.ENVIO)
    CALL EB.CALL.JAVA.API(V.EB.API.ID,Y.PARAMETRO.ENVIO,Y.RESPONSE,Y.CALLJ.ERROR)
    Y.EXT.MESSAGE = ''
    IF (Y.CALLJ.ERROR) THEN
        Y.EXT.MESSAGE = 'CALLJ ERROR CODE: ' : Y.CALLJ.ERROR
        Y.SENT.STATUS = 'CANCELLED'
    END ELSE
        Y.RECV = Y.RESPONSE
        Y.SUCCESS.IND = FIELD(Y.RECV,'^^',1)
        Y.RECV.MSG = FIELD(Y.RECV,'^^',2)
        Y.EXT.MESSAGE = 'Success:' : Y.SUCCESS.IND : ', Detail: ' : Y.RECV.MSG
        IF Y.SUCCESS.IND EQ 'true' THEN
            Y.SENT.STATUS = 'SENT'
        END ELSE
            Y.SENT.STATUS = 'FAILED'
            Y.EXT.MESSAGE = Y.EXT.MESSAGE[1,65]
        END
    END
    CALL OCOMO('JREMORE RESPONSE = ':Y.EXT.MESSAGE)
RETURN

*Marking this TT has processed...
DO.UPDATE.DIGI.REPRINT:
    Y.TRANS.ID                          = T.TT.ID;
    Y.APP.NAME                          = "ST.LAPAP.DIGI.DSLIP.REPRINT";
    Y.VER.NAME                          = Y.APP.NAME :",RAD";
    Y.FUNC                              = "I";
    Y.PRO.VAL                           = "PROCESS";
    Y.GTS.CONTROL                       = "";
    Y.NO.OF.AUTH                        = "0";
    FINAL.OFS                           = "";

    R.DIGI = ''
    R.DIGI<ST.LAP62.SENT.STATUS> = Y.SENT.STATUS
    R.DIGI<ST.LAP62.IN.DIRECTORY> = V.DIR.OUT
    R.DIGI<ST.LAP62.HOLD.CONTROL.ID> = Y.HOLD.CONTROL.ID
    R.DIGI<ST.LAP62.SENT.EXT.MESSAGE> = Y.EXT.MESSAGE

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.DIGI,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'','GENOFS','')

    CALL OCOMO('OFS POSTED = ' : FINAL.OFS)
RETURN
END
