* @ValidationCode : MjoxODUyNDcwMzE0OkNwMTI1MjoxNjg0ODUxOTg4NjQxOklUU1M6LTE6LTE6MTc3MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1770
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.LOAN.CUSTOMER.POSITION(Y.ARRAY.OUT)
*------------------------------------------------------------------------
*Description : This routine is nofile enquiry routine in order to fetch the loan
* details of the customer. This routine will fetch the details about the
*
*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : Y.ARRAY.OUT
* Deals With     : ENQUIRY>REDO.LOAN.CUSTOMER.POSITION

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO         REFERENCE            DESCRIPTION
* 03-MAR-2011     H GANESH  ODR-2010-10-0045 N.107   Initial Draft
* 02-MAY-2011     H GANESH      PACS00055030         Modified for displaying as per description
* 07-may-2012     Pradeep S     PACS00195649         Arrangement id replaced with Account id
*
* 18-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM, ++ to +=
* 18-APR-2023      Harishvikram C   Manual R22 conversion  CALL routine format modified
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.USER
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $USING APAP.TAM

    GOSUB INIT
    GOSUB PROCESS
    GOSUB PGM.END
RETURN

*------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------
* Variables and files are opened here

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.PRODUCT='F.AA.PRODUCT'
    F.AA.PRODUCT=''
    CALL OPF(FN.AA.PRODUCT,F.AA.PRODUCT)

    FN.REDO.CUSTOMER.ARRANGEMENT='F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUSTOMER.ARRANGEMENT=''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.EB.LOOKUP='F.EB.LOOKUP'
    F.EB.LOOKUP=''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FN.CUS.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUS.CIDENT = ''
    CALL OPF(FN.CUS.CIDENT,F.CUS.CIDENT)

    FN.CUS.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUS.RNC = ''
    CALL OPF(FN.CUS.RNC,F.CUS.RNC)

    FN.CUS.ACTANAC = 'F.CUSTOMER.L.CU.ACTANAC'
    F.CUS.ACTANAC = ''
    CALL OPF(FN.CUS.ACTANAC,F.CUS.ACTANAC)

    FN.CUS.NOUNICO = 'F.CUSTOMER.L.CU.NOUNICO'
    F.CUS.NOUNICO = ''
    CALL OPF(FN.CUS.NOUNICO,F.CUS.NOUNICO)


RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
* Here the main process of selecting the customer happens
    LOCATE "@ID" IN D.FIELDS<1> SETTING CUS.POS THEN
        Y.CUST.ID = D.RANGE.AND.VALUE<CUS.POS>
    END
**This part are used to find the unique customer id based on selection values

    CNT.FM = DCOUNT(D.RANGE.AND.VALUE,@FM)

    IF CNT.FM GE 3 THEN
        GOSUB PGM.END
    END

    IF CNT.FM GE 2 AND NOT(Y.CUST.ID) THEN
        GOSUB PGM.END
    END

    IF (Y.CUST.ID AND CNT.FM LE 2 ) OR ( NOT(Y.CUST.ID) AND CNT.FM LE 1 ) THEN
        LOCATE "L.CU.CIDENT" IN D.FIELDS<1> SETTING CIDENT.POS THEN
            Y.CIDENT.ID = D.RANGE.AND.VALUE<CIDENT.POS>
            CALL F.READ(FN.CUS.CIDENT,Y.CIDENT.ID,R.CUS.REC,F.CUS.CIDENT,CUS.ERR)
            Y.CUSTOMER.ID = FIELD(R.CUS.REC,'*',2)
        END

        LOCATE "L.CU.RNC" IN D.FIELDS<1> SETTING RNC.POS THEN
            Y.RNC.ID = D.RANGE.AND.VALUE<RNC.POS>
            CALL F.READ(FN.CUS.RNC,Y.RNC.ID,R.CUS.REC,F.CUS.RNC,CUS.ERR)
            Y.CUSTOMER.ID = FIELD(R.CUS.REC,'*',2)
        END

        LOCATE "L.CU.ACTANAC" IN D.FIELDS<1> SETTING ACTANAC.POS THEN
            Y.ACT.ID = D.RANGE.AND.VALUE<ACTANAC.POS>
            CALL F.READ(FN.CUS.ACTANAC,Y.ACT.ID,R.CUS.REC,F.CUS.ACTANAC,CUS.ERR)
            Y.CUSTOMER.ID = FIELD(R.CUS.REC,'*',2)
        END

        LOCATE "L.CU.NOUNICO" IN D.FIELDS<1> SETTING NOUNICO.POS THEN
            Y.NOUN.ID = D.RANGE.AND.VALUE<NOUNICO.POS>
            CALL F.READ(FN.CUS.NOUNICO,Y.NOUN.ID,R.CUS.REC,F.CUS.NOUNICO,CUS.ERR)
            Y.CUSTOMER.ID = FIELD(R.CUS.REC,'*',2)
        END

        GOSUB CHECK.CUST.ID
    END

