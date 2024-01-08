* @ValidationCode : MjotMTkzNDEwNTAxOTpVVEYtODoxNzA0NDUzNjA1OTI1OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 16:50:05
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.MM.TK.FIXED.LIST(Y.FINAL.ARRAY)
******************************************************************************
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : G.Sabari
*  ODR Number        : ODR-2010-08-0424
*  Program   Name    : REDO.NOFILE.MM.TK.FIXED.LIST
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : Y.FINAL.ARRAY
*-----------------------------------------------------------------------------
* DESCRIPTION       :This is a NOFILE enquiry routine to select MONEY MARKET
*                    records with CATEGORY EQ 21032

*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO                  REFERENCE            DESCRIPTION
*  16-Sep-2010     G.Sabari             ODR-2010-08-0424     INITIAL CREATION
*
*  23-Mar-2011     Krishna Murthy T.S   PACS00037719         Amended the logic for diffrence
*                                                            in Days calculation
*  31-May-2011     Shankar Raju         PACS00037719         Change in the history file status part
*  15-JUN-2011     RIYAS                PACS00037719         DATE CALCULATION
*  29-JUN-2011     RIYAS                PACS00037719         INTEREST RATE CALCULATION FOR FLOATING
*  10-APR-2012     Pradeep S            PACS00191157         Category validations
*
* 13-APR-2023     Conversion tool   R22 Auto conversion     VM to @VM, SM to @SM
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.DATES
    $INSERT I_F.LMM.ACCOUNT.BALANCES
    $INSERT I_F.REDO.MM.STATUS
    $INSERT I_F.REDO.CALL.LIST.CATEG
    $INSERT I_F.INTEREST.BASIS
    $INSERT I_F.BASIC.INTEREST
    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------
INITIALISE:
***********

    FN.MM = 'F.MM.MONEY.MARKET'
    F.MM = ''
    FN.ERR = ''
    FN.MM.HIS = 'F.MM.MONEY.MARKET$HIS'
    F.MM.HIS = ''
    FN.HIS.ERR = ''
    FN.CATEG = 'F.REDO.CALL.LIST.CATEG'
    F.CATEG = ''
    FN.INT.BASIS = 'F.INTEREST.BASIS'
    F.INT.BASIS = ''
    CALL OPF(FN.INT.BASIS,F.INT.BASIS)
    FN.CATEG.ERR = ''
    FN.BASIC.INTEREST = 'F.BASIC.INTEREST'
    F.BASIC.INTEREST= ''
    FN.LMM.ACCOUNT.BALANCES = 'F.LMM.ACCOUNT.BALANCES'
    F.LMM.ACCOUNT.BALANCES = ''
    FN.LMM.ACCOUNT.BALANCES.HIST = 'F.LMM.ACCOUNT.BALANCES.HIST'
    F.LMM.ACCOUNT.BALANCES.HIST = ''
    CALL OPF(FN.LMM.ACCOUNT.BALANCES.HIST,F.LMM.ACCOUNT.BALANCES.HIST)

    BI.ERR = ''
    SEL.CMD1 = ''
    SEL.CMD2 = ''
    SEL.ERR=''
    SEL.ERR2=''
    Z.ERR=''
    Y.FLAG = 'F'
    REGION.CODE = ''
    Y.DIFF = 'W'
    Y.MAT.VAL = ''
    Y.PRINCIPAL.VALUE = ''
    Y.COUNT.VAL = ''
    Y.BDY.AMT.PAID = ''
    Y.FINAL.LIST = ''
    Y.STAT.VAL = ''

RETURN
*-------------------------------------------------------------------------------
OPENFILES:
**********

    CALL OPF(FN.MM,F.MM)
    CALL OPF(FN.MM.HIS,F.MM.HIS)
    CALL OPF(FN.CATEG,F.CATEG)
    CALL OPF(FN.LMM.ACCOUNT.BALANCES,F.LMM.ACCOUNT.BALANCES)
RETURN
*-------------------------------------------------------------------------------
PROCESS:
********

