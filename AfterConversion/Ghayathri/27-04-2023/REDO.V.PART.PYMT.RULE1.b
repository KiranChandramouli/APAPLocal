* @ValidationCode : MjoyMDgzNzMxMjg2OkNwMTI1MjoxNjgyNTk0MTg5MTU5OmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Apr 2023 16:46:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.AA;*MANUAL R22 CODE CONVERSTION
SUBROUTINE REDO.V.PART.PYMT.RULE1
    

***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH
* PROGRAM NAME : REDO.V.PART.PYMT.RULE
*----------------------------------------------------------


* DESCRIPTION : This routine is a validation routine attached
* to ACCOUNT.2 of TELLER,AA.PART.PYMNT & CREDIT.ACCOUNT.NO of FUNDS.TRANSFER,AA.PART.PYMT
* model bank version to do overpayment validations
*------------------------------------------------------------

*    LINKED WITH : TELLER & CREDIT.ACCOUNT.NO AS VALIDATION ROUTINE
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE                          DESCRIPTION
*31.05.2010      GANESH                  ODR-2010-08-0017                   INITIAL CREATION
*17.05.2011      MARIMUTHU   PACS00060191&PACS00060192&PACS00060193         CHANGES MADE
*20.06.2011      SHANKAR RAJU           PACS00055028                        CONDITION ADDED FOR PARTIAL PAYMENT
*08.07.2011      MARIMUTHU              PACS00084115
*17.07.2011      MARIMUTHU              PACS00085210*-----------------------------------------------------------------------------------

*
* DATE                 WHO                  REFERENCE                    DESCRIPTION
* 29/03/2023         SURESH            MANUAL R22 CODE CONVERSTION           Package Name added APAP.AA
* 29/03/2023         Conversion Tool    AUTO R22 CODE CONVERSTION           SM to @SM,VM to @VM,FM to @FM,VAR2++ to VAR2 += 1
*-----------------------------------------------------------------------------------
*----------------------------------------------------------------------


*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_AA.APP.COMMON
    $INSERT I_F.REDO.H.TT.CONCAT.FILE
    $INSERT I_F.REDO.H.FT.CONCAT.FILE
    $INSERT I_F.REDO.H.PART.PAY
    $INSERT I_System
    $USING APAP.REDOVER
*    $INCLUDE TAM.BP I_REDO.V.PART.PYMT.RULE1.COMMON

    GOSUB INIT
    GOSUB OPENFILES
    IF MESSAGE NE 'VAL' THEN
        GOSUB PROCESS
    END
RETURN

*-------------------------------------------------------------
INIT:
*Initialising
*-------------------------------------------------------------
    LOC.REF.APPLICATION='AA.PRD.DES.TERM.AMOUNT':@FM:'TELLER':@FM:'FUNDS.TRANSFER' ;*AUTO R22 CODE CONVERSION
** PACS00084115 -S
    LOC.REF.FIELDS='L.AA.PART.ALLOW':@VM:'L.AA.PART.PCNT':@FM:'L.TT.PART.PCNT':@VM:'L.TT.NUM.PYMT':@VM:'L.TT.BIL.NUM':@VM:'L.TT.TAX.TYPE':@VM:'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@VM:'L.TT.DUE.PRS':@FM:'L.FT.PART.PCNT':@VM:'L.FT.NUM.PYMT':@VM:'L.FT.BILL.NUM':@VM:'L.FT.TAX.TYPE':@VM:'L.LOAN.COND':@VM:'L.LOAN.STATUS.1' ;*AUTO R22 CODE CONVERSION
** PACS00084115 - E
    LOC.REF.POS=''
    EFF.DATE=TODAY
    PROP.CLASS='TERM.AMOUNT'
    PROPERTY=''
    R.Condition=''
    ERR.MSG=''
    VAL.LOC.BILL.NUM = ''
    VAR.PENALTY.AMT = 0
RETURN

*-------------------------------------------------------------
OPENFILES:
*Opening File
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.H.PART.PAY = 'F.REDO.H.PART.PAY'
    F.REDO.H.PART.PAY = ''
    CALL OPF(FN.REDO.H.PART.PAY,F.REDO.H.PART.PAY)

    FN.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.CONTRACT.BALANCES = ''
    CALL OPF(FN.CONTRACT.BALANCES,F.CONTRACT.BALANCES)
