* @ValidationCode : MjoyMjU3MzgyNzg6Q3AxMjUyOjE2OTMyMjc3OTc2NTU6SVRTUzotMTotMTo0NjI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Aug 2023 18:33:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 462
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*28-08-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MAS.REDON.POST.RT
    $INSERT I_EQUATE ;*R22 MANUAL CONVERSION START
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.DATES
    $INSERT I_F.ST.LAPAP.CRC.ROUNDUP.DET
    $INSERT I_F.ST.LAPAP.CRC.ROUNDUP
    $INSERT I_F.FUNDS.TRANSFER ;*R22 MANUAL CONVERSION START
   $USING EB.TransactionControl
*-----------------------------------------------------------------------------------------
*
*
*
*----------------------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
    FN.CRC.ROUNDUP = 'FBNK.ST.LAPAP.CRC.ROUNDUP'
    F.CRC.ROUNDUP = ''
    CALL OPF(FN.CRC.ROUNDUP,F.CRC.ROUNDUP)

    FN.CRC.ROUNDUP.DET = 'FBNK.ST.LAPAP.CRC.ROUNDUP.DET'
    F.CRC.ROUNDUP.DET = ''
    CALL OPF(FN.CRC.ROUNDUP.DET,F.CRC.ROUNDUP.DET)

RETURN

PROCESS:
    CALL OCOMO('Waiting 30 seconds.')
    SLEEP 30
    GOSUB GET.PROCESSING

RETURN

GET.PROCESSING:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.CRC.ROUNDUP : " WITH BATCH.STATUS EQ PROCESSING"

    CALL OCOMO("SEL.CMD : " : SEL.CMD)

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)

    Y.PROCESSED.ROUNDUP.ID.L = ''
    LOOP

        REMOVE Y.ROUNDUP.ID FROM SEL.REC SETTING TAG

    WHILE Y.ROUNDUP.ID:TAG
        CALL OCOMO("ROUND-UP TO PROCESS = " : Y.ROUNDUP.ID)
        Y.PROCESSED.ROUNDUP.ID.L<-1> = Y.ROUNDUP.ID
        T.ROUNDUP.ID = Y.ROUNDUP.ID
        Y.ROUNDUP.ID.CURR = T.ROUNDUP.ID
        GOSUB DO.ROUNDUP.POST.PROCESSING
    REPEAT
RETURN

DO.ROUNDUP.POST.PROCESSING:
    CALL OCOMO("PROCESSING : " : T.ROUNDUP.ID)
    SEL2.ERR = ''; SEL2.LIST = ''; SEL2.REC = ''; SEL2.CMD = ''
    SEL2.CMD = "SELECT " : FN.CRC.ROUNDUP.DET : " WITH CRC.ROUNDUP.ID EQ " : T.ROUNDUP.ID
    CALL EB.READLIST(SEL2.CMD,SEL2.REC,'',SEL2.LIST,SEL2.ERR)

    CALL F.READ(FN.CRC.ROUNDUP,T.ROUNDUP.ID,R.RU,F.CRC.ROUNDUP,ERR.RU)
    Y.PAYMENT.ID = R.RU<ST.LAP68.PAYMENT.ID>

    Y.SUMMARY.ARR = '';
    Y.CANT.SUCESSFUL = 0;
    Y.CANT.FAILED = 0;
    Y.TOT.AMT.APPLIED = 0;
    Y.TOT.AMT.NOT.APPLIED = 0;
    LOOP

        REMOVE T.ROUNDUPDET.ID FROM SEL2.REC SETTING TAG2

    WHILE T.ROUNDUPDET.ID:TAG2
        CALL F.READ(FN.CRC.ROUNDUP.DET,T.ROUNDUPDET.ID,R.RUD,F.CRC.ROUNDUP.DET,ERR.RUD)
        Y.RU.AMT = 0;
        IF R.RUD THEN
            Y.RUD.STATUS = R.RUD<ST.LAP50.STATUS>
            Y.TXN.ID = R.RUD<ST.LAP50.TRANSACTION.ID>
            Y.OUR.REFERENCE = R.RUD<ST.LAP50.OUR.REFERENCE>
            Y.RU.AMT = R.RUD<ST.LAP50.CREDIT.AMOUNT>
            Y.INT.COMMENT = R.RUD<ST.LAP50.INT.COMMENTS>
*
            CHANGE @VM TO ' ' IN Y.INT.COMMENT
            CALL OCOMO('ID=':T.ROUNDUPDET.ID:',SATUS=':Y.RUD.STATUS : ', INT.COMM=':Y.INT.COMMENT)
*
            Y.SHOULD.SKIP = 'false'
            BEGIN CASE
*                CASE Y.RUD.STATUS = "CONFIRMING" OR Y.RUD.STATUS = 'PENDING'
                CASE Y.RUD.STATUS EQ "CONFIRMING" OR Y.RUD.STATUS EQ 'PENDING';* R22 UTILITY AUTO CONVERSION
                    CALL OCOMO("ROUND-UP = " : T.ROUNDUP.ID : ", still has unprocessed FUNDS.TRANSFER, skipping.")
                    Y.SHOULD.SKIP = 'true'
                    BREAK;
