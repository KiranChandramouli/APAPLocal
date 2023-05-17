*-----------------------------------------------------------------------------
* <Rating>-133</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.S.COM.CALC.DISB.DATE.AMT(IN.REC.VAL,OUT.REC.VAL)
*--------------------------------------------------------------------------------------------------
*
* Description           : This is the Common Routine for Calculating the Disburse Amount and Date
* *
* Developed On          : 23-Sep-2013
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : DE11
*
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
*                        Krishnaveni                    20131206             Disburse amount retreival corrected
* PACS00382500           Ashokkumar.V.P                  06/03/2015          Added new fields based on mapping
* PACS00460182           Ashokkumar.V.P                  11/06/2015          Adding changes based on new mapping
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.LIMIT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CURRENCY
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.CCY.HISTORY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PRODUCT.GROUP
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ACTIVITY.CHARGES
    $INSERT I_F.AA.PRODUCT.DESIGNER
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.SCHEDULED.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_REDO.B.COM.LNS.BY.DEBTOR.COMMON
    $INSERT I_F.LIMIT
    $INSERT I_F.EB.CONTRACT.BALANCES

    GOSUB GET.IN.REC.VAL
    GOSUB DISB.AMT.CHECK
    GOSUB GET.AMT.APPROVED.8
    GOSUB AA.TERM.AMOUNT.CHK
    GOSUB ECB.VALUE
    GOSUB FORM.VALUES
    RETURN
GET.IN.REC.VAL:
*-------------
    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'; F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)
    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'; F.AA.ARR.TERM.AMOUNT = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

    Y.AA.ARR.ID = FIELD(IN.REC.VAL,"#",1)
    Y.CUSTOMER.ID  = FIELD(IN.REC.VAL,"#",2)
    Y.CURRENCY   = FIELD(IN.REC.VAL,"#",3)
    Y.L.LOAN.STATUS.1 = FIELD(IN.REC.VAL,"#",4)
    R.AA.TERM.AMOUNT = FIELD(IN.REC.VAL,"#",5)
    R.AA.ACCOUNT.DETAILS = FIELD(IN.REC.VAL,"#",6)
    R.AA.OVERDUE = FIELD(IN.REC.VAL,"#",7)
    Y.ACCT.NO = FIELD(IN.REC.VAL,"#",8)
    R.AA.LIMIT = FIELD(IN.REC.VAL,"#",9)
    R.AA.ARRANGEMENT = ''; AA.ARRANGEMENT.ERR = ''; R.AA.PRODUCT.GROUP = ''; ERR.AA.PRODUCT.GROUP = ''
    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)
    RETURN
DISB.AMT.CHECK:
*-------------

    GOSUB AA.ACTIVITY.HIST.READ
    GOSUB TAKEOVER.COMMITMENT
    GOSUB CHK.LENDING.COMMITEMENT
    Y.DISBURSE.DATE = Y.SYS.DATE
    Y.ACT.AMT       = Y.FIN.DISB.AMT
    GOSUB LCCY.CHK
    RETURN
TAKEOVER.COMMITMENT:
*-------------------
    Y.DISB.COUNT = "1"
    Y.ACTIVITY.CNT = DCOUNT(Y.ACTIVITY,FM)
    Y.ACT.FIN.CNT = Y.ACTIVITY.CNT
    Y.FLAG = ''
    Y.LMT.ID = ''
    Y.AMT.APPROVE = ''
    Y.TAKE.FLG = ''
    Y.FIN.DISB.AMT = ''
    LOOP
    WHILE Y.DISB.COUNT LE Y.ACT.FIN.CNT
        Y.DISB.ACTIVITY = Y.ACTIVITY<Y.ACTIVITY.CNT>
        GOSUB GET.ACTIVITY.DTLS
        GOSUB CHK.DISB.ACTIVITY
        Y.ACTIVITY.CNT -= 1
        Y.DISB.COUNT++
    REPEAT
    RETURN