RETURN
*-------------------------------------------------------------
PROCESS:
    Y.PART.AMT = 0
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    VAR.LOC.ALLOW.POS = LOC.REF.POS<1,1>
    VAR.LOC.PCNT.POS = LOC.REF.POS<1,2>
    VAR.TT.PART.PCNT = LOC.REF.POS<2,1>
    VAR.TT.NUM.PYMT = LOC.REF.POS<2,2>
    VAR.TT.BILL.NUM = LOC.REF.POS<2,3>
    VAR.TT.TAX.TYPE = LOC.REF.POS<2,4>
** PACS00084115 -S
    VAR.TT.LOAN.STAT = LOC.REF.POS<2,5>
    VAR.TT.LOAN.COND = LOC.REF.POS<2,6>
    POS.TT.PROCESS = LOC.REF.POS<2,7>
** PACS00084115 -E
    VAR.FT.PART.PCNT = LOC.REF.POS<3,1>
    VAR.FT.NUM.PYMT = LOC.REF.POS<3,2>
    VAR.FT.BILL.NUM = LOC.REF.POS<3,3>
    VAR.FT.TAX.TYPE = LOC.REF.POS<3,4>
** PACS00084115 -S
    FT.LOAN.COND.POS = LOC.REF.POS<3,5>
    FT.LOAN.STATUS.POS = LOC.REF.POS<3,6>
** PACS00084115 -E


    IF APPLICATION EQ 'TELLER' THEN
        R.NEW(TT.TE.VALUE.DATE.1) = TODAY
* PACS00085210 -S
        Y.REQ.CHK = APPLICATION:PGM.VERSION
        IF Y.REQ.CHK NE "TELLER,REDO.MULTI.AA.ACRPAP" AND Y.REQ.CHK NE "TELLER,REDO.MULTI.AA.OVR.CHQ" AND Y.REQ.CHK NE "TELLER,REDO.MULTI.ADVANCE.CHQ" AND Y.REQ.CHK NE "TELLER,REDO.MULTI.AA.CHQ" THEN
            GOSUB TT.PROCESS
        END
* PACS00085210 -S
        IF Y.REQ.CHK EQ "TELLER,REDO.MULTI.AA.OVR.CHQ" THEN
            CALL APAP.REDOVER.redoVValDefaultAmt()
        END
* PACS00085210 -E

* PACS00085210 -E
        CALL APAP.REDOVER.redoVDefTtLoanStatusCond()
** PACS00084115 -S
        Y.LOAN.STATUS = R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.LOAN.STAT>
        Y.LOAN.COND = R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.LOAN.COND>
        Y.TT.PROCESS = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.PROCESS>
        CHANGE @SM TO @VM IN Y.LOAN.STATUS ;*AUTO R22 CODE CONVERSION
        CHANGE @SM TO @VM IN Y.LOAN.COND ;*AUTO R22 CODE CONVERSION

        IF Y.REQ.CHK EQ "TELLER,REDO.MULTI.AA.ACRPAP" OR Y.REQ.CHK EQ "TELLER,REDO.AA.PART.CHQ" OR Y.REQ.CHK EQ "TELLER,REDO.MULTI.ADVANCE.CHQ" OR Y.REQ.CHK EQ "TELLER,REDO.MULTI.AA.OVR.CHQ" OR Y.REQ.CHK EQ "TELLER,REDO.MULTI.AA.CHQ" THEN
            IF Y.LOAN.COND MATCHES 'ThreeReturnedChecks' THEN
                AF = TT.TE.LOCAL.REF
                AV = VAR.TT.LOAN.COND
                ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
                CALL STORE.END.ERROR
                R.NEW(TT.TE.AMOUNT.LOCAL.1) = ''
            END
        END

        IF ('JudicialCollection' MATCHES Y.LOAN.STATUS) OR ('Write-off' MATCHES Y.LOAN.STATUS) THEN
            IF Y.TT.PROCESS EQ '' THEN
                ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
                AF = TT.TE.LOCAL.REF
                AV = VAR.TT.LOAN.STAT
                CALL STORE.END.ERROR
                R.NEW(TT.TE.AMOUNT.LOCAL.1) = ''
            END

            IF ('Legal' MATCHES Y.LOAN.COND) THEN
                ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
                AF = TT.TE.LOCAL.REF
                AV = VAR.TT.LOAN.COND
                CALL STORE.END.ERROR
                R.NEW(TT.TE.AMOUNT.LOCAL.1) = ''
            END
        END
    END