*                CASE Y.RUD.STATUS = "APPLIED"
                CASE Y.RUD.STATUS EQ "APPLIED";* R22 UTILITY AUTO CONVERSION
                    Y.CANT.SUCESSFUL += 1
                    Y.SUMMARY.ARR<-1> = Y.TXN.ID : @VM : "SUCCESS" : @VM : ""
                    Y.TOT.AMT.APPLIED += Y.RU.AMT

*                CASE Y.RUD.STATUS = "FAILED"
                CASE Y.RUD.STATUS EQ "FAILED";* R22 UTILITY AUTO CONVERSION
                    Y.CANT.FAILED += 1
                    Y.FAIL.MSG = R.RUD<ST.LAP50.INT.COMMENTS>
                    Y.SUMMARY.ARR<-1> = Y.TXN.ID : @VM : "FAILED" : @VM : Y.INT.COMMENT
                    Y.TOT.AMT.NOT.APPLIED += Y.RU.AMT

                CASE 1
                    Y.CANT.FAILED += 1
                    Y.FAIL.MSG = R.RUD<ST.LAP50.INT.COMMENTS>
                    Y.SUMMARY.ARR<-1> = Y.TXN.ID : @VM : "FAILED" : @VM : Y.INT.COMMENT
                    Y.TOT.AMT.NOT.APPLIED += Y.RU.AMT

            END CASE

        END
    REPEAT
    Y.CNT.SUMM.ARR = DCOUNT(Y.SUMMARY.ARR,@FM)
    CALL OCOMO('Summary Array elements = ' : Y.CNT.SUMM.ARR)

    IF Y.RUD.STATUS NE 'CONFIRMING' THEN
        Y.NOTIFY.STATUS = ''
        BEGIN CASE
            CASE (Y.CANT.SUCESSFUL GT 0) AND (Y.CANT.FAILED EQ 0)
                Y.UPDATED.STATUS = 'APPLIED'
                Y.NOTIFY.STATUS = 'Applied'
            CASE (Y.CANT.SUCESSFUL GT 0) AND (Y.CANT.FAILED GT 0)
                Y.UPDATED.STATUS = 'PARTIALLY.APPLIED'
                Y.NOTIFY.STATUS = 'Partially Applied'
            CASE (Y.CANT.SUCESSFUL EQ 0) AND (Y.CANT.FAILED GT 0)
                Y.UPDATED.STATUS = 'NOT.APPLIED'
                Y.NOTIFY.STATUS = 'Not Applied'
            CASE @TRUE
                Y.UPDATED.STATUS = 'NOT.APPLIED'
                Y.NOTIFY.STATUS = 'Not Applied'
        END CASE

        IF Y.SHOULD.SKIP NE 'true' THEN
            GOSUB DO.UPDATE.MASTER.ROUNDUP
        END
    END

RETURN

DO.UPDATE.MASTER.ROUNDUP:
    CALL OCOMO('Round Up ' : Y.ROUNDUP.ID.CURR : ', update to status: ' : Y.UPDATED.STATUS)
    CALL OCOMO('Quantity SUCESSFUL ' : Y.CANT.SUCESSFUL)
    CALL OCOMO('Amount applied ' : Y.TOT.AMT.APPLIED)
    CALL OCOMO('Quantity FAILED ' : Y.CANT.FAILED)
    CALL OCOMO('Amount not applied ' : Y.TOT.AMT.NOT.APPLIED)

    R.RU = ''
    R.RU<ST.LAP68.BATCH.STATUS> = Y.UPDATED.STATUS
    R.RU<ST.LAP68.QTY.APPLIED> = Y.CANT.SUCESSFUL
    R.RU<ST.LAP68.AMT.APPLIED> = Y.TOT.AMT.APPLIED
    R.RU<ST.LAP68.QTY.NOT.APPL> = Y.CANT.FAILED
    R.RU<ST.LAP68.AMT.NOT.APPL> = Y.TOT.AMT.NOT.APPLIED

    GOSUB DO.POST.OFS
RETURN

DO.POST.OFS:
    Y.TRANS.ID = Y.ROUNDUP.ID.CURR
    Y.APP.NAME = "ST.LAPAP.CRC.ROUNDUP"
    Y.VER.NAME = Y.APP.NAME :",INPUT"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.RU,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"CR.CTA.OFS.GL",'')

*    CALL JOURNAL.UPDATE('')
EB.TransactionControl.JournalUpdate('');* R22 UTILITY AUTO CONVERSION

    GOSUB DO.SEND.RABBIT.NOTIFICATION
RETURN

DO.SEND.RABBIT.NOTIFICATION:
    Y.ARR.COPY = Y.SUMMARY.ARR
    CHANGE @FM TO '&&' IN Y.ARR.COPY
    CHANGE @VM TO '^' IN Y.ARR.COPY

    V.EB.API.ID = 'LAPAP.ROUNDUP.MSG.ITF'
    Y.PARAMETRO.ENVIO = Y.PAYMENT.ID : '@' : Y.NOTIFY.STATUS : '@' : Y.ARR.COPY
*CALL OCOMO(Y.PARAMETRO.ENVIO)
    CALL EB.CALL.JAVA.API(V.EB.API.ID,Y.PARAMETRO.ENVIO,Y.RESPONSE,Y.CALLJ.ERROR)

    IF Y.RESPONSE THEN
        CALL OCOMO('EB.CALL.JAVA.API Response = ' : Y.RESPONSE)
    END ELSE
        CALL OCOMO('EB.CALL.JAVA.API Error = ' : Y.CALLJ.ERROR)
    END

RETURN
END
