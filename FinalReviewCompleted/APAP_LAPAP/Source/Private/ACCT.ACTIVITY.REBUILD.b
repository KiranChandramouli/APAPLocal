<<<<<<< Updated upstream
* @ValidationCode : MjotMTI2MjMwNjMwMDpDcDEyNTI6MTY5MDE5NDc5NDIyNjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 16:03:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
=======
* @ValidationCode : MjotMTA1MTc5NjM4MDpDcDEyNTI6MTY4NDIyMjc3MDU3MjpJVFNTOi0xOi0xOjE4Nzk6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1879
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   IF STATEMENT MODIFIED , J to J.VAR , K to K.VAR , CONVERT into CHANGE
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION CALL RTN FORMAT CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE ACCT.ACTIVITY.REBUILD
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.TABLE.CAPITALIS.CORR
    $INSERT I_F.ACCOUNT


    F.ACCT = 'F.ACCOUNT'
    FN.ACCT = ''
    CALL OPF(F.ACCT, FN.ACCT)

    F.ECB = 'F.EB.CONTRACT.BALANCES'
    FN.ECB = ''
    CALL OPF(F.ECB, FN.ECB)

    F.ACTIV = 'F.ACCT.ACTIVITY'
    FN.ACTIV = ''
    CALL OPF(F.ACTIV, FN.ACTIV)

    SEL.CMD = "" ; SEL.LIST = "" ; Y.NOR = "" ; Y.RET.CODE = ""
    Y.ACC.IDS = "" ; DIFF.AMTS = "" ; Y.CNT = ""

*SEL.CMD = "GET.LIST ACCT.LIST"
*CALL EB.READLIST(SEL.CMD,SEL.LIST,"",Y.NOR,Y.RET.CODE)

*    FN.SAVEDLISTS = '&SAVEDLISTS&'
*    F.SAVEDLISTS = ''
*    CALL OPF(FN.SAVEDLISTS,F.SAVEDLISTS)

    SEL.LIST = ''
*    READ SEL.LIST FROM F.SAVEDLISTS,'ACCT.LIST' ELSE
*      SEL.LIST = ''
*    END
    SEL.LIST = 'DOP1406100040017'
    IF SEL.LIST THEN
        LOOP
            REMOVE TEMP.ID FROM SEL.LIST SETTING POS
            ACC.ID = FIELD(TEMP.ID,"*",1)
        WHILE ACC.ID:POS
            GOSUB MAIN.PROCESS
        REPEAT
    END
RETURN