** PACS00084115 -E
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB FT.PROCESS
        CALL APAP.REDOVER.redoVDefFtLoanStatusCond()
** PACS00084115 -S
        LOAN.COND = R.NEW(FT.LOCAL.REF)<1,FT.LOAN.COND.POS>
        Y.LOAN.STATUS = R.NEW(FT.LOCAL.REF)<1,FT.LOAN.STATUS.POS>

        CHANGE @SM TO @VM IN Y.LOAN.STATUS ;*AUTO R22 CODE CONVERSION
        CHANGE @SM TO @VM IN LOAN.COND ;*AUTO R22 CODE CONVERSION

        IF ('JudicialCollection' MATCHES Y.LOAN.STATUS) OR ('Write-off' MATCHES Y.LOAN.STATUS) THEN
            ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
            AF = FT.LOCAL.REF
            AV = FT.LOAN.STATUS.POS
            CALL STORE.END.ERROR
        END

        IF ('Legal' MATCHES LOAN.COND) THEN
            ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
            AF = FT.LOCAL.REF
            AV = FT.LOAN.COND.POS
            CALL STORE.END.ERROR
        END
    END

    Y.PART.AMT = Y.BASE.AMT

    CALL System.setVariable("CURRENT.PART.AMT",Y.PART.AMT)

** PACS00084115 -E
RETURN

*--------------
TT.PROCESS:

*Teller Process for checking the bills

    TEMP.ACT.ID = COMI
    CALL F.READ(FN.ACCOUNT,TEMP.ACT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    VAR.ACCT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    CALL APAP.AA.REDO.CRR.GET.CONDITIONS(VAR.ACCT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    VAL.PART.ALLOW = R.Condition<AA.AMT.LOCAL.REF><1,VAR.LOC.ALLOW.POS>
    VAL.PART.PCNT = R.Condition<AA.AMT.LOCAL.REF><1,VAR.LOC.PCNT.POS>
    IF VAL.PART.ALLOW EQ 'YES' THEN
*****PACS00060191 & PACS00060192 & PACS00060193******* - S
        CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.ACCT.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACCT.DET.ERR)
        GOSUB CHECK.NO.OF.BILLS.TT
* GOSUB TT.CHECK.BILL
*****PACS00060191 & PACS00060192 & PACS00060193******* - E
*>>>>>PACS00055028 - CHECK ADDED FOR ELSE PART - S
    END ELSE
        ETEXT='EB-REDO.AA.PART.NOT.ALLOW'
        CALL STORE.END.ERROR
    END
*>>>>>PACS00055028 - CHECK ADDED FOR ELSE PART - E
RETURN
*-------------
CHECK.NO.OF.BILLS.TT:
*-------------
*****PACS00060191 & PACS00060192 & PACS00060193******* - S
    Y.BILLS = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    CHANGE.BILLS = CHANGE(Y.BILLS,@SM,@VM) ;*AUTO R22 CODE CONVERSION
    Y.CNT.BIL = DCOUNT(CHANGE.BILLS,@VM) ;*AUTO R22 CODE CONVERSION
    IF Y.CNT.BIL EQ 0 THEN
        ETEXT='EB-REDO.AA.PART.PAY.NO.DUE'
        CALL STORE.END.ERROR
    END
    FLG = 0
    LOOP
    WHILE Y.CNT.BIL GT 0 DO
        FLG += 1
        IF VAL.COUNT GT 1 THEN
            ETEXT = "EB-REDO.PART.PAY.NOT.ALLOW"
            CALL STORE.END.ERROR
        END ELSE
            Y.BILL.ID = CHANGE.BILLS<1,FLG>
            CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BIL.DET,F.AA.BILL.DETAILS,BILL.ERR)
            Y.PROPS = R.AA.BIL.DET<AA.BD.PROPERTY>
            LOCATE 'ACCOUNT' IN Y.PROPS<1,1> SETTING POS.PR THEN
                Y.SETTLE.STATUS = R.AA.BIL.DET<AA.BD.SETTLE.STATUS,1>
                GOSUB SET.ST.REP
            END
        END
        Y.CNT.BIL -= 1
    REPEAT
    IF VAL.COUNT GT 1 THEN
        ETEXT = "EB-REDO.PART.PAY.NOT.ALLOW"
        CALL STORE.END.ERROR
    END
    IF VAL.COUNT EQ '' THEN
        ETEXT='EB-REDO.AA.PART.PAY.NO.DUE'
        CALL STORE.END.ERROR
    END
    IF VAL.COUNT EQ 1 THEN
        R.NEW(TT.TE.AMOUNT.LOCAL.1) = FMT(Y.BASE.AMT,"R2#10")
        CALL F.READ(FN.REDO.H.PART.PAY,VAR.ACCT.ID,R.REDO.H.PART.PAY,F.REDO.H.PART.PAY,CONCAT.ERR)
        IF R.REDO.H.PART.PAY EQ '' THEN
            R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS>= 1
            VAR.NO.OF.PAYMENTS = R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS>
        END
        ELSE
            VAR.NO.OF.PAYMENTS = R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS>+ 1
        END
        R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.NUM.PYMT> = VAR.NO.OF.PAYMENTS
        R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.BILL.NUM> = Y.ORG.BILL
        R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.PART.PCNT> = VAL.PART.PCNT
    END