*CALL CACHE.READ(FN.CATEG,'SYSTEM',R.CATEG,Y.CATEG.ERR)
    IDVAR.1 = 'SYSTEM' ;* R22 Utility Changes
    CALL CACHE.READ(FN.CATEG,IDVAR.1,R.CATEG,Y.CATEG.ERR);* R22 Utility Changes
    Y.DESC = R.CATEG<CALL.LIST.CATEG.DESCRIPTION>

    LOCATE 'TESN5' IN Y.DESC<1,1> SETTING Y.CAT.POS THEN
        Y.CATEGORY = R.CATEG<CALL.LIST.CATEG.CATEGORY,Y.CAT.POS>
        CHANGE @SM TO " " IN Y.CATEGORY      ;* PACS00191157 - S/E
    END

    GOSUB SEL.STMT.FORMATION

    SEL.CMD1 := " BY.DSND @ID"
    SEL.CMD2 := " BY.DSND @ID"

    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,"",NO.OF.REC1,SEL.ERR)
    CALL EB.READLIST(SEL.CMD2,SEL.LIST2,"",NO.OF.REC2,SEL.ERR2)

    IF SEL.LIST1 EQ '' THEN
        RETURN
    END

    IF Y.STAT.VAL EQ 'ALL' OR Y.STAT.VAL EQ '' OR Y.STAT.VAL EQ 'MATURED' OR Y.STAT.VAL EQ 'LIVE' THEN

        Y.HIS.LIST = FIELDS(SEL.LIST2,';',1)

        GOSUB LIVEFILE

        GOSUB HISFILE

        SEL.LIST =  Y.FINAL.LIST
    END

    IF Y.STAT.VAL EQ 'LIVE' THEN
        SEL.LIST = SEL.LIST1
    END

    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS
    WHILE Y.ID:POS
        Y.BDY.AMT.PAID = ''
        CALL F.READ(FN.MM,Y.ID,R.REC,F.MM,FN.ERR)

        IF R.REC THEN

            GOSUB BDY.DETAILS


*            Y.TODAY = TODAY
*PACS00037719 - START
*Added pre check conditions for CDD and Calculating only Calendar days
*            IF Y.BDY.VAL.DATE AND Y.TODAY THEN
*                Y.DIFF = 'C'
*                CALL CDD(REGION.CODE,Y.BDY.VAL.DATE,Y.TODAY,Y.DIFF)
*            END
*PACS00037719 - END
*           Y.DATES = Y.DIFF
            Y.BASE = R.REC<MM.INTEREST.BASIS>
            GOSUB CALC.BASE
            Y.BDY.TOT.INT.RATE = Y.BDY.INTEREST.RATE + Y.BDY.SPREAD
            Y.ACT.INT.RT = (Y.BDY.TOT.INT.RATE/100)/Y.BASE
*Y.BDY.INT.ACCRUED=Y.BDY.FACE.VALUE * Y.ACT.INT.RT * Y.BDY.DAYS
            GOSUB INT.RATE.CALC
            CALL EB.ROUND.AMOUNT(Y.CCY.VAL,Y.BDY.INT.ACCRUED,"","")

*IF Y.BDY.STATUS EQ 'MATURED' THEN
*END
            IF Y.BDY.DAYS LT 0 THEN
                Y.BDY.AMT.PAID = 0
            END ELSE
                Y.BDY.AMT.PAID=Y.BDY.FACE.VALUE + Y.BDY.INT.ACCRUED
            END

        END ELSE
            CALL F.READ(FN.MM.HIS,Y.ID,R.REC,F.MM.HIS,Z.ERR)
            FLAG.HIS = 1
            GOSUB BDY.DETAILS
            FLAG.HIS = ''
            Y.BDY.MM.ID = FIELD(Y.ID,';',1)
            IF R.REC<MM.RECORD.STATUS> EQ 'REVE' THEN
                CONTINUE
            END
            Y.ID = Y.BDY.MM.ID
            Y.BASE = R.REC<MM.INTEREST.BASIS>
            GOSUB CALC.BASE
            Y.BDY.TOT.INT.RATE = Y.BDY.INTEREST.RATE + Y.BDY.SPREAD
            Y.ACT.INT.RT = (Y.BDY.TOT.INT.RATE/100)/Y.BASE
*Y.BDY.INT.ACCRUED=Y.BDY.FACE.VALUE * Y.ACT.INT.RT * Y.BDY.DAYS
            GOSUB INT.RATE.CALC
            CALL EB.ROUND.AMOUNT(Y.CCY.VAL,Y.BDY.INT.ACCRUED,"","")

