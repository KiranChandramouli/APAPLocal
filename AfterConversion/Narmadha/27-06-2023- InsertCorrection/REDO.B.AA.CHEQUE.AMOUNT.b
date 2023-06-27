* @ValidationCode : Mjo3MjA1MzY0Njk6VVRGLTg6MTY4Nzg2NDY5NDk0ODpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Jun 2023 16:48:14
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
SUBROUTINE REDO.B.AA.CHEQUE.AMOUNT(Y.RTC.ID)
*---------------------------------------------------
* Description: This routine is a batch routine to update the cheque amount among the transaction.
*---------------------------------------------------
* Input  Arg: Transaction ID - REDO.TRANSACTION.CHAIN.
* Output Arg: N/A
*27-06-2023 Narmadha V  Manual R22 Conversion - Commented and changing respective variable name
*---------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LOAN.FT.TT.TXN
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_REDO.B.AA.CHEQUE.AMOUNT.COMMON


    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    CALL OCOMO("Processing -":Y.RTC.ID)
    R.RTC = ''
    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,Y.RTC.ID,R.RTC,F.REDO.TRANSACTION.CHAIN,RTC.ERR)
    IF R.RTC ELSE
* Need to delete from concat file
        CALL OCOMO("RTC Doesnt exist ":Y.RTC.ID)
        CALL F.DELETE(FN.REDO.CONCAT.CHQ.TXN,Y.RTC.ID)
        RETURN
    END

    Y.CHEQUES      = R.RTC<RTC.CHEQUE.NO>
    Y.CHEQUE.AMT   = R.RTC<RTC.CHEQUE.AMT>

    CHANGE @VM TO @FM IN Y.CHEQUES
    CHANGE @VM TO @FM IN Y.CHEQUE.AMT

    GOSUB GET.CASH.TRANS.AMOUNT
    GOSUB UPDATE.CHEQUE.AMOUNTS
    CALL OCOMO("Processed ": Y.RTC.ID)
    CALL F.DELETE(FN.REDO.CONCAT.CHQ.TXN,Y.RTC.ID)
    R.RTC<RTC.CHQ.PROC.STAT,-1> = 'BATCH.PROCESSED'
    CALL F.WRITE(FN.REDO.TRANSACTION.CHAIN,Y.RTC.ID,R.RTC)