RETURN
*****PACS00060191 & PACS00060192 & PACS00060193******* - E

RETURN
*-------------
SET.ST.REP:
*-------------

    IF Y.SETTLE.STATUS NE 'REPAID' THEN
        GOSUB TT.CHECK.BILL
        Y.ORG.BILL = Y.BILL.ID
        VAL.COUNT += 1
    END
RETURN
*-------------
FT.PROCESS:

*FT process for Checking the bills
    TEMP.ACT.ID = COMI
    CALL F.READ(FN.ACCOUNT,TEMP.ACT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    VAR.ACCT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    CALL APAP.AA.REDO.CRR.GET.CONDITIONS(VAR.ACCT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    VAL.PART.ALLOW = R.Condition<AA.AMT.LOCAL.REF><1,VAR.LOC.ALLOW.POS>
    VAL.PART.PCNT = R.Condition<AA.AMT.LOCAL.REF><1,VAR.LOC.PCNT.POS>
    IF VAL.PART.ALLOW EQ 'YES' THEN
*****PACS00060191 & PACS00060192 & PACS00060193******* - S
        CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.ACCT.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACCT.DET.ERR)
        GOSUB CHECK.NO.OF.BILLS.FT
*****PACS00060191 & PACS00060192 & PACS00060193******* - E
* GOSUB FT.CHECK.BILL
*>>>>>PACS00055028 - CHECK ADDED FOR ELSE PART - S
    END ELSE
        ETEXT='EB-REDO.AA.PART.NOT.ALLOW'
        CALL STORE.END.ERROR
    END
*>>>>>PACS00055028 - CHECK ADDED FOR ELSE PART - E
RETURN
***********
CHECK.NO.OF.BILLS.FT:
***********
*****PACS00060191 & PACS00060192 & PACS00060193******* - S
    Y.BILLS = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    CHANGE.BILLS = CHANGE(Y.BILLS,@SM,@VM) ;*AUTO R22 CODE CONVERSION
    Y.CNT.BIL = DCOUNT(CHANGE.BILLS,@VM) ;*AUTO R22 CODE CONVERSION
    IF Y.CNT.BIL EQ 0 THEN
        ETEXT='EB-REDO.AA.PART.PAY.NO.DUE'
        CALL STORE.END.ERROR
    END
    FLG = 0
    LOOP
    WHILE Y.CNT.BIL GT 0 DO
        FLG += 1
        IF VAL.COUNT GT 1 THEN
            ETEXT = "EB-REDO.PART.PAY.NOT.ALLOW"
            CALL STORE.END.ERROR
        END ELSE
            Y.BILL.ID = CHANGE.BILLS<1,FLG>
            CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BIL.DET,F.AA.BILL.DETAILS,BILL.ERR)
            Y.PROPS = R.AA.BIL.DET<AA.BD.PROPERTY>
            LOCATE 'ACCOUNT' IN Y.PROPS<1,1> SETTING POS.PR THEN
                Y.SETTLE.STATUS = R.AA.BIL.DET<AA.BD.SETTLE.STATUS,1>
                GOSUB SET.ST.REP.FT
            END
        END
        Y.CNT.BIL -= 1
    REPEAT
    IF VAL.COUNT GT 1 THEN
        ETEXT = "EB-REDO.PART.PAY.NOT.ALLOW"
        CALL STORE.END.ERROR
    END
    IF VAL.COUNT EQ '' THEN
        ETEXT='EB-REDO.AA.PART.PAY.NO.DUE'
        CALL STORE.END.ERROR
    END
    IF VAL.COUNT EQ 1 THEN
        R.NEW(FT.CREDIT.AMOUNT) = FMT(Y.BASE.AMT,"R2#10")
        CALL F.READ(FN.REDO.H.PART.PAY,VAR.ACCT.ID,R.REDO.H.PART.PAY,F.REDO.H.PART.PAY,CONCAT.ERR)
        IF R.REDO.H.PART.PAY EQ '' THEN
            R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS>= 1
            VAR.NO.OF.PAYMENTS = R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS>
        END
        ELSE
            VAR.NO.OF.PAYMENTS = R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS>+ 1
        END
        R.NEW(FT.LOCAL.REF)<1,VAR.FT.NUM.PYMT> = VAR.NO.OF.PAYMENTS
        R.NEW(FT.LOCAL.REF)<1,VAR.FT.BILL.NUM> = Y.ORG.BILL
        R.NEW(FT.LOCAL.REF)<1,VAR.FT.PART.PCNT> = VAL.PART.PCNT
    END

