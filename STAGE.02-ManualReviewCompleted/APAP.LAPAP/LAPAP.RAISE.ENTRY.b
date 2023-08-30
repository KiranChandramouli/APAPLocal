* @ValidationCode : MjotMTQwMDg1MTAzOTpDcDEyNTI6MTY4MjQwNDMwNjg5MDpJVFNTMTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 12:01:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
**==================================================================================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.RAISE.ENTRY
**==================================================================================================================================
* Reads the details from savedlists and raise entry by calling EB.ACCOUNTING
* We will multiply with -1 in the amount provided in the SL. So you have to give the actual available amount. We will pass the opposite entry for that
* Please make sure - AC.BALANCE.TYPE refered correctly and raising ENTRY

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                     REFERENCE           DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion       BP is removed in Insert File, = to EQ , ++ to +=
* 21-APR-2023    Narmadha V         R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.COMPANY
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.BALANCE.TYPE ;*R22 Auto conversion - END

**==================================================================================================================================
    COMO.DATE=TODAY
    COMO.TIME=TIME()
    COMO.NAME = "LAPAP.RAISE.ENTRY_":COMO.DATE:"_":COMO.TIME

    EXECUTE "COMO ON ":COMO.NAME

    GOSUB INITIALISE
    OUT.LIST<-1> = "ARR.ID*BALANCE.TYPE*ENTRY.AMT*ENTRY.ID"

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB UPDATE.LOG
    WRITE OUT.LIST TO F.SL,"CORR.ENTRIES_":COMO.DATE:"_":COMO.TIME
    EXECUTE 'COMO OFF'

* Call routine for closed loand
    CALL APAP.LAPAP.LAPAP.CLOSE.ARRANGEMENT

RETURN

**==================================================================================================================================
*==========
INITIALISE:
*==========
RETURN
**==================================================================================================================================
*=========
OPENFILES:
*=========

    FN.SAVEDLISTS = '&SAVEDLISTS&'
    F.SAVEDLISTS = ''
    CALL OPF(FN.SAVEDLISTS,F.SAVEDLISTS)

    FN.AA.ARR = 'F.AA.ARRANGEMENT'
    F.AA.ARR = ''
    CALL OPF(FN.AA.ARR,F.AA.ARR)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.CLOSURE = 'F.ACCOUNT.CLOSURE'
    F.ACCOUNT.CLOSURE = ''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.AC='F.ACCOUNT'
    F.AC=''
    CALL OPF(FN.AC,F.AC)

    FN.AC.HIS='F.ACCOUNT$HIS'
    F.AC.HIS=''
    CALL OPF(FN.AC.HIS,F.AC.HIS)

    FN.AC.ACT = 'F.ACCOUNT.ACT'
    FV.AC.ACT = ''
    CALL OPF(FN.AC.ACT, FV.AC.ACT)

    FN.AC.ENT.TODAY = 'F.ACCT.ENT.TODAY'
    FV.AC.ENT.TODAY = ''
    CALL OPF(FN.AC.ENT.TODAY, FV.AC.ENT.TODAY)

    AA.SEP = '#'
    FN.COMO='&COMO&'
    F.COMO=''
    CALL OPF(FN.COMO,F.COMO)

    FN.SL='&SAVEDLISTS&'
    F.SL=''
    CALL OPF(FN.SL,F.SL)

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FAILED = ''; PROCESSED = ''

    LIST.NAME = "AA.ADJ.CLEAR.BAL"

RETURN
**==================================================================================================================================
*=======
PROCESS:
*=======

    CALL F.READ(FN.SAVEDLISTS,LIST.NAME,ARR.IDS,F.SAVEDLISTS,RET.ERR)

    TEMP.REC = ARR.IDS

    LOOP
        REMOVE ARR.ID FROM ARR.IDS SETTING POS
    WHILE ARR.ID:POS
        OUT.LIST.BAL.TYPE = ''
        OUT.LIST.VALUE = ''
        TEMP.ERR = 0