CHK.LENDING.COMMITEMENT:
*----------------------
    IF NOT(Y.TAKE.FLG) THEN
        Y.DISB.COUNT = "1"
        Y.ACTIVITY.CNT = DCOUNT(Y.ACTIVITY,FM)
        Y.ACT.FIN.CNT = Y.ACTIVITY.CNT
        Y.FLAG = ''
        Y.LMT.ID = ''
        Y.AMT.APPROVE = ''
        Y.FIN.DISB.AMT = ''
        LOOP
        WHILE Y.DISB.COUNT LE Y.ACT.FIN.CNT
            Y.DISB.ACTIVITY = Y.ACTIVITY<Y.ACTIVITY.CNT>
            GOSUB GET.ACTIVITY.DTLS
            GOSUB CHK.DISB.COMMITMENT
            Y.ACTIVITY.CNT -= 1
            Y.DISB.COUNT++
        REPEAT
    END
    RETURN
CHK.DISB.ACTIVITY:
*----------------
    LOOP
        REMOVE Y.ACTI FROM Y.DISB.ACTIVITY SETTING POS
    WHILE Y.ACTI:POS
        Y.ACTIVITY.STATUS = Y.ACTIVITY.STATUS.1<Y.ACTI.CNT>
        IF Y.ACTIVITY.STATUS EQ 'AUTH' THEN
            IF Y.ACTI EQ 'LENDING-TAKEOVER-ARRANGEMENT' THEN
                Y.DISB.DATE       = Y.DISB.DATE.1<Y.ACTI.CNT>
                Y.ACTIVITY.REF    = Y.ACTIVITY.REF.1<Y.ACTI.CNT>
                IF NOT(Y.DISB.AMT) THEN
                    Y.DISB.AMT        = R.AA.TERM.AMOUNT<AA.AMT.AMOUNT>
                    Y.FIN.DISB.AMT = Y.DISB.AMT
                END
                IF Y.DISB.DATE AND NOT(Y.FLAG) THEN
                    Y.SYS.DATE = Y.DISB.DATE
                    Y.FLAG = '1'
                END
                IF NOT(Y.COMP.CODE) THEN
                    GOSUB COMP.CODE.ACTVITY
                END
                Y.TAKE.FLG = '1'
            END
        END
        Y.ACTI.CNT ++
    REPEAT
    RETURN
CHK.DISB.COMMITMENT:
*-------------------
    LOOP
        REMOVE Y.ACTI FROM Y.DISB.ACTIVITY SETTING POS
    WHILE Y.ACTI:POS
        Y.ACTIVITY.STATUS = Y.ACTIVITY.STATUS.1<Y.ACTI.CNT>
        IF Y.ACTIVITY.STATUS EQ 'AUTH' THEN
            IF Y.ACTI EQ 'LENDING-DISBURSE-COMMITMENT' THEN
                Y.DISB.AMT        = Y.DISB.AMT.1<Y.ACTI.CNT>
                Y.DISB.DATE       = Y.DISB.DATE.1<Y.ACTI.CNT>
                Y.ACTIVITY.REF    = Y.ACTIVITY.REF.1<Y.ACTI.CNT>
                GOSUB CHK.DISB.DATE
                IF NOT(Y.COMP.CODE) THEN
                    GOSUB COMP.CODE.ACTVITY
                END
            END
        END
        Y.ACTI.CNT ++
    REPEAT
    RETURN
GET.ACTIVITY.DTLS:
*----------------
    Y.DISB.AMT.1        = Y.ACT.AMT<Y.ACTIVITY.CNT>
    Y.DISB.DATE.1       = Y.ACT.DATE<Y.ACTIVITY.CNT>
    Y.ACTIVITY.REF.1    = Y.ACT.REFERENCE<Y.ACTIVITY.CNT>
    Y.ACTIVITY.STATUS.1 = Y.ACT.STATUS<Y.ACTIVITY.CNT>
    CHANGE SM TO FM IN Y.DISB.AMT.1
    CHANGE SM TO FM IN Y.DISB.DATE.1
    CHANGE SM TO FM IN Y.ACTIVITY.REF.1
    CHANGE SM TO FM IN Y.ACTIVITY.STATUS.1
* (S) 20131206 to fix incorrect dirbursement amount
    Y.DISB.AMT = ""
    Y.DISB.DATE = ""
    Y.ACTIVITY.REF = ""
    Y.ACTIVITY.STATUS = ""
