* @ValidationCode : MjoxNDM1MTU0MjU0OkNwMTI1MjoxNjkwMTc2OTEzMTM3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 11:05:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.POPULATE.FT.CREDIT.DETAILS
    
**************************************************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Ganesh R
* PROGRAM NAME: REDO.POPULATE.FT.CREDIT.DETAILS
* ODR NO      : ODR-2011-03-0150
*-----------------------------------------------------------------------------------------------------
*DESCRIPTION: This routine is to get the FT details from a Work File REDO.AUTH.CODE.DETAILS and populate in Teller Version
*******************************************************************************************************
*linked with :
*In parameter:
*Out parameter:
*****************************************************************************************************
*Modification History
*  Date       Who                 Reference           Description
* 16 jan 2011 Ganesh R            ODR-2011-03-0150    Will Store the Detils
* 30 MAR 2013 Arundev             PACS00254620        account default changes
* 10 MAY 2013 Vignesh Kumaar R    PACS00251021        DO NOT ALLOW REUSE THE AUTHORIZATION OF POS
* 29 AUG 2013 Vignesh Kumaar R    PACS00314147        ACCOUNT SHOULDN'T BE AUTOPOPULATED [DISCUSSED WITH BALA/MARIROSA]
*13/07/2023   CONVERSION TOOL                         AUTO R22 CODE CONVERSION -VM TO @VM
*13/07/2023    VIGNESHWARI          	              MANUAL R22 CODE CONVERSION - call routine modified
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_REDO.DEBIT.CARD.COMMON
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.AT.POS.MERCHANT.ACCT ;*

    IF OFS$HOT.FIELD EQ 'L.TT.POS.AUTHNM' THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END
    GOSUB PGM.END
RETURN
************
OPEN.FILES:
************
    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    F.ATM.REVERSAL  = ''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    LREF.APP   = 'TELLER'
    LREF.FIELD = 'L.FT.NOSTRO.ACC':@VM:'L.TT.CLIENT.COD':@VM:'L.TT.CLIENT.NME'
    LREF.POS   = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    NOSTRO.ACC.POS = LREF.POS<1,1>
    POS.CLIENT.COD = LREF.POS<1,2>
    POS.CLIENT.NME = LREF.POS<1,3>

RETURN
**********
PROCESS:
**********
*Get the Value of Auth Code

* Fix for PACS00251021 [DO NOT ALLOW REUSE THE AUTHORIZATION OF POS]

*    Y.CCARD.NO = TEMP.VAR
    Y.CCARD.NO = System.getVariable("CURRENT.CARD.NUM")

    FN.REDO.CASHIER.DEALSLIP.INFO = 'F.REDO.CASHIER.DEALSLIP.INFO'
    F.REDO.CASHIER.DEALSLIP.INFO = ''
    CALL OPF(FN.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO)

    R.REDO.CASHIER.DEALSLIP.INFO = Y.CCARD.NO
    WRITE R.REDO.CASHIER.DEALSLIP.INFO ON F.REDO.CASHIER.DEALSLIP.INFO, COMI

* End of Fix

    Y.AUTH.ID = COMI
    Y.AUTH.ID = Y.CCARD.NO:'.':Y.AUTH.ID

    Y.DR.CR.MARKER = R.NEW(TT.TE.DR.CR.MARKER)
    CALL F.READ(FN.ATM.REVERSAL,Y.AUTH.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERR)
    IF R.ATM.REVERSAL THEN
        GOSUB CHECK.PROCESS
    END ELSE
        ETEXT = "EB-REDO.WRONG.AUTH.NUM"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END

*Read the FT id and get the details

    CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.ERR)
    IF R.FUNDS.TRANSFER THEN
        Y.DEBIT.ACCOUNT = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
        Y.ACC.ID        = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
        Y.DEBIT.AMOUNT  = R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
        IF NOT(Y.DEBIT.AMOUNT) THEN
            Y.DEBIT.AMOUNT = R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>
            Y.DEBIT.CCY    = R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>
        END
        Y.DEBIT.CCY     = R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>

*PACS00254620-start
        IF (PGM.VERSION EQ ',REDO.CHEQUE.GOVERN.NOTAX.TRF.CHQ') THEN
            IF Y.DR.CR.MARKER EQ 'DEBIT' THEN
