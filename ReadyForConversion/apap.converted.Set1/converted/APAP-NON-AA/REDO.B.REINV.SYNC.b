SUBROUTINE REDO.B.REINV.SYNC(Y.AZ.ACCOUNT.ID)
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.REINV.SYNC
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*       This batch routine should be attached to the BATCH REDO.REINV.SYNC to ensure
* the interest rates and interest capitalisation frequency is same as of AZ.ACCOUNT
* and reinvested account
*---------------------------------------------------------------------------------
* Linked with   : None
* In Parameter  : Y.AZ.ACCOUNT.ID
* Out Parameter : None
*--------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 17-06-2010      SUJITHA.S   ODR-2009-10-0332  INITIAL CREATION
* 29-03-2012      RIYAS J     PACS00188349      CRATE ACI FOR LIQUIDATION ACCOUNT IF ROOLLOVER DATE IS HOLIDAY
*--------------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.ACCT.CAPITALISATION
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.AZ.SCHEDULES
    $INSERT I_REDO.B.REINV.SYNC.COMMON
    $INSERT I_F.DATES

    GOSUB INIT
    GOSUB PROCESS
RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    R.AZACCOUNT = ''
    R.AZ.ACCT.CAP = ''
    R.AZ.INT.LIQ.ACCT.CAP  = ''
    Y.ACI.OFS.ARRAY = ''
    OFS.ACCT.CAP = ''
    Y.OFS.POST.ARRAY = ''
    VAR.INT.RATE = ''
    OFS.SRC.ID = 'REINV.DEPOSIT'

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    CALL F.READ(FN.AZACCOUNT,Y.AZ.ACCOUNT.ID,R.AZACCOUNT,F.AZACCOUNT,AZ.ACC.ERR)
    CALL F.READ(FN.AZ.SCHEDULES,Y.AZ.ACCOUNT.ID,R.AZ.SCHEDULES,F.AZ.SCHEDULES,AZ.SCH.ERR)
    Y.INT.LIQ.ACC = R.AZACCOUNT<AZ.INTEREST.LIQU.ACCT>
    Y.VALUE.DATE  = R.AZACCOUNT<AZ.VALUE.DATE>
    Y.CURR.NO     = R.AZACCOUNT<AZ.CURR.NO>
    Y.CREATE.DATE = R.AZACCOUNT<AZ.CREATE.DATE>

    CALL F.READ(FN.ACCOUNT,Y.AZ.ACCOUNT.ID,R.AZ.BASE.ACC,F.ACCOUNT,ACC.ERR)
    CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACC,R.INT.LIQ.ACC,F.ACCOUNT,ACC.ERR)

    Y.BASE.OPEN.DATE = R.AZ.BASE.ACC<AC.OPENING.DATE>

*THIS PART IS USED TO FETCH THE PREVIOUS CALENDAR DAY FROM AZ.SCHEDULES DATE FOR INT.LIQ.ACCOUNT
    Y.DATES = R.AZ.SCHEDULES<AZ.SLS.DATE>
    CHANGE @VM TO @FM IN Y.DATES
    Y.TODAY = TODAY
    CNT.FM.VALUE = DCOUNT(Y.DATES,@FM)

    IF Y.BASE.OPEN.DATE EQ Y.VALUE.DATE THEN
        CNT = 3
    END ELSE
        CNT = 1
    END
    LOOP

    WHILE CNT LE CNT.FM.VALUE

        Y.VALUE = Y.DATES<CNT>
        Y.ORG.DATE = Y.VALUE
        IF Y.TODAY LT Y.VALUE THEN
            Y.CHECK = "-1C"

            CALL CDT(Y.REGION,Y.VALUE,Y.CHECK)
            CNT = CNT.FM.VALUE
            Y.DATE = Y.VALUE:"M01":Y.VALUE[7,2]
        END
        CNT += 1
    REPEAT