* IF Y.BDY.STATUS EQ 'MATURED' THEN
* END

            IF Y.BDY.DAYS LT 0 THEN
                Y.BDY.AMT.PAID = 0
            END ELSE
                Y.BDY.AMT.PAID = Y.BDY.FACE.VALUE + Y.BDY.INT.ACCRUED
            END

        END

        GOSUB HDR.DETS

        Y.FINAL.ARRAY<-1>= Y.BDY.MM.ID:"*":Y.BDY.CUSTOMER:"*":Y.BDY.VAL.DATE:"*":Y.BDY.MAT.DATE:"*":Y.BDY.FACE.VALUE:"*":Y.BDY.INTEREST.TYPE:"*":Y.BDY.INTEREST.RATE:"*":Y.BDY.SPREAD:"*":Y.BDY.TOT.INT.RATE:"*":Y.BDY.DAYS:"*":Y.BDY.STATUS:"*":Y.BDY.INT.ACCRUED:"*":Y.BDY.AMT.PAID:"*":Y.HDR.COUNTPTY:"*":Y.HDR.PRINCI:"*":Y.HDR.MAT:"*":Y.HDR.STATUS

    REPEAT

RETURN

*------------------------------------
INT.RATE.CALC:
*---------------
*New Section for rate Interest calculation

    Y.BDY.INT.ACCRUED = 0
    IF Y.DIFF GE 1 THEN
*Y.BDY.INT.ACCRUED = ( Y.BDY.FACE.VALUE*(Y.BDY.TOT.INT.RATE/100))* (Y.DIFF/Y.BASE)
        R.LMM.ACCOUNT.BALANCES = ''
        Y.LMM.ID = Y.ID:'00'
        CALL F.READ(FN.LMM.ACCOUNT.BALANCES,Y.LMM.ID,R.LMM.ACCOUNT.BALANCES,F.LMM.ACCOUNT.BALANCES,ERR.AC.BAL)
        GOSUB READ.LMM.REC
    END
*PACS00055015 - E

RETURN

READ.LMM.REC:
*-------------

    IF NOT(R.LMM.ACCOUNT.BALANCES) THEN
        CALL F.READ(FN.LMM.ACCOUNT.BALANCES.HIST,Y.LMM.ID,R.LMM.ACCOUNT.BALANCES,F.LMM.ACCOUNT.BALANCES.HIST,ERR.AC.BAL)
        IF R.LMM.ACCOUNT.BALANCES THEN
            GOSUB CALC.INT.ACC
        END
    END ELSE
        GOSUB CALC.INT.ACC
    END

RETURN

CALC.INT.ACC:
*--------------

*New Section for Flating rate Interest

    IF Y.BDY.MAT.DATE LT TODAY THEN
        Y.BDY.INT.ACCRUED = R.LMM.ACCOUNT.BALANCES<LD27.COMMITTED.INT>
    END ELSE
        Y.BDY.INT.ACCRUED = R.LMM.ACCOUNT.BALANCES<LD27.OUTS.CUR.ACC.I.PAY>
        IF NOT(Y.BDY.INT.ACCRUED) THEN
            Y.BDY.INT.ACCRUED = SUM(R.LMM.ACCOUNT.BALANCES<LD27.INT.AMT.TODATE>)
        END
    END
    IF Y.BDY.DAYS LT 0 THEN
        Y.BDY.INT.ACCRUED = 0
    END

RETURN

*-------------------------------------------------------------------------------
LIVEFILE:
*********

    LOOP
        REMOVE Y.MM.ID FROM SEL.LIST1 SETTING LIV.POS
    WHILE Y.MM.ID:LIV.POS

        LOCATE Y.MM.ID IN Y.HIS.LIST SETTING HI.POS THEN
            LOCATE Y.MM.ID IN Y.FINAL.LIST<1> SETTING FI.POS ELSE
                Y.FINAL.LIST<-1> = Y.MM.ID
            END
        END ELSE
            LOCATE Y.MM.ID IN Y.FINAL.LIST<1> SETTING FINAL.POS ELSE
                Y.FINAL.LIST<-1> = Y.MM.ID
            END
        END
    REPEAT

