* @ValidationCode : MjotMTc3Nzg1NzAyMjpDcDEyNTI6MTcwMjk4ODM0MzU4NzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP ;*R22 Manual Code Conversion
SUBROUTINE DR.REG.TASAS.ACTIVAS.CONCAT(REC.ID)
*----------------------------------------------------------------------------
* Company Name   : APAP
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.TASAS.ACTIVAS.CONCAT
* Date           : 27-May-2013
*----------------------------------------------------------------------------
* Description:
*------------
* The Central Bank of the Dominican Republic requires that with a daily frequency  the Financial Institutions submit a summary report with
* the information about lending and deposit rates report of the prior working date
* This job is for Activas
*----------------------------------------------------------------------------
*
* Modification History :
*
* ----------------------
*   Date       Author              Modification Description
* 25-Jul-2014  Ashokkumar.V.P      PACS00305233:- Changed to consider all month as 30 days
* 09-Oct-2014  Ashokkumar.V.P      PACS00305233:- Added new Loan product. Added MM interest with Spread rate.
* 05-May-2015  Ashokkumar.V.P      PACS00305233:- Changed F.WRITE to WRITE
*
* Date                  Who                               Reference                                           Description
* ----                  ----                                ----                                                     ----
* 29-March-2023          Ajith Kumar                 R22 Manual code Conversion                            Package Name added APAP.AA
* 29-March-2023        Conversion Tool                              R22 Auto Code Conversion                       $INCLUDE change into $INSERT,VM to@VM ,FM to @ FM , <> to NE , > to GT
* 15-12-2023           Santosh C                   MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.CUSTOMER
*   $INSERT I_F.AA.ARRANGEMENT ;*R22 Manual Code Conversion_Utility Check
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.GROUP.DATE
*   $INSERT I_AA.APP.COMMON ;*R22 Manual Code Conversion_Utility Check
    $INSERT I_F.AA.PRODUCT.DESIGNER
    $INSERT I_AA.ID.COMPONENT
*   $INSERT I_F.AA.ACTIVITY.HISTORY ;*R22 Manual Code Conversion_Utility Check
*
    $INSERT I_DR.REG.TASAS.ACTIVAS.CONCAT.COMMON  ;*R22 Auto Code Conversion
    $INSERT I_F.DR.REG.ACTIVAS.GROUP               ;*R22 Auto Code Conversion
    $USING AA.Framework
*
    GOSUB PROCESS
RETURN
 
PROCESS:
*------*
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "SELECT.AA"
            R.AA.ARRANGEMENT = ''; AA.ARRANGEMENT.ERR = ''
*R22 Manual Code Conversion_Utility Check-Start
*          CALL F.READ(FN.AA.ARRANGEMENT,REC.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)
*           PROD.GRP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
*           YAA.PROD = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
*           CCY.VAL = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
*           CUS.ID = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
*           STRT.DATE = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
            
            R.AA.ARRANGEMENT = AA.Framework.Arrangement.Read(REC.ID, AA.ARRANGEMENT.ERR)
            PROD.GRP = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProductGroup>
            YAA.PROD = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrProduct>
            CCY.VAL = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrCurrency>
            CUS.ID = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrCustomer>
            STRT.DATE = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrStartDate>
*R22 Manual Code Conversion_Utility Check-End
            BANK.EMP.FLAG = 'NO'
            GOSUB EXCLUDE.BANK.EMP
            IF BANK.EMP.FLAG EQ 'NO' THEN
                GOSUB EVAL.PROD.INT.RATE
                GOSUB UPDATE.GROUPS
            END
        CASE CONTROL.LIST<1,1> EQ "SELECT.MM"
            CALL F.READ(FN.MM.MONEY.MARKET,REC.ID,R.MM.MONEY.MARKET,F.MM.MONEY.MARKET,MM.MONEY.MARKET.ERR)
            CUS.ID = R.MM.MONEY.MARKET<MM.CUSTOMER.ID>
            BANK.EMP.FLAG = 'NO'
            GOSUB EXCLUDE.BANK.EMP
            IF BANK.EMP.FLAG EQ 'NO' THEN
                VAL.DATE = R.MM.MONEY.MARKET<MM.VALUE.DATE>
                MM.MAT.DATE = R.MM.MONEY.MARKET<MM.MATURITY.DATE>
                YDATE = VAL.DATE
                YDATE1 = MM.MAT.DATE
                GOSUB DATE.30.CHK
                MM.TERM.IN.DAYS = ABS(Y.DAYS)
                MM.PRINC = R.MM.MONEY.MARKET<MM.PRINCIPAL>
                MM.CCY = R.MM.MONEY.MARKET<MM.CURRENCY>
                MM.RATE.TYPE = R.MM.MONEY.MARKET<MM.INT.RATE.TYPE>
                GOSUB MM.RATE.CHK
            END
    END CASE
