* @ValidationCode : MjotNzgwODIyMzE0OkNwMTI1MjoxNjgyNjU4Njk1NTc4OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Apr 2023 10:41:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.LOAN.CUSTOMER.POSITION.ARCIB(Y.ARRAY.OUT)
*------------------------------------------------------------------------
*Description : This routine is nofile enquiry routine in order to fetch the loan
* details of the customer. This routine is for ARCIB
*
*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : Y.ARRAY.OUT
* Deals With     : ENQUIRY>REDO.LOAN.CUSTOMER.POSITION.ARCIB

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO         REFERENCE            DESCRIPTION
* 03-MAR-2011     H GANESH  ODR-2010-10-0045 N.107   Initial Draft
* 02-MAY-2011     H GANESH      PACS00055030         Modified as per issue
* 19-JUN-2015     ASLAM         PACS00459919         Modified AS PER ISSUE
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN , F.READ to CACHE.READ , VM to @VM , FM to @FM , ++ to +=
* 13-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT I_System
    $USING APAP.TAM


    GOSUB INIT
    GOSUB PROCESS
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

    FN.REDO.CUSTOMER.ARRANGEMENT='F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUSTOMER.ARRANGEMENT=''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)

    FN.AA.INTEREST.ACCRUALS='F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS=''
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)

    FN.AA.PRODUCT='F.AA.PRODUCT'
    F.AA.PRODUCT=''
    CALL OPF(FN.AA.PRODUCT,F.AA.PRODUCT)

    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    CALL OPF(FN.ACC,F.ACC)

RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
* Here the main process of selecting the customer happens



    Y.TEMP.D.RANGE.AND.VALUE =D.RANGE.AND.VALUE
    IF Y.TEMP.D.RANGE.AND.VALUE EQ '' THEN
        RETURN
    END

    Y.CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN	;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CUSTOMER.ID = ""
    END

    GOSUB GET.ARRANGEMENT

RETURN

*------------------------------------------------------------------------
GET.ARRANGEMENT:
*------------------------------------------------------------------------
* In this part, all arrangement related to that customer are fetched from REDO.CUSTOMER.ARRANGEMENT

    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUSTOMER.ID,R.CUS.ARR,F.REDO.CUSTOMER.ARRANGEMENT,CUS.ARR.ERR)
    Y.OWNER=R.CUS.ARR<CUS.ARR.OWNER>
    Y.OWNER.CNT=DCOUNT(Y.OWNER,@VM)

    Y.ARRAY=''
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.OWNER.CNT


        Y.ARR.ID=Y.OWNER<1,Y.VAR1>

        IF Y.ARR.ID THEN
            GOSUB CHECK.AA
        END
        Y.VAR1 += 1
    REPEAT
    Y.OTHER=R.CUS.ARR<CUS.ARR.OTHER.PARTY>
    Y.OTHER.CNT=DCOUNT(Y.OTHER,@VM)
    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE Y.OTHER.CNT

        Y.ARR.ID=Y.OTHER<1,Y.VAR2>
        CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.ARR.REC,F.AA.ARRANGEMENT,ARR.ERR)
        Y.STATUS = R.ARR.REC<AA.ARR.ARR.STATUS>
        Y.LINK.ACC = R.ARR.REC<AA.ARR.LINKED.APPL.ID,1>
        R.ACC = ''
        ERR.ACC = ''
        CALL F.READ(FN.ACC,Y.LINK.ACC,R.ACC,F.ACC,ERR.ACC)
        Y.POST.STATUS = R.ACC<AC.POSTING.RESTRICT>
        IF Y.POST.STATUS NE 75 OR Y.POST.STATUS EQ 90 THEN
            IF R.ACC AND Y.STATUS NE 'EXPIRED' THEN
                Y.PRODUCT=R.ARR.REC<AA.ARR.PRODUCT>
                GOSUB GET.ROLE
                GOSUB GET.TERM.AMOUNT
                Y.ARRAY:=Y.ARR.ID
                Y.ARRAY:='*':Y.PRODUCT
                Y.ARRAY:='*':Y.ROLE.CUS
                Y.ARRAY:='*':Y.TERM.AMOUNT
                CALL APAP.TAM.redoAaGetOutBalance(Y.ARR.ID,Y.BALANCE)
                Y.ARRAY:='*':Y.BALANCE
*GOSUB GET.NEXT.PAYMENT
                Y.ARRAY:='*':Y.NEXT.PAY.AMT
                Y.ARRAY:='*':R.ARR.REC<AA.ARR.CURRENCY>
                Y.ARRAY:='*':R.ARR.REC<AA.ARR.START.DATE>
                GOSUB GET.INT.RATE
                Y.ARRAY:='*':Y.INTEREST.RATE:@FM
            END
        END
        Y.VAR2 += 1
    REPEAT
    GOSUB FINAL.ARRAY
