* @ValidationCode : MjoxMzQyMTUwMzAyOkNwMTI1MjoxNjg2Njc1ODQ1MjMzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:34:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.ORANGE.PAYMENTS(Y.RECORD.ID)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 06-JUNE-2023      Conversion Tool       R22 Auto Conversion - = to EQ , FM to @FM and TNO to C$T24.SESSION.NO
* 06-JUNE-2023      Harsha                R22 Manual Conversion - Added Package
*------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
*
    $INSERT I_REDO.FI.ORANGE.PYMT.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
*
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $USING APAP.LAPAP

*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD  THEN
        GOSUB PROCESS
    END
*
RETURN
*
* =====
PROCESS:
* =====


    BEGIN CASE
        CASE Y.RECORD.TYPE EQ "FT"
            CALL F.READ(FN.FUNDS.TRANSFER,Y.RECORD.ID, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER, FT.ERR)
            CALL RAD.CONDUIT.LINEAR.TRANSLATION("MAP","ORANGE.FT",FN.FUNDS.TRANSFER,Y.RECORD.ID,R.FUNDS.TRANSFER,R.RETURN.MESSAGE,Y.ERR)
        CASE Y.RECORD.TYPE EQ "TT"
            CALL F.READ(FN.TELLER,Y.RECORD.ID, R.TELLER, F.TELLER, TT.ERR)
            CALL RAD.CONDUIT.LINEAR.TRANSLATION("MAP","ORANGE.TT",FN.TELLER,Y.RECORD.ID,R.TELLER,R.RETURN.MESSAGE,Y.ERR)
    END CASE
    IF Y.ERR NE '' THEN
        K.MON.TP='08'
        K.DESC=Y.ERR
        APAP.LAPAP.redoInterfaceRecAct(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)      ;*R22 Manual Conversion - Added Package
    END ELSE
        yLine = R.RETURN.MESSAGE:"         "
        GOSUB WRITE.LINE
    END


RETURN
*
* =========
WRITE.LINE:
* =========
*

    WRITESEQ yLine APPEND TO FILE.TEXT ELSE
        K.MON.TP='08'
        K.DESC=E
        APAP.LAPAP.redoInterfaceRecAct(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)  ;*R22 Manual Conversion - Added Package
    END
*
*    WEOFSEQ FILE.TEXT
*    CLOSESEQ FILE.TEXT
*
RETURN
*
* =========
INITIALISE:
* =========
*
    LOOP.CNT       = 1
    MAX.LOOPS      = 2
*
    W.ERROR        = ""
    R.BCR = ''
    R.RETURN.MESSAGE = ''
    Y.ERR = ''

*
    K.INT.CODE=''
    K.INT.TYPE='BATCH'
    K.BAT.NO=''
    K.BAT.TOT=''
    K.INFO.OR=''
    K.INFO.DE=''
    K.ID.PROC=''
    K.MON.TP='01'
    K.DESC=''
    K.REC.CON=''
    K.EX.USER=OPERATOR
    K.EX.PC=C$T24.SESSION.NO	;*R22 Auto Conversion  - TNO to C$T24.SESSION.NO
*
RETURN

* ========
OPEN.FILES:
* ========
*
*    OPENSEQ FULL.NAME TO FILE.TEXT ELSE

*        W.ERROR = 'NO SE PUDO CREAR ARCHIVO-':FULL.NAME

*    END
*
RETURN
*
* ===================
CHECK.PRELIM.CONDITIONS:
* ===================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                IF NOT(Y.RECORD.ID) OR LEN(Y.RECORD.ID) GT 12 THEN
                    W.ERROR = "Invalid.Record.ID.&":@FM:Y.RECORD.ID
                END

            CASE LOOP.CNT EQ 2
                Y.RECORD.TYPE = Y.RECORD.ID[1,2]
                IF Y.RECORD.TYPE NE "FT" AND Y.RECORD.TYPE NE "TT"   THEN
                    W.ERROR = "Invalid.Transaction.ID.Trailer.&":@FM:Y.RECORD.TYPE
                END
        END CASE

        IF W.ERROR THEN
            PROCESS.GOAHEAD = 0
        END

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