RETURN
*---------------------------------------------------
GET.CASH.TRANS.AMOUNT:
*---------------------------------------------------
    Y.CASH.AMOUNT  = 0
    Y.TRANS.IDS    = R.RTC<RTC.TRANS.ID>
    Y.TRANS.TYPES  = R.RTC<RTC.TRANS.TYPE>
    Y.TRANS.AMOUNT = R.RTC<RTC.TRANS.AMOUNT>
    Y.TRANS.CNT = DCOUNT(Y.TRANS.IDS,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.TRANS.CNT
        Y.ID     = Y.TRANS.IDS<1,Y.VAR1>
        Y.TYPE   = Y.TRANS.TYPES<1,Y.VAR1>
        Y.AMOUNT = Y.TRANS.AMOUNT<1,Y.VAR1>

        IF Y.ID[1,2] EQ 'TT'  AND Y.TYPE EQ 'CASH' THEN
            Y.CASH.AMOUNT += Y.AMOUNT
        END

        Y.VAR1 += 1
    REPEAT
RETURN
*---------------------------------------------------
UPDATE.CHEQUE.AMOUNTS:
*---------------------------------------------------

    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.TRANS.CNT
        Y.CNCT.ID = Y.TRANS.IDS<1,Y.VAR2>
        CALL F.READ(FN.REDO.LOAN.FT.TT.TXN,Y.CNCT.ID,R.TXN,F.REDO.TRANSACTION.CHAIN,TXN.ERR)
        IF R.TXN THEN
            GOSUB ADJUST.BALANCES
            CALL F.WRITE(FN.REDO.LOAN.FT.TT.TXN,Y.CNCT.ID,R.TXN)
            GOSUB PROCESS.AUTH
        END
        Y.VAR2 += 1
    REPEAT
RETURN
*---------------------------------------------------
ADJUST.BALANCES:
*---------------------------------------------------
    Y.TOT.TXN.AMT = R.TXN<LN.FT.TT.TOTAL.AMOUNT>
    IF Y.TOT.TXN.AMT GT Y.CASH.AMOUNT THEN
        Y.TOT.TXN.AMT -= Y.CASH.AMOUNT
        Y.CASH.AMOUNT = 0
    END ELSE
        Y.CASH.AMOUNT -= Y.TOT.TXN.AMT
        Y.TOT.TXN.AMT = 0
    END

    Y.CHQ.CNT = DCOUNT(R.TXN<LN.FT.TT.CHEQUE.NO>,@VM)
    Y.VAR3 = 1
    LOOP
    WHILE Y.VAR3 LE Y.CHQ.CNT
        GOSUB ADJUST.CHEQUES.AMOUNT
        Y.VAR3 += 1
    REPEAT
RETURN
*---------------------------------------
ADJUST.CHEQUES.AMOUNT:
*---------------------------------------

    IF Y.TOT.TXN.AMT GT 0 THEN
        Y.CHQ.ID = R.TXN<LN.FT.TT.CHEQUE.NO,Y.VAR3>
        LOCATE Y.CHQ.ID IN Y.CHEQUES SETTING POS1 THEN
            IF Y.TOT.TXN.AMT GT Y.CHEQUE.AMT<POS1> THEN
                Y.TOT.TXN.AMT = Y.TOT.TXN.AMT - Y.CHEQUE.AMT<POS1>
              
*    R.TXN<LN.FT.TT.REQ.TXN.AMT,Y.VAR3> = Y.CHEQUE.AMT<POS1>; *Manual R22 conversion
                Y.CHEQUE.AMT<POS1> = 0
            END ELSE
                Y.CHEQUE.AMT<POS1> = Y.CHEQUE.AMT<POS1> - Y.TOT.TXN.AMT
*    R.TXN<LN.FT.TT.REQ.TXN.AMT,Y.VAR3> = Y.TOT.TXN.AMT ; *Manual R22 conversion
                Y.TOT.TXN.AMT = 0
            END
        END
    END ELSE
* R.TXN<LN.FT.TT.REQ.TXN.AMT,Y.VAR3> = 0 ; *Manual R22 conversion
    END
RETURN
*---------------------------------------
PROCESS.AUTH:
*---------------------------------------

    Y.ID = Y.CNCT.ID
    R.TEMP.REC = Y.CNCT.ID
    CALL F.WRITE(FN.REDO.TEMP.WORK.TXN,Y.CNCT.ID,R.TEMP.REC)
    Y.FLG = ''
* Y.TT.TXN.IDS = R.TXN<LN.FT.TT.TRANSACTION.ID>
    Y.TT.TXN.IDS = R.TXN<LN.FT.TT.FT.TRANSACTION.ID> ;*Manual R22 conversion, LN.FT.TT.TRANSACTION.ID chnaged to LN.FT.TT.FT.TRANSACTION.ID
    Y.CNT = DCOUNT(Y.TT.TXN.IDS,@VM)
    LOOP
    WHILE Y.CNT GT 0 DO
        Y.FLG += 1
        Y.TT.ID = Y.TT.TXN.IDS<1,Y.FLG>
        IF NOT(Y.TT.ID) THEN
            RETURN
        END
        CALL F.READ(FN.REDO.TEMP.WORK,Y.TT.ID,R.REDO.TEMP.WORK,F.REDO.TEMP.WORK,TEMP.ERR)
        IF NOT(R.REDO.TEMP.WORK) THEN
            CALL F.WRITE(FN.REDO.TEMP.WORK,Y.TT.ID,Y.CNCT.ID)
        END ELSE
            LOCATE Y.CNCT.ID IN R.REDO.TEMP.WORK SETTING POS ELSE
                R.REDO.TEMP.WORK<-1> = Y.CNCT.ID
                CALL F.WRITE(FN.REDO.TEMP.WORK,Y.TT.ID,R.REDO.TEMP.WORK)
            END
        END
        Y.CNT -= 1
    REPEAT


RETURN
END
