<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : Mjo1MDAyMDM4Mzk6Q3AxMjUyOjE2OTAxOTQ3OTgwMjI6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 16:03:18
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
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
$PACKAGE APAP.LAPAP
SUBROUTINE DR.REP.AC.INT.CALC(ACCT.ID,R.ACCOUNT,INT.RATE)
*----------------------------------------------------------------------------
* Company Name   : APAP
*----------------------------------------------------------------------------
* Description:
*------------
* The Interest rate calculation routine
*----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
*
* 01-Dec-2014  Ashokkumar.V.P      PACS00305233:- Fixed the saving account interest calculation bug.
<<<<<<< Updated upstream
<<<<<<< Updated upstream
* Date                  who                   Reference
=======
* Date                  who                   Reference              
>>>>>>> Stashed changes
=======
* Date                  who                   Reference              
>>>>>>> Stashed changes
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND VM TO @VM AND F.READ TO CACHE.READ AND REMOVED F.GROUP.CREDIT.INT AND F.BASIC.INTEREST AND F.GROUP.DATE
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.GROUP.DATE
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.PERIODIC.INTEREST
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.GROUP.CREDIT.INT
    $INSERT I_DAS.COMMON
    $INSERT I_DAS.BASIC.INTEREST

    GOSUB INIT
    GOSUB CALC.AC.INT.RATE
RETURN

CALC.AC.INT.RATE:
*****************
    LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    CR.MAR.OPR = ''; CR.MAR.RATE = ''; YG.CR.INT.RATE = ''; CR.BASIC.RTE = ''; CR.LIMIT.AMT = '';
    CR.INT.RATE = ''; YAC.CR.INT = ''; CNT.AC.CR.INT = 0; WORK.BAL = ''; AC.CR.INT = ''; GD.ID = ''; BI.ID = ''
    WORK.BAL = R.ACCOUNT<AC.WORKING.BALANCE>
    CCY.VAL = R.ACCOUNT<AC.CURRENCY>
    YAC.CR.INT = R.ACCOUNT<AC.ACCT.CREDIT.INT>
    CNT.AC.CR.INT = DCOUNT(YAC.CR.INT,@VM)
    AC.CR.INT = R.ACCOUNT<AC.ACCT.CREDIT.INT,CNT.AC.CR.INT>
    COND.GRP = R.ACCOUNT<AC.CONDITION.GROUP>

    IF AC.CR.INT THEN
        ACI.ID = ACCT.ID:'-':AC.CR.INT
        R.ACCOUNT.CREDIT.INT = ''; ACCOUNT.CREDIT.INT.ERR = ''; CR.BASIC.RTE = ''; YG.CR.INT.RATE = ''
        CALL F.READ(FN.ACCOUNT.CREDIT.INT,ACI.ID,R.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT,ACCOUNT.CREDIT.INT.ERR)
        CR.MAR.RATE = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.MARGIN.RATE,1>
        CR.MAR.OPR = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.MARGIN.OPER,1>
        YG.CR.INT.RATE = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.INT.RATE>
        CR.LIMIT.AMT = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.LIMIT.AMT>
        CR.BASIC.RTE = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.BASIC.RATE,1>
        IF YG.CR.INT.RATE THEN
            GOSUB CR.LMT.AMT
            GOSUB CR.INT.CASE
        END
        IF NOT(YG.CR.INT.RATE) AND CR.BASIC.RTE THEN
            KEY.PART = ''; BI.INT.RATE = ''
            KEY.PART = CR.BASIC.RTE:CCY.VAL:LAST.WORK.DAY
            CALL EB.GET.INTEREST.RATE(KEY.PART,BI.INT.RATE)
            GOSUB BI.INT.CASE
        END
        IF NOT(INT.RATE) THEN
            GOSUB SUB.PROCESS
        END
    END ELSE
        GOSUB SUB.PROCESS
    END
RETURN