RETURN

MM.RATE.CHK:
************
    INT.SPRD = 0
    BEGIN CASE
        CASE MM.RATE.TYPE EQ '1'
            MM.RATE = R.MM.MONEY.MARKET<MM.INTEREST.RATE>
            GOSUB UPDATE.GROUP7
        CASE MM.RATE.TYPE EQ '3'
            INT.KEY = R.MM.MONEY.MARKET<MM.INTEREST.KEY>
            INT.SPRD = R.MM.MONEY.MARKET<MM.INTEREST.SPREAD.1>
            GRP.DT.ID = INT.KEY:MM.CCY
            CALL F.READ(FN.GROUP.DATE,GRP.DT.ID,R.GROUP.DATE,F.GROUP.DATE,GROUP.DATE.ERR)
            GRP.CR.DATE = R.GROUP.DATE<AC.GRD.CREDIT.GROUP.DATE>
            BI.ID = INT.KEY:MM.CCY:GRP.CR.DATE
            CALL F.READ(FN.BASIC.INTEREST,BI.ID,R.BASIC.INTEREST,F.BASIC.INTEREST,BASIC.INTEREST.ERR)
            MM.RATE = R.BASIC.INTEREST<EB.BIN.INTEREST.RATE> + INT.SPRD
            GOSUB UPDATE.GROUP7
    END CASE
RETURN
*----------------------------------------------------------------------------
UPDATE.GROUP7:
*************
*
    R.DR.REG.ACTIVAS.GROUP = ''
    YACTIV.ID = 'GROUP7-':ARR.INT.RATE
    GOSUB READ.ACTIVAS.GRP
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB MM.WRITE.GROUP
    END ELSE
        GOSUB MM.NEW.WRITE.GROUP
    END
*
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.CONCAT.PASV
    END
RETURN

MM.WRITE.GROUP:
***************
*
    BEGIN CASE
        CASE MM.TERM.IN.DAYS LE MM.RANGE1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB1.LOANS> += 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB1.AMT> += MM.PRINC
        CASE MM.TERM.IN.DAYS GT MM.RANGE1 AND MM.TERM.IN.DAYS LE MM.RANGE2
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB2.LOANS> += 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB2.AMT> += MM.PRINC
        CASE MM.TERM.IN.DAYS GT MM.RANGE2 AND MM.TERM.IN.DAYS LE MM.RANGE3
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB3.LOANS> += 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB3.AMT> += MM.PRINC
        CASE MM.TERM.IN.DAYS GT MM.RANGE3
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB4.LOANS> += 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB4.AMT> += MM.PRINC
    END CASE
RETURN

MM.NEW.WRITE.GROUP:
******************
*
    BEGIN CASE
        CASE MM.TERM.IN.DAYS LE MM.RANGE1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB1.LOANS> = 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB1.AMT> = MM.PRINC
        CASE MM.TERM.IN.DAYS GT MM.RANGE1 AND MM.TERM.IN.DAYS LE MM.RANGE2
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB2.LOANS> = 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB2.AMT> = MM.PRINC
        CASE MM.TERM.IN.DAYS GT MM.RANGE2 AND MM.TERM.IN.DAYS LE MM.RANGE3
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB3.LOANS> = 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB3.AMT> = MM.PRINC
        CASE MM.TERM.IN.DAYS GT MM.RANGE3
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB4.LOANS> = 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB4.AMT> = MM.PRINC
    END CASE
RETURN

EXCLUDE.BANK.EMP:
*---------------*
    R.CUSTOMER = ''; CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    REL.CODES = ''
    REL.CODES = R.CUSTOMER<EB.CUS.RELATION.CODE>
    CHANGE @VM TO @FM IN REL.CODES ;*R22 Auto Code Conversion
    IF REL.CODES THEN
        CNT.REL.CODES = DCOUNT(REL.CODES,@FM) ;*R22 Auto Code Conversion
        CTR.REL.CODES = 1
        GOSUB CTR.REL.CODE.LOOP
    END ELSE
        BANK.EMP.FLAG = 'NO'
    END
RETURN