*************
MAIN.PROCESS:
*************


    R.ACCT = ''; R.ECB = ''; ACTIV.MNTHS = ''; ACCT.BAL = ''
    READU R.ACCT FROM FN.ACCT, ACC.ID ELSE
        R.ACCT = ''
        RELEASE FN.ACCT, ACC.ID
        CRT 'Account-':ACC.ID:'-missing'
        RETURN
    END

    READU R.ECB FROM FN.ECB, ACC.ID ELSE
        R.ECB = ''
        RELEASE FN.ACCT, ACC.ID
        RELEASE FN.ECB, ACC.ID
        CRT 'ECB-':ACC.ID:'-missing'
        RETURN
    END

    ACCT.BAL = R.ACCT<AC.ONLINE.ACTUAL.BAL>
    IF NOT(ACCT.BAL) THEN
        ACCT.BAL = 0
    END ;*R22 AUTO CODE CONVERSION

    CRT 'Processing account ':ACC.ID

    ACTIV.BAL = 0
    BALANCE.DATE = TODAY
    YBALANCE = ""
    CR.MVMT = ""
    DR.MVMT = ""
    ERR = ""
    CALL EB.GET.ACCT.BALANCE(ACC.ID, R.ACCT, "BOOKING", BALANCE.DATE, "", YBALANCE, CR.MVMT, DR.MVMT, ERR)
    ACTIV.BAL = YBALANCE
    IF NOT(ACTIV.BAL) THEN
        ACTIV.BAL = 0
    END


    CRT 'Rebuilding ACCT.ACTIVITY for account ':ACC.ID:' Balance in account = ':ACCT.BAL:' balance in activity = ':ACTIV.BAL
    ACTIV.MNTHS = R.ECB<ECB.ACTIVITY.MONTHS>
    BK.BAL = ACCT.BAL
    VALUE.BAL = ACCT.BAL
    CHANGE @VM TO @FM IN ACTIV.MNTHS ;*R22 AUOT CODE CONVERSION
    ACNT = DCOUNT(ACTIV.MNTHS, @FM)
    LAST.BK = ''; LAST.VAL = ''
    FOR J.VAR = ACNT TO 1 STEP -1
        ACTIV.ID = ACC.ID:'-':ACTIV.MNTHS<J.VAR> ;*R22 AUOT CODE CONVERSION
        R.ACTIV = ''
        READ R.ACTIV FROM FN.ACTIV, ACTIV.ID ELSE R.ACTIV = ''

        BCNT = DCOUNT(R.ACTIV<IC.ACT.BK.DAY.NO>, @VM)
        FOR K.VAR = BCNT TO 1 STEP -1 ;*R22 AUOT CODE CONVERSION
            R.ACTIV<IC.ACT.BK.BALANCE, K.VAR> = BK.BAL
            BK.BAL = BK.BAL - R.ACTIV<IC.ACT.BK.CREDIT.MVMT, K.VAR> - R.ACTIV<IC.ACT.BK.DEBIT.MVMT, K.VAR>
            LAST.BK = ACTIV.MNTHS<J.VAR>
        NEXT K.VAR

        VCNT = DCOUNT(R.ACTIV<IC.ACT.DAY.NO>, @VM)
        FOR K.VAR = VCNT TO 1 STEP -1
            R.ACTIV<IC.ACT.BALANCE, K.VAR> = VALUE.BAL
            VALUE.BAL = VALUE.BAL - R.ACTIV<IC.ACT.TURNOVER.CREDIT, K.VAR> - R.ACTIV<IC.ACT.TURNOVER.DEBIT, K.VAR>
            LAST.VAL = ACTIV.MNTHS<J.VAR>
        NEXT K.VAR
        WRITE R.ACTIV TO FN.ACTIV, ACTIV.ID
    NEXT J.VAR

    IF LAST.BK THEN
        R.ACTIV = ''; ACTIV.ID = ACC.ID:'-':LAST.BK
        READ R.ACTIV FROM FN.ACTIV, ACTIV.ID ELSE R.ACTIV = ''
        BK.BAL = R.ACTIV<IC.ACT.BK.BALANCE, 1> - R.ACTIV<IC.ACT.BK.CREDIT.MVMT, 1> - R.ACTIV<IC.ACT.BK.DEBIT.MVMT, 1>
        IF BK.BAL GE 0 THEN
            R.ACTIV<IC.ACT.BK.CREDIT.MVMT, 1> += BK.BAL
        END ELSE
            R.ACTIV<IC.ACT.BK.DEBIT.MVMT, 1> += BK.BAL
        END
        WRITE R.ACTIV TO FN.ACTIV, ACTIV.ID
    END

    IF LAST.VAL THEN
        R.ACTIV = ''; ACTIV.ID = ACC.ID:'-':LAST.VAL
        READ R.ACTIV FROM FN.ACTIV, ACTIV.ID ELSE R.ACTIV = ''
        VALUE.BAL = R.ACTIV<IC.ACT.BALANCE, 1> - R.ACTIV<IC.ACT.TURNOVER.CREDIT, 1> - R.ACTIV<IC.ACT.TURNOVER.DEBIT, 1>
        IF BK.BAL GE 0 THEN
            R.ACTIV<IC.ACT.TURNOVER.CREDIT, 1> += VALUE.BAL
        END ELSE
            R.ACTIV<IC.ACT.TURNOVER.DEBIT, 1> += VALUE.BAL
        END
        WRITE R.ACTIV TO FN.ACTIV, ACTIV.ID
    END

*APAP.LAPAP.ASP.REBUILD(ACC.ID)
    APAP.LAPAP.aspRebuild(ACC.ID);*R22 MANUAL CODE CONVERSION


    RELEASE FN.ACCT, ACC.ID
    RELEASE FN.ECB, ACC.ID

RETURN
END