* (E) 20131206
    Y.ACTI.CNT = 1
    RETURN
*---------------------
AA.ACTIVITY.HIST.READ:
*---------------------
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ARR.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,AA.ACTIVITY.HISTORY.ERR)
    Y.ACTIVITY      = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
    Y.ACT.REFERENCE = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF>
    Y.ACT.STATUS    = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.STATUS>
    Y.ACT.AMT       = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.AMT>
    Y.ACT.DATE      = R.AA.ACTIVITY.HISTORY<AA.AH.SYSTEM.DATE>
    Y.EFF.DATE.ACT = R.AA.ACTIVITY.HISTORY<AA.AH.EFFECTIVE.DATE>
    CHANGE VM TO FM IN Y.ACTIVITY
    CHANGE VM TO FM IN Y.ACT.REFERENCE
    CHANGE VM TO FM IN Y.ACT.STATUS
    CHANGE VM TO FM IN Y.ACT.AMT
    CHANGE VM TO FM IN Y.ACT.DATE
    CHANGE VM TO FM IN Y.EFF.DATE.ACT
    RETURN
CHK.DISB.DATE:
*-------------
    IF Y.DISB.DATE AND NOT(Y.FLAG) THEN
        Y.SYS.DATE = Y.DISB.DATE
        Y.SYS.ACT.REF = Y.ACTIVITY.REF.1
        Y.FLAG = '1'
    END
    IF Y.FLAG EQ '1' AND Y.DISB.DATE THEN
        IF Y.SYS.DATE EQ Y.DISB.DATE THEN
            GOSUB CHK.STATUS.AUTH
        END
    END
    RETURN
CHK.STATUS.AUTH:
*--------------
    IF Y.ACTIVITY.STATUS EQ 'AUTH' THEN
        IF Y.FIN.DISB.AMT THEN
            Y.FIN.DISB.AMT += Y.DISB.AMT
        END ELSE
            Y.FIN.DISB.AMT = Y.DISB.AMT
        END
    END
    RETURN
COMP.CODE.ACTVITY:
*----------------
    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.ACTIVITY.REF,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR)
    IF R.AA.ARRANGEMENT.ACTIVITY THEN
        Y.COMP.CODE.1 = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.CO.CODE>
        Y.COMP.CODE   = Y.COMP.CODE.1
    END
    RETURN
LCCY.CHK:
*--------
    IF Y.CURRENCY EQ LCCY THEN
        Y.DISBURSE.AMT = Y.ACT.AMT
    END ELSE
        GOSUB CURRENCY.READ
        Y.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
        IF Y.DISBURSE.DATE GE Y.DATE THEN
            GOSUB DISB.AMT.STEP.1
        END
        IF Y.DISBURSE.DATE LT Y.DATE THEN
            Y.CCY.CURR.NO = R.CCY<EB.CUR.CURR.NO>
            GOSUB DISB.AMOUNT.CHK
        END
    END
    RETURN
DISB.AMOUNT.CHK:
*---------------
    IF Y.CCY.CURR.NO EQ "1" THEN
        GOSUB DISB.AMT.STEP.1
    END ELSE
        GOSUB DISB.YEAR.DATE
    END
    RETURN
DISB.YEAR.DATE:
*-------------
    Y.DISB.YEAR    = Y.DISBURSE.DATE[1,4]
    Y.CCY.HIST.ID  = Y.CURRENCY:".":Y.DISB.YEAR
    CALL F.READ(FN.CCY.HISTORY,Y.CCY.HIST.ID,R.CCY.HISTORY,F.CCY.HISTORY,CCY.HIST.ERR)
    IF R.CCY.HISTORY THEN
        GOSUB EFF.DATE.CHK
        GOSUB CCY.HISTORY.CHK
    END
    RETURN
