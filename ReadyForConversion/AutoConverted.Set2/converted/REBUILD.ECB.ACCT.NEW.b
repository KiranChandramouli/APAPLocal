SUBROUTINE REBUILD.ECB.ACCT.NEW
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.DATES
    $INSERT I_ACCT.COMMON
*   $INSERT I_F.STMT.ENTRY
    $INSERT I_F.STATIC.CHANGE.TODAY
    $INSERT I_F.CONSOL.UPDATE.WORK
    $INSERT I_F.CONSOLIDATE.ASST.LIAB

    EXECUTE "COMO ON REBUILD.ECB.ACCT.NEW"

    GOSUB OPEN.REQD.FILES
    SEL.LIST = 'DOP1406100040017'
    LOOP
        REMOVE ACC.ID FROM SEL.LIST SETTING A.POS
    WHILE ACC.ID: A.POS
        GOSUB PROCESS.ACCOUNTS
    REPEAT

    EXECUTE "COMO OFF REBUILD.ECB.ACCT.NEW"

RETURN

******************
PROCESS.ACCOUNTS:
******************

    R.ACC = ''; R.AET = ''; ACCT.BAL = 0
    READU R.ACC FROM FN.ACCOUNT, ACC.ID ELSE R.ACC = ""
    READ R.AET FROM FN.AET, ACC.ID ELSE R.AET = ""
    ACCT.BAL = R.ACC<AC.OPEN.ACTUAL.BAL>
    IF NOT(ACCT.BAL) THEN
        ACCT.BAL = 0
    END

    CCY = R.ACC<AC.CURRENCY>
    CO.CODE = R.ACC<AC.CO.CODE>
    PRODUCT.CAT = R.ACC<AC.CATEGORY>

    R.ECB = ''; OLD.OPEN.ASST = ''
    READU R.ECB FROM FN.EB.CONTRACT.BALANCES, ACC.ID ELSE R.ECB = ''
    IF NOT(R.ECB) THEN
        CRT "Missing EB.CONTRACT.BALANCES record ":ACC.ID
        RELEASE FN.EB.CONTRACT.BALANCES, ACC.ID
        RELEASE FN.ACCOUNT, ACC.ID
        RETURN
    END

    Y.COUNT = DCOUNT(R.ECB<ECB.TYPE.SYSDATE>, @VM)
    AET.CNT = DCOUNT(R.AET, @FM)