RETURN
*****PACS00060191 & PACS00060192 & PACS00060193******* - E

*-----------
SET.ST.REP.FT:
*-----------
    IF Y.SETTLE.STATUS NE 'REPAID' THEN
        GOSUB FT.CHECK.BILL
        Y.ORG.BILL = Y.BILL.ID
        VAL.COUNT += 1
    END
RETURN
***********
TT.CHECK.BILL:
* Get the number of bills
*****PACS00060191 & PACS00060192 & PACS00060193******* - S

*    CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.ACCT.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACCT.DET.ERR)
*    Y.NO.BILL = DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>,VM)
*    VAR2 = 1
*    LOOP
*    WHILE VAL.LOC.BILL.NUM EQ ''
*        IF FLAG.ERROR EQ 1 THEN
*            RETURN
*        END
*        GOSUB TT.CHECK.PROCESS
*    REPEAT
*    IF FLAG.ERROR THEN
*        RETURN
*    END
*    R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.PART.PCNT> = VAL.PART.PCNT
*    VAR.PREV.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,VAR3,1>
*    VAR.PREV.BILL.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE,VAR3,1>
*    CALL F.READ(FN.AA.BILL.DETAILS,VAR.PREV.BILL.ID,R.BIL.DETAILS,F.AA.BILL.DETAILS,BILL.DET.ERR2)
*    VAR.ST.CHG.DT = R.BIL.DETAILS<AA.BD.BILL.ST.CHG.DT,1>
*    IF VAR.ST.CHG.DT LT VAR.PREV.BILL.DATE THEN
*        ETEXT = "EB-REDO.PART.PAY.NOT.ALLOW"
*        CALL STORE.END.ERROR
*    END
*    CALL F.READ(FN.AA.BILL.DETAILS,VAL.LOC.BILL.NUM,R.AA.BIL.DETAILS,F.AA.BILL.DETAILS,BILL.DET.ERR1)

