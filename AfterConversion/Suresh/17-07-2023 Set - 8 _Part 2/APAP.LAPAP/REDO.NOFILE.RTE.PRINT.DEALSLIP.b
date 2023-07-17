* @ValidationCode : MjozMzU1NDUzMDk6Q3AxMjUyOjE2ODkzNDAwNTg2NDA6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 14 Jul 2023 18:37:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE REDO.NOFILE.RTE.PRINT.DEALSLIP(Y.DATA)
*----------------------------------------------------------------------------------------------------------------------
* Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By      : APAP
* Program   Name    : REDO.NOFILE.RTE.PRINT.DEALSLIP
*----------------------------------------------------------------------------------------------------------------------
* Description       : Routine to produce the dealslip for the requested version
* Linked With       : VERSION.CONTROL FT/TT/TFS
* In  Parameter     : N/A
* Out Parameter     : N/A
* Files  Used       : FT/TT/TFS
*----------------------------------------------------------------------------------------------------------------------
* Modification Details:
* =====================
* Date         Who                  Reference               Description
* ------       -----                ------------            -------------
* 02-03-2018   APAP                 RTE 24 hours process    Initial version
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion           FM TO @FM, VM TO @VM, CONVERT TO CHANGE
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_RC.COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.T24.FUND.SERVICES

    $INSERT I_F.REDO.APAP.H.REPRINT.SEQ
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.REDO.H.CASHIER.PRINT

    Y.FLAG = ''
    Y.AML.FLAG = ''
    Y.FINAL.DEALSLIP = ''
    OFS$DEAL.SLIP.PRINTING = 1
    Y.LAST.VERSION.FLAG = ''
    GET.AC.VERSION = ''
    GET.ACTUAL.VERSION = ''
    Y.RFT.FLAG = ''
    Y.FT.NV.FLAG = ''
    Y.TRANS.LIST = ''
    LOC.APPLICATION.VAL = APPLICATION

    GET.TXN.ID = System.getVariable("CURRENT.WTM.FIRST.ID")
    IF GET.TXN.ID EQ 'CURRENT.WTM.FIRST.ID' OR GET.TXN.ID EQ '' THEN
        LOCATE "TRANS.ID" IN D.FIELDS<1> SETTING WTM.POS THEN
            GET.TXN.ID = D.RANGE.AND.VALUE<WTM.POS>
        END ELSE
            ENQ.ERROR = 'REFERENCIA DE TRANSACCION NO ENCONTRADA'
            RETURN
        END
    END

    Y.APPL =  'TELLER':@FM:'FUNDS.TRANSFER':@FM:'T24.FUND.SERVICES'
    Y.FIELD = 'L.ACTUAL.VERSIO':@FM:'L.ACTUAL.VERSIO':@FM:'L.T24FS.TRA.DAY'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FIELD,Y.POS)

    FN.REDO.TRANSACTION.CHAIN = 'F.REDO.TRANSACTION.CHAIN'
    F.REDO.TRANSACTION.CHAIN = ''
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)

    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,GET.TXN.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,REDO.TRANSACTION.CHAIN.ERR)

    FN.REDO.H.CASHIER.PRINT = 'F.REDO.H.CASHIER.PRINT'
    F.REDO.H.CASHIER.PRINT = ''
    CALL OPF(FN.REDO.H.CASHIER.PRINT,F.REDO.H.CASHIER.PRINT)
    CALL CACHE.READ(FN.REDO.H.CASHIER.PRINT,'SYSTEM',R.REDO.H.CASHIER.PRINT,REDO.H.CASHIER.PRINT.ERR)
    LIST.OF.VERSION = R.REDO.H.CASHIER.PRINT<REDO.CASH.VERSION.NAME>

    IF R.REDO.TRANSACTION.CHAIN THEN
        RTC.TRANS.ID.VAL = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>
        Y.FT.NV.FLAG = GET.TXN.ID
        LOOP
            REMOVE GET.ID FROM RTC.TRANS.ID.VAL SETTING TXN.POS
        WHILE GET.ID:TXN.POS
            GOSUB CHECK.CASE
            GOSUB CHAIN.PROCESS
        REPEAT
    END

    GET.ID = GET.TXN.ID
    GOSUB CHECK.CASE
    GOSUB MAIN.PROCESS

    GET.ACTUAL.VERSION <-1> = R.RECORD.VAL<GET.LRF.POS,L.ACTUAL.VERSIO.POS>:@FM:GET.AC.VERSION
    GOSUB CHECK.DUMMY.CALL

    IF NOT(Y.FLAG) THEN
        GOSUB GET.DEALSLIP.INFO

        IF R.REDO.TRANSACTION.CHAIN THEN
            RTC.TRANS.ID.VAL = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>
            Y.TRANS.LIST = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>
            LOOP
                REMOVE GET.ID FROM RTC.TRANS.ID.VAL SETTING TXN.POS
            WHILE GET.ID:TXN.POS
                GOSUB CHECK.CASE
                GOSUB MAIN.PROCESS
                GET.TXN.ID = GET.ID
                GOSUB GET.DEALSLIP.INFO
            REPEAT
        END

        IF Y.RFT.FLAG THEN
            GOSUB UPDATE.REPRINT.TABLE
        END

