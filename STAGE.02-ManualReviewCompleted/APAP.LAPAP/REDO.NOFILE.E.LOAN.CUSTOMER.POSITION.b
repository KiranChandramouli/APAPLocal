* @ValidationCode : MjoxNzIzNDQ0NTM1OkNwMTI1MjoxNjgyMDc4MTc1NTA4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:26:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.NOFILE.E.LOAN.CUSTOMER.POSITION(Y.ARRAY.OUT)
*------------------------------------------------------------------------
*Description : This routine is nofile enquiry routine in order to fetch the loan
*Attached to : ENQUIRY>REDO.LOAN.CUSTOMER.POSITION
*
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO         REFERENCE            DESCRIPTION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION       FM TO @FM, VM TO @VM, ++ TO +=, F.READ TO CACHE.READ, I TO I.VAR
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION          CALL routine format modified
*------------------------------------------------------------------------

    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION - START
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
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT ;*AUTO R22 CODE CONVERSION - END

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
            Y.STATUS = R.ARR.REC<AA.ARR.ARR.STATUS>
            IF Y.STATUS EQ 'AUTH' THEN
                Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
                CONTINUE
            END
            CALL CACHE.READ(FN.AA.PRODUCT, Y.PRODUCT, R.AA.PRD, PRD.ERR) ;*AUTO R22 CODE CONVERSION
            GOSUB GET.TERM.AMOUNT
            GOSUB GET.ACCT.NO
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

*--TODO
            Y.BAL = 0
            Y.TOT.BAL = 0
            CALL APAP.TAM.REDO.GET.TOTAL.OUTSTANDING.SIN.UNC.UND(Y.ARR.ID,Y.BAL,Y.TOT.BAL) ;*MANUAL R22 CODE CONVERSION
            Y.BALANCE = Y.BAL<1>
            Y.ARRAY:='*':Y.BALANCE
            GOSUB GET.NEXT.PAYMENT
            Y.ARRAY:='*':Y.NEXTPAY.AMT
            Y.ARRAY:='*':R.ARR.REC<AA.ARR.CURRENCY>
            Y.ARRAY:='*':R.ARR.REC<AA.ARR.START.DATE>:@FM
        END
        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
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
            Y.STATUS = R.ARR.REC<AA.ARR.ARR.STATUS>
            IF Y.STATUS EQ 'AUTH' THEN
                Y.VAR2 += 1 ;*AUTO R22 CODE CONVERSION
                CONTINUE
            END
            GOSUB GET.ROLE
            GOSUB GET.TERM.AMOUNT
            GOSUB GET.ACCT.NO
            Y.ARRAY:=Y.AA.ACCT.ID
            Y.ARRAY:='*':Y.PRODUCT
            Y.ARRAY:='*':Y.ROLE.CUS
            Y.ARRAY:='*':Y.TERM.AMOUNT

*--TODO
            Y.BAL = 0
            Y.TOT.BAL = 0

            CALL APAP.TAM.REDO.GET.TOTAL.OUTSTANDING.SIN.UNC.UND(Y.ARR.ID,Y.BAL,Y.TOT.BAL) ;*MANUAL R22 CODE CONVERSION
            Y.BALANCE = Y.BAL<1>
            Y.ARRAY:='*':Y.BALANCE
            GOSUB GET.NEXT.PAYMENT
            Y.ARRAY:='*':Y.NEXTPAY.AMT
            Y.ARRAY:='*':R.ARR.REC<AA.ARR.CURRENCY>
            Y.ARRAY:='*':R.ARR.REC<AA.ARR.START.DATE>:@FM
        END
        Y.VAR2 += 1 ;*AUTO R22 CODE CONVERSION
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
    Y.TERM.AMOUNT=0
    EFF.DATE = ''; PROP.CLASS='TERM.AMOUNT'; PROPERTY = ''; R.CONDITION = ''; ERR.MSG = ''
    CALL APAP.TAM.REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    Y.TERM.AMOUNT=R.CONDITION<AA.AMT.AMOUNT>
RETURN
*------------------------------------------------------------------------
GET.NEXT.PAYMENT:
*------------------------------------------------------------------------
    ARRANGEMENT.ID = Y.ARR.ID
    PROP.CLASS     = 'PAYMENT.SCHEDULE'
    PROP.NAME      = ''
    RET.ERR        = ''
    R.AA           = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARRANGEMENT.ID,PROP.CLASS,PROP.NAME,'','',R.AA,RET.ERR)

    R.AA = RAISE(R.AA)

    CUOTA = 0
    CUOTA.CALC = 0
    CUOTA.ACT  = 0
    Y.CUOTA.TOT = 0
    Y.NEXTPAY.AMT = 0

    Y.CAN.MULT = R.AA<AA.PS.PAYMENT.TYPE>
    Y.CAN.NUM  = DCOUNT(Y.CAN.MULT,@VM)

    IF Y.STATUS NE "PENDING.CLOSURE" AND Y.STATUS NE "CLOSE" THEN

        FOR I.VAR = 1 TO Y.CAN.NUM ;*AUTO R22 CODE CONVERSION
            CUOTA.CALC = R.AA<AA.PS.CALC.AMOUNT,I.VAR>
            CUOTA.ACT  = R.AA<AA.PS.ACTUAL.AMT,I.VAR>
            TIPO.PAGO = R.AA<AA.PS.PAYMENT.TYPE,I.VAR>

            IF CUOTA.ACT NE '' THEN
                CUOTA =  CUOTA.ACT
            END ELSE
                CUOTA = CUOTA.CALC
            END


            IF TIPO.PAGO NE 'CAPPROG' THEN
                Y.CUOTA.TOT = CUOTA + Y.CUOTA.TOT
            END
        NEXT I.VAR ;*AUTO R22 CODE CONVERSION

        Y.NEXTPAY.AMT = Y.CUOTA.TOT
    END

RETURN

*------------------------------------------------------------------------
GET.ROLE:
*------------------------------------------------------------------------
    Y.ROLE=''; ERR.MSG = ''
    Y.OTHER.PARTY=''; EFF.DATE = ''; PROP.CLASS='CUSTOMER'; PROPERTY = ''; R.CONDITION.CUSTOMER = ''
    CALL APAP.TAM.REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CUSTOMER,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
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

    IN.ACC.ID = ''
    IN.ARR.ID = Y.ARR.ID
    OUT.ID    = ''
    ERR.TEXT  = ''
    CALL APAP.TAM.REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT) ;*MANUAL R22 CODE CONVERSION
    IF NOT(ERR.TEXT) THEN
        Y.AA.ACCT.ID = OUT.ID
    END

RETURN
*---------------------------------------------------------------------------
PGM.END:
*---------------------------------------------------------------------------
END