*

    Y.TYPE.INT.PAY = R.AZACCOUNT<AZ.LOCAL.REF,Y.TYPE.INT.PAY.POS>
    Y.TAX.KEY.FROM.AZ = R.AZACCOUNT<AZ.TAX.KEY>
    Y.TAX.ON.FORM.AZ = R.AZACCOUNT<AZ.TAX.ON>

    IF Y.TYPE.INT.PAY EQ 'Reinvested' THEN
        GOSUB REINV.PART
    END ELSE
*This part is used to update transit status for non reinvested deposits

        GOSUB CHECK.TRANSIT.AND.STATUS

    END
RETURN
*----------------------------------------------------------------------------------
REINV.PART:
*---------------------------------------------------------------------------------


    GOSUB CHECK.ACCT.CAP

    GOSUB CHECK.ACI
    IF OFS.ACCT.CAP THEN
        Y.OFS.POST.ARRAY<-1> = OFS.ACCT.CAP
    END

    IF Y.OFS.POST.ARRAY THEN
        MSG.ID = ''
        ERR.OFS = ''
        CALL OFS.POST.MESSAGE(Y.OFS.POST.ARRAY,MSG.ID,OFS.SRC.ID,ERR.OFS)
    END

    GOSUB CHECK.TRANSIT.AND.STATUS
    GOSUB UPD.INT.LIQ.ACC
* PACS00188349-S
    GOSUB MATURITY.DATE.OFS
* PACS00188349-E
RETURN
*---------------------------------------------------------------------------------
CHECK.ACCT.CAP:
*---------------------------------------------------------------------------------
*PACS00263513 - START


    CALL F.READ(FN.ACCAP,Y.INT.LIQ.ACC,R.AZ.INT.LIQ.ACCT.CAP,F.ACCAP,ACC.CAP.ERR)

    Y.LAST.CAP.DATE = R.INT.LIQ.ACC<AC.CAP.DATE.CR.INT,1>

    IF (R.AZ.INT.LIQ.ACCT.CAP EQ '') AND (Y.DATE NE '') THEN

        Y.ACCT.ARRAY<IC.ACCAP.CR.CAP.FREQUENCY> = Y.DATE
        Y.ACCT.ARRAY<IC.ACCAP.DR.CAP.FREQUENCY> = Y.DATE
        GOSUB FORM.OFS.ACCT.CAP

    END ELSE
        IF (R.AZ.INT.LIQ.ACCT.CAP NE '') AND (Y.DATE NE '') THEN

            Y.CR.DATE = R.AZ.INT.LIQ.ACCT.CAP<IC.ACCAP.CR.CAP.FREQUENCY>

            IF Y.DATE NE Y.CR.DATE AND (Y.LAST.CAP.DATE EQ Y.CR.DATE[1,8] OR Y.CR.DATE GE Y.ORG.DATE) THEN
                Y.ACCT.ARRAY<IC.ACCAP.CR.CAP.FREQUENCY> = Y.DATE
                Y.ACCT.ARRAY<IC.ACCAP.DR.CAP.FREQUENCY> = Y.DATE
                GOSUB FORM.OFS.ACCT.CAP
            END
        END

    END

RETURN
*---------------------------------------------------------------------------------
FORM.OFS.ACCT.CAP:
*---------------------------------------------------------------------------------

*PACS00263513 - END
    ACTUAL.APP.NAME = 'ACCT.CAPITALISATION'
    OFS.FUNCTION = 'I'
    PROCESS = 'PROCESS'
    OFS.VERSION = ''
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = Y.INT.LIQ.ACC
    OFS.RECORD = ''
    VERSION.ACCT = 'ACCT.CAPITALISATION,RE'
    MSG.ID = ''

    OPTION = ''
    CALL OFS.BUILD.RECORD(ACTUAL.APP.NAME,OFS.FUNCTION,PROCESS,VERSION.ACCT,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,Y.ACCT.ARRAY,OFS.ACCT.CAP)