******This part are used to find the unique customer id based on selection values


*    Y.TEMP.D.RANGE.AND.VALUE =D.RANGE.AND.VALUE
*    IF Y.TEMP.D.RANGE.AND.VALUE EQ '' THEN
*        RETURN
*    END
*    CALL REDO.E.FORM.SEL.STMT(FN.CUSTOMER, '', '', SEL.CMD.CUS)
*    CALL EB.READLIST(SEL.CMD.CUS,SEL.LIST.CUS,'',NO.OF.REC.CUS,SEL.ERR)
*    IF SEL.LIST.CUS THEN
*        Y.CUSTOMER.ID=SEL.LIST.CUS<1>
*    END ELSE
*        RETURN
*    END

*********The above part is commented for performance issue

    R.CUS.ARR = ''

    IF Y.CUSTOMER.ID THEN
        CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUSTOMER.ID,R.CUS.ARR,F.REDO.CUSTOMER.ARRANGEMENT,CUS.ARR.ERR)
    END

    IF R.CUS.ARR THEN
        GOSUB GET.ARRANGEMENT
    END

RETURN
*-------------------------------------------------------------------------
CHECK.CUST.ID:
*-------------------------------------------------------------------------
    IF Y.CUSTOMER.ID AND Y.CUST.ID THEN
        IF (Y.CUSTOMER.ID NE Y.CUST.ID) THEN
            GOSUB PGM.END
        END
        Y.CUSTOMER.ID = Y.CUST.ID
    END

    IF NOT(Y.CUSTOMER.ID) AND Y.CUST.ID THEN
        Y.CUSTOMER.ID = Y.CUST.ID
    END

RETURN
*------------------------------------------------------------------------
GET.ARRANGEMENT:
*------------------------------------------------------------------------
* In this part, all arrangement related to that customer are fetched from REDO.CUSTOMER.ARRANGEMENT

    Y.OWNER=R.CUS.ARR<CUS.ARR.OWNER>
    Y.OWNER.CNT=DCOUNT(Y.OWNER,@VM)

    Y.ARRAY=''
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.OWNER.CNT

        Y.ARR.ID=Y.OWNER<1,Y.VAR1>
        IF Y.ARR.ID THEN
            CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.ARR.REC,F.AA.ARRANGEMENT,ARR.ERR)
            Y.PRODUCT=R.ARR.REC<AA.ARR.PRODUCT>
            CALL CACHE.READ(FN.AA.PRODUCT, Y.PRODUCT, R.AA.PRD, PRD.ERR) ;*R22 Auto conversion
            GOSUB GET.TERM.AMOUNT
            GOSUB GET.ACCT.NO       ;* PACS00195649 - S/E
*Y.ARRAY:=Y.ARR.ID
            Y.ARRAY:=Y.AA.ACCT.ID
            IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN
                Y.PROD.DESC=R.AA.PRD<AA.PDT.DESCRIPTION,1>
            END
            IF R.USER<EB.USE.LANGUAGE> EQ 2 THEN
                GOSUB CHECK.COND
            END
            Y.ARRAY:='*':Y.PROD.DESC
            Y.ARRAY:='*'
            Y.ARRAY:='*':Y.TERM.AMOUNT