******** Clear multi-value other than accruals ********
    OPEN.BAL = 0; OLD.OPEN.BAL = 0; OLD.OPEN.ASST = R.ECB<ECB.OPEN.ASSET.TYPE>
    FOR I.VAR = 1 TO Y.COUNT
        Y.TYPE = R.ECB<ECB.CURR.ASSET.TYPE, I.VAR>
        ASST.TYPE = FIELD(R.ECB<ECB.TYPE.SYSDATE, I.VAR>, '-', 1)
        TYPE.DATE = FIELD(R.ECB<ECB.TYPE.SYSDATE, I.VAR>, '-', 2)
        IF NOT(NUM(ASST.TYPE[1,5])) AND ASST.TYPE[2] NE 'BL' AND ASST.TYPE[1,4] NE 'CONT' THEN
            IF TYPE.DATE LT TODAY OR NOT(TYPE.DATE) THEN
                OLD.OPEN.BAL = OLD.OPEN.BAL + R.ECB<ECB.OPEN.BALANCE, I.VAR> + R.ECB<ECB.CREDIT.MVMT, I.VAR> + R.ECB<ECB.DEBIT.MVMT, I.VAR>
            END
        END
    NEXT I.VAR

    CRT 'Account ':ACC.ID:' Balance in ECB = ':OLD.OPEN.BAL:' account = ':ACCT.BAL

    OPEN.BAL = ACCT.BAL
    IF NOT(OPEN.BAL) THEN
        OPEN.BAL = 0
    END

    FOR I.VAR = 1 TO Y.COUNT
        Y.TYPE = R.ECB<ECB.CURR.ASSET.TYPE, I.VAR>
        ASST.TYPE = FIELD(R.ECB<ECB.TYPE.SYSDATE, I.VAR>, '-', 1)
        ASST.TYPE = ASST.TYPE[1,5]
        TYPE.DATE = FIELD(R.ECB<ECB.TYPE.SYSDATE, I.VAR>, '-', 2)
        IF NOT(NUM(ASST.TYPE)) THEN
            DEL R.ECB<ECB.TYPE.SYSDATE, I.VAR>
            DEL R.ECB<ECB.VALUE.DATE, I.VAR>
            DEL R.ECB<ECB.MAT.DATE, I.VAR>
            DEL R.ECB<ECB.OPEN.BALANCE, I.VAR>
            DEL R.ECB<ECB.OPEN.BAL.LCL, I.VAR>
            DEL R.ECB<ECB.CREDIT.MVMT, I.VAR>
            DEL R.ECB<ECB.CR.MVMT.LCL, I.VAR>
            DEL R.ECB<ECB.DEBIT.MVMT, I.VAR>
            DEL R.ECB<ECB.DB.MVMT.LCL, I.VAR>
            DEL R.ECB<ECB.NAU.MVMT, I.VAR>
            DEL R.ECB<ECB.NAU.TXN.ID, I.VAR>
            DEL R.ECB<ECB.CURR.ASSET.TYPE, I.VAR>
            I.VAR -= 1
            Y.COUNT -= 1
        END
    NEXT I.VAR

    CONSOL.KEY = R.ECB<ECB.CONSOL.KEY>
    OPEN.TYPE = R.ECB<ECB.OPEN.ASSET.TYPE>
    PREV.ASST.TYPE = OPEN.TYPE
    NEW.ASST.TYPE = OPEN.TYPE
    R.ECB<ECB.CURRENCY> = CCY
    R.ECB<ECB.CO.CODE> = CO.CODE
    R.ECB<ECB.DATE.LAST.UPDATE> = TODAY
    R.ECB<ECB.POSS.SIGN.CHANGE> = ""    ;* Flag will be set while processing ACCT.ENT.TODAY entries
    R.ECB<ECB.PRODUCT> = "AC"
    R.ECB<ECB.APPLICATION> = "ACCOUNT"

    IF OPEN.TYPE[1,3] EQ "NIL" THEN
        CRT "New account with NILOPEN type"
        RELEASE FN.EB.CONTRACT.BALANCES, ACC.ID
        RELEASE FN.ACCOUNT, ACC.ID
        RETURN
    END

    DELETE FN.SCT, ACC.ID     ;* Clear STATIC.CHANGE.TODAY will be built if required

******** Build multi-value for open balance ********

    IF OPEN.BAL NE '' THEN
        BEGIN CASE
            CASE OPEN.BAL GT 0
                CALL AC.DETERMINE.INIT.ASSET.TYPE(ACC.ID, R.ACC, CHK.TYPE, OPEN.BAL)
                R.ECB<ECB.OPEN.ASSET.TYPE> = CHK.TYPE
            CASE OPEN.BAL LT 0
                CALL AC.DETERMINE.INIT.ASSET.TYPE(ACC.ID, R.ACC, CHK.TYPE, OPEN.BAL)
                R.ECB<ECB.OPEN.ASSET.TYPE> = CHK.TYPE
            CASE OTHERWISE
                R.ECB<ECB.OPEN.ASSET.TYPE> = OPEN.TYPE
        END CASE

        OPEN.TYPE = R.ECB<ECB.OPEN.ASSET.TYPE>
        NEW.ASST.TYPE = OPEN.TYPE
        MVMT = OPEN.BAL
        M.POS = 1
        INS OPEN.TYPE BEFORE R.ECB<ECB.TYPE.SYSDATE, M.POS>
        INS "" BEFORE R.ECB<ECB.VALUE.DATE, M.POS>
        INS "" BEFORE R.ECB<ECB.MAT.DATE, M.POS>
        INS OPEN.BAL BEFORE R.ECB<ECB.OPEN.BALANCE, M.POS>
        INS "" BEFORE R.ECB<ECB.OPEN.BAL.LCL, M.POS>
        INS "" BEFORE R.ECB<ECB.CREDIT.MVMT, M.POS>
        INS "" BEFORE R.ECB<ECB.CR.MVMT.LCL, M.POS>
        INS "" BEFORE R.ECB<ECB.DEBIT.MVMT, M.POS>
        INS "" BEFORE R.ECB<ECB.DB.MVMT.LCL, M.POS>
        INS "" BEFORE R.ECB<ECB.NAU.MVMT, M.POS>
        INS "" BEFORE R.ECB<ECB.NAU.TXN.ID, M.POS>
        INS OPEN.TYPE BEFORE R.ECB<ECB.CURR.ASSET.TYPE, M.POS>
    END