*        CALL F.READ(FN.SL,LIST.NAME,TEMP.REC,F.SL,TEMP.SL.ERR)

        ENTRY = ""
        BASE.ENTRY = ""
        ENTRIES = ""

        CNT.ENTRY = DCOUNT(ARR.ID,'#')

        ARR.NO = FIELD(ARR.ID,'#',1,1)

        TXN.CODE = FIELD(ARR.NO,'*', 2)

        ARR.NO = FIELD(ARR.NO, '*', 1)

        IF NOT(TXN.CODE) THEN
            TXN.CODE = "851"
        END

        EXIT.FLAG = ''

        GOSUB CHECK.TXN.CODE
        IF NOT(EXIT.FLAG) THEN

            CALL F.READ(FN.AA.ARR,ARR.NO,R.ARRANGEMENT,F.AA.ARR,RET.ERR)
            ACC.NO = R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
            SAVE.ID.COMPANY = ID.COMPANY
            IF R.ARRANGEMENT THEN
                CALL LOAD.COMPANY(R.ARRANGEMENT<AA.ARR.CO.CODE>)
            END

            RET.ERR = '' ; DEL.REQ = ''

            IF NUM(ARR.NO) THEN
                ACC.NO = ARR.NO
            END

**CALL F.READ(FN.ACCOUNT,ACC.NO,R.ACCOUNT,F.ACCOUNT,RET.ERR)
            READ R.ACCOUNT FROM F.ACCOUNT, ACC.NO THEN
                RET.ERR = ""
            END ELSE
                RET.ERR = 1
            END


            IF NUM(ARR.NO) THEN
                CALL LOAD.COMPANY(R.ACCOUNT<AC.CO.CODE>)
            END

            IF RET.ERR THEN
                AC.ID = ACC.NO
                GOSUB COPY.ACCOUNT
**CALL F.READ(FN.ACCOUNT,ACC.NO,R.ACCOUNT,F.ACCOUNT,RET.ERR)

                IF RET.ERR NE "" THEN
                    READ R.ACCOUNT FROM F.ACCOUNT, ACC.NO THEN
                        RET.ERR = ""
                    END ELSE
                        RET.ERR = 1
                    END
                END

                IF RET.ERR EQ '' AND ACC.NO NE '' THEN
                    R.ACCOUNT<AC.CASH.POOL.GROUP> = ''
                    IF R.ACCOUNT<AC.ARRANGEMENT.ID> NE ARR.NO OR  R.ACCOUNT<AC.ARRANGEMENT.ID> EQ '' THEN
                        R.ACCOUNT<AC.ARRANGEMENT.ID> = ARR.NO
                    END
                    WRITE R.ACCOUNT TO F.ACCOUNT, ACC.NO
                END
                DEL.REQ = 1
            END


            ENTRY.SUM = 0

            FOR ENT.IDX = 2 TO CNT.ENTRY

                Y.ENTRY.DETS = FIELD(ARR.ID,'#',ENT.IDX,1)

                BAL.TYPE = FIELD(Y.ENTRY.DETS,'*',1,1)
                VALUE = FIELD(Y.ENTRY.DETS,'*',2,1)

                OUT.LIST.BAL.TYPE = BAL.TYPE:',':OUT.LIST.BAL.TYPE
                OUT.LIST.VALUE = VALUE:',':OUT.LIST.VALUE
                IS.CONTINGENT = 1
                CALL CACHE.READ("F.AC.BALANCE.TYPE", BAL.TYPE, BALANCE.RECORD, BAL.ERR)

                BEGIN CASE
                    CASE RIGHT(BAL.TYPE,2) EQ 'BL'
                    CASE BALANCE.RECORD<AC.BT.REPORTING.TYPE> EQ "CONTINGENT"
                    CASE 1
                        IS.CONTINGENT = ''
                END CASE
                IF NOT(IS.CONTINGENT) THEN
                    ENTRY.SUM += VALUE
                END

                GOSUB BASE.ENTRY
                GOSUB BUILD.ENTRIES
            NEXT ENT.IDX
            IF ENTRY.SUM EQ 0 THEN
                GOSUB POST.ENTRIES
                GOSUB UPDATE.SL
            END ELSE
                TEMP.ERR = "The sum of the entry amount in the Savedlists not equal to 0. ":ARR.ID
                GOSUB UPDATE.SL
            END

            IF DEL.REQ THEN
                GOSUB DELETE.ACCOUNT
                DEL.REQ = ''
            END

            CALL LOAD.COMPANY(SAVE.ID.COMPANY)
        END
    REPEAT