* CALL REDO.AA.GET.OUT.BALANCE(Y.ARR.ID,Y.BALANCE)
            CALL APAP.TAM.redoGetTotalOutstandingSinUncUnd(Y.ARR.ID,Y.BAL,Y.TOT.BAL) ;*Manual R22 conversion
            Y.BALANCE = Y.BAL<1>
            Y.ARRAY:='*':Y.BALANCE
            GOSUB GET.NEXT.PAYMENT
            Y.ARRAY:='*':Y.NEXTPAY.AMT
            Y.ARRAY:='*':R.ARR.REC<AA.ARR.CURRENCY>
            Y.ARRAY:='*':R.ARR.REC<AA.ARR.START.DATE>:@FM
        END
        Y.VAR1 += 1
    REPEAT
    Y.OTHER=R.CUS.ARR<CUS.ARR.OTHER.PARTY>
    Y.OTHER.CNT=DCOUNT(Y.OTHER,@VM)
    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE Y.OTHER.CNT

        Y.ARR.ID=Y.OTHER<1,Y.VAR2>
        IF Y.ARR.ID THEN
            CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.ARR.REC,F.AA.ARRANGEMENT,ARR.ERR)
            Y.PRODUCT=R.ARR.REC<AA.ARR.PRODUCT>
            GOSUB GET.ROLE
            GOSUB GET.TERM.AMOUNT
            GOSUB GET.ACCT.NO       ;* PACS00195649 - S/E
*Y.ARRAY:=Y.ARR.ID
            Y.ARRAY:=Y.AA.ACCT.ID
            Y.ARRAY:='*':Y.PRODUCT
            Y.ARRAY:='*':Y.ROLE.CUS
            Y.ARRAY:='*':Y.TERM.AMOUNT
*    CALL REDO.AA.GET.OUT.BALANCE(Y.ARR.ID,Y.BALANCE)
            CALL APAP.TAM.redoGetTotalOutstandingSinUncUnd(Y.ARR.ID,Y.BAL,Y.TOT.BAL) ;*Manual R22 conversion
            Y.BALANCE = Y.BAL<1>
            Y.ARRAY:='*':Y.BALANCE
            GOSUB GET.NEXT.PAYMENT
            Y.ARRAY:='*':Y.NEXTPAY.AMT
            Y.ARRAY:='*':R.ARR.REC<AA.ARR.CURRENCY>
            Y.ARRAY:='*':R.ARR.REC<AA.ARR.START.DATE>:@FM
        END
        Y.VAR2 += 1
    REPEAT

    GOSUB FINAL.ARRAY
RETURN
*-----------------------------------------------------------------------
CHECK.COND:
*-----------------------------------------------------------------------
    IF R.AA.PRD<AA.PDT.DESCRIPTION,2> THEN
        Y.PROD.DESC=R.AA.PRD<AA.PDT.DESCRIPTION,2>
    END ELSE
        Y.PROD.DESC=R.AA.PRD<AA.PDT.DESCRIPTION,1>
    END

RETURN
*------------------------------------------------------------------------
GET.TERM.AMOUNT:
*------------------------------------------------------------------------
* Get the loan total commitment value
    Y.TERM.AMOUNT=0
    EFF.DATE = ''
    PROP.CLASS='TERM.AMOUNT'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
    CALL APAP.TAM.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG) ;*Manual R22 conversion
    Y.TERM.AMOUNT=R.CONDITION<AA.AMT.AMOUNT>
RETURN
*------------------------------------------------------------------------
GET.NEXT.PAYMENT:
*------------------------------------------------------------------------
* This part gets the next payment amount for that arrangement

*R.PAY.SCHED = ''
*Y.NEXTPAY.AMT=0
*OUT.PROPERTY=''
*CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'PAYMENT.SCHEDULE',R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)
*CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARR.ID,'PAYMENT.SCHEDULE','','', RET.IDS,R.PAY.SCHED,RET.ERR)

*R.PAY.SCHED=RAISE(R.PAY.SCHED)      ;* since we faced problem in the array returned by AA.GET.ARRANGEMENT.CONDITIONS, RAISE function
* has been used and then calc amount has been fetched
* R.PAY.SCHED=LOWER(R.PAY.SCHED)

