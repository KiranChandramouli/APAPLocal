$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.TEMP.DISB.PAYM.DETAILS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is used as input routine to update the local table REDO.AA.DISBURSE.METHOD
*-------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 09-06-2017        Edwin Charles D  R15 Upgrade       Initial Creation
** 10-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 10-04-2023 Skanda R22 Manual Conversion - No changes
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.H.AA.DIS.CHG
    $INSERT I_F.REDO.AA.DISBURSE.METHOD
    $INSERT I_F.CUSTOMER
*   $INSERT I_F.AA.CUSTOMER ;* R22 Auto conversion
    $INSERT I_F.AA.CHARGE.DETAILS
    $INSERT I_System
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY


MAIN:


    IF V$FUNCTION EQ 'D' THEN
        RETURN
    END

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.H.AA.DIS.CHG = 'F.REDO.H.AA.DIS.CHG'
    F.REDO.H.AA.DIS.CHG = ''

    FN.REDO.AA.DISBURSE.METHOD = 'F.REDO.AA.DISBURSE.METHOD'
    F.REDO.AA.DISBURSE.METHOD = ''
    CALL OPF(FN.REDO.AA.DISBURSE.METHOD,F.REDO.AA.DISBURSE.METHOD)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AA.CHARGE.DETAILS = 'F.AA.CHARGE.DETAILS'
    F.AA.CHARGE.DETAILS = ''
    CALL OPF(FN.AA.CHARGE.DETAILS,F.AA.CHARGE.DETAILS)

    FN.REDO.AA.GET.PARTY.ROLE = 'F.REDO.AA.GET.PARTY.ROLE'
    F.REDO.AA.GET.PARTY.ROLE = ''
    CALL OPF(FN.REDO.AA.GET.PARTY.ROLE,F.REDO.AA.GET.PARTY.ROLE)

    FN.REDO.RCA.ID.AR = 'F.REDO.CREATE.ARRANGEMENT.ID.ARRANGEMENT'
    F.REDO.RCA.ID.AR = ''
    CALL OPF(FN.REDO.RCA.ID.AR,F.REDO.RCA.ID.AR)

    FN.RCA = 'F.REDO.CREATE.ARRANGEMENT'
    F.RCA = ''
    CALL OPF(FN.RCA,F.RCA)

    FN.AA.AC = 'F.AA.ACCOUNT.DETAILS'
    F.AA.AC = ''
    CALL OPF(FN.AA.AC,F.AA.AC)

    FN.RCA.PART = 'F.REDO.AA.PART.DISBURSE.FC'
    F.RCA.PART = ''
    CALL OPF(FN.RCA.PART,F.RCA.PART)

    FN.REDO.GET.AAA.NEW.CHG.PDIS = 'F.REDO.GET.AAA.NEW.CHG.PDIS'
    F.REDO.GET.AAA.NEW.CHG.PDIS = ''
    CALL OPF(FN.REDO.GET.AAA.NEW.CHG.PDIS,F.REDO.GET.AAA.NEW.CHG.PDIS)

    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AAA = ''
    CALL OPF(FN.AAA,F.AAA)


    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:


    Y.TEMP.ID = System.getVariable("CURRENT.Template.ID")
    IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN       ;*Tus Start
        Y.TEMP.ID=''
    END   ;*Tus End
    Y.ARR.AC = R.NEW(FT.TN.DEBIT.ACCT.NO)

    CALL F.READ(FN.ACCOUNT,Y.ARR.AC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>

    CALL F.READ(FN.REDO.AA.DISBURSE.METHOD,Y.AA.ID,R.REDO.AA.DISBURSE.METHOD,F.REDO.AA.DISBURSE.METHOD,AA.DIS.ERR)
    IF R.REDO.AA.DISBURSE.METHOD THEN

        LOCATE Y.TEMP.ID IN R.REDO.AA.DISBURSE.METHOD<DIS.MET.FC.DISBURSE.ID,1> SETTING PS.FC THEN

            Y.REF.ID.CNT = DCOUNT(R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.REF.ID,PS.FC>,@SM)
            LOCATE ID.NEW IN R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.REF.ID,PS.FC,1> SETTING PS.CB THEN
                GOSUB PROCESS.DELETE.RECS
            END ELSE
                R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.REF.ID,PS.FC,Y.REF.ID.CNT+1> = ID.NEW
                IF R.NEW(FT.TN.DEBIT.AMOUNT) NE '' THEN
                    R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.AMT,PS.FC,Y.REF.ID.CNT+1> = R.NEW(FT.TN.DEBIT.AMOUNT)
                END ELSE
                    R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.AMT,PS.FC,Y.REF.ID.CNT+1> = R.NEW(FT.TN.CREDIT.AMOUNT)
                END
                GOSUB TYPE.PAYMENT
                R.REDO.AA.DISBURSE.METHOD<DIS.MET.TYPE.PAYMENT,PS.FC,Y.REF.ID.CNT+1> = Y.TYPE.PAY
            END
        END ELSE
            Y.REF.FC.CNT = DCOUNT(R.REDO.AA.DISBURSE.METHOD<DIS.MET.FC.DISBURSE.ID>,@VM)
            R.REDO.AA.DISBURSE.METHOD<DIS.MET.FC.DISBURSE.ID,Y.REF.FC.CNT+1> = Y.TEMP.ID

            Y.REF.ID.CNT = DCOUNT(R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.REF.ID>,@SM)
            R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.REF.ID,Y.REF.FC.CNT+1> = ID.NEW
            IF R.NEW(FT.TN.DEBIT.AMOUNT) NE '' THEN
                R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.AMT,Y.REF.FC.CNT+1> = R.NEW(FT.TN.DEBIT.AMOUNT)
            END ELSE
                R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.AMT,Y.REF.FC.CNT+1> = R.NEW(FT.TN.CREDIT.AMOUNT)
            END
            GOSUB TYPE.PAYMENT
            R.REDO.AA.DISBURSE.METHOD<DIS.MET.TYPE.PAYMENT,Y.REF.FC.CNT+1> = Y.TYPE.PAY

            IF R.REDO.AA.DISBURSE.METHOD<DIS.MET.FC.DISBURSE.ID> EQ '' THEN
                SET.CF = 1
            END ELSE
                SET.CF = Y.REF.FC.CNT + 1
            END
            GOSUB PROCESS.CHG.AAL

        END
    END ELSE
        GOSUB GET.COMMON.VAL
    END

    GOSUB WRITE.TEMPLATE

RETURN

PROCESS.DELETE.RECS:

    IF V$FUNCTION EQ 'D' THEN
        GOSUB PROCES.DL.RE
    END ELSE
        RETURN
    END

RETURN

PROCES.DL.RE:

    DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.REF.ID,PS.FC,PS.CB>
    DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.AMT,PS.FC,PS.CB>
    DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.TYPE.PAYMENT,PS.FC,PS.CB>

    IF R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.REF.ID,PS.FC,1>  EQ '' THEN
        DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.FC.DISBURSE.ID,PS.FC>
        DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.CHARGE.PROP,PS.FC>
        DEL R.REDO.AA.DISBURSE.METHOD<DIS.MET.CHARGE.AMT,PS.FC>
    END

    CALL F.WRITE(FN.REDO.AA.DISBURSE.METHOD,Y.AA.ID,R.REDO.AA.DISBURSE.METHOD)

RETURN

GET.COMMON.VAL:


    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.AA.ID,'CUSTOMER','','',RET.PROP,RET.COND,RET.ERR)
    RET.COND = RAISE(RET.COND)
    Y.PR.OWN = RET.COND<AA.CUS.PRIMARY.OWNER>
    Y.OWN = RET.COND<AA.CUS.OWNER>
    Y.OT.PARTY = RET.COND<AA.CUS.OTHER.PARTY>
    Y.OT.PARTY.ROLE = RET.COND<AA.CUS.ROLE>

    Y.VALS.PARTY = 'PRIMARY.OWN':'*':Y.PR.OWN
    FLG.PR = ''
    Y.PAR.CNT = DCOUNT(Y.OT.PARTY,@VM)
    LOOP
    WHILE Y.PAR.CNT GT 0 DO
        FLG.PR += 1
        Y.VALS.PARTY<-1> = Y.OT.PARTY.ROLE<1,FLG.PR>:'*':Y.OT.PARTY<1,FLG.PR>
        Y.PAR.CNT -= 1
    REPEAT

    IF Y.VALS.PARTY THEN
        CALL F.WRITE(FN.REDO.AA.GET.PARTY.ROLE,Y.AA.ID,Y.VALS.PARTY)
    END

    R.REDO.AA.DISBURSE.METHOD<DIS.MET.CUSTOMER.NO> = Y.PR.OWN

    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.AA.ID,'TERM.AMOUNT','','',RET.PROP,RET.COND.TM,RET.ERR)
    RET.COND.TM = RAISE(RET.COND.TM)
    Y.TERM.AMT = RET.COND.TM<AA.AMT.AMOUNT>
    R.REDO.AA.DISBURSE.METHOD<DIS.MET.TERM.AMOUNT> = Y.TERM.AMT

    R.REDO.AA.DISBURSE.METHOD<DIS.MET.FC.DISBURSE.ID> = Y.TEMP.ID

    SET.CF = 1
    GOSUB PROCESS.CHG.AAL

    R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.REF.ID> = ID.NEW
    IF R.NEW(FT.TN.DEBIT.AMOUNT) NE '' THEN
        R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.AMT> = R.NEW(FT.TN.DEBIT.AMOUNT)
    END ELSE
        R.REDO.AA.DISBURSE.METHOD<DIS.MET.DISBURSE.AMT> = R.NEW(FT.TN.CREDIT.AMOUNT)
    END

    GOSUB TYPE.PAYMENT
    R.REDO.AA.DISBURSE.METHOD<DIS.MET.TYPE.PAYMENT> = Y.TYPE.PAY

    Y.CHG.AMT = R.NEW(FT.TN.AA.CHG.AMOUNT)
    R.REDO.AA.DISBURSE.METHOD<DIS.MET.TOTAL.CHG.AMT> = Y.CHG.AMT