RETURN
**==================================================================================================================================
*==========
BASE.ENTRY:
*==========

    FCCY = ""
    IF R.ACCOUNT<AC.CURRENCY> NE LCCY THEN
        FCCY = 1
    END

    BASE.ENTRY = ""
    ENTRY = ""

    BASE.ENTRY<AC.STE.ACCOUNT.NUMBER> = ""
    BASE.ENTRY<AC.STE.COMPANY.CODE> = R.ACCOUNT<AC.CO.CODE>
    BASE.ENTRY<AC.STE.CURRENCY> = R.ACCOUNT<AC.CURRENCY>
    BASE.ENTRY<AC.STE.TRANSACTION.CODE> = 'COR'
    BASE.ENTRY<AC.STE.CUSTOMER.ID> = R.ACCOUNT<AC.CUSTOMER>
    BASE.ENTRY<AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT<AC.CATEGORY>
    BASE.ENTRY<AC.STE.ACCOUNT.OFFICER> = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    BASE.ENTRY<AC.STE.OUR.REFERENCE> = ARR.NO
    BASE.ENTRY<AC.STE.TRANS.REFERENCE> = "CORRECTION ":ARR.NO
    BASE.ENTRY<AC.STE.POSITION.TYPE> = "TR"
    BASE.ENTRY<AC.STE.SYSTEM.ID> = 'AA'
    BASE.ENTRY<AC.STE.CONTRACT.BAL.ID> = ACC.NO
    BASE.ENTRY<AC.STE.BOOKING.DATE> = TODAY
    BASE.ENTRY<AC.STE.VALUE.DATE> = TODAY
    BASE.ENTRY<AC.STE.CURRENCY.MARKET> = 1
    SYSTEM.ID = BASE.ENTRY<AC.STE.SYSTEM.ID>
    CRF.SYSTEM.ID = ""

RETURN
**==================================================================================================================================
*=============
BUILD.ENTRIES:
*=============

* CRF entry - asset type 1
    IF FCCY THEN
        BASE.ENTRY<AC.STE.AMOUNT.FCY> = VALUE * (-1)

        Y.RATE = ''
        Y.CCY = R.ACCOUNT<AC.CURRENCY>
        Y.MKT = ''
        Y.CORR.LCY.AMT = ''

        CALL MIDDLE.RATE.CONV.CHECK(VALUE, Y.CCY, Y.RATE, Y.MKT, Y.CORR.LCY.AMT, "", "")

        BASE.ENTRY<AC.STE.EXCHANGE.RATE> = Y.RATE
        BASE.ENTRY<AC.STE.AMOUNT.LCY> = Y.CORR.LCY.AMT* -1


    END ELSE
        BASE.ENTRY<AC.STE.AMOUNT.LCY> = VALUE * (-1)
    END

    ENTRY = BASE.ENTRY

    IF BALANCE.RECORD<AC.BT.ENTRY.TYPE> EQ 'STMT' THEN
        ENTRY<AC.STE.ACCOUNT.NUMBER> = ACC.NO
        ENTRY<AC.STE.TRANSACTION.CODE> = TXN.CODE
    END

    IF BAL.TYPE[1,2] EQ 'PL' THEN
        ENTRY<AC.STE.PL.CATEGORY> = BAL.TYPE[3,5]
        ENTRY<AC.STE.CUSTOMER.ID> = R.ACCOUNT<AC.CUSTOMER>
        ENTRY<AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT<AC.CATEGORY>
        ENTRY<AC.STE.ACCOUNT.NUMBER> = ""
        ENTRY<AC.STE.OUR.REFERENCE> = ACC.NO
        ENTRY<AC.STE.TRANSACTION.CODE> = TXN.CODE
    END ELSE
        YINT.ACC = ''
        CALL INT.ACC(BAL.TYPE , YINT.ACC)

        IF YINT.ACC OR NUM(BAL.TYPE) THEN
            ENTRY<AC.STE.ACCOUNT.NUMBER> = BAL.TYPE
            ENTRY<AC.STE.CRF.TXN.CODE> = ""
            ENTRY<AC.STE.CONSOL.KEY> = ""
            ENTRY<AC.STE.TRANSACTION.CODE> = TXN.CODE
        END ELSE
            ENTRY<AC.STE.CRF.TYPE> = BAL.TYPE     ;* from AA
            ENTRY<AC.STE.BALANCE.TYPE> = BAL.TYPE
        END

    END

    IF CRF.SYSTEM.ID THEN     ;* so that no consol ent today is written
        ENTRY<AC.STE.SYSTEM.ID> = CRF.SYSTEM.ID
    END

    ENTRIES<-1> = LOWER(ENTRY)