RETURN
*---------------------------------------------------------------------------------
CHECK.ACI:
*---------------------------------------------------------------------------------


    Y.ACI.DATE = R.AZ.BASE.ACC<AC.ACCT.CREDIT.INT>

    Y.ACI.ID = Y.AZ.ACCOUNT.ID:'-':Y.ACI.DATE<1,DCOUNT(Y.ACI.DATE,@VM)>
    IF Y.ACI.DATE EQ '' THEN
        GOSUB INT.RATE.CHECK
        IF Y.ACI.OFS.ARRAY THEN
            Y.ID.DATE = R.AZACCOUNT<AZ.VALUE.DATE>
            GOSUB FORM.ACI.OFS
        END

    END ELSE

        CHANGE @VM TO @FM IN Y.ACI.DATE
        LOCATE Y.VALUE.DATE IN Y.ACI.DATE SETTING Y.VALUE.POS THEN
            Y.DATE.CNT = Y.VALUE.POS
            Y.TOTAL.CNT.DATE = DCOUNT(Y.ACI.DATE,@FM)
            LOOP
            WHILE Y.DATE.CNT LE Y.TOTAL.CNT.DATE
                Y.INT.LIQ.ACI.DATE = R.INT.LIQ.ACC<AC.ACCT.CREDIT.INT>
                GOSUB CHECK.INT.LIQ.ACC.ACI
                Y.DATE.CNT += 1
            REPEAT
        END
    END

RETURN
*--------------------------------------------------------------------------------
CHECK.INT.LIQ.ACC.ACI:
*--------------------------------------------------------------------------------
    IF Y.INT.LIQ.ACI.DATE EQ '' THEN
        Y.ID.DATE = Y.ACI.DATE<Y.DATE.CNT>
        Y.ACI.ID = Y.AZ.ACCOUNT.ID:'-':Y.ID.DATE
        CALL F.READ(FN.ACI,Y.ACI.ID,R.AZ.ACI,F.ACI,AZ.ACI.ERR)
        Y.ACI.AZ = FIELD(R.AZ.ACI,@FM,1,44)
        Y.ACI.OFS.ARRAY = Y.ACI.AZ
        GOSUB FORM.ACI.OFS
        GOSUB UPD.ACI.OFS
    END ELSE
        GOSUB COMPARE.ACI
    END
RETURN
*---------------------------------------------------------------------------------
COMPARE.ACI:
*---------------------------------------------------------------------------------
    CHANGE @VM TO @FM IN Y.ACI.DATE
    LOCATE Y.VALUE.DATE IN Y.ACI.DATE SETTING Y.VALUE.POS THEN
        Y.DATE.CNT = Y.VALUE.POS
        Y.TOTAL.CNT.DATE = DCOUNT(Y.ACI.DATE,@FM)
        LOOP
        WHILE Y.DATE.CNT LE Y.TOTAL.CNT.DATE
            Y.ID.DATE = Y.ACI.DATE<Y.DATE.CNT>

            Y.INT.LIQ.ACI.ID = Y.INT.LIQ.ACC:'-':Y.ID.DATE
            CALL F.READ(FN.ACI,Y.INT.LIQ.ACI.ID,R.INT.LIQ.ACI,F.ACI,INT.LIQ.ACI.ERR)
            Y.ACI.INT.LIQ = FIELD(R.INT.LIQ.ACI,@FM,1,44)

            Y.ACI.ID = Y.AZ.ACCOUNT.ID:'-':Y.ID.DATE
            CALL F.READ(FN.ACI,Y.ACI.ID,R.AZ.ACI,F.ACI,AZ.ACI.ERR)
            Y.ACI.AZ = FIELD(R.AZ.ACI,@FM,1,44)

            IF Y.ACI.AZ EQ Y.ACI.INT.LIQ THEN
                Y.ACI.OFS.ARRAY = Y.ACI.AZ
            END ELSE
                Y.ACI.OFS.ARRAY = Y.ACI.AZ
                GOSUB FORM.ACI.OFS
                GOSUB UPD.ACI.OFS
            END
            Y.DATE.CNT += 1
        REPEAT
    END