RETURN

PROCESS.CHG.AAL:


    IF Y.TEMP.ID[1,3] EQ 'ARR' THEN
        CALL F.READ(FN.RCA,Y.TEMP.ID,R.RCA,F.RCA,RCA.ERR)
        Y.CHARGS = R.RCA<REDO.FC.CHARG.DISC>
        Y.CHR.AMT = R.RCA<REDO.FC.CHARG.AMOUNT>

        CALL F.READ(FN.AA.AC,Y.AA.ID,R.AA.AC,F.AA.AC,AA.AC.ERR)
        IF R.AA.AC THEN
            GOSUB GET.BILLS.DE
        END

    END ELSE
        IF Y.TEMP.ID[1,3] EQ 'PRR' THEN
            CALL F.READ(FN.RCA.PART,Y.TEMP.ID,R.RCA.PART,F.RCA.PART,RCA.ER.P)
            Y.CHARGS =  R.RCA.PART<REDO.PDIS.CHARG.DISC>
            Y.CHR.AMT = R.RCA.PART<REDO.PDIS.CHARG.AMOUNT>
            CALL F.READ(FN.REDO.GET.AAA.NEW.CHG.PDIS,Y.TEMP.ID,R.REDO.GET.AAA.NEW.CHG.PDIS,F.REDO.GET.AAA.NEW.CHG.PDIS,PDIS.ER)
            IF R.REDO.GET.AAA.NEW.CHG.PDIS THEN
                GOSUB PART.CHG.PRO
            END
        END
    END

