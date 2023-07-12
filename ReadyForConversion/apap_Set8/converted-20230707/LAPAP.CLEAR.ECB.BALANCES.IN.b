SUBROUTINE LAPAP.CLEAR.ECB.BALANCES.IN(ACC.ID)

*=====================================================================
* Routine is developed for BOAB client. This routine is used to do the below
* Its used to clear all available balances of AA account
* Update AA.SCHEDULED.ACTIVITY and AA.LENDING.NEXT.ACTIVITY
* PRODUCT.LINE - LENDING - Can modify as required for other lines
* Amount will parked in the Internal account enter by bank.
*======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AC.BALANCE.TYPE
    $INSERT I_F.AA.SCHEDULED.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.BALANCES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_LAPAP.CLEAR.ECB.BALANCES.IN.COMMON

    GOSUB PROCESS
RETURN

PROCESS:
*******
    AA.ID.POSITION = EREPLACE(ACC.ID,",",@FM)
    AA.ID = AA.ID.POSITION<1>
    GOSUB GET.ARRANGEMENT
    GOSUB CHECK.PROCESS.REQD
    IF DONT.PROCESS THEN
        RETURN
    END
    GOSUB UPDATE.ASA
    GOSUB CLEAR.ECB
    GOSUB UPDATE.BILLS
    GOSUB RAISE.ENTRY
    GOSUB WRITE.DATA
RETURN

*=====================================================================

GET.ARRANGEMENT:

    CALL F.READ(FN.AA, AA.ID, R.ARRANGEMENT, F.AA, AA.ERR)

    ARR.STATUS = R.ARRANGEMENT<AA.ARR.ARR.STATUS>

    AC.ID =  R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,1>
    PRODUCT.LINE = R.ARRANGEMENT<AA.ARR.PRODUCT.LINE>
    CO.CODE = R.ARRANGEMENT<AA.ARR.CO.CODE,1>

RETURN

*=====================================================================
CHECK.PROCESS.REQD:

    DONT.PROCESS = ""
    IF ARR.STATUS EQ "UNAUTH" THEN
        DONT.PROCESS = 1
    END ELSE
        R.AAM = ""; AAM.ERR = ""
        CALL F.READ(FN.AAM, AC.ID, R.AAM, F.AA, AAM.ERR)
        IF AAM.ERR THEN
            R.AAS = ""; AAS.ERR = ""
            CALL F.READ(FN.AAS, AA.ID, R.AAS, F.AAS, AAS.ERR)
            IF AAS.ERR THEN
            END ELSE
                DONT.PROCESS  = 1
            END
        END ELSE
            DON.PROCESS = 1
        END
    END
RETURN

*=====================================================================

UPDATE.ASA:

    ASA.ERR = ""; R.ASA = ""
    CALL F.READ(FN.ASA, AA.ID, R.ASA, F.ASA, ASA.ERR)
    IF NOT(ASA.ERR) THEN
        CNT.ACT = DCOUNT(R.ASA<AA.SCH.ACTIVITY.NAME>, @VM)
        FOR IDX = 1 TO CNT.ACT
            IF R.ASA<AA.SCH.NEXT.DATE ,IDX> THEN
                R.ASA<AA.SCH.LAST.DATE ,IDX> = R.ASA<AA.SCH.NEXT.DATE ,IDX>
                R.ASA<AA.SCH.NEXT.DATE ,IDX> = ""
            END
        NEXT IDX

        NEXT.ACT.ID = AA.ID:'-':R.ASA<AA.SCH.NEXT.RUN.DATE>
        NEXT.LEAST.DATE = ""
        R.ASA<AA.SCH.NEXT.RUN.DATE> = NEXT.LEAST.DATE

        CALL F.READ(FN.ANA, NEXT.ACT.ID, R.ANA, F.ANA, ANA.ERR)

        IF NOT(ANA.ERR) THEN
            CALL F.DELETE(FN.ANA, NEXT.ACT.ID)
            NEW.NEXT.ACT.ID = AA.ID:'-':NEXT.LEAST.DATE
            CALL F.WRITE(FN.ANA, NEW.NEXT.ACT.ID,  R.ANA)
        END
        CALL F.WRITE(FN.ASA, AA.ID, R.ASA)
    END

RETURN

*=====================================================================

UPDATE.BILLS:

    GOSUB GET.ACCOUNT.DETAILS
    IF NOT(AAD.ERR) THEN
        GOSUB UPDATE.AAD.BASICS
        GOSUB PROCESS.BILLS
        CALL F.WRITE(FN.AAD, AA.ID, R.AAD)
    END

RETURN

*=====================================================================

GET.ACCOUNT.DETAILS:

    R.AAD = ""; AAD.ERR = ""
    CALL F.READ(FN.AAD, AA.ID, R.AAD, F.AAD, AAD.ERR)