*        GOSUB UPDATE.DEALSLIP.ID
    END
    APPLICATION = LOC.APPLICATION.VAL

RETURN

*----------------------------------------------------------------------------------------------------------------------
CHECK.DUMMY.CALL:
*----------------------------------------------------------------------------------------------------------------------

    LOOP
        REMOVE GET.VERSION.ID FROM GET.ACTUAL.VERSION SETTING VER.POS
    WHILE GET.VERSION.ID:VER.POS
        LOCATE GET.VERSION.ID IN LIST.OF.VERSION<1,1> SETTING VER.POS THEN
            Y.LAST.VERSION.FLAG = GET.VERSION.ID
            Y.VERSION.DEAL.FLAG <-1> = GET.VERSION.ID
        END
    REPEAT

RETURN

*----------------------------------------------------------------------------------------------------------------------
CHECK.CASE:
*----------------------------------------------------------------------------------------------------------------------

    BEGIN CASE

        CASE GET.ID[1,2] EQ 'TT'
            GET.APPLICATION = 'TELLER'
            L.ACTUAL.VERSIO.POS = Y.POS<1,1>

        CASE GET.ID[1,2] EQ 'FT'
            GET.APPLICATION = 'FUNDS.TRANSFER'
            L.ACTUAL.VERSIO.POS = Y.POS<2,1>

        CASE GET.ID[1,5] EQ 'T24FS'
            GET.APPLICATION = 'T24.FUND.SERVICES'
            L.ACTUAL.VERSIO.POS = Y.POS<3,1>

        CASE OTHERWISE
            Y.FLAG = 1

    END CASE

    APPLICATION = GET.APPLICATION
    GOSUB GET.STANDARD.SELECT.INFO
RETURN

*----------------------------------------------------------------------------------------------------------------------
CHAIN.PROCESS:
*----------------------------------------------------------------------------------------------------------------------

    FN.APPLICATION = 'F.':GET.APPLICATION
    F.APPLICATION = ''
    CALL OPF(FN.APPLICATION,F.APPLICATION)
    CALL F.READ(FN.APPLICATION,GET.ID,R.REC,F.APPLICATION,ERR.APPLICATION)

    IF NOT(R.REC) THEN
        Y.FLAG = 1
    END ELSE
        GET.INPUTTER.POS = FIELD.POS<1>
        GET.AUTHORISER.POS = FIELD.POS<2>

        GET.INPUTTER.VAL = R.REC<GET.INPUTTER.POS>
        GET.AUTHORISER.VAL = R.REC<GET.AUTHORISER.POS>

        GET.INPUTTER = FIELD(GET.INPUTTER.VAL,'_',2)
        GET.AUTHORISER = FIELD(GET.AUTHORISER.VAL,'_',2)
        GET.FASTPATH.FLAG = INDEX(GET.AUTHORISER.VAL,'FASTPATH',1)

        GET.AC.VERSION <-1> = R.REC<GET.LRF.POS,L.ACTUAL.VERSIO.POS>

        GET.RECORD.STATUS = FIELD.POS<5>
        IF GET.RECORD.STATUS EQ 'INAO' THEN
            Y.FLAG = 1
        END

    END