CTR.REL.CODE.LOOP:
******************
    LOOP
    WHILE CTR.REL.CODES LE CNT.REL.CODES
        REL.POS = ''
        LOCATE REL.CODES<CTR.REL.CODES> IN REL.CHK.LIST<1> SETTING REL.POS THEN
            CTR.REL.CODES = CNT.REL.CODES
            BANK.EMP.FLAG = "YES"
        END
        CTR.REL.CODES += 1
    REPEAT
RETURN

UPDATE.GROUPS:
*------------*
    GOSUB GET.INT.RATE
    IF NOT(ARR.INT.RATE) THEN
        RETURN
    END
    GOSUB GET.TERM.DAYS

    YST.FLG = 0
    BEGIN CASE
        CASE PROD.GRP EQ GRP1.VAL AND CCY.VAL EQ LCCY
            GOSUB GET.COMM.GRP
        CASE PROD.GRP EQ GRP2.VAL AND CCY.VAL EQ LCCY
            GOSUB GET.CONS.GRP
        CASE PROD.GRP EQ GRP3.VAL AND CCY.VAL EQ LCCY
            GOSUB UPDATE.GROUP3
            IF ARR.INT.RATE LT PROD.INT.RATE THEN
                GOSUB UPDATE.GROUP4
            END
        CASE PROD.GRP EQ GRP4.VAL AND CCY.VAL EQ LCCY
            PFM = '';PVM = ''; PSM = ''
            FINDSTR 'COM' IN YAA.PROD SETTING PFM,PVM,PSM THEN
                GOSUB GET.COMM.GRP
            END
            PFM = '';PVM = ''; PSM = ''
            FINDSTR 'CONS' IN YAA.PROD SETTING PFM,PVM,PSM THEN
                GOSUB GET.CONS.GRP
            END
        CASE CCY.VAL NE LCCY
            IF PROD.GRP EQ GRP4.VAL THEN
                GOSUB CREDIT.LOANS.CHK
            END
            IF PROD.GRP EQ GRP4.VAL AND YST.FLG NE 1 THEN
                RETURN
            END
            GOSUB UPDATE.GROUP.5.6
    END CASE
RETURN

CREDIT.LOANS.CHK:
*****************
    PFM = '';PVM = ''; PSM = ''
    FINDSTR 'COM' IN YAA.PROD SETTING PFM,PVM,PSM THEN
        YST.FLG = 1
    END
    PFM = '';PVM = ''; PSM = ''
    FINDSTR 'CONS' IN YAA.PROD SETTING PFM,PVM,PSM THEN
        YST.FLG = 1
    END
RETURN

GET.COMM.GRP:
*************
    GOSUB UPDATE.GROUP1
    IF ARR.INT.RATE LT PROD.INT.RATE THEN
        GOSUB UPDATE.GROUP4
    END
RETURN

GET.CONS.GRP:
*************
    GOSUB UPDATE.GROUP2
    IF ARR.INT.RATE LT PROD.INT.RATE THEN
        GOSUB UPDATE.GROUP4
    END
RETURN

GET.INT.RATE:
************
    ArrangementID = REC.ID
    idPropertyClass = ''
    idProperty = 'PRINCIPALINT'
    effectiveDate = ''
    returnIds = ''
    returnConditions = ''
    returnError = ''; ARR.INT.RATE = ''
*   CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError) ;*R22 Manual Code Conversion_Utility Check
    INT.REC = RAISE(returnConditions)
    ARR.INT.RATE = INT.REC<AA.INT.EFFECTIVE.RATE,1>
RETURN
*----------------------------------------------------------------------------
GET.TERM.DAYS:
*************

    YCONT.FLG = 0; YACTIVITY = ''
    ArrangementID = REC.ID
    effectiveDate = ''
    idPropertyClass = 'TERM.AMOUNT'
    idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''
*   CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError) ;*R22 Manual Code Conversion_Utility Check
    R.AA.TERM.AMOUNT = RAISE(returnConditions)
    TERM = R.AA.TERM.AMOUNT<AA.AMT.TERM>
    AMT.VAL = R.AA.TERM.AMOUNT<AA.AMT.AMOUNT>
    MAT.DATE = R.AA.TERM.AMOUNT<AA.AMT.MATURITY.DATE>

    Y.REGION = ''; Y.DAYS = 'C'
    IF MAT.DATE AND STRT.DATE THEN
        YDATE = STRT.DATE
        YDATE1 = MAT.DATE
        GOSUB DATE.30.CHK
        TERM.IN.DAYS = ABS(Y.DAYS)
    END
