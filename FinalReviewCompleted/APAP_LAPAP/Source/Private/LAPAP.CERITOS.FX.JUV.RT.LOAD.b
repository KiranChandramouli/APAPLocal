* @ValidationCode : MjoyMTA1Njg2MTk1OkNwMTI1MjoxNjkwMTY3NTQwNTg0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:00
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
*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CERITOS.FX.JUV.RT.LOAD

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 20-JULY-2023      Harsha                R22 Auto Conversion  - FM to @FM  and SM to @SM 
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CARD.RENEWAL
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_LAPAP.CERITOS.FX.JUV.COMMON
    $INSERT I_F.ST.LAPAP.CDJ.LOG
    $INSERT I_F.REDO.H.REPORTS.PARAM
    
    GOSUB OPEN.FILES
    GOSUB DO.RUN.VALIDATE
    GOSUB INIT.REDO.H.REPORTS.PARAM
RETURN

OPEN.FILES:
    FN.ACC  = "FBNK.ACCOUNT"
    FV.ACC  = ""
    R.ACC  = ""
    ACC.ERR = ""
    CALL OPF(FN.ACC,FV.ACC)

    FN.CR  = "F.REDO.CARD.RENEWAL"
    FV.CR  = ""
    R.CR  = ""
    CR.ERR  = ""
    CALL OPF(FN.CR,FV.CR)

    FN.AR  = "F.ATM.REVERSAL"
    FV.AR  = ""
    R.AR  = ""
    AR.ERR  = ""
    CALL OPF(FN.AR,FV.AR)

    FN.LP  = "F.REDO.LY.POINTS"
    FV.LP  = ""
    R.LP  = ""
    LP.ERR  = ""
    CALL OPF(FN.LP,FV.LP)


    FN.CDJ = "FBNK.ST.LAPAP.CDJ.LOG"
    FV.CDJ = ""
    CALL OPF(FN.CDJ,FV.CDJ)

**----------------------------------Agregar nueva tabla
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
**------------------------------------------------------

    Y.CAN.RUN = 'SI'
    Y.FECHA.HOY     = TODAY
    Y.ANIO.ACTUAL    = Y.FECHA.HOY[1,4]
    Y.MES.ACTUAL    = Y.FECHA.HOY[5,2]
    Y.MES.ANTERIOR   = ''
    Y.ANIO.ACTUAL.FMT  = Y.ANIO.ACTUAL
    Y.MAX.DAY     = "31"
    Y.TOTAL.CARDS    = 0
    Y.TOTAL.TXN     = 0
    Y.TOTAL.CERITOS.GEN = 0
    Y.CERITOS.ACTUAL  = 0
    Y.VALOR.MON.ACTUAL  = 0
    Y.CERITOS.INT   = 0
    Y.CERITOS.MUL   = 0
    Y.CERITOS.MUL2   = 0
    Y.VALOR.MON.INT  = 0
    Y.VALOR.MON.MUL  = 0
    Y.VALOR.MON.MUL2  = 0
    BEGIN CASE
        CASE Y.MES.ACTUAL EQ "01"
            Y.MES.ANTERIOR  = "12"
            Y.MAX.DAY  = "31"
        CASE Y.MES.ACTUAL EQ "02"
            Y.MES.ANTERIOR  = "01"
            Y.MAX.DAY  = "31"
        CASE Y.MES.ACTUAL EQ "03"
            Y.MES.ANTERIOR  = "02"
            Y.MAX.DAY  = "28"
        CASE Y.MES.ACTUAL EQ "04"
            Y.MES.ANTERIOR  = "03"
            Y.MAX.DAY  = "31"
        CASE Y.MES.ACTUAL EQ "05"
            Y.MES.ANTERIOR  = "04"
            Y.MAX.DAY  = "30"
        CASE Y.MES.ACTUAL EQ "06"
            Y.MES.ANTERIOR  = "05"
            Y.MAX.DAY  = "31"
        CASE Y.MES.ACTUAL EQ "07"
            Y.MES.ANTERIOR  = "06"
            Y.MAX.DAY  = "30"
        CASE Y.MES.ACTUAL EQ "08"
            Y.MES.ANTERIOR  = "07"
            Y.MAX.DAY  = "31"
        CASE Y.MES.ACTUAL EQ "09"
            Y.MES.ANTERIOR  = "08"
            Y.MAX.DAY  = "31"
        CASE Y.MES.ACTUAL EQ "10"
            Y.MES.ANTERIOR  = "09"
            Y.MAX.DAY  = "30"
        CASE Y.MES.ACTUAL EQ "11"
            Y.MES.ANTERIOR  = "10"
            Y.MAX.DAY  = "31"
        CASE Y.MES.ACTUAL EQ "12"
            Y.MES.ANTERIOR  = "11"
            Y.MAX.DAY  = "30"
    END CASE
    IF Y.MES.ACTUAL EQ "01" AND Y.MES.ANTERIOR EQ "12" THEN
        Y.ANIO.ACTUAL.FMT  = Y.ANIO.ACTUAL - 1
    END
    Y.START.DATE    = Y.ANIO.ACTUAL.FMT : Y.MES.ANTERIOR : "01"
    Y.END.DATE     = Y.ANIO.ACTUAL.FMT : Y.MES.ANTERIOR : Y.MAX.DAY
RETURN

DO.RUN.VALIDATE:
    Y.RUN.ID = "CDJFX" : Y.ANIO.ACTUAL.FMT : Y.MES.ACTUAL
    CALL F.READ(FN.CDJ,Y.RUN.ID,R.CDJ,FV.CDJ,CDJ.ERR)
    IF R.CDJ NE '' THEN

        Y.CAN.RUN = "NO"
    END
RETURN

INIT.REDO.H.REPORTS.PARAM:
**********
    Y.REPORT.PARAM.ID = "FX.JUV.RT"
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.REPORT.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    END

    LOCATE "PCODE" IN Y.FIELD.NME.ARR<1,1> SETTING NME.POS THEN
        Y.REL.VAL.CODE = Y.FIELD.VAL.ARR<1,NME.POS>
    END
    Y.REL.VAL.CODE = CHANGE(Y.REL.VAL.CODE,@SM,@VM)
RETURN

END