*****PACS00060191 & PACS00060192 & PACS00060193******* - E

    ACCOUNT.ID = TEMP.ACT.ID
    BALANCE.TO.CHECK = 'ACCPENALTYINT'
    DATE.OPTIONS = ''
    EFFECTIVE.DATE = TODAY
    DATE.OPTIONS<4>  = 'ECB'
    BALANCE.AMOUNT = ""
    CALL AA.GET.PERIOD.BALANCES(ACCOUNT.ID, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
    PRIN.BALANCE = BAL.DETAILS<IC.ACT.BALANCE>

    VAR.TOT.AMT = R.AA.BIL.DET<AA.BD.OR.TOTAL.AMOUNT>
    VAR.OUT.AMT = SUM(R.AA.BIL.DET<AA.BD.OS.PROP.AMOUNT>)
    Y.BASE.AMT = (VAR.TOT.AMT * (VAL.PART.PCNT/100)) + ABS(PRIN.BALANCE)
    IF Y.BASE.AMT GT VAR.OUT.AMT THEN
        Y.BASE.AMT = VAR.OUT.AMT + ABS(PRIN.BALANCE)
    END

*****PACS00060191 & PACS00060192 & PACS00060193******* -S

*    R.NEW(TT.TE.AMOUNT.LOCAL.1) = FMT(Y.BASE.AMT,"R2#10")
*    CALL F.READ(FN.REDO.H.PART.PAY,VAR.ACCT.ID,R.REDO.H.PART.PAY,F.REDO.H.PART.PAY,CONCAT.ERR)
*    IF R.REDO.H.PART.PAY EQ '' THEN
*        R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS>= 1
*        VAR.NO.OF.PAYMENTS = R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS>
*    END
*    ELSE
*        VAR.NO.OF.PAYMENTS = R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS>+ 1
*    END
*    R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.NUM.PYMT> = VAR.NO.OF.PAYMENTS
*****PACS00060191 & PACS00060192 & PACS00060193******* - E

RETURN
*****************
TT.CHECK.PROCESS:
*Defaulting the values of the amount

    VAR.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,VAR2,1>
    IF VAR.BILL.ID EQ '' THEN
        FLAG.ERROR = 1
        RETURN
    END
    ELSE
        VAL.BILL.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.STATUS,VAR2,1>
        VAL.SETTLE.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS,VAR2,1>
    END
    IF VAL.LOC.BILL.NUM EQ '' THEN
        IF VAL.SETTLE.STATUS NE 'REPAID' THEN
**START--
*****PACS00060191 & PACS00060192 & PACS00060193*******
            CALL F.READ(FN.AA.BILL.DETAILS,VAR.BILL.ID,R.AA.BIL.DETAILS,F.AA.BILL.DETAILS,BILL.DET.ERR1)
            Y.PROPRTY = R.AA.BIL.DETAILS<AA.BD.PROPERTY>
            LOCATE 'ACCOUNT' IN Y.PROPRTY<1,1> SETTING POS.PR THEN
                R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.BILL.NUM> = VAR.BILL.ID
                VAR3 = VAR2 - 1
            END ELSE
                VAR2 += 1 ;*AUTO R22 CODE CONVERSION
                RETURN
            END
*****PACS00060191 & PACS00060192 & PACS00060193*******
***END--
        END
        ELSE
            VAR2 += 1 ;*AUTO R22 CODE CONVERSION
        END
    END
    VAL.LOC.BILL.NUM = R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.BILL.NUM>
RETURN
*---------------
FT.CHECK.BILL:
*****PACS00060191 & PACS00060192 & PACS00060193******* - S

*    CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.ACCT.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACCT.DET.ERR)
*    Y.NO.BILL = DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>,VM)
*    VAR2 = 1

*    LOOP
*    WHILE VAL.LOC.BILL.NUM EQ ''
*        IF FLAG.ERROR EQ 1 THEN
*            RETURN
*        END
*        GOSUB FT.CHECK.PROCESS
*    REPEAT
*    IF FLAG.ERROR THEN
*        ETEXT = "EB-REDO.PART.PAY.NOT.ALLOW"
*        CALL STORE.END.ERROR
*    END
*    R.NEW(FT.LOCAL.REF)<1,VAR.FT.PART.PCNT> = VAL.PART.PCNT
*    VAR.PREV.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,VAR3,1>
*    VAR.PREV.BILL.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE,VAR3,1>
*    CALL F.READ(FN.AA.BILL.DETAILS,VAR.PREV.BILL.ID,R.BIL.DETAILS,F.AA.BILL.DETAILS,BILL.DET.ERR2)
*    VAR.ST.CHG.DT = R.BIL.DETAILS<AA.BD.BILL.ST.CHG.DT,1>
*    IF VAR.ST.CHG.DT LT VAR.PREV.BILL.DATE THEN
*        ETEXT = "EB-REDO.PART.PAY.NOT.ALLOW"
*        CALL STORE.END.ERROR
*    END
*    CALL F.READ(FN.REDO.H.PART.PAY,VAR.ACCT.ID,R.REDO.H.PART.PAY,F.REDO.H.PART.PAY,Y.CONCAT.ERR)
*    IF R.REDO.H.PART.PAY EQ '' THEN
*        R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS> = 1
*        VAR.NO.OF.PAYMENTS = R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS>
*    END
*    ELSE
*        VAR.NO.OF.PAYMENTS = R.REDO.H.PART.PAY<PART.PAY.NUM.OF.PYMTS> + 1
*    END
*    R.NEW(FT.LOCAL.REF)<1,VAR.FT.NUM.PYMT> = VAR.NO.OF.PAYMENTS