SUB.PROCESS:
************
    GD.ID = COND.GRP:CCY.VAL
    GOSUB READ.GROUP.DTE
    GCI.ID = COND.GRP:CCY.VAL:GRP.CR.DATE
    R.GROUP.CREDIT.INT = ''; GROUP.CREDIT.INT.ERR = ''
    CALL CACHE.READ(FN.GROUP.CREDIT.INT, GCI.ID, R.GROUP.CREDIT.INT, GROUP.CREDIT.INT.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.GROUP.CREDIT.INT
    CR.MAR.OPR = R.GROUP.CREDIT.INT<IC.GCI.CR.MARGIN.OPER,1>
    CR.MAR.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.MARGIN.RATE,1>
    YG.CR.INT.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.INT.RATE>
    CR.BAS.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.BASIC.RATE,1>
    CR.LIMIT.AMT = R.GROUP.CREDIT.INT<IC.GCI.CR.LIMIT.AMT>
    IF YG.CR.INT.RATE THEN
        GOSUB CR.LMT.AMT
        GOSUB CR.INT.CASE
    END ELSE
        KEY.PART = ''; BI.INT.RATE = ''
        KEY.PART = CR.BAS.RATE:CCY.VAL:LAST.WORK.DAY
        CALL EB.GET.INTEREST.RATE(KEY.PART,BI.INT.RATE)
        GOSUB BI.INT.CASE
    END
RETURN

CR.LMT.AMT:
***********
    YCNT.INT.RATE = 0
    YCNT.INT.RATE = DCOUNT(YG.CR.INT.RATE,@VM)
    IF YCNT.INT.RATE EQ 1 THEN
        CR.INT.RATE = YG.CR.INT.RATE
        RETURN
    END
    YCNT = 0
    LOOP
    UNTIL YCNT EQ YCNT.INT.RATE
        YCNT+=1
        YT.CR.LIMIT.AMT = CR.LIMIT.AMT<1,YCNT>
        IF NOT(YT.CR.LIMIT.AMT) THEN
            CR.INT.RATE = YG.CR.INT.RATE<1,YCNT>
            CONTINUE
        END

        IF WORK.BAL LE YT.CR.LIMIT.AMT THEN
            CR.INT.RATE = ''
            CR.INT.RATE = YG.CR.INT.RATE<1,YCNT>
            YCNT = YCNT.INT.RATE
        END ELSE
            CONTINUE
        END
    REPEAT
RETURN

CR.INT.CASE:
************
    BEGIN CASE
        CASE CR.MAR.OPR EQ 'ADD'
            INT.RATE = CR.INT.RATE + CR.MAR.RATE
        CASE CR.MAR.OPR EQ 'SUBTRACT'
            INT.RATE = CR.INT.RATE - CR.MAR.RATE
        CASE 1
            INT.RATE = CR.INT.RATE
    END CASE
RETURN

BI.INT.CASE:
************
    BEGIN CASE
        CASE CR.MAR.OPR EQ 'ADD'
            INT.RATE = BI.INT.RATE + CR.MAR.RATE
        CASE CR.MAR.OPR EQ 'SUBTRACT'
            INT.RATE = BI.INT.RATE - CR.MAR.RATE
        CASE 1
            INT.RATE = BI.INT.RATE
    END CASE
RETURN

READ.GROUP.DTE:
***************
    R.GROUP.DATE = ''; GROUP.DATE.ERR = ''; GRP.INT.DATE = ''
    CALL CACHE.READ(FN.GROUP.DATE, GD.ID, R.GROUP.DATE, GROUP.DATE.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.GROUP.DATE
    GRP.CR.DATE = R.GROUP.DATE<AC.GRD.CREDIT.GROUP.DATE>
RETURN

READ.BASIC.INT:
***************
    R.BASIC.INTEREST = ''; BASIC.INTEREST.ERR = ''; BI.INT.RATE = ''
    CALL CACHE.READ(FN.BASIC.INTEREST, BI.ID, R.BASIC.INTEREST, BASIC.INTEREST.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.BASIC.INTEREST
    BI.INT.RATE = R.BASIC.INTEREST<EB.BIN.INTEREST.RATE>
RETURN

INIT:
*****
    FN.BASIC.INTEREST = 'F.BASIC.INTEREST' ; F.BASIC.INTEREST = ''
    FN.GROUP.DATE = 'F.GROUP.DATE' ; F.GROUP.DATE = ''
    FN.PERIODIC.INTEREST = 'F.PERIODIC.INTEREST'  ; F.PERIODIC.INTEREST = ''
    FN.ACCOUNT.CREDIT.INT = 'F.ACCOUNT.CREDIT.INT' ; F.ACCOUNT.CREDIT.INT = ''
    FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT' ; F.GROUP.CREDIT.INT = ''

    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)
    CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)
    CALL OPF(FN.PERIODIC.INTEREST,F.PERIODIC.INTEREST)
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)
    CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)
RETURN
END
