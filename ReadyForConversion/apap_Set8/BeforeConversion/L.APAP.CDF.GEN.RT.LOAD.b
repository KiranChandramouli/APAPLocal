*-----------------------------------------------------------------------------
* <Rating>-45</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CDF.GEN.RT.LOAD
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT TAM.BP I_F.REDO.CARD.RENEWAL
    *$INSERT ATM.BP I_F.ATM.REVERSAL
    $INSERT TAM.BP I_F.REDO.LY.POINTS
    $INSERT LAPAP.BP I.L.APAP.CDF.GEN.RT.COMMON
    $INSERT BP I_F.ST.COUNT.CDF.GEN.RT

    GOSUB INI
    *--GOSUB GET.ACCOUNTS
    RETURN

*****    
INI:
*****
    GOSUB OPEN.FILES
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
    Y.CAN.RUN    = "SI"

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

    Y.PA = " START.DATE: " : Y.START.DATE : " END.DATE: " : Y.END.DATE
    CALL OCOMO("PROCESS STARTED WITH PERIOD " : "CDF" : Y.ANIO.ACTUAL.FMT : Y.MES.ACTUAL : Y.PA)
    
    GOSUB DO.RUN.VALIDATE

    RETURN

***********
OPEN.FILES:
***********
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

    FN.CDF   = "FBNK.ST.L.APAP.CDF.LOG"
    FV.CDF   = ""
    R.CDF   = ""
    CDF.ERR  = ""
    CALL OPF(FN.CDF,FV.CDF)

    *--FN.COUNT = "F.ST.COUNT.CDF.GEN.RT"
    *--FV.COUNT = ""
    *--R.COUNT = ""
    *--ERR.COUNT = ""
    *--CALL OPF(FN.COUNT,FV.COUNT)

    FN.COUNT = "F.LAPAP.LOG.TC"
    FV.COUNT = ""
    *--R.COUNT = ""
    *--ERR.COUNT = ""
    CALL OPF(FN.COUNT,FV.COUNT)

    
   *-- CALL F.DELETE(FN.COUNT, REC.SEND)
    
    RETURN

*************
*GET.ACCOUNTS:
*************
*    IF Y.CAN.RUN EQ "SI" THEN
*        SEL.ACC.CMD = "SELECT " : FN.ACC : " WITH CATEGORY EQ 6021"
*        CALL EB.READLIST(SEL.ACC.CMD,SEL.ACC.LIST,"",NO.OF.RECS.ACC,SEL.ACC.ERROR)

*        LOOP REMOVE Y.ACC.ID FROM SEL.ACC.LIST SETTING ACC.POS
*        WHILE Y.ACC.ID DO
*            CALL F.READ(FN.ACC,Y.ACC.ID,R.ACC,FV.ACC,ACC.ERR)

*            IF R.ACC NE '' THEN
*                Y.CUSTOMER    = R.ACC<AC.CUSTOMER>
*                Y.CARD.RENEWAL.ID  = Y.CUSTOMER : "-" :  Y.ACC.ID
*               Y.CATEGORY    = R.ACC<AC.CATEGORY>
*                GOSUB GET.CARDS
*            END
*        REPEAT
*        GOSUB DO.LOG
*    END ELSE
*        CALL OCOMO("PROCESO EJECUTADO.")
*    END

*    RETURN

****************   
DO.RUN.VALIDATE:
****************
    Y.RUN.ID = "CDF" : Y.ANIO.ACTUAL.FMT : Y.MES.ACTUAL
    CALL F.READ(FN.CDF,Y.RUN.ID,R.CDF,FV.CDF,CDF.ERR)
    IF R.CDF NE '' THEN
        Y.CAN.RUN = "NO"
    END

    RETURN
END