RETURN


RETURN
**==================================================================================================================================

POST.ENTRIES:
*============

    IF ENTRIES THEN

        V = 20
        APPLICATION = "AA.ARRANGEMENT.ACTIVITY"

        CALL EB.ACCOUNTING('AAA',"SAO",ENTRIES,"")

        ENT.ID = R.NEW(10)
        CALL JOURNAL.UPDATE("")

* CRT ARR.ID:"*":ENTRIES:"*":TEXT:"*":ETEXT:"*":R.NEW(V-10):"*":R.NEW(V-9)
        OUT.LIST<-1> = ARR.NO:"*":OUT.LIST.BAL.TYPE:"*":OUT.LIST.VALUE:"*":ENT.ID

    END

RETURN
**==================================================================================================================================

UPDATE.LOG:
*==========

    CRT @(1,10):DTEXT

    DTEXT = "   !!! Correction Completed !!! ."
    LOOP
        CRT @(1,12):DTEXT
        EXIT
    REPEAT

RETURN
**==================================================================================================================================

UPDATE.SL:

    DEL TEMP.REC<1>
    CALL F.WRITE(FN.SL,LIST.NAME,TEMP.REC)

    IF TEMP.ERR THEN
        FAILED<-1> = ARR.ID:"#":TEMP.ERR
        TEMP.ERR=0
    END ELSE
        PROCESSED <-1>= ARR.ID
    END

    PROCESS.ID = LIST.NAME:"_PROCESSED_":COMO.DATE:"_":COMO.TIME
    FAILED.ID = LIST.NAME:"_FAILED_"::COMO.DATE:"_":COMO.TIME

    CALL F.WRITE(FN.COMO,PROCESS.ID,PROCESSED)
    CALL F.WRITE(FN.COMO,FAILED.ID,FAILED)

    CALL JOURNAL.UPDATE('')

RETURN
**==================================================================================================================================
COPY.ACCOUNT:

** Replaced with EB.READ.HISTORY.REC for performance

    ACC.NO.HIS = AC.ID
    CALL EB.READ.HISTORY.REC(F.AC.HIS,ACC.NO.HIS,R.HIS.ACC,HIS.ERR)
    ACCOUNT.HIST.ID = ACC.NO.HIS

    EXECUTE 'COPY FROM ':FN.AC.HIS:' TO ':FN.AC:' "':ACCOUNT.HIST.ID:'",':AC.ID

RETURN
**==================================================================================================================================
DELETE.ACCOUNT:

    CALL F.DELETE(FN.AC,AC.ID)

    SEL.CMD = 'SELECT ':FN.AC.ACT:' WITH @ID LIKE ...':AC.ID:'...'
    CALL EB.READLIST(SEL.CMD,ACT.LIST,'','','')
    LOOP
        REMOVE ACT.ID FROM ACT.LIST SETTING ACT.POS
    WHILE ACT.ID : ACT.POS
        CALL F.DELETE(FN.AC.ACT, ACT.ID)
    REPEAT

    CALL F.DELETE(FN.AC.ENT.TODAY, AC.ID)

    CALL JOURNAL.UPDATE('')

RETURN

**==================================================================================================================================
CHECK.TXN.CODE:
*==============

    CALL CACHE.READ(FN.TRANSACTION, TXN.CODE, R.TRANS, RET.ERR) ;*R22 Auto conversion

    IF RET.ERR THEN

        CRT 'Invalid transaction code used for arrangement id :':ARR.NO:' (Correction entry wont get generated!!)'
        EXIT.FLAG = 1

    END

RETURN