RETURN
*-------------------------------------------------------------------------------
HISFILE:
********

    LOOP
        REMOVE Y.HIS.MM.ID FROM Y.HIS.LIST SETTING HIS.POS
    WHILE Y.HIS.MM.ID:HIS.POS

        LOCATE Y.HIS.MM.ID IN SEL.LIST1<1> SETTING LI.POS THEN
            LOCATE Y.HIS.MM.ID IN Y.FINAL.LIST<1> SETTING FIN.POS ELSE
                Y.FINAL.LIST<-1> = Y.HIS.MM.ID
            END
        END ELSE
            CALL EB.READ.HISTORY.REC(F.MM.HIS,Y.HIS.MM.ID,R.REC,Y.ERR)
            LOCATE Y.HIS.MM.ID IN Y.FINAL.LIST<1> SETTING FIN.POS ELSE
                Y.FINAL.LIST<-1> = Y.HIS.MM.ID
            END
        END

    REPEAT

RETURN
*-------------------------------------------------------------------------------
SEL.STMT.FORMATION:
*******************

    LOCATE "CURRENCY" IN D.FIELDS<1> SETTING Y.CCY.POS THEN
        Y.CCY.VAL= D.RANGE.AND.VALUE<Y.CCY.POS>
    END

    LOCATE "INITIAL.DATE" IN D.FIELDS<1> SETTING Y.INIT.POS THEN
        Y.INIT.VAL= D.RANGE.AND.VALUE<Y.INIT.POS>
    END

    LOCATE "FINAL.DATE" IN D.FIELDS<1> SETTING Y.FIN.POS THEN
        Y.FINAL.VAL= D.RANGE.AND.VALUE<Y.FIN.POS>
    END

    LOCATE "STATUS" IN D.FIELDS<1> SETTING Y.STAT.POS THEN
        Y.STAT.VAL= D.RANGE.AND.VALUE<Y.STAT.POS>
        GOSUB FORM.SEL.CMD
    END

    IF Y.FLAG NE 'T' THEN
        SEL.CMD1 = "SELECT ":FN.MM:" WITH CATEGORY EQ ":Y.CATEGORY
        SEL.CMD1 := " AND CURRENCY EQ ":Y.CCY.VAL
        SEL.CMD1 := " AND VALUE.DATE GE ":Y.INIT.VAL
        SEL.CMD1 := " AND VALUE.DATE LE ":Y.FINAL.VAL

        SEL.CMD2 = "SELECT ":FN.MM.HIS:" WITH CATEGORY EQ ":Y.CATEGORY
        SEL.CMD2 := " AND CURRENCY EQ ":Y.CCY.VAL
        SEL.CMD2 := " AND VALUE.DATE GE ":Y.INIT.VAL
        SEL.CMD2 := " AND VALUE.DATE LE ":Y.FINAL.VAL
        SEL.CMD2 := " AND RECORD.STATUS NE REVE "
    END

    LOCATE "MATURITY.DATE" IN D.FIELDS<1> SETTING Y.MAT.POS THEN
        Y.MAT.VAL= D.RANGE.AND.VALUE<Y.MAT.POS>
        SEL.CMD1:=" AND MATURITY.DATE EQ ":Y.MAT.VAL
        SEL.CMD2:=" AND MATURITY.DATE EQ ":Y.MAT.VAL
    END

    LOCATE "CUSTOMER.ID" IN D.FIELDS<1> SETTING Y.COUNT.POS THEN
        Y.COUNT.VAL= D.RANGE.AND.VALUE<Y.COUNT.POS>
        SEL.CMD1:=" AND CUSTOMER.ID EQ ":Y.COUNT.VAL
        SEL.CMD2:=" AND CUSTOMER.ID EQ ":Y.COUNT.VAL
    END

    LOCATE "PRINCIPAL" IN D.FIELDS<1> SETTING Y.PRIN.POS THEN
        Y.OPERAND=D.LOGICAL.OPERANDS<Y.PRIN.POS>
        Y.PRINCIPAL.VALUE=D.RANGE.AND.VALUE<Y.PRIN.POS>
        GOSUB CHECK.OPERAND
    END

RETURN
*---------------------------------------------------------------------------------------------