*                R.NEW(TT.TE.ACCOUNT.1)  = Y.DEBIT.ACCOUNT ;* Fix for PACS00314147
                R.NEW(TT.TE.CURRENCY.1) = Y.DEBIT.CCY
            END ELSE
*                R.NEW(TT.TE.ACCOUNT.2)  = Y.DEBIT.ACCOUNT ;* Fix for PACS00314147
                R.NEW(TT.TE.CURRENCY.2) = Y.DEBIT.CCY
            END
        END ELSE
*PACS00254620-end
*            R.NEW(TT.TE.ACCOUNT.1)  = Y.DEBIT.ACCOUNT       ;* Fix for PACS00314147
            R.NEW(TT.TE.CURRENCY.1) = Y.DEBIT.CCY
        END

        IF (PGM.VERSION NE ',REDO.TDB.CHQ.GERENCIA' AND PGM.VERSION NE ',REDO.CHEQUE.GOVERN.NOTAX.TRF.CHQ') THEN

            IF Y.DEBIT.CCY EQ LCCY THEN
                R.NEW(TT.TE.AMOUNT.LOCAL.2) = Y.DEBIT.AMOUNT
                R.NEW(TT.TE.AMOUNT.LOCAL.1) = Y.DEBIT.AMOUNT
            END ELSE
                R.NEW(TT.TE.AMOUNT.FCY.2) = Y.DEBIT.AMOUNT
                R.NEW(TT.TE.AMOUNT.FCY.1) = Y.DEBIT.AMOUNT
            END
        END

        IF (PGM.VERSION EQ ',REDO.TDB.CHQ.GERENCIA') THEN
            R.NEW(TT.TE.ACCOUNT.1)  = R.NEW(TT.TE.LOCAL.REF)<1,NOSTRO.ACC.POS>
        END

* Fix for PACS00314147 [ACCOUNT SHOULDN'T BE AUTOPOPULATED]

        IF PGM.VERSION EQ ',REDO.TDEB.CUENTA' OR PGM.VERSION EQ ',REDO.CHEQUE.GOVERN.NOTAX.TRF.CHQ' THEN
            Y.TERM.ID = R.ATM.REVERSAL<AT.REV.TERM.ID>
            FN.AT.POS.MERCHANT.ACCT = 'F.AT.POS.MERCHANT.ACCT'
            F.AT.POS.MERCHANT.ACCT = ''
            CALL OPF(FN.AT.POS.MERCHANT.ACCT,F.AT.POS.MERCHANT.ACCT)
            CALL F.READ(FN.AT.POS.MERCHANT.ACCT,Y.TERM.ID,R.AT.POS.MERCHANT.ACCT,F.AT.POS.MERCHANT.ACCT,POS.ERR)
            GET.ACCOUNT.NUMB = R.AT.POS.MERCHANT.ACCT<AT.PMA.MERCHANT.ACCT.NO>
            R.NEW(TT.TE.ACCOUNT.2) = GET.ACCOUNT.NUMB
        END

* End of Fix

    END ELSE
        ETEXT = "EB-REDO.WRONG.AUTH.NUM"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    Y.CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    R.NEW(TT.TE.CUSTOMER.2) = Y.CUSTOMER.ID
    R.NEW(TT.TE.LOCAL.REF)<1,POS.CLIENT.COD> = Y.CUSTOMER.ID

    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    R.NEW(TT.TE.LOCAL.REF)<1,POS.CLIENT.NME> = R.CUSTOMER<EB.CUS.SHORT.NAME>

    IF (PGM.VERSION EQ ',REDO.CHEQUE.GOVERN.NOTAX.TRF.CHQ') THEN

        APAP.TAM.redoHandleCommTaxFields();*MANUAL R22 CODE CONVERSION
        
    END

RETURN

*****************
CHECK.PROCESS:
*****************
    Y.WITHDRAW.STATUS = R.ATM.REVERSAL<AT.REV.WITHDRAW.STATUS>
    IF NOT(Y.WITHDRAW.STATUS) THEN
        Y.FT.ID = R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>
    END ELSE
        ETEXT = "EB-NUM.ALREADY.USED"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
RETURN
*************
PGM.END:
************
END