RETURN

UPDATE.GROUP2:
*------------*
*
    R.DR.REG.ACTIVAS.GROUP = ''
    YACTIV.ID = 'GROUP2-':ARR.INT.RATE
    GOSUB READ.ACTIVAS.GRP
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.GROUP
    END ELSE
        GOSUB NEW.WRITE.GROUP
    END
*
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.CONCAT.PASV
    END
RETURN
*----------------------------------------------------------------------------
WRITE.GROUP:
************
*

    BEGIN CASE
        CASE TERM.IN.DAYS LE RANGE1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB1.LOANS> += 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB1.AMT> += AMT.VAL
        CASE TERM.IN.DAYS GT RANGE1 AND TERM.IN.DAYS LE RANGE2
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB2.LOANS> += 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB2.AMT> += AMT.VAL
        CASE TERM.IN.DAYS GT RANGE2 AND TERM.IN.DAYS LE RANGE3
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB3.LOANS> += 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB3.AMT> += AMT.VAL
        CASE TERM.IN.DAYS GT RANGE3 AND TERM.IN.DAYS LE RANGE4
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB4.LOANS> += 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB4.AMT> += AMT.VAL
        CASE TERM.IN.DAYS GT RANGE4 AND TERM.IN.DAYS LE RANGE5
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB5.LOANS> += 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB5.AMT> += AMT.VAL
        CASE TERM.IN.DAYS GT RANGE5
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB6.LOANS> += 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB6.AMT> += AMT.VAL
    END CASE
RETURN
*----------------------------------------------------------------------------
NEW.WRITE.GROUP:
****************
*
    BEGIN CASE
        CASE TERM.IN.DAYS LE RANGE1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB1.LOANS> = 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB1.AMT> = AMT.VAL
        CASE TERM.IN.DAYS GT RANGE1 AND TERM.IN.DAYS LE RANGE2
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB2.LOANS> = 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB2.AMT> = AMT.VAL
        CASE TERM.IN.DAYS GT RANGE2 AND TERM.IN.DAYS LE RANGE3
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB3.LOANS> = 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB3.AMT> = AMT.VAL
        CASE TERM.IN.DAYS GT RANGE3 AND TERM.IN.DAYS LE RANGE4
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB4.LOANS> = 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB4.AMT> = AMT.VAL
        CASE TERM.IN.DAYS GT RANGE4 AND TERM.IN.DAYS LE RANGE5
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB5.LOANS> = 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB5.AMT> = AMT.VAL
        CASE TERM.IN.DAYS GT RANGE5
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB6.LOANS> = 1
            R.DR.REG.ACTIVAS.GROUP<DR.ACT.GRP.SUB6.AMT> = AMT.VAL
    END CASE
*
RETURN
*----------------------------------------------------------------------------
UPDATE.GROUP1:
*------------*
*
    R.DR.REG.ACTIVAS.GROUP = ''
    YACTIV.ID = 'GROUP1-':ARR.INT.RATE
    GOSUB READ.ACTIVAS.GRP
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.GROUP
    END ELSE
        GOSUB NEW.WRITE.GROUP
    END
*
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.CONCAT.PASV
    END
RETURN
*----------------------------------------------------------------------------
UPDATE.GROUP3:
*------------*
*
    R.DR.REG.ACTIVAS.GROUP = ''
    YACTIV.ID = 'GROUP3-':ARR.INT.RATE
    GOSUB READ.ACTIVAS.GRP
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.GROUP
    END ELSE
        GOSUB NEW.WRITE.GROUP
    END
*
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.CONCAT.PASV
    END
RETURN
*----------------------------------------------------------------------------
UPDATE.GROUP4:
*------------*
*
    R.DR.REG.ACTIVAS.GROUP = ''
    YACTIV.ID = 'GROUP4-':ARR.INT.RATE
    GOSUB READ.ACTIVAS.GRP
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.GROUP
    END ELSE
        GOSUB NEW.WRITE.GROUP
    END
*
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.CONCAT.PASV
    END
RETURN

UPDATE.GROUP5:
*------------*
*
    R.DR.REG.ACTIVAS.GROUP = ''
    YACTIV.ID = 'GROUP5-':ARR.INT.RATE
    GOSUB READ.ACTIVAS.GRP
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.GROUP
    END ELSE
        GOSUB NEW.WRITE.GROUP
    END
*
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.CONCAT.PASV
    END
RETURN