*    CALL F.READ(FN.AA.AC,Y.AA.ID,R.AA.AC,F.AA.AC,AA.AC.ERR)
*    IF R.AA.AC THEN
*        GOSUB GET.BILLS.DE
*    END

RETURN

PART.CHG.PRO:

    Y.PCNT = DCOUNT(R.REDO.GET.AAA.NEW.CHG.PDIS,@FM) ; P.FLG = ''
    LOOP
    WHILE Y.PCNT GT 0 DO
        P.FLG += 1
        Y.AAA.ID = R.REDO.GET.AAA.NEW.CHG.PDIS<P.FLG>
        CALL F.READ(FN.AAA,Y.AAA.ID,R.AAA,F.AAA,AAA.ERR)
        Y.AAA.ACT = R.AAA<AA.ARR.ACT.ACTIVITY>

        Y.CHR.CNT = DCOUNT(Y.CHARGS,@VM) ; PP.DLF = ''
        LOOP
        WHILE Y.CHR.CNT GT 0 DO
            PP.DLF += 1
            Y.ACD = 'LENDING-CHANGE-':Y.CHARGS<1,PP.DLF>
            IF Y.AAA.ACT EQ Y.ACD THEN
                R.REDO.AA.DISBURSE.METHOD<DIS.MET.CHARGE.PROP,SET.CF,P.FLG> = Y.CHARGS<1,PP.DLF>
                R.REDO.AA.DISBURSE.METHOD<DIS.MET.CHARGE.AMT,SET.CF,P.FLG> = Y.CHR.AMT<1,PP.DLF>
            END
            Y.CHR.CNT -= 1
        REPEAT
        Y.PCNT -= 1
    REPEAT

RETURN

GET.BILLS.DE:

    BLS = R.AA.AC<AA.AD.BILL.ID>
    BLS = CHANGE(BLS,@VM,@FM)
    BLS = CHANGE(BLS,@SM,@FM)
    Y.BLS.CNT = DCOUNT(BLS,@FM) ; FL.BLS = '' ; FLG.2 = ''
    LOOP
    WHILE Y.BLS.CNT GT 0 DO
        FL.BLS += 1
        BILL.REFERENCE = BLS<FL.BLS>
        CALL AA.GET.BILL.DETAILS(Y.AA.ID, BILL.REFERENCE, BILL.DETAILS, RET.ERROR)
        IF BILL.DETAILS THEN
            GOSUB CHECK.BLS
        END
        Y.BLS.CNT -= 1
    REPEAT

