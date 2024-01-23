* @ValidationCode : Mjo3MDMxNDc1MDg6Q3AxMjUyOjE3MDQ0MzI2MDA0Mjc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2024 11:00:00
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REGEN.NAB.ACCOUNTING(ARR.ID)
*--------------------------------------------------------
*Description: This is batch routine to raise the reverse accounting entries
* for NAB accounting
*--------------------------------------------------------
*Input Arg  : N/A
*Out   Arg  : N/A
*Deals With : NAB Accounting
*--------------------------------------------------------
* Date           Name               Dev Ref.                         Comments
* 16 Oct 2012   H Ganesh      NAB Accounting-PACS00202156     Initial Draft
* 04-APR-2023  Conversion tool   R22 Auto conversion      FM TO @FM, VM to @VM, SM to @SM, ++ to +=
* 04-APR-2023    Harishvikram C   Manual R22 conversion     CALL routine format modified
*18/01/2024         Suresh        R22 UTILITY AUTO CONVERSION   Change F.READ to F.READU
*--------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.REDO.AA.INT.CLASSIFICATION
    $INSERT I_REDO.B.REGEN.NAB.ACCOUNTING.COMMON
    $INSERT I_F.REDO.AA.NAB.HISTORY
    $USING APAP.TAM
    $USING AC.API
    $USING ST.CompanyCreation

    GOSUB PROCESS
RETURN
*--------------------------------------------------------
PROCESS:
*--------------------------------------------------------

    CALL OCOMO('Processing the Arrangement: ':ARR.ID)

*    CALL F.READ(FN.REDO.AA.NAB.HISTORY,ARR.ID,R.REDO.AA.NAB.HISTORY,F.REDO.AA.NAB.HISTORY,NAB.ERR)
    CALL F.READU(FN.REDO.AA.NAB.HISTORY,ARR.ID,R.REDO.AA.NAB.HISTORY,F.REDO.AA.NAB.HISTORY,NAB.ERR,'');* R22 UTILITY AUTO CONVERSION
    Y.PAID.DATE = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.LAST.PAY.DATE>
    Y.STA = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.STATUS>
    GOSUB GET.ACCOUNTING.AMT    ;* Here we will calculate the amount for NAB accounting reversal.
    IF Y.NAB.AMT THEN
        GOSUB FORM.ENTRIES
*R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACC.AMT.SETLED> = ''

        CALL F.WRITE(FN.REDO.AA.NAB.HISTORY,ARR.ID,R.REDO.AA.NAB.HISTORY)

    END ELSE
        CALL OCOMO("No NAB Accounting reversal raised - ":ARR.ID)
    END
RETURN
*------------------------------------------------------------
GET.ACCOUNTING.AMT:
*------------------------------------------------------------
    IN.ACC.ID = ''