******** Build AET mvmts ********

    IF AET.CNT GE 1 THEN
        M.POS = ""; NEW.TYPE = ""
        NEW.TYPE = OPEN.TYPE :"-": TODAY
        LOCATE NEW.TYPE IN R.ECB<ECB.TYPE.SYSDATE, 1> SETTING M.POS ELSE NULL
        INS "" BEFORE R.ECB<ECB.TYPE.SYSDATE, M.POS>
        INS "" BEFORE R.ECB<ECB.VALUE.DATE, M.POS>
        INS "" BEFORE R.ECB<ECB.MAT.DATE, M.POS>
        INS "" BEFORE R.ECB<ECB.OPEN.BALANCE, M.POS>
        INS "" BEFORE R.ECB<ECB.OPEN.BAL.LCL, M.POS>
        INS "" BEFORE R.ECB<ECB.CREDIT.MVMT, M.POS>
        INS "" BEFORE R.ECB<ECB.CR.MVMT.LCL, M.POS>
        INS "" BEFORE R.ECB<ECB.DEBIT.MVMT, M.POS>
        INS "" BEFORE R.ECB<ECB.DB.MVMT.LCL, M.POS>
        INS "" BEFORE R.ECB<ECB.NAU.MVMT, M.POS>
        INS "" BEFORE R.ECB<ECB.NAU.TXN.ID, M.POS>
        INS OPEN.TYPE BEFORE R.ECB<ECB.CURR.ASSET.TYPE, M.POS>
        R.ECB<ECB.TYPE.SYSDATE, M.POS> = OPEN.TYPE :"-": TODAY
    END

    FOR J.VAR = 1 TO AET.CNT
        STMT.ID = ""; STMT.REC = ""; AMT = ""
        STMT.ID = R.AET<J.VAR>
        READ STMT.REC FROM FN.STMT.ENTRY, STMT.ID ELSE STMT.REC=""
        IF STMT.REC<AC.STE.AMOUNT.FCY> THEN
            AMT = STMT.REC<AC.STE.AMOUNT.FCY>
        END ELSE
            AMT = STMT.REC<AC.STE.AMOUNT.LCY>
        END

        IF AMT GT 0 THEN
            LOCAL.FIELD = RE.CUW.ASST.CREDIT.MVMT
            FOREIGN.FIELD = RE.CUW.ASST.CREDIT.LCY.MVMT
        END ELSE
            LOCAL.FIELD = RE.CUW.ASST.DEBIT.MVMT
            FOREIGN.FIELD = RE.CUW.ASST.DEBIT.LCY.MVMT
        END

        IF PREV.ASST.TYPE NE NEW.ASST.TYPE THEN
            ADD.ASST.TYPE = NEW.ASST.TYPE
            CUW.FCY.AMT = STMT.REC<AC.STE.AMOUNT.FCY>
            CUW.LCY.AMT = STMT.REC<AC.STE.AMOUNT.LCY>
            GOSUB REV.ADD.CUW.MVMTS
            ADD.ASST.TYPE = PREV.ASST.TYPE
            CUW.FCY.AMT = STMT.REC<AC.STE.AMOUNT.FCY> * -1
            CUW.LCY.AMT = STMT.REC<AC.STE.AMOUNT.LCY> * -1
            GOSUB REV.ADD.CUW.MVMTS
        END

        MVMT += AMT
        NET.AET.AMT += AMT
        IF AMT GE 0 THEN
            R.ECB<ECB.CREDIT.MVMT, M.POS> += AMT
        END ELSE
            R.ECB<ECB.DEBIT.MVMT, M.POS> += AMT
        END

        BEGIN CASE
            CASE MVMT GT 0
                GOSUB DETERMINE.CURR.TYPE
                R.ECB<ECB.CURR.ASSET.TYPE,M.POS> = CURR.TYPE
            CASE MVMT LT 0
                GOSUB DETERMINE.CURR.TYPE
                R.ECB<ECB.CURR.ASSET.TYPE,M.POS> = CURR.TYPE
            CASE OTHERWISE
                R.ECB<ECB.CURR.ASSET.TYPE,M.POS> = OPEN.TYPE
        END CASE

        SAV.APPL = APPLICATION
        APPLICATION = "FUNDS.TRANSFER"

        IF R.ACC<AC.CO.CODE> AND R.ECB<ECB.CONSOL.KEY> EQ '' THEN
            SAVE.COMPANY = ID.COMPANY
            IF R.ACC<AC.CO.CODE> NE ID.COMPANY THEN
                ID.COMPANY = R.ACC<AC.CO.CODE>
            END
            APP.ID = 'AC'
            CONSOL.APP.ABBREV = 'COND.APP'
            CONSOL.APP.FILES = ''
            CALL RE.APPLICATIONS(CONSOL.APP.ABBREV, CONSOL.APP.FILES)
            LOCATE APP.ID IN CONSOL.APP.ABBREV SETTING APOS THEN
                YCONSOL.APPS = RAISE(CONSOL.APP.FILES<2, APOS>)
            END
            YCONSOL.APP.IDS = ACC.ID
            CONSOL.APP.ID = APP.ID
            NEW.CONSOL.KEY = ''
            CALL EB.ALLOCATE.AL.KEY(CONSOL.APP.ID, YCONSOL.APPS, YCONSOL.APP.IDS, '', NEW.CONSOL.KEY, YERR)
            ID.COMPANY = SAVE.COMPANY
            R.ECB<ECB.CONSOL.KEY> = NEW.CONSOL.KEY
            CRT 'Consol key ':NEW.CONSOL.KEY:' set for account ':ACC.ID
            R.ECB<ECB.CO.CODE> = R.ACC<AC.CO.CODE>
            R.ECB<ECB.CURRENCY> = R.ACC<AC.CURRENCY>
            R.ECB<ECB.PRODUCT> = "AC"
            R.ECB<ECB.APPLICATION> = "ACCOUNT"
            R.ECB<ECB.CUSTOMER> = R.ACC<AC.CUSTOMER>

            IF NEW.CONSOL.KEY THEN
                YPARAMS = NEW.CONSOL.KEY:@FM:ACC.ID
                CALL RE.UPDATE.LINK.FILE(YPARAMS, "") ;* To build RE.CONSOL.WORK
            END
        END

        APPLICATION = SAV.APPL

        IF OPEN.TYPE NE R.ECB<ECB.CURR.ASSET.TYPE,M.POS> AND NOT(R.ECB<ECB.POSS.SIGN.CHANGE>) THEN
            R.ECB<ECB.POSS.SIGN.CHANGE> = "Y"
            STATIC.REC=""
            STATIC.REC<RE.SCT.SYSTEM.ID, 1>  = R.ECB<ECB.PRODUCT>
            STATIC.REC<RE.SCT.OLD.CONSOL.KEY,1> = R.ECB<ECB.CONSOL.KEY>         ;* To work with routines using previous format
            STATIC.REC<RE.SCT.NEW.CONSOL.KEY,1> = ""
            STATIC.REC<RE.SCT.TXN.REF,1> = ""
            STATIC.REC<RE.SCT.PRODUCT,1> = ""
            STATIC.REC<RE.SCT.CUSTOMER,1> = ""
            STATIC.REC<RE.SCT.CURRENCY,1> = ""
            STATIC.REC<RE.SCT.CURRENCY.MARKET,1> = ""
            STATIC.REC<RE.SCT.INTEREST.RATE,1> = ""
            STATIC.REC<RE.SCT.INTEREST.KEY,1> = ""
            STATIC.REC<RE.SCT.INTEREST.BASIS,1> = ""
            STATIC.REC<RE.SCT.CRF.TXN.CODE,1> = ""
            STATIC.REC<RE.SCT.OLD.PRODCAT,1> = PRODUCT.CAT
            STATIC.REC<RE.SCT.NEW.PRODCAT,1> = ""
            STATIC.REC<RE.SCT.OLD.TYPE,1,1> = ""
            STATIC.REC<RE.SCT.NEW.TYPE,1,1> = ""
            STATIC.REC<RE.SCT.OLD.DATE,1,1> = ""
            STATIC.REC<RE.SCT.NEW.DATE,1,1> = ""
            WRITE STATIC.REC TO FN.SCT, ACC.ID
        END         ;* Update Sgn flag and SCT
    NEXT J.VAR

    GOTO FINALISE

    IF OLD.OPEN.ASST NE NEW.ASST.TYPE THEN
        ADD.ASST.TYPE = OLD.OPEN.ASST
        CUW.LCY.AMT = OLD.OPEN.BAL * -1
        IF CUW.LCY.AMT GT 0 THEN
            LOCAL.FIELD = RE.CUW.ASST.CREDIT.MVMT
            FOREIGN.FIELD = RE.CUW.ASST.CREDIT.LCY.MVMT
        END ELSE
            LOCAL.FIELD = RE.CUW.ASST.DEBIT.MVMT
            FOREIGN.FIELD = RE.CUW.ASST.DEBIT.LCY.MVMT
        END
        GOSUB REV.ADD.CUW.MVMTS
        ADD.ASST.TYPE = NEW.ASST.TYPE
        CUW.LCY.AMT = OPEN.BAL
        IF CUW.LCY.AMT GT 0 THEN
            LOCAL.FIELD = RE.CUW.ASST.CREDIT.MVMT
            FOREIGN.FIELD = RE.CUW.ASST.CREDIT.LCY.MVMT
        END ELSE
            LOCAL.FIELD = RE.CUW.ASST.DEBIT.MVMT
            FOREIGN.FIELD = RE.CUW.ASST.DEBIT.LCY.MVMT
        END
        GOSUB REV.ADD.CUW.MVMTS
    END ELSE
        ADD.ASST.TYPE = OLD.OPEN.ASST
        CUW.LCY.AMT = OPEN.BAL - OLD.OPEN.BAL
        IF CUW.LCY.AMT GT 0 THEN
            LOCAL.FIELD = RE.CUW.ASST.CREDIT.MVMT
            FOREIGN.FIELD = RE.CUW.ASST.CREDIT.LCY.MVMT
        END ELSE
            LOCAL.FIELD = RE.CUW.ASST.DEBIT.MVMT
            FOREIGN.FIELD = RE.CUW.ASST.DEBIT.LCY.MVMT
        END
        GOSUB REV.ADD.CUW.MVMTS
    END