*Y.NEXTPAY.AMT=R.PAY.SCHED<AA.PS.CALC.AMOUNT,1,1>
*PACS00275779 -S


    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARR.ID,R.AA.ACC.DET,F.AA.ACCOUNT.DETAILS,ACT.ERR)
    Y.PAY.START.DATE = R.AA.ACC.DET<AA.AD.PAYMENT.START.DATE>
    IF Y.PAY.START.DATE ELSE
        Y.PAY.START.DATE = TODAY
    END

    Y.NEXTPAY.AMT=''
    Y.AMT = 0
    SIMULATION.REF = ''
    NO.RESET = '1'
    YREGION = ''
    YDATE = TODAY
    Y.YEAR = YDATE[1,4] + 1
    YDAYS.ORIG = Y.YEAR:TODAY[5,4]
    DATE.RANGE = Y.PAY.START.DATE:@FM:YDAYS.ORIG     ;* Date range is passed for 1 years to avoid building schedule for whole loan term

    PAYMENT.DATES = '' ; PAYMENT.TYPES = '' ; TOT.PAYMENT = '' ; PAYMENT.METHOD = '' ; DUE.TYPE.AMTS = ''
    PAYMENT.PROPERTIES = '' ; PAYMENT.PROPERTIES.AMT = '' ; DUE.OUTS = ''

    CALL AA.SCHEDULE.PROJECTOR(Y.ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)

    Y.DATES.CNT = DCOUNT(PAYMENT.DATES,@FM)
    CNT = 1
    LOOP

    WHILE CNT LE Y.DATES.CNT
        Y.PAY.DATE = PAYMENT.DATES<CNT>
        IF Y.PAY.DATE GT TODAY THEN
            Y.AMT = TOT.PAYMENT<CNT>
            CNT = Y.DATES.CNT+1
        END
        CNT += 1
    REPEAT

    Y.NEXTPAY.AMT = Y.AMT

*PACS00275779 - E

RETURN
*------------------------------------------------------------------------
GET.ROLE:
*------------------------------------------------------------------------
* Gets the role of the customer in that arrangement

    Y.ROLE=''
    Y.OTHER.PARTY=''
    EFF.DATE = ''
    PROP.CLASS='CUSTOMER'
    PROPERTY = ''
    R.CONDITION.CUSTOMER = ''
    ERR.MSG = ''
    CALL APAP.TAM.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CUSTOMER,ERR.MSG) ;*Manual R22 conversion
    Y.OTHER.PARTY=R.CONDITION.CUSTOMER<AA.CUS.OTHER.PARTY>
    Y.ROLE=R.CONDITION.CUSTOMER<AA.CUS.ROLE>
    LOCATE Y.CUSTOMER.ID IN Y.OTHER.PARTY<1,1> SETTING POS1 THEN

        Y.ROLE.CUS=Y.ROLE<1,POS1>
        CALL F.READ(FN.EB.LOOKUP,'AA.PARTY.ROLE*':Y.ROLE.CUS,R.EB.LOOKUP,F.EB.LOOKUP,LOOK.ERR)
        IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN
            Y.ROLE.CUS=R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
        END
        IF R.USER<EB.USE.LANGUAGE> EQ 2 THEN
            GOSUB CHECK.COND1
        END
    END

RETURN
*-----------------------------------------------------------------------
CHECK.COND1:
*-----------------------------------------------------------------------
    IF R.EB.LOOKUP<EB.LU.DESCRIPTION,2> THEN
        Y.ROLE.CUS=R.EB.LOOKUP<EB.LU.DESCRIPTION,2>
    END ELSE
        Y.ROLE.CUS=R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
    END
RETURN
*------------------------------------------------------------------------
FINAL.ARRAY:
*------------------------------------------------------------------------
    Y.ARRAY.OUT:=Y.ARRAY

RETURN

*--------------------------------------------------------------------------
GET.ACCT.NO:
*--------------------------------------------------------------------------
*PACS00195649 - New section to get AA Account id

    IN.ACC.ID = ''
    IN.ARR.ID = Y.ARR.ID
    OUT.ID    = ''
    ERR.TEXT  = ''
    CALL APAP.TAM.redoConvertAccount(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT) ;*Manual R22 conversion
    IF NOT(ERR.TEXT) THEN
        Y.AA.ACCT.ID = OUT.ID
    END

RETURN
*---------------------------------------------------------------------------
PGM.END:
*---------------------------------------------------------------------------
END