*****PACS00060191 & PACS00060192 & PACS00060193******* - E

    ACCOUNT.ID = TEMP.ACT.ID
    BALANCE.TO.CHECK = 'ACCPENALTYINT'
    DATE.OPTIONS = ''
    EFFECTIVE.DATE = TODAY
    DATE.OPTIONS<4>  = 'ECB'
    BALANCE.AMOUNT = ""
    CALL AA.GET.PERIOD.BALANCES(ACCOUNT.ID, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
    PRIN.BALANCE = BAL.DETAILS<IC.ACT.BALANCE>

    VAR.TOT.AMT = R.AA.BIL.DET<AA.BD.OR.TOTAL.AMOUNT>
    VAR.OUT.AMT = SUM(R.AA.BIL.DET<AA.BD.OS.PROP.AMOUNT>)
    Y.BASE.AMT = (VAR.TOT.AMT * (VAL.PART.PCNT/100)) + ABS(PRIN.BALANCE)
    IF Y.BASE.AMT GT VAR.OUT.AMT THEN
        Y.BASE.AMT = VAR.OUT.AMT + ABS(PRIN.BALANCE)
    END

RETURN
****************
FT.CHECK.PROCESS:
*Defaulting the amount

    VAR.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,VAR2,1>
    IF VAR.BILL.ID EQ '' THEN
        FLAG.ERROR = 1
        RETURN
    END
    ELSE
        VAL.BILL.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.STATUS,VAR2,1>
        VAL.SETTLE.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS,VAR2,1>
    END
    IF VAL.LOC.BILL.NUM EQ '' THEN
        IF VAL.SETTLE.STATUS NE 'REPAID' THEN
**START--
*****PACS00060191 & PACS00060192 & PACS00060193*******
            CALL F.READ(FN.AA.BILL.DETAILS,VAR.BILL.ID,R.AA.BIL.DETAILS,F.AA.BILL.DETAILS,BILL.DET.ERR1)
            Y.PROPRTY = R.AA.BIL.DETAILS<AA.BD.PROPERTY>
            LOCATE 'ACCOUNT' IN Y.PROPRTY<1,1> SETTING POS.PR THEN
                R.NEW(FT.LOCAL.REF)<1,VAR.FT.BILL.NUM> = VAR.BILL.ID
                VAR3 = VAR2 - 1
            END ELSE
                VAR2 += 1 ;*AUTO R22 CODE CONVERSION
                RETURN
            END
*****PACS00060191 & PACS00060192 & PACS00060193*******
***END--
        END
        ELSE
            VAR2 += 1 ;*AUTO R22 CODE CONVERSION
            RETURN
        END
    END
    VAL.LOC.BILL.NUM = R.NEW(FT.LOCAL.REF)<1,VAR.FT.BILL.NUM>
    CALL F.READ(FN.AA.BILL.DETAILS,VAL.LOC.BILL.NUM,R.AA.BIL.DETAILS,F.AA.BILL.DETAILS,BILL.DET.ERR1)
    CALL F.READ(FN.CONTRACT.BALANCES,TEMP.ACT.ID,R.CONTRACT.BALANCES,F.CONTRACT.BALANCES,CONTRACT.ERR)

    ACCOUNT.ID = TEMP.ACT.ID
    BALANCE.TO.CHECK = 'ACCPENALTYINT'
    DATE.OPTIONS = ''
    EFFECTIVE.DATE = TODAY
    DATE.OPTIONS<4>  = 'ECB'
    BALANCE.AMOUNT = ""
    CALL AA.GET.PERIOD.BALANCES(ACCOUNT.ID, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
    PRIN.BALANCE = BAL.DETAILS<IC.ACT.BALANCE>

    VAR.TOT.AMT = R.AA.BIL.DETAILS<AA.BD.OR.TOTAL.AMOUNT>
    VAR.OUT.AMT = SUM(R.AA.BIL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
    Y.BASE.AMT = (VAR.TOT.AMT * (VAL.PART.PCNT/100)) + ABS(PRIN.BALANCE)
    IF Y.BASE.AMT GT VAR.OUT.AMT THEN
        Y.BASE.AMT = VAR.OUT.AMT + ABS(PRIN.BALANCE)
    END
    R.NEW(FT.CREDIT.AMOUNT) = FMT(Y.BASE.AMT,"R2#10")
RETURN
END