FINALISE:

    WRITE R.ECB TO FN.EB.CONTRACT.BALANCES, ACC.ID

    RELEASE FN.EB.CONTRACT.BALANCES, ACC.ID
    RELEASE FN.ACCOUNT, ACC.ID

RETURN

********************
DETERMINE.CURR.TYPE:
********************
    CURR.TYPE = ""
    IF MVMT GT 0 THEN
        BEGIN CASE
            CASE OPEN.TYPE EQ "CREDIT" OR OPEN.TYPE EQ "DEBIT"
                CURR.TYPE = "CREDIT"
            CASE OPEN.TYPE EQ "OFFSUSP"
                CURR.TYPE = "OFFSUSP"
            CASE OPEN.TYPE EQ "SUSPENS"
                CURR.TYPE = "SUSPENS"
            CASE OPEN.TYPE EQ "OFFCR" OR OPEN.TYPE EQ "OFFDB"
                CURR.TYPE = "OFFCR"
        END CASE
    END ELSE
        BEGIN CASE
            CASE OPEN.TYPE EQ "CREDIT" OR OPEN.TYPE EQ "DEBIT"
                CURR.TYPE = "DEBIT"
            CASE OPEN.TYPE EQ "OFFSUSP"
                CURR.TYPE = "OFFSUSP"
            CASE OPEN.TYPE EQ "SUSPENS"
                CURR.TYPE = "SUSPENS"
            CASE OPEN.TYPE EQ "OFFCR" OR OPEN.TYPE EQ "OFFDB"
                CURR.TYPE = "OFFDB"
        END CASE
    END