RETURN

*=====================================================================

UPDATE.AAD.BASICS:

    R.AAD<AA.AD.ARR.AGE.STATUS> = "CUR"
    R.AAD<AA.AD.SUSP.STATUS, 1> = "ACCRUE"
    R.AAD<AA.AD.SUSPENDED> = ""
    R.AAD<AA.AD.ALL.AGE.STATUS> = ""

RETURN

*=====================================================================

UPDATE.AAD.BILLS:

    R.AAD<AA.AD.BILL.STATUS, PAY.IDX, BILL.IDX> = BL.STATUS
    R.AAD<AA.AD.SET.STATUS, PAY.IDX, BILL.IDX> = SET.STATUS
    R.AAD<AA.AD.AGING.STATUS, PAY.IDX, BILL.IDX> = AGE.STATUS
    R.AAD<AA.AD.NXT.AGE.DATE, PAY.IDX, BILL.IDX> = ""
    R.AAD<AA.AD.CHASER.DATE, PAY.IDX, BILL.IDX> = ""

RETURN

*=====================================================================

PROCESS.BILLS:

    BILL.PAY.CNT = DCOUNT(R.AAD<AA.AD.BILL.PAY.DATE>, @VM)

    FOR PAY.IDX = 1 TO BILL.PAY.CNT
        BILL.CNT = DCOUNT(R.AAD<AA.AD.BILL.ID, PAY.IDX>, @SM)
        FOR BILL.IDX = 1 TO BILL.CNT
            BILL.ID = R.AAD<AA.AD.BILL.ID, PAY.IDX, BILL.IDX>
            GOSUB GET.BILL.RECORD
            IF NOT(ABD.ERR) THEN
                GOSUB CHECK.BILL.TYPE
                IF NOT(IGNORE.BILL) THEN
                    GOSUB UPDATE.AAD.BILLS
                    R.BILL.RECORD<AA.BD.OS.TOTAL.AMOUNT> = 0
                    PROPERTY.COUNT = DCOUNT(R.BILL.RECORD<AA.BD.PROPERTY>, @VM)
                    FOR PROPERTY.IDX = 1 TO PROPERTY.COUNT
                        R.BILL.RECORD<AA.BD.OS.PROP.AMOUNT, PROPERTY.IDX> = 0   ;*to overcome comparing 0 with NULL issue
                        R.BILL.RECORD<AA.BD.SUS.PROP.AMOUNT, PROPERTY.IDX> = 0  ;*to overcome comparing 0 with NULL issue
                    NEXT PROPERTY.IDX

                    PAY.PROP.CNT = DCOUNT(R.BILL.RECORD<AA.BD.PAY.PROPERTY, 1>, @SM)

                    FOR PAY.PROP.IDX = 1 TO PAY.PROP.CNT
                        R.BILL.RECORD<AA.BD.OS.PR.AMT, 1, PAY.PROP.IDX> = 0
                    NEXT PAY.PROP.IDX

                    INS BL.STATUS BEFORE R.BILL.RECORD<AA.BD.BILL.STATUS,1>
                    INS CHG.DATE BEFORE R.BILL.RECORD<AA.BD.BILL.ST.CHG.DT,1>
                    INS SET.STATUS BEFORE R.BILL.RECORD<AA.BD.SETTLE.STATUS,1>
                    INS CHG.DATE BEFORE R.BILL.RECORD<AA.BD.SET.ST.CHG.DT,1>
                    INS AGE.STATUS BEFORE R.BILL.RECORD<AA.BD.AGING.STATUS,1>
                    INS CHG.DATE BEFORE R.BILL.RECORD<AA.BD.AGING.ST.CHG.DT,1>

                    CALL F.WRITE(FN.ABD, BILL.ID, R.BILL.RECORD)
                END
            END
        NEXT BILL.IDX
    NEXT PAY.IDX

RETURN

*=====================================================================

GET.BILL.RECORD:

    R.BILL.RECORD = ""; ABD.ERR = ""
    CALL F.READ(FN.ABD, BILL.ID, R.BILL.RECORD, F.ABD, ABD.ERR)

RETURN

*=====================================================================

CHECK.BILL.TYPE:

    IGNORE.BILL = 1

    BEGIN CASE
        CASE R.AAD<AA.AD.BILL.TYPE,PAY.IDX,BILL.IDX> MATCHES "INFO"
        CASE R.AAD<AA.AD.BILL.STATUS,PAY.IDX,BILL.IDX> EQ "ISSUED"
        CASE R.AAD<AA.AD.BILL.STATUS,PAY.IDX,BILL.IDX> EQ "CANCELLED"
        CASE NOT(R.BILL.RECORD<AA.BD.OS.TOTAL.AMOUNT>)
        CASE 1
            IGNORE.BILL = ""
    END CASE