RETURN
*---------------------------------------------------------------------------------
FORM.ACI.OFS:
*---------------------------------------------------------------------------------


    GOSUB ROUNDING.RATE
    ACTUAL.APP.NAME1 = 'ACCOUNT.CREDIT.INT'
    OFS.FUNCTION1 = 'I'
    PROCESS1 = 'PROCESS'
    OFS.VERSION1 = ''
    GTSMODE1 = ''
    NO.OF.AUTH1 = '0'
    TRANSACTION.ID1 =  Y.INT.LIQ.ACC:'-':Y.ID.DATE
    OFS.RECORD1 = ''
    VERSION1 = 'ACCOUNT.CREDIT.INT,RE'
    MSG.ID1 = ''
    OPTION1 = ''

    IF Y.TAX.KEY.FROM.AZ THEN
        Y.ACI.OFS.ARRAY<IC.ACI.TAX.KEY> = Y.TAX.KEY.FROM.AZ
    END

    CALL OFS.BUILD.RECORD(ACTUAL.APP.NAME1,OFS.FUNCTION1,PROCESS1,VERSION1,GTSMODE1,NO.OF.AUTH1,TRANSACTION.ID1,Y.ACI.OFS.ARRAY,OFS.ACI)


RETURN
*----------------------------------------------------------------------------------
UPD.ACI.OFS:
*----------------------------------------------------------------------------------
    IF Y.ACI.OFS.ARRAY THEN
        Y.OFS.POST.ARRAY<-1> = OFS.ACI
    END
RETURN
*---------------------------------------------------------------------------------

MATURITY.DATE.OFS:
*---------------------------------------------------------------------------------

    Y.MATURITY.DATE = R.AZACCOUNT<AZ.MATURITY.DATE>
    Y.NEXT.WORKING.DAY  =  R.DATES(EB.DAT.NEXT.WORKING.DAY)
    IF Y.MATURITY.DATE GT TODAY AND Y.MATURITY.DATE LT Y.NEXT.WORKING.DAY THEN
        CALL AWD('',Y.MATURITY.DATE,YDAY.TYPE)
        IF YDAY.TYPE NE 'W' THEN
            CALL REDO.ACI.AZ.INT.RATE(Y.AZ.ACCOUNT.ID,Y.ACI.OFS.ARRAY,Y.MATURITY.DATE,VAR.INT.RATE)
        END
    END

RETURN
*---------------------------------------------------------------------------------
ROUNDING.RATE:
*---------------------------------------------------------------------------------

    Y.ACI.RATE = Y.ACI.OFS.ARRAY<IC.ACI.CR.INT.RATE>
    Y.RATE.CNT = DCOUNT(Y.ACI.RATE,@VM)
    Y.CNT =1
    LOOP
    WHILE Y.CNT LE Y.RATE.CNT
        Y.ACI.OFS.ARRAY<IC.ACI.CR.INT.RATE,Y.CNT> = DROUND(Y.ACI.OFS.ARRAY<IC.ACI.CR.INT.RATE,Y.CNT>,2)
        Y.CNT += 1
    REPEAT

RETURN
*---------------------------------------------------------------------------------
INT.RATE.CHECK:
*---------------------------------------------------------------------------------


    Y.INT.LIQ.ACI.DATE = R.INT.LIQ.ACC<AC.ACCT.CREDIT.INT>
    IF Y.INT.LIQ.ACI.DATE EQ '' THEN
        Y.ACI.OFS.ARRAY<IC.ACI.CR.INT.RATE> = DROUND(R.AZACCOUNT<AZ.INTEREST.RATE>,2)
        Y.ACI.OFS.ARRAY<IC.ACI.CR.BALANCE.TYPE>="DAILY"
    END ELSE
        Y.INT.LIQ.ACI.ID = Y.INT.LIQ.ACC:'-':Y.INT.LIQ.ACI.DATE<1,DCOUNT(Y.INT.LIQ.ACI.DATE,@VM)>
        CALL F.READ(FN.ACI,Y.INT.LIQ.ACI.ID,R.INT.LIQ.ACI,F.ACI,INT.LIQ.ACI.ERR)
        Y.OLD.RATE = R.INT.LIQ.ACI<IC.ACI.CR.INT.RATE>
        IF Y.OLD.RATE NE R.AZACCOUNT<AZ.INTEREST.RATE> THEN
            Y.ACI.OFS.ARRAY<IC.ACI.CR.INT.RATE> = DROUND(R.AZACCOUNT<AZ.INTEREST.RATE>,2)
            Y.ACI.OFS.ARRAY<IC.ACI.CR.BALANCE.TYPE>="DAILY"
        END ELSE
            Y.ACI.OFS.ARRAY = ''
        END
    END