RETURN

******************
REV.ADD.CUW.MVMTS:
******************

    CUW.ID = CONSOL.KEY:'***':TODAY:'*':TERMNO
    R.CUW = ''; ASST.POS = ''
    READU R.CUW FROM FN.CUW, CUW.ID ELSE R.CUW = ''
    IF R.CUW EQ '' THEN       ;* Store basic info
        R.CUW<RE.CUW.CURRENCY> = CCY
        IF R.CUW<RE.CUW.CURRENCY> EQ "" THEN
            R.CUW<RE.CUW.CURRENCY> = LCCY
        END
    END
    LOCATE ADD.ASST.TYPE IN R.CUW<RE.CUW.ASSET.TYPE, 1> SETTING ASST.POS ELSE
        R.CUW<RE.CUW.ASSET.TYPE,ASST.POS> = ADD.ASST.TYPE
    END

    IF R.CUW<RE.CUW.CURRENCY> EQ LCCY THEN
        R.CUW<LOCAL.FIELD, ASST.POS, 1> += CUW.LCY.AMT
        CRT 'Creating adjustment in CUW ':CUW.ID:' asset = ':ADD.ASST.TYPE:' amount = ':CUW.LCY.AMT
    END ELSE
        R.CUW<LOCAL.FIELD, ASST.POS, 1> += CUW.FCY.AMT
        R.CUW<FOREIGN.FIELD, ASST.POS, 1> += CUW.LCY.AMT
        CRT 'Creating adjustment in CUW ':CUW.ID:' asset = ':ADD.ASST.TYPE:' amount = ':CUW.FCY.AMT:' lcy = ':CUW.LCY.AMT
    END
    WRITE R.CUW TO FN.CUW, CUW.ID