EFF.DATE.CHK:
*-----------
    Y.EFF.DATE     = R.CCY.HISTORY<CHT.EFFECTIVE.DATE>
    Y.CCY.HIS.CURR.NO  = R.CCY.HISTORY<CHT.CCY.CURR.NO>
    Y.EFF.DATE.CNT     = "1"
    Y.EFF.DATE.TOT.CNT = DCOUNT(Y.EFF.DATE,VM)
    LOOP
    WHILE Y.EFF.DATE.CNT LE Y.EFF.DATE.TOT.CNT
        Y.EFFECTIVE.DATES = Y.EFF.DATE<1,Y.EFF.DATE.CNT>
        IF Y.DISBURSE.DATE GE Y.EFFECTIVE.DATES THEN
            Y.CCY.CURR.NO.NEW =  Y.CCY.HIS.CURR.NO<1,Y.EFF.DATE.CNT>
        END
        IF Y.CCY.CURR.NO.NEW THEN
            Y.EFF.DATE.CNT = Y.EFF.DATE.TOT.CNT
        END
        Y.EFF.DATE.CNT++
    REPEAT
    RETURN
CCY.HISTORY.CHK:
*--------------
    Y.CCY.HIS.ID = Y.CURRENCY:";":Y.CCY.CURR.NO.NEW
    CALL F.READ(FN.CURRENCY.HIS,Y.CCY.HIS.ID,R.CURRENCY.HIS,F.CURRENCY.HIS,CURRENCY.HIS.ERR)
    IF R.CURRENCY.HIS THEN
        Y.CURRENCY.MARKET.HIS = R.CURRENCY.HIS<EB.CUR.CURRENCY.MARKET>
        Y.REVAL.DATE.HIS      = R.CURRENCY.HIS<EB.CUR.REVAL.RATE>
        Y.MID.REVAL.RATE.HIS  = R.CURRENCY.HIS<EB.CUR.MID.REVAL.RATE>
        LOCATE "1" IN Y.CURRENCY.MARKET.HIS SETTING CURR.MRKT.POS.HIS THEN
            GOSUB GET.REVAL.RATE.CHK
        END
    END
    RETURN
GET.REVAL.RATE.CHK:
*----------------
    Y.REVAL.RATE.VAL.HIS = Y.REVAL.RATE<CURR.MRKT.POS>
    IF Y.REVAL.RATE.VAL.HIS THEN
        Y.DISBURSE.AMT       = Y.ACT.AMT * Y.REVAL.RATE.VAL.HIS
    END ELSE
        Y.MID.REVAL.RATE.VAL.HIS = Y.MID.REVAL.RATE.HIS<CURR.MRKT.POS.HIS>
        Y.DISBURSE.AMT           = Y.ACT.AMT * Y.MID.REVAL.RATE.VAL.HIS
    END
    RETURN
*-------------
CURRENCY.READ:
**------------
    CCY.ERR = ""
    R.CCY   = ""
    CALL F.READ(FN.CCY,Y.CURRENCY,R.CCY,F.CCY,CCY.ERR)
    RETURN
DISB.AMT.STEP.1:
**--------------
    Y.CURRENCY.MARKET = R.CCY<EB.CUR.CURRENCY.MARKET>
    Y.REVAL.RATE      = R.CCY<EB.CUR.REVAL.RATE>
    Y.MID.REVAL.RATE  = R.CCY<EB.CUR.MID.REVAL.RATE>
    LOCATE "1" IN Y.CURRENCY.MARKET SETTING CURR.MRKT.POS THEN
        Y.REVAL.RATE.VAL = Y.REVAL.RATE<CURR.MRKT.POS>
        Y.DISBURSE.AMT   = Y.ACT.AMT * Y.REVAL.RATE.VAL
        IF Y.REVAL.RATE.VAL EQ "" THEN
            Y.MID.REVAL.RATE.VAL = Y.MID.REVAL.RATE<CURR.MRKT.POS>
            Y.DISBURSE.AMT = Y.ACT.AMT * Y.MID.REVAL.RATE.VAL
        END
    END
    RETURN
GET.LIMIT.CHK:
*------------
    Y.EFF.DATE.1 =  Y.EFF.DATE.ACT<Y.DISB.COUNT>
    IF Y.EFF.DATE.1 THEN
        GOSUB CHK.LMT.VAL
    END
    RETURN
