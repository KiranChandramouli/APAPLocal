* @ValidationCode : MjoyMDc0MjgzOTM0OkNwMTI1MjoxNjg5MzEwNzM5MzY4OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 10:28:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.CERITOS.FX.JUV.RT.POST
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts , Added call OfsGlobusManager
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CARD.RENEWAL
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_LAPAP.CERITOS.FX.JUV.COMMON
   $USING EB.TransactionControl

    GOSUB DO.LOG
RETURN

DO.LOG:

    Y.TRANS.ID.2  = "CDJFX" : Y.ANIO.ACTUAL.FMT : Y.MES.ACTUAL
    Y.APP.NAME.2  = "ST.LAPAP.CDJ.LOG"
    Y.VER.NAME.2  = Y.APP.NAME.2 :",IN"
    Y.FUNC.2   = "I"
    Y.PRO.VAL.2  = "PROCESS"
    Y.GTS.CONTROL.2 = ""
    Y.NO.OF.AUTH.2  = ""
    FINAL.OFS.2  = ""
    OPTIONS.2   = ""
    Y.CAN.NUM.2  = 0
    Y.CAN.MULT.2  = ""
    R.CDF.FIN   = ""
    R.CDF.FIN<1>  = Y.ANIO.ACTUAL.FMT : Y.MES.ACTUAL        ;*RUN.PERIOD
    R.CDF.FIN<2>  = Y.TOTAL.TXN         ;*TOTAL.TXNS
    R.CDF.FIN<3>  = Y.TOTAL.CARDS       ;*TOTAL.CARDS
    R.CDF.FIN<4>  = INT(Y.TOTAL.CERITOS.GEN)      ;*TOTAL.CERITOS.GEN
    CALL OCOMO("VALORES DEL LOG: " : R.CDF.FIN)
    CALL OFS.BUILD.RECORD(Y.APP.NAME.2,Y.FUNC.2,Y.PRO.VAL.2,Y.VER.NAME.2,Y.GTS.CONTROL.2,Y.NO.OF.AUTH.2,Y.TRANS.ID.2,R.CDF.FIN,FINAL.OFS.2)
    CALL OfsGlobusManager("DIARY.OFS", FINAL.OFS.2)		;*R22 Manual Conversion - Added call OfsGlobusManager
*    CALL JOURNAL.UPDATE(Y.TRANS.ID.2)
EB.TransactionControl.JournalUpdate(Y.TRANS.ID.2);* R22 UTILITY AUTO CONVERSION

RETURN
END