RETURN

****************
OPEN.REQD.FILES:
****************

    F.ACCOUNT = 'F.ACCOUNT'
    FN.ACCOUNT = ''
    CALL OPF(F.ACCOUNT, FN.ACCOUNT)

    F.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    FN.EB.CONTRACT.BALANCES = ''
    CALL OPF(F.EB.CONTRACT.BALANCES, FN.EB.CONTRACT.BALANCES)
    MNE.ID = F.ACCOUNT[2,3]

    F.ACCT.STMT.PRINT = 'F.ACCT.STMT.PRINT'
    FN.ACCT.STMT.PRINT = ''
    CALL OPF(F.ACCT.STMT.PRINT, FN.ACCT.STMT.PRINT)

    F.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
    FN.ACCT.ACTIVITY = ''
    CALL OPF(F.ACCT.ACTIVITY, FN.ACCT.ACTIVITY)

    F.STMT.PRINTED = 'F.STMT.PRINTED'
    FN.STMT.PRINTED = ''
    CALL OPF(F.STMT.PRINTED, FN.STMT.PRINTED)

    F.STMT.ENTRY = 'F.STMT.ENTRY'
    FN.STMT.ENTRY = ''
    CALL OPF(F.STMT.ENTRY, FN.STMT.ENTRY)

    F.CAL = 'F.CONSOLIDATE.ASST.LIAB'; FN.CAL = ''
    CALL OPF(F.CAL, FN.CAL)

    F.SL = '&SAVEDLISTS&'; FN.SL = ''
    OPEN F.SL TO FN.SL ELSE
        CRT 'Unable to open ':F.SL
        STOP
    END

    SEL.LIST = ''
    READ SEL.LIST FROM FN.SL,'PROBLEM.LIST' ELSE
        SEL.LIST = ''
    END

    F.AET = "F.ACCT.ENT.TODAY"
    FN.AET = ""
    CALL OPF(F.AET, FN.AET)

    F.SCT = "F.STATIC.CHANGE.TODAY"
    FN.SCT = ""
    CALL OPF(F.SCT, FN.SCT)

    F.RCC = "F.RE.CONSOL.CONTRACT"
    FN.RCC = ""
    CALL OPF(F.RCC, FN.RCC)

    F.RCC.SEQ = "F.RE.CONSOL.CONTRACT.SEQU"
    FN.RCC.SEQ = ""
    CALL OPF(F.RCC.SEQ, FN.RCC.SEQ)

    F.CUW = "F.CONSOL.UPDATE.WORK"
    FN.CUW = ""
    CALL OPF(F.CUW, FN.CUW)

    TERMNO = ABS(C$T24.SESSION.NO)

RETURN

END