CHK.LMT.VAL:
*-----------
    IF NOT(Y.LIMIT.REF) THEN
        LOCATE "LENDING-TAKEOVER-ARRANGEMENT" IN Y.DISB.ACTIVITY<1,1,1> SETTING DISB.ACT.POS THEN
            GOSUB GET.LMT.DTLS.6
        END ELSE
            LOCATE "LENDING-NEW-ARRANGEMENT" IN Y.DISB.ACTIVITY<1,1,1> SETTING DISB.NEW.POS THEN
                GOSUB GET.LMT.DTLS.6
            END
        END
    END
    RETURN
GET.LMT.DTLS.6:
*--------------

    Y.LIMIT.REF = ''
*    Y.FORM.ID = Y.AA.ARR.ID:"-LIMITES-":Y.EFF.DATE.1:".1"
*    CALL F.READ(FN.AA.LIMIT,Y.FORM.ID,R.AA.LIMIT,F.AA.LIMIT,AA.LIMIT.ERR)
    IF R.AA.LIMIT THEN
        Y.LMT.REF =  R.AA.LIMIT<AA.LIM.LIMIT.REFERENCE>
*AA Changes 20161013
        Y.LMT.SERIAL = R.AA.LIMIT<AA.LIM.LIMIT.SERIAL>
*    Y.LIMIT.REF = Y.CUSTOMER.ID:".":FMT(Y.LMT.REF,'R%10')
        Y.LIMIT.REF = Y.CUSTOMER.ID:".":FMT(Y.LMT.REF,'R%7'):".":FMT(Y.LMT.SERIAL,'R%2')
*AA Chnages 20161013
        Y.SINGLE.LIMIT = R.AA.LIMIT<AA.LIM.SINGLE.LIMIT>
    END
    YMUL.LIMIT = ''
    IF Y.SINGLE.LIMIT EQ 'N' AND Y.LMT.REF NE '' THEN
        YMUL.LIMIT = Y.LIMIT.REF
    END
    RETURN
AA.TERM.AMOUNT.CHK:
*-----------------
    Y.L.STATUS.CHG.DT   = R.AA.OVERDUE<AA.OD.LOCAL.REF,Y.L.STATUS.CHG.DT.POS>
    IF Y.L.LOAN.STATUS.1 EQ "Restructured" THEN
        Y.RESTRUCT.DATE = Y.L.STATUS.CHG.DT
    END
    IF Y.RESTRUCT.DATE THEN
        Y.RESTRUCT.DATE.DIS  = Y.RESTRUCT.DATE[7,2]:"/":Y.RESTRUCT.DATE[5,2]:"/":Y.RESTRUCT.DATE[1,4]
    END
    GOSUB CHK.LN.STATUS.TERM.AMT
    GOSUB GET.APP.DATE
    GOSUB EARLY.PAY.OFF
    RETURN
CHK.LN.STATUS.TERM.AMT:
*---------------------
    YPRCT.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    CALL F.READ(FN.AA.PRODUCT.GROUP,YPRCT.GROUP,R.AA.PRODUCT.GROUP,F.AA.PRODUCT.GROUP,ERR.AA.PRODUCT.GROUP)
    LOCATE 'TERM.AMOUNT' IN R.AA.PRODUCT.GROUP<AA.PG.PROPERTY.CLASS,1> SETTING PROP.POS THEN
        PROPERTY.VAL = R.AA.PRODUCT.GROUP<AA.PG.PROPERTY,PROP.POS>
    END
    YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.ID>

    Y.RENEWAL.DATE = ''
    IF Y.L.LOAN.STATUS.1 EQ "Normal" OR Y.L.LOAN.STATUS.1 EQ "" THEN
        LOCATE "LENDING-CHANGE.TERM-COMMITMENT" IN YACT.ID.ARR<1,1> SETTING CHG.POSN THEN
            YACT.DTE.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.DATE,CHG.POSN,1>
*            TERM.AMT.ID = Y.AA.ARR.ID:'-':PROPERTY.VAL:'-':YACT.DTE.ID:'.1'
*            GOSUB AA.ARR.TERM.AMT.READ
*            IF NOT(R.AA.TERM.AMOUNT) THEN
*                TERM.AMT.ID = Y.AA.ARR.ID:'-':PROPERTY.VAL:'-':YACT.DTE.ID:'.2'
*                GOSUB AA.ARR.TERM.AMT.READ
*            END
            Y.RENEWAL.DATE = YACT.DTE.ID
        END
    END
    Y.RENEWAL.DATE.DIS = ''
    IF Y.RENEWAL.DATE THEN
        Y.RENEWAL.DATE.DIS = Y.RENEWAL.DATE[7,2]:"/":Y.RENEWAL.DATE[5,2]:"/":Y.RENEWAL.DATE[1,4]
    END
    RETURN