RETURN


CHECK.BLS:

    Y.BIL.TYP = BILL.DETAILS<AA.BD.BILL.TYPE>
    IF Y.BIL.TYP EQ 'ACT.CHARGE' THEN
        Y.PRP = BILL.DETAILS<AA.BD.PROPERTY>
        LOCATE Y.PRP IN Y.CHARGS<1,1> SETTING POS.LL THEN
            FLG.1 += 1
            Y.PRP.AMT = BILL.DETAILS<AA.BD.OR.PROP.AMOUNT>
            R.REDO.AA.DISBURSE.METHOD<DIS.MET.CHARGE.PROP,SET.CF,FLG.1> = Y.PRP
            R.REDO.AA.DISBURSE.METHOD<DIS.MET.CHARGE.AMT,SET.CF,FLG.1> = Y.PRP.AMT
        END
    END

RETURN

TYPE.PAYMENT:

    BEGIN CASE
        CASE PGM.VERSION EQ ',REDO.AA.CHEQUE' OR PGM.VERSION EQ ',REDO.AA.PART.CHEQUE'
            Y.TYPE.PAY = 'CHEQUE'
        CASE PGM.VERSION EQ ',REDO.AA.ACDP' OR PGM.VERSION EQ ',REDO.AA.PART.ACDP'
            Y.TYPE.PAY = 'DEPOSIT'
        CASE PGM.VERSION EQ ',REDO.AA.CASH' OR PGM.VERSION EQ ',REDO.AA.PART.CASH'
            Y.TYPE.PAY = 'CASH'
        CASE PGM.VERSION EQ ',REDO.AA.OTI' OR PGM.VERSION EQ ',REDO.AA.PART.OTI'
            Y.TYPE.PAY = 'INSTRUMENT'
        CASE PGM.VERSION EQ ',REDO.AA.LTCC' OR PGM.VERSION EQ ',REDO.AA.PART.LTCC'
            Y.TYPE.PAY = 'CR.CARD'
        CASE PGM.VERSION EQ ',REDO.AA.INTERBRANCH.ACH' OR PGM.VERSION EQ ',REDO.AA.PART.INTERBRANCH.ACH'
            Y.TYPE.PAY = 'INTERBRANCH'
        CASE PGM.VERSION EQ ',REDO.AA.IB.ACH' OR PGM.VERSION EQ ',REDO.AA.PART.IB.ACH'
            Y.TYPE.PAY = 'IB.ACH'
        CASE PGM.VERSION EQ ',REDO.MULTI.AA.ACRP.DISB' OR PGM.VERSION EQ ',REDO.MULTI.AA.PART.ACRP.DISB'
            Y.TYPE.PAY = 'OVERPAYMENT'
        CASE PGM.VERSION EQ ',REDO.MULTI.AA.ACPOAP.DISB' OR PGM.VERSION EQ ',REDO.MULTI.AA.PART.ACPOAP.DISB'
            Y.TYPE.PAY = 'PAYOFF'
        CASE PGM.VERSION EQ ',REDO.MULTI.AA.ACCRAP.DISB' OR PGM.VERSION EQ ',REDO.MULTI.AA.ACCRAP.PDISB'
            Y.TYPE.PAY = 'ADVANCE'
        CASE PGM.VERSION EQ ',REDO.MULTI.REPAY.CHQ.DISB'
            Y.TYPE.PAY = 'REGULAR'
    END CASE

RETURN

WRITE.TEMPLATE:

    CON.DATE = OCONV(DATE(),"D-")
    DATE.TIME = CON.DATE[9,2]:CON.DATE[1,2]:CON.DATE[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
    R.REDO.AA.DISBURSE.METHOD<DIS.MET.DATE.TIME> = DATE.TIME
    R.REDO.AA.DISBURSE.METHOD<DIS.MET.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;* R22 Auto conversion
    R.REDO.AA.DISBURSE.METHOD<DIS.MET.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR ;* R22 Auto conversion
    R.REDO.AA.DISBURSE.METHOD<DIS.MET.CURR.NO> = 1
    R.REDO.AA.DISBURSE.METHOD<DIS.MET.CO.CODE> = ID.COMPANY
    CALL F.WRITE(FN.REDO.AA.DISBURSE.METHOD,Y.AA.ID,R.REDO.AA.DISBURSE.METHOD)

RETURN

PGM.END:

END