RETURN
*---------------------------------------------------------------------------------
CHECK.TRANSIT.AND.STATUS:
*---------------------------------------------------------------------------------
    Y.TRANIST.VALUE = R.AZACCOUNT<AZ.LOCAL.REF,Y.INTRANSIT.POS>
    IF Y.TRANIST.VALUE NE 'NO' THEN
        Y.AZ.ALL.IN.ONE.PRODUCT = R.AZACCOUNT<AZ.ALL.IN.ONE.PRODUCT>
        CALL F.READ(FN.AZPRODUCT,Y.AZ.ALL.IN.ONE.PRODUCT,R.AZPRODUCT,F.AZPRODUCT,AZ.PROD.ERR)
        Y.AZ.METHOD.PAY=R.AZACCOUNT<AZ.LOCAL.REF,Y.AZ.METHOD.PAY.POS>
        Y.TRANSITDAYS=R.AZPRODUCT<AZ.APP.LOCAL.REF,Y.TRANSITDAYS.POS>
        R.AZACCOUNT<AZ.LOCAL.REF,Y.INTRANSIT.POS> = ''
        CHANGE @SM TO @FM IN Y.AZ.METHOD.PAY
        CHANGE @VM TO @FM IN Y.AZ.METHOD.PAY
        LOCATE "CHEQUE.DEPOSIT" IN Y.AZ.METHOD.PAY SETTING CHQ.POS THEN
            IF Y.TRANSITDAYS GT 0 THEN
                R.AZACCOUNT<AZ.LOCAL.REF,Y.INTRANSIT.POS>='YES'
            END
*Y.VALUE.DATE=R.AZACCOUNT<AZ.VALUE.DATE>
            Y.VALUE.DATE = Y.CREATE.DATE
            SIGN='+'
            Y.ACTUAL.DAYS=Y.TRANSITDAYS:'D'

            CALL CALENDAR.DAY(Y.VALUE.DATE,SIGN,Y.ACTUAL.DAYS)
            Y.DISPLACEMENT.DATE=Y.ACTUAL.DAYS

            IF Y.DISPLACEMENT.DATE LT TODAY THEN
                R.AZACCOUNT<AZ.LOCAL.REF,Y.INTRANSIT.POS>='NO'
            END ELSE
                R.AZACCOUNT<AZ.LOCAL.REF,Y.INTRANSIT.POS>='YES'
            END
        END
        CALL F.WRITE(FN.AZACCOUNT,Y.AZ.ACCOUNT.ID,R.AZACCOUNT)
    END
RETURN
*------------------------------------------------------------------------------------------
UPD.INT.LIQ.ACC:
*-----------------------------------------------------------------------------------------
    R.INT.LIQ.ACC<AC.LOCAL.REF,Y.STATUS1.POS> = R.AZ.BASE.ACC<AC.LOCAL.REF,Y.STATUS1.POS>
    R.INT.LIQ.ACC<AC.LOCAL.REF,Y.STATUS2.POS> = R.AZ.BASE.ACC<AC.LOCAL.REF,Y.STATUS2.POS>
    R.INT.LIQ.ACC<AC.LOCAL.REF,Y.NOTIFY1.POS> = R.AZ.BASE.ACC<AC.LOCAL.REF,Y.NOTIFY1.POS>
    R.INT.LIQ.ACC<AC.LOCAL.REF,Y.NOTIFY2.POS> = R.AZ.BASE.ACC<AC.LOCAL.REF,Y.NOTIFY2.POS>
    CALL F.WRITE(FN.ACCOUNT,Y.INT.LIQ.ACC,R.INT.LIQ.ACC)

RETURN
*-----------------------------------------------------------------------------------
END