RETURN
*-----------------------------------------------------------------------------------------
CHECK.AA:
*-------------------------------------------------------------------------------------------

    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.ARR.REC,F.AA.ARRANGEMENT,ARR.ERR)
    Y.STATUS = R.ARR.REC<AA.ARR.ARR.STATUS>
    Y.LINK.ACC = R.ARR.REC<AA.ARR.LINKED.APPL.ID,1>
*----------------------PACS00459919-------------------------------------
    R.ACC = ''
    ERR.ACC = ''
    CALL F.READ(FN.ACC,Y.LINK.ACC,R.ACC,F.ACC,ERR.ACC)
    Y.POST.STATUS = R.ACC<AC.POSTING.RESTRICT>
    IF Y.POST.STATUS NE 75 OR Y.POST.STATUS EQ 90 THEN
        IF R.ACC AND Y.STATUS NE 'EXPIRED' THEN
*----------------------PACS00459919------------------------------------
            Y.PRODUCT=R.ARR.REC<AA.ARR.PRODUCT>
            CALL CACHE.READ(FN.AA.PRODUCT, Y.PRODUCT, R.AA.PRD, PRD.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
            Y.LOAN.TYPE = R.AA.PRD<AA.PDT.DESCRIPTION,LNGG>
            IF NOT(Y.LOAN.TYPE) THEN
                Y.LOAN.TYPE = R.AA.PRD<AA.PDT.DESCRIPTION,1>
            END
            GOSUB GET.TERM.AMOUNT
            GOSUB GET.ROLE
            Y.ARRAY:=Y.ARR.ID

            IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN
                Y.PROD.DESC=R.AA.PRD<AA.PDT.DESCRIPTION,1>
            END
            IF R.USER<EB.USE.LANGUAGE> EQ 2 THEN
                IF R.AA.PRD<AA.PDT.DESCRIPTION,2> THEN
                    Y.PROD.DESC=R.AA.PRD<AA.PDT.DESCRIPTION,2>
                END ELSE
                    Y.PROD.DESC=R.AA.PRD<AA.PDT.DESCRIPTION,1>
                END
            END
            Y.ARRAY:='*':Y.PROD.DESC
            Y.ARRAY:='*':Y.ROLE.CUS
            Y.ARRAY:='*':Y.TERM.AMOUNT
            CALL APAP.TAM.redoAaGetOutBalance(Y.ARR.ID,Y.BALANCE)
            Y.ARRAY:='*':Y.BALANCE
            Y.NEXT.PAY.AMT=''
*GOSUB GET.NEXT.PAYMENT
            Y.ARRAY:='*':Y.NEXT.PAY.AMT
            Y.ARRAY:='*':R.ARR.REC<AA.ARR.CURRENCY>
            Y.ARRAY:='*':R.ARR.REC<AA.ARR.START.DATE>
            GOSUB GET.INT.RATE
            Y.ARRAY:='*':Y.INTEREST.RATE:Y.LOAN.TYPE:@FM
        END
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
    CALL APAP.TAM.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG);*R22 Manual Conversion
    Y.TERM.AMOUNT=R.CONDITION<AA.AMT.AMOUNT>
RETURN

*------------------------------------------------------------------------
GET.ROLE:
*------------------------------------------------------------------------
* Gets the alias name of the customer
    IN.ACC.ID=''
    IN.ARR.ID=Y.ARR.ID
    OUT.ID=''
    CALL APAP.TAM.redoConvertAccount(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT);*R22 Manual Conversion
    Y.ROLE.CUS=OUT.ID


RETURN
*------------------------------------------------------------------------
GET.INT.RATE:
*------------------------------------------------------------------------

    PROP.NAME='PRINCIPAL'
    OUT.PROP=''
    ERR=''
    CALL APAP.TAM.redoGetInterestProperty(Y.ARR.ID,PROP.NAME,OUT.PROP,ERR);*R22 Manual Conversion
    Y.INT.ID=Y.ARR.ID:'-':OUT.PROP
    CALL F.READ(FN.AA.INTEREST.ACCRUALS,Y.INT.ID,R.INT.ACCRUAL,F.AA.INTEREST.ACCRUALS,INT.ACC.ERR)
    Y.INTEREST.RATE=R.INT.ACCRUAL<AA.INT.ACC.RATE,1,1>


RETURN
*------------------------------------------------------------------------
FINAL.ARRAY:
*------------------------------------------------------------------------
    Y.ARRAY.OUT:=Y.ARRAY

RETURN
END