RETURN

*=====================================================================

CLEAR.ECB:

    ECB.RECORD = ""; ECB.ERR = ""; DIFF.ARR = ""; OPP.BAL.AMOUNT = 0

    CALL F.READ(FN.ECB, AC.ID, ECB.RECORD, F.ECB, ECB.ERR)
    IF NOT(ECB.ERR) THEN
        CALL AA.CONSOLIDATE.ECB.AMOUNTS(ECB.RECORD)         ;* Add the movements and the opening balance to arrive at the current balance

        TOTAL.BALANCES = DCOUNT(ECB.RECORD<ECB.CURR.ASSET.TYPE>,@VM)

        FOR BALANCE.TYPE.POS = 1 TO TOTAL.BALANCES
            BALANCE.TYPE = ECB.RECORD<ECB.TYPE.SYSDATE,BALANCE.TYPE.POS>
            REQD.BALANCE.TYPE = BALANCE.TYPE
            GOSUB GET.BALANCE.AMOUNT
            BALANCE.AMOUNT = RETURN.AMOUNT + 0
            IF BALANCE.AMOUNT THEN
                GOSUB GET.BALANCE.TYPE
                GOSUB CHECK.IGNORE.TYPES
                IF NOT(IGNORE.TYPE) THEN
                    GOSUB CHECK.BALANCE.TYPE
                    IF NOT(TABLE.ERROR) THEN
                        GOSUB RAISE.ENTRY
                    END
                END
            END
            IF BALANCE.TYPE.POS EQ TOTAL.BALANCES AND OPP.BAL.AMOUNT NE 0 THEN   ;* If its last balance type then need to add the opposite entry to internal account
                DIFF.ARR = DIFF.ARR:'#':Y.CUENTA.INTERNA:'*':OPP.BAL.AMOUNT*(-1)
            END
        NEXT BALANCE.TYPE.POS

        IF DIFF.ARR NE '' THEN
            UPDATE.STRING<-1> = DIFF.ARR
        END

    END
RETURN

*=====================================================================

GET.BALANCE.TYPE:

    TABLE.ERROR = ""
    CALL CACHE.READ("F.AC.BALANCE.TYPE", BALANCE.TYPE, BALANCE.RECORD, TABLE.ERROR)

RETURN

*=====================================================================

CHECK.IGNORE.TYPES:

    IGNORE.TYPE = 1

    BEGIN CASE
        CASE RIGHT(BALANCE.TYPE,2) EQ 'BL'
        CASE 1
            IGNORE.TYPE = ""
    END CASE

RETURN
*=====================================================================
CHECK.BALANCE.TYPE:

    BEGIN CASE

        CASE BALANCE.TYPE MATCHES "CONTDB":@VM:"CONTCR"
            TABLE.ERROR = ''
    END CASE

RETURN
*=====================================================================
GET.BALANCE.AMOUNT:

    RETURN.AMOUNT = 0
    REQUEST.TYPE = ""
    REQUEST.TYPE<2> = ""      ;*NAU values should not be consider
    REQUEST.TYPE<4> = "ECB"
    BALANCE.DETAILS = ""
    CALL AA.GET.PERIOD.BALANCES(AC.ID, REQD.BALANCE.TYPE, REQUEST.TYPE, "TODAY", "", "", BALANCE.DETAILS, RET.ERR)

    RETURN.AMOUNT = BALANCE.DETAILS<IC.ACT.BALANCE>

RETURN
*=====================================================================
RAISE.ENTRY:

    IS.CONTINGENT = 1

    BEGIN CASE
        CASE BALANCE.RECORD<AC.BT.REPORTING.TYPE> EQ "CONTINGENT"
        CASE 1
            IS.CONTINGENT = ''
    END CASE

    IF NOT(IS.CONTINGENT) THEN
        OPP.BAL.AMOUNT += BALANCE.AMOUNT
    END

    IF DIFF.ARR EQ "" THEN
        DIFF.ARR = AA.ID:'#':BALANCE.TYPE:'*':BALANCE.AMOUNT
    END ELSE
        DIFF.ARR = DIFF.ARR:'#':BALANCE.TYPE:'*':BALANCE.AMOUNT
    END

RETURN
*=====================================================================
WRITE.DATA:
    CALL F.WRITE(FN.ST.LAPAP.INFILEPRESTAMO, AA.ID, UPDATE.STRING)
*OPEN "&SAVEDLISTS&" TO VV.SAVELISTS ELSE STOP "Unable to open SaveLists File"
*WRITE UPDATE.STRING TO VV.SAVELISTS, "AA.ADJ.CLEAR.BAL"
RETURN
*=====================================================================
END