GET.APP.DATE:
*-----------
    LIMIT.ERR = ""; R.LIMIT   = ""
    CALL F.READ(FN.LIMIT,Y.LIMIT.REF,R.LIMIT,F.LIMIT,LIMIT.ERR)
    IF R.LIMIT THEN
        Y.COUN.CODE = R.LIMIT<LI.COUNTRY.OF.RISK>
        Y.APPROVAL.DATE = R.LIMIT<LI.APPROVAL.DATE>
    END
    Y.APROVAL.DATE.DIS = ''; Y.CONTRACT.DATE = ''
    Y.CONTRACT.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.CONTRACT.DATE>
    IF Y.CONTRACT.DATE THEN
        Y.APROVAL.DATE.DIS = Y.CONTRACT.DATE[7,2]:"/":Y.CONTRACT.DATE[5,2]:"/":Y.CONTRACT.DATE[1,4]
    END
    RETURN
EARLY.PAY.OFF:
*------------
    Y.L.AA.PART.ALLOW  = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,Y.L.AA.PART.ALLOW.POS>
    IF Y.L.AA.PART.ALLOW EQ "YES" THEN
        Y.EARLY.PAY.OFF = "S"
    END ELSE
        Y.EARLY.PAY.OFF = "N"
    END
    RETURN
AA.ARR.TERM.AMT.READ:
**-------------------
    AA.TERM.AMT.ERR   = ""; R.AA.ARR.TERM.AMT = ""
    CALL F.READ(FN.AA.ARR.TERM.AMOUNT,TERM.AMT.ID,R.AA.ARR.TERM.AMT,F.AA.ARR.TERM.AMOUNT,AA.TERM.AMT.ERR)
    RETURN

GET.AMT.APPROVED.8:
*------------------
    GOSUB AA.ACTIVITY.HIST.READ
    Y.DISB.COUNT = "1"
    Y.ACTIVITY.CNT = DCOUNT(Y.ACTIVITY,FM)
    Y.ACT.FIN.CNT = Y.ACTIVITY.CNT
    Y.FLAG = ''
    Y.LMT.ID = ''
    Y.AMT.APPROVE = ''
    LOOP
    WHILE Y.DISB.COUNT LE Y.ACT.FIN.CNT
        Y.DISB.ACTIVITY = Y.ACTIVITY<Y.DISB.COUNT>
        GOSUB GET.LIMIT.CHK
        IF NOT(Y.AMT.APPROVE) THEN
            Y.AMT.APPROVE = ''
            LOCATE "LENDING-TAKEOVER-ARRANGEMENT" IN Y.DISB.ACTIVITY<1,1,1> SETTING DISB.ACT.POS THEN
                GOSUB GET.EFFECTIVE.DATE
                Y.AMT.APPROVE = R.AA.ARR.TERM.AMT<AA.AMT.AMOUNT>
            END ELSE
                GOSUB CHK.ACT.AMOUT
            END
        END
        IF Y.AMT.APPROVE THEN
            Y.DISB.COUNT = Y.ACT.FIN.CNT
        END
        Y.DISB.COUNT++
    REPEAT
    RETURN
CHK.ACT.AMOUT:
*------------
    LOCATE "LENDING-AMEND.HISTORY-COMMITMENT" IN Y.DISB.ACTIVITY<1,1,1> SETTING DISB.AMEND.POS THEN
        GOSUB GET.EFFECTIVE.DATE
        Y.AMT.APPROVE = R.AA.ARR.TERM.AMT<AA.AMT.AMOUNT>
    END ELSE
        LOCATE "LENDING-NEW-ARRANGEMENT" IN Y.DISB.ACTIVITY<1,1,1> SETTING DISB.NEW.POS THEN
            GOSUB GET.EFFECTIVE.DATE
            Y.AMT.APPROVE = R.AA.ARR.TERM.AMT<AA.AMT.AMOUNT>
        END
    END
    RETURN