BDY.DETAILS:
************
    Y.BDY.MM.ID = Y.ID
    Y.BDY.CUSTOMER=R.REC<MM.CUSTOMER.ID>
    Y.BDY.VAL.DATE=R.REC<MM.VALUE.DATE>
    Y.BDY.MAT.DATE=R.REC<MM.MATURITY.DATE>
    Y.BDY.FACE.VALUE=R.REC<MM.PRINCIPAL>
    Y.BDY.INTEREST.TYPE=R.REC<MM.INT.RATE.TYPE>
    Y.BDY.INTEREST.RATE=R.REC<MM.INTEREST.RATE>
*S-PACS00037719- 29-JUN
    Y.MM.CURRENCY = R.REC<MM.CURRENCY>
    Y.MM.INT.KEY = R.REC<MM.INTEREST.KEY>
    IF Y.BDY.INTEREST.RATE EQ '' THEN
        Y.BI.ID = Y.MM.INT.KEY:Y.MM.CURRENCY:TODAY
        CALL EB.GET.INTEREST.RATE(Y.BI.ID,BASIC.RATE)
        Y.BDY.INTEREST.RATE = BASIC.RATE
    END
*E-PACS00037719- 29-JUN
    Y.BDY.TOT.INT.RATE = ''
    CALL EB.ROUND.AMOUNT(Y.CCY.VAL,Y.BDY.INTEREST.RATE,"","")

    Y.BDY.SPREAD=R.REC<MM.INTEREST.SPREAD.1>
*PACS00037719 - START
*Added pre check conditions for CDD and Calculating only Calendar days
*    IF Y.BDY.VAL.DATE AND Y.BDY.MAT.DATE THEN
*        Y.DIFF = 'C'
*        CALL CDD(REGION.CODE,Y.BDY.VAL.DATE,Y.BDY.MAT.DATE,Y.DIFF)
*    END
*PACS00037719 - END
*    Y.BDY.DAYS=Y.DIFF
*PACS00037719 - START
    BEGIN CASE
        CASE LEN(Y.BDY.MAT.DATE) NE 8
            Y.DATE1 = Y.BDY.VAL.DATE
            Y.DATE2 = TODAY
            Y.BDY.STATUS = "LIVE"
        CASE Y.BDY.MAT.DATE GE TODAY
            Y.DATE1 = TODAY
            Y.DATE2 = Y.BDY.VAL.DATE
            Y.BDY.STATUS = "LIVE"
        CASE Y.BDY.MAT.DATE LT TODAY
            Y.DATE1 = Y.BDY.VAL.DATE
            Y.DATE2 = Y.BDY.MAT.DATE
            Y.BDY.STATUS = "MATURED"
    END CASE

    IF Y.DATE1 AND Y.DATE2 THEN
        Y.DIFF = 'C'
        CALL CDD(REGION.CODE,Y.DATE1,Y.DATE2,Y.DIFF)
* Y.DIFF = ABS(Y.DIFF)
    END


    IF Y.BDY.VAL.DATE GT TODAY THEN
        Y.DATE1 = Y.BDY.VAL.DATE
        Y.DATE2 = TODAY
        Y.BDY.STATUS = "LIVE"
        Y.DIFF = 'C'
        CALL CDD(REGION.CODE,Y.DATE1,Y.DATE2,Y.DIFF)
    END ELSE
        Y.DIFF = ABS(Y.DIFF)
    END

    Y.BDY.DAYS = Y.DIFF
*PACS00037719 - END
*    Y.STATUS=R.REC<MM.STATUS>
*    IF Y.STATUS EQ 'LIQ' OR FLAG.HIS EQ 1 THEN
*        Y.BDY.STATUS = "MATURED"
*    END ELSE
*        Y.BDY.STATUS = "LIVE"
*    END

RETURN

*-------------------------------------------------------------------------------
CALC.BASE:
*----------

    R.BASE = ''
    CALL CACHE.READ(FN.INT.BASIS, Y.BASE, R.BASE, BASIS.ERR) ;*R22 Auto conversion
    IF R.BASE THEN
        Y.BASE = R.BASE<IB.INT.BASIS>
        Y.BASE = FIELD(Y.BASE,"/",2)
    END