UPDATE.GROUP6:
*------------*
*
    R.DR.REG.ACTIVAS.GROUP = ''
    YACTIV.ID = 'GROUP6-':ARR.INT.RATE
    GOSUB READ.ACTIVAS.GRP
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.GROUP
    END ELSE
        GOSUB NEW.WRITE.GROUP
    END
*
    IF R.DR.REG.ACTIVAS.GROUP THEN
        GOSUB WRITE.CONCAT.PASV
    END
RETURN

READ.ACTIVAS.GRP:
*****************
    R.DR.REG.ACTIVAS.GROUP = ''; DR.REG.ACTIVAS.GROUP.ERR = ''
    CALL F.READ(FN.DR.REG.ACTIVAS.GROUP,YACTIV.ID,R.DR.REG.ACTIVAS.GROUP,F.DR.REG.ACTIVAS.GROUP,DR.REG.ACTIVAS.GROUP.ERR)
RETURN

WRITE.CONCAT.PASV:
******************
    WRITE R.DR.REG.ACTIVAS.GROUP ON F.DR.REG.ACTIVAS.GROUP, YACTIV.ID ON ERROR
        CALL OCOMO("Unable to write to the file":F.DR.REG.ACTIVAS.GROUP)
    END
RETURN

UPDATE.GROUP.5.6:
*---------------*
*
    IF ARR.INT.RATE GE PROD.INT.RATE THEN
        GOSUB UPDATE.GROUP5
    END ELSE
        GOSUB UPDATE.GROUP6
    END
RETURN
*----------------------------------------------------------------------------
EVAL.PROD.INT.RATE:
*-----------------*
    FIX.RATE = ''; MARGIN.OPR = ''; MARGIN.RATE = ''
*   PRODUCT.ID = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    PRODUCT.ID = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrProduct>  ;*R22 Manual Code Conversion_Utility Check
    SEL.CMD  =  "SELECT ":FN.AA.PRD.DES.INTEREST:" LIKE ":PRODUCT.ID:"-PRINCIPALINT-":CCY.VAL:"... BY-DSND @ID"
    LISTA.HDR = ''; NO.REC.HEADER = ''; RET.CODE = ''; R.AA.PRD.CAT.INTEREST = ''; YERR = ''
    CALL EB.READLIST(SEL.CMD, LISTA.HDR, '', NO.REC.HEADER, RET.CODE)
    REMOVE ID.RATE FROM LISTA.HDR SETTING POS
    CALL F.READ(FN.AA.PRD.DES.INTEREST,ID.RATE,R.AA.PRD.DES.INTEREST,F.AA.PRD.DES.INTEREST,YERR)
    FIX.RATE = R.AA.PRD.DES.INTEREST<AA.INT.FIXED.RATE>
    MARGIN.OPR = R.AA.PRD.DES.INTEREST<AA.INT.MARGIN.OPER>
    MARGIN.RATE = R.AA.PRD.DES.INTEREST<AA.INT.MARGIN.RATE>
*
    BEGIN CASE
        CASE MARGIN.OPR EQ 'ADD'
            PROD.INT.RATE = FIX.RATE + MARGIN.RATE
        CASE MARGIN.OPR EQ 'SUBTRACT'
            PROD.INT.RATE = FIX.RATE - MARGIN.RATE
        CASE 1
            PROD.INT.RATE = FIX.RATE
    END CASE
RETURN

DATE.30.CHK:
*************
    Y.NO.OF.MONTHS = 0; Y.MNTH = ''; YACT.MONTH = 0
    IF LEN(YDATE) NE 8 OR LEN(YDATE1) NE 8 THEN ;*R22 Auto Code Conversion
        Y.DAYS = 0
        RETURN
    END
    IF YDATE[1,4] GT YDATE1[1,4] THEN ;*R22 Auto Code Conversion
        TMP.YDATE1 = YDATE1
        TMP.YDATE = YDATE
        YDATE1 = TMP.YDATE
        YDATE = TMP.YDATE1
    END
    Y.GDAYS = 'C'
    CALL EB.NO.OF.MONTHS(YDATE,YDATE1,Y.NO.OF.MONTHS)
    Y.MNTH = Y.NO.OF.MONTHS:'M'
    CALL CALENDAR.DAY(YDATE,'+',Y.MNTH)
    CALL CDD('',Y.MNTH,YDATE1,Y.GDAYS)
    IF Y.NO.OF.MONTHS THEN
        YACT.MONTH = Y.NO.OF.MONTHS * 30
    END
    Y.DAYS =  YACT.MONTH + Y.GDAYS
RETURN
END
