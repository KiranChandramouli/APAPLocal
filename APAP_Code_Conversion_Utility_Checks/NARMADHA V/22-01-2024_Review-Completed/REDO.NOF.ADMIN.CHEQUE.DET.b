* @ValidationCode : MjoxMzIxNjUzNzQwOlVURi04OjE3MDU5MTc4NzE3NTU6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2024 15:34:31
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.ADMIN.CHEQUE.DET(Y.FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.NOF.ADMIN.CHEQUE.DET
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This is No-file Enquiry routine. It will fetch the field details required for enquiry
*
* In parameter  :
* out parameter : Y.FIN.ARR
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
* DATE         WHO                REFERENCE          DESCRIPTION
* 12-01-2011   MARIMUTHU s        ODR-2009-10-0795   Initial Creation
* 17-01-2011   Prahbu N           PACS00033473       Selection Criteria Added for enquiry and line 49 added to support it
* 24-07-2013   Vignesh Kumaar R   PACS00298102       DEBIT ENTRIES SHOULD NOT BE RECORDED AS THIS IS RELATED TO TAX
* 19-01-2024      Narmadha V     R22 Utility Changes,Manual R22 Conversion -   ID variable changed instead of hardcoding, F.READ to F.READU
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT ;*
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.ADMIN.CHEQUE.DETAILS
    $INSERT I_F.REDO.TEMP.UPDATE.CUS.AC
    $USING EB.TransactionControl ;*Manual R22 Conversion
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.REDO.ADMIN.CHEQUE.DETAILS = 'F.REDO.ADMIN.CHEQUE.DETAILS'
    F.REDO.ADMIN.CHEQUE.DETAILS = ''
    CALL OPF(FN.REDO.ADMIN.CHEQUE.DETAILS,F.REDO.ADMIN.CHEQUE.DETAILS)
    FN.REDO.TEMP.UPDATE.CUS.AC = 'F.REDO.TEMP.UPDATE.CUS.AC'
    F.REDO.TEMP.UPDATE.CUS.AC = ''
    CALL OPF(FN.REDO.TEMP.UPDATE.CUS.AC,F.REDO.TEMP.UPDATE.CUS.AC)

* Fix for PACS00298102 [DEBIT ENTRIES SHOULD NOT BE RECORDED AS THIS IS RELATED TO TAX #1]

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

* End of Fix

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    LOCATE 'CLIENT.ID' IN D.FIELDS<1> SETTING Y.CUS.POS THEN
        Y.CUSTOMER.ID=D.RANGE.AND.VALUE<1,Y.CUS.POS>
        Y.SEL.STMT.CUS=' AND CLIENT.ID EQ' :' ':Y.CUSTOMER.ID
    END

    SEL.CMD = 'SELECT ':FN.REDO.ADMIN.CHEQUE.DETAILS:' WITH CHEQ.PRINT EQ "NO"':Y.SEL.STMT.CUS:' BY CHEQ.BENEFICIARY BY AGENCY'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,CHEQ.ERR)
    LOOP
        REMOVE Y.ADMIN.CQ.ID FROM SEL.LIST SETTING POS
    WHILE Y.ADMIN.CQ.ID:POS
        FLG.CK += 1
        CALL F.READ(FN.REDO.ADMIN.CHEQUE.DETAILS,Y.ADMIN.CQ.ID,R.REDO.ADMIN.CHEQ,F.REDO.ADMIN.CHEQUE.DETAILS,CHEQ.ERR)
        Y.BENEFIC.NAME = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.CHEQ.BENEFICIARY>
        Y.AGENCY.CK = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.AGENCY>
        FLAG += 1
        IF Y.BENE.NAME NE Y.BENEFIC.NAME OR Y.AGENCY.1.CK NE Y.AGENCY.CK THEN
            IF FLAG GT 1 THEN
                Y.FIN.ARR<-1> = Y.BENE.NAME:'*':Y.CUSTOMER.NAME:'*':Y.AGENCY:'*':Y.PAY.DATE:'*':Y.DEP.NO:'*':Y.INT.RATE:'*':Y.TAX.VALUE:'*':Y.INT.VALUE:'*':Y.TOT.INT.VAL:'*':DUP.NO.DISP.ACCS:'*':Y.TOT.ACCS   ;* Fix for PACS00298102
                GOSUB CHECK.SAME.CUST
                CALL F.WRITE(FN.REDO.TEMP.UPDATE.CUS.AC,Y.CUSTOMER.NAME,R.REC.TEMP)
*CALL JOURNAL.UPDATE('')
                EB.TransactionControl.JournalUpdate('');* R22 Utility Changes
                Y.CUSTOMER.NAME = ''; Y.AGENCY = ''; Y.PAY.DATE = ''; Y.DEP.NO = ''; Y.INT.RATE = ''; Y.INT.VALUE = ''; Y.SAM.DATE = ''; Y.TAX.VALUE = '';
                FLAG = 1
            END
            GOSUB GET.VALUES.DIFF.CUS
            Y.BENE.NAME = Y.BENEFIC.NAME
            Y.AGENCY.1.CK = Y.AGENCY.CK
        END ELSE

            GOSUB GET.VALUES.SAME.CUS
            Y.BENE.NAME = Y.BENEFIC.NAME
            Y.AGENCY.1.CK = Y.AGENCY.CK
        END
        IF FLG.CK EQ NO.OF.RECS THEN
            Y.FIN.ARR<-1> = Y.BENE.NAME:'*':Y.CUSTOMER.NAME:'*':Y.AGENCY:'*':Y.PAY.DATE:'*':Y.DEP.NO:'*':Y.INT.RATE:'*':Y.TAX.VALUE:'*':Y.INT.VALUE:'*':Y.TOT.INT.VAL::'*':DUP.NO.DISP.ACCS:'*':Y.TOT.ACCS    ;* Fix for PACS00298102
            R.REC.TEMP<REDO.RG.AC.ID> = Y.DEP.NO
            R.REC.TEMP<REDO.RG.AC.DATE> = Y.SAM.DATE
            CALL F.WRITE(FN.REDO.TEMP.UPDATE.CUS.AC,Y.CUSTOMER.NAME,R.REC.TEMP)
*CALL JOURNAL.UPDATE('')
            EB.TransactionControl.JournalUpdate('');* R22 Utility Changes
        END

    REPEAT

RETURN

CHECK.SAME.CUST:
*---------------
    LOCATE Y.CUSTOMER.NAME IN Y.CUST.ARRAY<1,1> SETTING Y.CU.POS THEN

        R.REC.TEMP = ''
        Y.IGNORE.SET = ''
*CALL F.READ(FN.REDO.TEMP.UPDATE.CUS.AC, Y.CUSTOMER.NAME,R.REC.TEMP, F.REDO.TEMP.UPDATE.CUS.AC, Y.REC.ERR)
        CALL F.READU(FN.REDO.TEMP.UPDATE.CUS.AC, Y.CUSTOMER.NAME,R.REC.TEMP, F.REDO.TEMP.UPDATE.CUS.AC, Y.REC.ERR,'');* R22 Utility Changes
        Y.AC.TOT = R.REC.TEMP<REDO.RG.AC.ID>
        Y.AC.CNT = DCOUNT(Y.AC.TOT,@VM)
        Y.POS = Y.AC.CNT + 1
        LOCATE Y.DEP.NO IN Y.AC.TOT<1,1> SETTING Y.DEP.POS THEN
            Y.DEP.DAT = R.REC.TEMP<REDO.RG.AC.DATE,Y.DEP.POS>
            IF Y.DEP.DAT EQ Y.SAM.DATE THEN
                Y.IGNORE.SET = 1
            END
        END
        IF NOT(Y.IGNORE.SET) THEN
            R.REC.TEMP<REDO.RG.AC.ID,Y.POS> = Y.DEP.NO
            R.REC.TEMP<REDO.RG.AC.DATE,Y.POS> = Y.SAM.DATE
        END
        R.REC.TEMP<REDO.RG.SAME.CUST> = 'YES'
    END ELSE
        Y.CUST.ARRAY<1,-1> = Y.CUSTOMER.NAME
        R.REC.TEMP<REDO.RG.AC.ID> = Y.DEP.NO
        R.REC.TEMP<REDO.RG.AC.DATE> = Y.SAM.DATE
    END

RETURN
*-----------------------------------------------------------------------------
GET.VALUES.DIFF.CUS:
*-----------------------------------------------------------------------------
    NO.DISP.ACCS = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.DEPOSIT.NO>
    DUP.NO.DISP.ACCS = NO.DISP.ACCS:'-'
    Y.AGENCY = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.AGENCY>
    Y.PAY.DATE = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.PAYMENT.DATE>
    Y.SAM.DATE = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.PAYMENT.DATE>
    Y.PAY.DATE = ICONV(Y.PAY.DATE,'D')
    Y.PAY.DATE = OCONV(Y.PAY.DATE,'D')
    Y.DEP.NO = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.DEPOSIT.NO>
    Y.INT.RATE = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.INTEREST.RATE>
    Y.INT.RATE = FMT(Y.INT.RATE,'L2#6')
    Y.INT.VALUE = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.INT.PAYMNT.AMT>
    Y.CUSTOMER.NAME = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.CLIENT.ID>

* Fix for PACS00298102 [DEBIT ENTRIES SHOULD NOT BE RECORDED AS THIS IS RELATED TO TAX #2]

    GOSUB CALC.TAX.AMOUNT
    Y.TAX.VALUE = TOT.TAX
    Y.TOT.INT.VAL = Y.INT.VALUE - TOT.TAX
    Y.TOT.ACCS = Y.DEP.NO
* End of Fix

RETURN
*-----------------------------------------------------------------------------
GET.VALUES.SAME.CUS:
*-----------------------------------------------------------------------------

    IF NO.DISP.ACCS NE R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.DEPOSIT.NO> THEN
        DUP.NO.DISP.ACCS := R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.DEPOSIT.NO>:'-'
        NO.DISP.ACCS = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.DEPOSIT.NO>
    END

    Y.AGENCY := @VM:R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.AGENCY>
    Y.CH.PAY.DATE = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.PAYMENT.DATE>
    Y.SAM.DATE := @VM:R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.PAYMENT.DATE>
    Y.CH.PAY.DATE = ICONV(Y.CH.PAY.DATE,'D')
    Y.CH.PAY.DATE = OCONV(Y.CH.PAY.DATE,'D')
    Y.PAY.DATE := @VM:Y.CH.PAY.DATE
    Y.DEP.NO := @VM:R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.DEPOSIT.NO>
    Y.SAM.INT.RATE = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.INTEREST.RATE>
    Y.SAM.INT.RATE = FMT(Y.SAM.INT.RATE,'L2#6')
    Y.INT.RATE := @VM:Y.SAM.INT.RATE
    Y.INT.VALUE := @VM:R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.INT.PAYMNT.AMT>
* Y.CUSTOMER.NAME := VM:R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.CLIENT.NAME>
    GET.INT.VAL = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.INT.PAYMNT.AMT>

* Fix for PACS00298102 [DEBIT ENTRIES SHOULD NOT BE RECORDED AS THIS IS RELATED TO TAX #3]

    GOSUB CALC.TAX.AMOUNT
    Y.TAX.VALUE : = @VM:TOT.TAX
    GET.TOT.VAL = GET.INT.VAL - TOT.TAX
    Y.TOT.INT.VAL += GET.TOT.VAL
    Y.TOT.ACCS<1,-1> = Y.DEP.NO
* End of Fix

RETURN

*----------------------------------------------------------------------------------------------------------------------
CALC.TAX.AMOUNT:
*----------------------------------------------------------------------------------------------------------------------

    R.AZ.ACCOUNT = ''
    GET.AZ.ACCOUNT.NO = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.DEPOSIT.NO>
    CALL F.READ(FN.AZ.ACCOUNT,GET.AZ.ACCOUNT.NO,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)

    TAX.CUST = R.AZ.ACCOUNT<AZ.CUSTOMER>
    SUBJECT.AMT = R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.INT.PAYMNT.AMT>
    TAX.CCY = R.AZ.ACCOUNT<AZ.CURRENCY>
    TAX.KEY = R.AZ.ACCOUNT<AZ.TAX.KEY>
    TOT.TAX = ''
    TAX.ACCT = ''
    TAX.RATE = ''

    CALL AZ.TAX.CALC(TAX.CUST,SUBJECT.AMT,TAX.CCY,TAX.KEY,TOT.TAX,TAX.ACCT,TAX.RATE)

RETURN

*-----------------------------------------------------------------------------
PROGRAM.END:

END