*APAP.TAM.REDO.CONVERT.ACCOUNT(IN.ACC.ID,ARR.ID,OUT.ID,ERR.TEXT);*Manual R22 conversion
    APAP.TAM.redoConvertAccount(IN.ACC.ID,ARR.ID,OUT.ID,ERR.TEXT);*Manual R22 conversion
    CALL F.READ(FN.ACCOUNT,OUT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    Y.ACCRUED.AMT = ''
    Y.BILL.IDS = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.BILL.ID>
    Y.BILL.CNT =DCOUNT(Y.BILL.IDS,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.BILL.CNT
        IF R.ACCOUNT<AC.LOCAL.REF,POS.L.OD.STATUS> EQ 'NAB' THEN          ;* when loan is in NAB, then we will reverse the NAB accounting based on repayment amount.
            Y.INTEREST = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.INT.PAID,Y.VAR1>
            Y.NAB.AMT += R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.INT.PAID,Y.VAR1> - R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACCT.AMT.RAISED,Y.VAR1>
            R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACCT.AMT.RAISED,Y.VAR1> = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.INT.PAID,Y.VAR1>
        END ELSE        ;* When loan is out of NAB, then we need to reverse the whole interest amount.
            Y.INTEREST = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.INT.AMT,Y.VAR1>
            Y.NAB.AMT += R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.INT.AMT,Y.VAR1> - R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACCT.AMT.RAISED,Y.VAR1>
            R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACCT.AMT.RAISED,Y.VAR1> = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.INT.AMT,Y.VAR1>
        END
        CALL OCOMO("Processing the bill ":FIELD(Y.BILL.IDS<1,Y.VAR1>,"-",1):"-> of NAB Amount -> [":Y.NAB.AMT:"] -> Settled amt -> ":Y.INTEREST)
        Y.VAR1 += 1
    REPEAT
    IF R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACC.AMT> THEN
        Y.ACCRUED.AMT = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACC.AMT>
    END ELSE
        Y.ACCRUED.AMT = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACC.AMT.SETLED>
    END

    IF Y.ACCRUED.AMT THEN
        GOSUB CALC.ACCRUED.AMT
        Y.NAB.AMT += Y.ACC.INT.PAID - R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACCRUED.AMT.RAISED>

        R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACCRUED.AMT.RAISED> = Y.ACC.INT.PAID
        CALL OCOMO("Accrued interest -> [":Y.NAB.AMT:"]->":R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACCRUED.AMT.RAISED>)
    END


RETURN
*--------------------------------------------------------
CALC.ACCRUED.AMT:
*--------------------------------------------------------
* Here we will check whether loan is out of NAB then accrued interest will reversed else we will check whether accrured interest
* bill has been settled. based on that we will calculated the balance amount.
    Y.ACC.INT.PAID = 0
    Y.ACC.INT.STATUS = ''
    IF R.ACCOUNT<AC.LOCAL.REF,POS.L.OD.STATUS> NE 'NAB' THEN  ;* If loan is out of NAB then accrued interest in paid.
        Y.ACC.INT.STATUS = 'PAID'
    END ELSE
        GOSUB CHECK.NEXT.BILL     ;* check whether accrued interest bill is settled or not.
    END
    IF Y.ACC.INT.STATUS EQ 'PAID' THEN
        CALL OCOMO("Accrued interest Settled")
        Y.ACC.INT.PAID = Y.ACCRUED.AMT
    END ELSE
        Y.ACC.INT.PAID = 0
        CALL OCOMO("Accrued interest Pending")
    END

RETURN
*--------------------------------------------------------
CHECK.NEXT.BILL:
*--------------------------------------------------------
    Y.SSET = ''
    ACCR.BIL.DATE = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.NXT.BILL.DATE>
    ACCR.AMT      = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.ACC.AMT>
    IF ACCR.BIL.DATE NE '' AND ACCR.AMT NE '' THEN

        CALL F.READ(FN.AA.ACCT.DET,ARR.ID,R.AA.ACCT.DET,F.AA.ACCT.DET,ACCC.ERR)
        AA.BILS = R.AA.ACCT.DET<AA.AD.BILL.ID>
        AA.BILS = CHANGE(AA.BILS,@VM,@FM)
        AA.BILS = CHANGE(AA.BILS,@SM,@FM)
        Y.AR.CNT = DCOUNT(AA.BILS,@FM); Y.AR = ''
        LOOP
        WHILE Y.AR.CNT GT 0 DO
            Y.AR += 1
            Y.AR.BIL = AA.BILS<Y.AR>
            CALL F.READ(FN.AA.BILL.DETAILS,Y.AR.BIL,R.AA.BILL.AR,F.AA.BILL.DETAILS,BL.ER)
            Y.PAY.AR.DATE = R.AA.BILL.AR<AA.BD.PAYMENT.DATE>
            IF Y.PAY.AR.DATE EQ ACCR.BIL.DATE THEN
                LOCATE 'PRINCIPALINT' IN R.AA.BILL.AR<AA.BD.PROPERTY,1> SETTING POS.ARS THEN
                    Y.OS.AR.AMT = R.AA.BILL.AR<AA.BD.OS.PROP.AMOUNT,POS.ARS>
                    IF Y.OS.AR.AMT LE 0 THEN
                        Y.SSET = 'Y'
                        Y.AR.CNT = 0
                    END
                END
            END
            Y.AR.CNT -= 1
        REPEAT

    END
    IF Y.SSET EQ 'Y' THEN
        Y.ACC.INT.STATUS = 'PAID'
    END

RETURN
*--------------------------------------------------------
FORM.ENTRIES:
*--------------------------------------------------------

    CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    Y.LOAN.ACC = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    Y.LOAN.COMP= R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
    Y.LOAN.CUR = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>

    CALL F.READ(FN.ACCOUNT,Y.LOAN.ACC,R.ACC,F.ACCOUNT,ACC.ERRR)
    Y.LOAN.CATEG = R.ACC<AC.CATEGORY>

    GOSUB BEFORE.RAISE.ENTRIES

    CALL F.READ(FN.REDO.CONCAT.ACC.NAB,Y.LOAN.ACC,R.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB,CNCT.ERR)
    IF R.REDO.CONCAT.ACC.NAB THEN
        Y.NEW.AC = R.REDO.CONCAT.ACC.NAB<1>
        CALL F.READ(FN.ACCOUNT,Y.NEW.AC,R.CONT.ACC,F.ACCOUNT,ACC.ERR)
        GOSUB RAISE.ENTRIES
    END

RETURN
*--------------------------------------------------------
BEFORE.RAISE.ENTRIES:
*--------------------------------------------------------

    Y.INTERNAL.ACC = ''
    LOCATE Y.LOAN.CATEG IN R.REDO.AA.INT.CLASSIFICATION<REDO.INT.CLASS.PROD.CATEGORY,1> SETTING POS.CMP THEN
        LOCATE Y.LOAN.CUR IN R.REDO.AA.INT.CLASSIFICATION<REDO.INT.CLASS.CURRENCY,POS.CMP,1> SETTING POS.CUR THEN
            Y.INTERNAL.ACC = R.REDO.AA.INT.CLASSIFICATION<REDO.INT.CLASS.DEBIT.INT.ACCOUNT,POS.CMP,POS.CUR>
        END
    END ELSE
        CALL OCOMO('Product category not parameterized ':ARR.ID)
        GOSUB END1
    END
    IF Y.INTERNAL.ACC THEN
        Y.LOAN.CO.CODE = Y.LOAN.COMP
*APAP.TAM.REDO.NAB.CREATE.INT.ACC(Y.LOAN.CO.CODE,Y.INTERNAL.ACC,Y.RET.INT.ACC);*Manual R22 conversion
        APAP.TAM.redoNabCreateIntAcc(Y.LOAN.CO.CODE,Y.INTERNAL.ACC,Y.RET.INT.ACC);*Manual R22 conversion
        Y.INTERNAL.ACC = Y.RET.INT.ACC
        CALL F.READ(FN.ACCOUNT,Y.INTERNAL.ACC,R.INT.ACC,F.ACCOUNT,ACC.ERR)
        IF R.INT.ACC ELSE
            CALL OCOMO('Internal Account not created - ':ARR.ID)
            GOSUB END1
        END
    END ELSE
        CALL OCOMO('Internal Account not parameterized ':ARR.ID)
        GOSUB END1

    END

RETURN
*------------------------------------------------------
RAISE.ENTRIES:
*------------------------------------------------------

    R.DR.STMT.ENTRY = ''
    R.STMT.ENTRY    = ''
    R.CR.STMT.ENTRY = ''

    R.DR.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>    = Y.INTERNAL.ACC
    R.DR.STMT.ENTRY<AC.STE.COMPANY.CODE>      = R.INT.ACC<AC.CO.CODE>
    R.DR.STMT.ENTRY<AC.STE.AMOUNT.LCY>        = -1*Y.NAB.AMT
    R.DR.STMT.ENTRY<AC.STE.TRANSACTION.CODE>  = '1'
    R.DR.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY>  = R.INT.ACC<AC.CATEGORY>
    R.DR.STMT.ENTRY<AC.STE.VALUE.DATE>        = TODAY
    R.DR.STMT.ENTRY<AC.STE.CURRENCY>          = R.INT.ACC<AC.CURRENCY>
    R.DR.STMT.ENTRY<AC.STE.OUR.REFERENCE>     = R.INT.ACC<AC.CO.CODE>
    R.DR.STMT.ENTRY<AC.STE.EXPOSURE.DATE>     = TODAY
    R.DR.STMT.ENTRY<AC.STE.CURRENCY.MARKET>   = '1'
    R.DR.STMT.ENTRY<AC.STE.TRANS.REFERENCE>   = Y.NEW.AC
    R.DR.STMT.ENTRY<AC.STE.SYSTEM.ID>         = 'AC'
    R.DR.STMT.ENTRY<AC.STE.BOOKING.DATE>      = TODAY

    CHANGE @FM TO @SM IN R.DR.STMT.ENTRY
    CHANGE @SM TO @VM IN R.DR.STMT.ENTRY

    R.STMT.ENTRY<-1> = R.DR.STMT.ENTRY

    R.CR.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>   = Y.NEW.AC
    R.CR.STMT.ENTRY<AC.STE.COMPANY.CODE>     = R.CONT.ACC<AC.CO.CODE>
    R.CR.STMT.ENTRY<AC.STE.AMOUNT.LCY>       = Y.NAB.AMT
    R.CR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = '51'
    R.CR.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> = R.CONT.ACC<AC.CATEGORY>
    R.CR.STMT.ENTRY<AC.STE.VALUE.DATE>       = TODAY
    R.CR.STMT.ENTRY<AC.STE.CURRENCY>         = R.CONT.ACC<AC.CURRENCY>
    R.CR.STMT.ENTRY<AC.STE.OUR.REFERENCE>    = R.CONT.ACC<AC.CO.CODE>
    R.CR.STMT.ENTRY<AC.STE.EXPOSURE.DATE>    = TODAY
    R.CR.STMT.ENTRY<AC.STE.CURRENCY.MARKET>  = '1'
    R.CR.STMT.ENTRY<AC.STE.TRANS.REFERENCE>  = Y.NEW.AC
    R.CR.STMT.ENTRY<AC.STE.SYSTEM.ID>        = 'AC'
    R.CR.STMT.ENTRY<AC.STE.BOOKING.DATE>     = TODAY

    CHANGE @FM TO @SM IN R.CR.STMT.ENTRY
    CHANGE @SM TO @VM IN R.CR.STMT.ENTRY

    R.STMT.ENTRY<-1> = R.CR.STMT.ENTRY

    IF Y.LOAN.COMP THEN
*        CALL LOAD.COMPANY(Y.LOAN.COMP)
        ST.CompanyCreation.LoadCompany(Y.LOAN.COMP);* R22 UTILITY AUTO CONVERSION
    END

    ACC.PRODUCT = 'AC'
    ACC.TYPE    = 'SAO'         ;*Automatically overridden when an override conditions

*    CALL EB.ACCOUNTING(ACC.PRODUCT,ACC.TYPE,R.STMT.ENTRY,'')  ;* Raise accounting for Consolidated
    AC.API.EbAccounting(ACC.PRODUCT,ACC.TYPE,R.STMT.ENTRY,'')  ;* Raise accounting for Consolidated;* R22 UTILITY AUTO CONVERSION
    CALL OCOMO('Processed the Arrangement: ':ARR.ID)

RETURN
*------------------------------------------
END1:
END