GET.EFFECTIVE.DATE:
*------------------

    ARR.INFO      = ''
    ARR.INFO<1>   = Y.AA.ARR.ID
    R.ARRANGEMENT = ''
    Y.EFF.DATE.PROP    = TODAY
    CALL AA.GET.ARRANGEMENT.PROPERTIES(ARR.INFO,Y.EFF.DATE.PROP,R.ARRANGEMENT,PROP.LIST)
*
    CLASS.LIST = ''
    CALL AA.GET.PROPERTY.CLASS(PROP.LIST,CLASS.LIST)
    CLASS.LIST = RAISE(CLASS.LIST)
    PROP.LIST  = RAISE(PROP.LIST)
    CLASS.CTR  = '';
*
    Y.DCNT.CLASS = DCOUNT(CLASS.LIST,FM)
    LOOP
        REMOVE Y.CLASS FROM CLASS.LIST SETTING CLASS.POS
        CLASS.CTR +=1
    WHILE Y.CLASS:CLASS.POS
        IF Y.CLASS EQ "TERM.AMOUNT" THEN
            Y.TERM.AMOUNT.PROPERTY = PROP.LIST<CLASS.CTR>
        END
        IF Y.TERM.AMOUNT.PROPERTY THEN
            Y.ACT.ID = 'LENDING-DISBURSE':'-':Y.TERM.AMOUNT.PROPERTY
            Y.EFF.DATE.PRO =  Y.EFF.DATE.ACT<Y.DISB.COUNT>
            IF Y.EFF.DATE.PRO THEN
                Y.AA.ID.REC =  Y.AA.ARR.ID:"-":Y.TERM.AMOUNT.PROPERTY:"-":Y.EFF.DATE.PRO:".1"
                TERM.AMT.ID = Y.AA.ID.REC
                GOSUB AA.ARR.TERM.AMT.READ
            END
            RETURN
        END
    REPEAT
    RETURN
*
ECB.VALUE:
**********
    R.EB.CONTRACT.BALANCES = ''; EB.CONTRACT.BALANCES.ERR = ''; TOTCOM = ''
    CALL F.READ(FN.EB.CONTRACT.BALANCES,Y.ACCT.NO,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,EB.CONTRACT.BALANCES.ERR)
    YASST.TPE.VAL = R.EB.CONTRACT.BALANCES<ECB.CURR.ASSET.TYPE>
    LOCATE 'TOTCOMMITMENT' IN YASST.TPE.VAL<1,1> SETTING TOTCOMMITMENT.POS THEN
        OPEN.BAL = 0; CR.MVMT = 0; DR.MVMT = 0
        OPEN.BAL = R.EB.CONTRACT.BALANCES<ECB.OPEN.BALANCE,TOTCOMMITMENT.POS>
        CR.MVMT = R.EB.CONTRACT.BALANCES<ECB.CREDIT.MVMT,TOTCOMMITMENT.POS>
        DR.MVMT = R.EB.CONTRACT.BALANCES<ECB.DEBIT.MVMT,TOTCOMMITMENT.POS>
        TOTCOM = OPEN.BAL + CR.MVMT + DR.MVMT
    END
    TOTCOM = ABS(TOTCOM)
    RETURN

FORM.VALUES:
*----------
    IF NOT(Y.APROVAL.DATE.DIS) THEN
        Y.LIMIT.REF = ''
    END
    Y.SYS.DATE = Y.APROVAL.DATE.DIS
*                        1              2          3               4                 5                6                           7                    8                     9             10           11           12
    OUT.REC.VAL = Y.SYS.DATE:FM:Y.COMP.CODE:FM:Y.LIMIT.REF:FM:Y.DISBURSE.AMT:FM:Y.EARLY.PAY.OFF:FM:Y.APROVAL.DATE.DIS:FM:Y.RESTRUCT.DATE.DIS:FM:Y.RENEWAL.DATE.DIS:FM:Y.AMT.APPROVE:FM:Y.COUN.CODE:FM:YMUL.LIMIT:FM:TOTCOM
    RETURN
END