RETURN
*-------------------------------------------------------------------------------
CHECK.OPERAND:
**************

    BEGIN CASE

        CASE Y.OPERAND EQ '1'
            SEL.CMD1:=" AND PRINCIPAL EQ ":Y.PRINCIPAL.VALUE
            SEL.CMD2:=" AND PRINCIPAL EQ ":Y.PRINCIPAL.VALUE

        CASE Y.OPERAND EQ '3'
            SEL.CMD1:=" AND WITH PRINCIPAL LT ":Y.PRINCIPAL.VALUE
            SEL.CMD2:=" AND WITH PRINCIPAL LT ":Y.PRINCIPAL.VALUE

        CASE Y.OPERAND EQ '4'
            SEL.CMD1:=" AND WITH PRINCIPAL GT ":Y.PRINCIPAL.VALUE
            SEL.CMD2:=" AND WITH PRINCIPAL GT ":Y.PRINCIPAL.VALUE
    END CASE

RETURN
*-------------------------------------------------------------------------------
FORM.SEL.CMD:
*************

    IF Y.STAT.VAL EQ "LIVE" THEN
        SEL.CMD1 = "SELECT ":FN.MM:" WITH STATUS EQ CUR"
        SEL.CMD1 := " AND CATEGORY EQ ":Y.CATEGORY
        SEL.CMD1 := " AND CURRENCY EQ ":Y.CCY.VAL
        SEL.CMD1 := " AND VALUE.DATE GE  ":Y.INIT.VAL
        SEL.CMD1 := " AND VALUE.DATE LE  ":Y.FINAL.VAL
    END

    IF Y.STAT.VAL EQ "MATURED" THEN
        SEL.CMD1 = "SELECT ":FN.MM:" WITH STATUS EQ LIQ"
        SEL.CMD1 := " AND CURRENCY EQ ":Y.CCY.VAL
        SEL.CMD1 := " AND CATEGORY EQ ":Y.CATEGORY
        SEL.CMD1 := " AND VALUE.DATE GE ":Y.INIT.VAL
        SEL.CMD1 := " AND VALUE.DATE LE ":Y.FINAL.VAL

        SEL.CMD2 = "SELECT ":FN.MM.HIS:" WITH STATUS EQ LIQ"
        SEL.CMD2 := " AND CURRENCY EQ ":Y.CCY.VAL
        SEL.CMD2 := " AND CATEGORY EQ ":Y.CATEGORY
        SEL.CMD2 := " AND VALUE.DATE GE ":Y.INIT.VAL
        SEL.CMD2 := " AND VALUE.DATE LE ":Y.FINAL.VAL
    END

    IF Y.STAT.VAL EQ "ALL" THEN
        SEL.CMD1 = "SELECT ":FN.MM:" WITH CATEGORY EQ ":Y.CATEGORY
        SEL.CMD1 := " AND CURRENCY EQ ":Y.CCY.VAL
        SEL.CMD1 := " AND VALUE.DATE GE ":Y.INIT.VAL
        SEL.CMD1 := " AND VALUE.DATE LE ":Y.FINAL.VAL

        SEL.CMD2 = "SELECT ":FN.MM.HIS:" WITH CATEGORY ":Y.CATEGORY
        SEL.CMD2 := " AND CURRENCY EQ ":Y.CCY.VAL
        SEL.CMD2 := " AND VALUE.DATE GE ":Y.INIT.VAL
        SEL.CMD2 := " AND VALUE.DATE LE ":Y.FINAL.VAL
        SEL.CMD2 := " AND RECORD.STATUS NE REVE "
    END

    Y.FLAG = 'T'

RETURN
*-------------------------------------------------------------------------------
HDR.DETS:
*********

    IF Y.COUNT.VAL THEN
        Y.HDR.COUNTPTY = Y.COUNT.VAL
    END ELSE
        Y.HDR.COUNTPTY = 'ALL'
    END

    IF Y.PRINCIPAL.VALUE THEN
        Y.HDR.PRINCI = Y.PRINCIPAL.VALUE
    END ELSE
        Y.HDR.PRINCI = 'ALL'
    END

    IF Y.MAT.VAL THEN
        Y.HDR.MAT = Y.MAT.VAL
    END ELSE
        Y.HDR.MAT = 'ALL'
    END
    IF Y.STAT.VAL THEN
        Y.HDR.STATUS = Y.STAT.VAL
    END ELSE
        Y.HDR.STATUS = 'ALL'
    END
RETURN

END