RETURN

*----------------------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*----------------------------------------------------------------------------------------------------------------------

    FN.APPLICATION = 'F.':GET.APPLICATION
    F.APPLICATION = ''
    CALL OPF(FN.APPLICATION,F.APPLICATION)
    CALL F.READ(FN.APPLICATION,GET.ID,R.RECORD.VAL,F.APPLICATION,ERR.APPLICATION)

    IF NOT(R.RECORD.VAL) THEN
        Y.FLAG = 1
    END ELSE

        GET.INPUTTER.POS = FIELD.POS<1>
        GET.AUTHORISER.POS = FIELD.POS<2>

        GET.INPUTTER.VAL = R.RECORD.VAL<GET.INPUTTER.POS>
        GET.AUTHORISER.VAL = R.RECORD.VAL<GET.AUTHORISER.POS>

        GET.INPUTTER = FIELD(GET.INPUTTER.VAL,'_',2)
        GET.AUTHORISER = FIELD(GET.AUTHORISER.VAL,'_',2)
        GET.FASTPATH.FLAG = INDEX(GET.AUTHORISER.VAL,'FASTPATH',1)
        GET.RECORD.STATUS = FIELD.POS<5>

        IF GET.RECORD.STATUS EQ 'INAO' THEN
            Y.FLAG = 1
        END


    END

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.STANDARD.SELECT.INFO:
*----------------------------------------------------------------------------------------------------------------------

    CALL GET.STANDARD.SELECTION.DETS(GET.APPLICATION,R.STANDARD.SELECTION)
    LIST.OF.FIELD.NAME = 'INPUTTER':@VM:'AUTHORISER':@VM:'LOCAL.REF':@VM:'OVERRIDE':@VM:'RECORD.STATUS'
    FIELD.POS = ''

    LOOP
        REMOVE FIELD.NAME FROM LIST.OF.FIELD.NAME SETTING F.POS
    WHILE FIELD.NAME:F.POS

        LOCATE FIELD.NAME IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,1> SETTING SS.POS THEN
            FIELD.POS <-1>= R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,SS.POS>
        END
    REPEAT
    GET.LRF.POS = FIELD.POS<3>

RETURN

*----------------------------------------------------------------------------------------------------------------------
GET.DEALSLIP.INFO:
*----------------------------------------------------------------------------------------------------------------------

    GET.LRF.POS = FIELD.POS<3>
    GET.VERSION = R.RECORD.VAL<GET.LRF.POS,L.ACTUAL.VERSIO.POS>

    LOCATE GET.VERSION IN LIST.OF.VERSION<1,1> SETTING VER.POS THEN
        GET.DEALSLIP.LIST = R.REDO.H.CASHIER.PRINT<REDO.CASH.SLIP.ID,VER.POS>

        FN.REDO.CASHIER.DEALSLIP.INFO = 'F.REDO.CASHIER.DEALSLIP.INFO'
        F.REDO.CASHIER.DEALSLIP.INFO = ''
        CALL OPF(FN.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO)


        READ R.REDO.CASHIER.DEALSLIP.INFO FROM F.REDO.CASHIER.DEALSLIP.INFO, GET.TXN.ID THEN
            RETURN
        END ELSE
            Y.RFT.FLAG = 1
            Y.DATA<-1> = GET.TXN.ID
        END

        MATBUILD R.NEW.BACK FROM R.NEW
        ID.NEW.BACK = ID.NEW
        ID.NEW = GET.TXN.ID
        MATPARSE R.NEW FROM R.RECORD.VAL

        GOSUB CHECK.RTE.FORM
        Y.FINAL.DEALSLIP = ''
        LOOP
            REMOVE DEALSLIP.ID FROM GET.DEALSLIP.LIST SETTING DEAL.POS
        WHILE DEALSLIP.ID:DEAL.POS
            OFS$DEAL.SLIP.PRINTING = 1

            CALL PRODUCE.DEAL.SLIP(DEALSLIP.ID)

        REPEAT

        MATPARSE R.NEW FROM R.NEW.BACK
        ID.NEW = ID.NEW.BACK

        R.REDO.CASHIER.DEALSLIP.INFO = 'PRINTED'

        WRITE R.REDO.CASHIER.DEALSLIP.INFO TO F.REDO.CASHIER.DEALSLIP.INFO, GET.TXN.ID
        Y.GET.TXN.SEQ.ID = GET.TXN.ID
        CALL System.setVariable("CURRENT.WTM.FIRST.ID","")

    END
RETURN
*----------------------------------------------------------------------------------------------------------------------
UPDATE.REPRINT.TABLE:
*----------------------------------------------------------------------------------------------------------------------

    FN.REDO.APAP.H.REPRINT.SEQ = 'F.REDO.APAP.H.REPRINT.SEQ'
    F.REDO.APAP.H.REPRINT.SEQ = ''
    CALL OPF(FN.REDO.APAP.H.REPRINT.SEQ,F.REDO.APAP.H.REPRINT.SEQ)

    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.REPRINT.SEQ>   = '0'
    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.REPRINT.FLAG>  = 'NO'
    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.INIT.PRINT>    = 'NO'
*    Y.TXN.DSLIP = System.getVariable("CURRENT.WTM.FIRST.ID")
    GET.FIRST.ID = FIELD(C$LAST.HOLD.ID,',',1)
    R.REDO.APAP.H.REPRINT.SEQ<REDO.REP.SEQ.HOLD.CTRL.ID> = CHANGE(C$LAST.HOLD.ID,',',@VM)
    C$LAST.HOLD.ID = GET.FIRST.ID:',':C$LAST.HOLD.ID
*    CALL F.WRITE(FN.REDO.APAP.H.REPRINT.SEQ,Y.TXN.DSLIP,R.REDO.APAP.H.REPRINT.SEQ)

    WRITE R.REDO.APAP.H.REPRINT.SEQ TO F.REDO.APAP.H.REPRINT.SEQ, Y.GET.TXN.SEQ.ID

RETURN

*----------------------------------------------------------------------------------------------------------------------
UPDATE.DEALSLIP.ID:
*----------------------------------------------------------------------------------------------------------------------

    GET.INITIAL.ID = System.getVariable("CURRENT.WTM.FIRST.ID")
    GET.INITIAL.ID = GET.INITIAL.ID:'-REPRINT'

    R.REDO.CASHIER.DEALSLIP.INFO = ''
    R.REDO.CASHIER.DEALSLIP.INFO = CHANGE(C$LAST.HOLD.ID, ',', @FM) ;*R22 Auto Conversion

    WRITE R.REDO.CASHIER.DEALSLIP.INFO TO F.REDO.CASHIER.DEALSLIP.INFO, GET.INITIAL.ID
RETURN

*----------------------------------------------------------------------------------------------------------------------
CHECK.RTE.FORM:
*----------------------------------------------------------------------------------------------------------------------
*    IF Y.AML.FLAG EQ '' THEN

    AML.CHECK.OVERRIDE.ID = 'AML.TXN.AMT.EXCEED'
    GET.OVERRIDE.POS = FIELD.POS<4>
    Y.VER.OVERRIDES = R.RECORD.VAL<GET.OVERRIDE.POS>
    FINDSTR AML.CHECK.OVERRIDE.ID IN Y.VER.OVERRIDES SETTING OVER.POS THEN
        IF GET.TXN.ID[1,2] EQ 'TT' THEN
            Y.FINAL.DEALSLIP =  'AML.TT.RTE.FORM'
            CALL PRODUCE.DEAL.SLIP('AML.TT.RTE.FORM')
            Y.AML.FLAG = 1    ;* RTE form needs to be produced for all FT's except TT transaction
        END

        IF GET.TXN.ID[1,2] EQ 'FT' THEN
            CALL PRODUCE.DEAL.SLIP('AML.FT.RTEFRD')
            Y.AML.FLAG = 1
        END

        IF GET.TXN.ID[1,5] EQ 'T24FS' THEN
            CALL PRODUCE.DEAL.SLIP('AML.TFS.RTE.FOR')
            Y.AML.FLAG = 1
        END

    END
*    END

RETURN
*----------------------------------------------------------------------------------------------------------------------
END
