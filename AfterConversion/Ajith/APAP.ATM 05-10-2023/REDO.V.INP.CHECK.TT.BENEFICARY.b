$PACKAGE APAP.ATM
* @ValidationCode : MjotMTU4MTczNzczNzpDcDEyNTI6MTY5NjM0MDI0NTQ3NjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Oct 2023 19:07:25
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


SUBROUTINE REDO.V.INP.CHECK.TT.BENEFICARY
 
*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Riyas
* PROGRAM NAME: REDO.V.INP.CHECK.TT.BENEFICARY
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is to make mandatory Beneficary field

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT

*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE        WHO                REFERENCE           DESCRIPTION
* 26.02.2013  Riyas              ODR-2009-12-0285    INITIAL CREATION
* 27/05/2013  Vignesh Kumaar R   PACS00280709        Validation on TT>AMOUNT with ATM>TXN.AMOUNT [REDELIVERING PACK]
*----------------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*11-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM,IF CONDITION ADDED
*11-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*--------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER

    $INSERT I_F.FUNDS.TRANSFER ;*
    $INSERT I_System ;*
    $INSERT I_F.ATM.REVERSAL ;*

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
******

    LREF.APP   = 'TELLER'
    LREF.FIELD = 'L.TT.BENEFICIAR':@VM:'L.TT.POS.AUTHNM':@VM:'L.FT.NOSTRO.ACC'
    LREF.POS   = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    BENEFICIARY.POS = LREF.POS<1,1>
    NOSTRO.ACC.POS = LREF.POS<1,3>

* Fix for PACS00280709 [Validation on TT>AMOUNT with ATM>TXN.AMOUNT]

    POS.AUTHNM = LREF.POS<1,2>

    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    F.ATM.REVERSAL = ''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

* End of Fix

RETURN

PROCESS:
*********

    Y.BENE = R.NEW(TT.TE.LOCAL.REF)<1,BENEFICIARY.POS>
    CHANGE @SM TO @FM IN Y.BENE

    IF NOT(Y.BENE<1>) THEN
        AF = TT.TE.LOCAL.REF
        AV = BENEFICIARY.POS
        AS = 1
        ETEXT = "AC-MAND.FLD"
        CALL STORE.END.ERROR
    END

    CALL TT.PERFORM.DEF.PROCESSING        ;* Fix for PACS00294719

* Fix for PACS00305984 [CASHIER DEAL SLIP PRINT OPTION]

    IF PGM.VERSION EQ ',REDO.AMD.CHQ.TAX' OR PGM.VERSION EQ ',REDO.CHQ.ADM.OTROS' OR PGM.VERSION EQ ',REDO.TDB.CHQ.GERENCIA' OR PGM.VERSION EQ ',REDO.CHEQUE.GOVERN.TAX.TRF.CHQ' OR PGM.VERSION EQ ',REDO.CHEQUE.GOVERN.TAX.TRF' OR PGM.VERSION EQ ',REDO.ADM.CHQ.NOTAX' THEN
        CALL System.setVariable("CURRENT.WTM.FIRST.ID",ID.NEW)
    END

    IF PGM.VERSION EQ ',REDO.CHQ.ADM.OTROS.TFR' THEN
        RETURN
    END

* End of Fix

* Fix for PACS00280709 [Validation on TT>AMOUNT with ATM>TXN.AMOUNT]

    Y.AUTH.NUM = R.NEW(TT.TE.LOCAL.REF)<1,POS.AUTHNM>

    IF Y.AUTH.NUM THEN
        Y.CCARD.NO = System.getVariable("CURRENT.CARD.NUM")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION.START
            Y.CCARD.NO = "" ;*R22 AUTO CODE CONVERSION
        END  ;*R22 AUTO CODE CONVERSION.END
        Y.ATM.ID = Y.CCARD.NO:'.':Y.AUTH.NUM

        CALL F.READ(FN.ATM.REVERSAL,Y.ATM.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERR)
        IF R.ATM.REVERSAL THEN
            Y.ATM.DEBIT.AMT = R.ATM.REVERSAL<AT.REV.TXN.AMOUNT>
            Y.TT.NET.AMOUNT = R.NEW(TT.TE.NET.AMOUNT)

            IF Y.ATM.DEBIT.AMT NE Y.TT.NET.AMOUNT THEN
                AF = TT.TE.AMOUNT.LOCAL.1
                ETEXT = "EB-REDO.ATM.TXN.AMT.CHECK"
                CALL STORE.END.ERROR
            END

            Y.WITHDRAW.STATUS = R.ATM.REVERSAL<AT.REV.WITHDRAW.STATUS>

            IF Y.WITHDRAW.STATUS THEN
                AF = TT.TE.LOCAL.REF
                AV = POS.AUTHNM
                ETEXT = "EB-NUM.ALREADY.USED"
                CALL STORE.END.ERROR
            END

            Y.FT.ID = R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>
            R.FUNDS.TRANSFER = ''
            CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.ERR)

            IF R.FUNDS.TRANSFER ELSE
                AF = TT.TE.LOCAL.REF
                AV = POS.AUTHNM
                ETEXT = "EB-REDO.WRONG.AUTH.NUM"
                CALL STORE.END.ERROR
            END

        END ELSE
            AF = TT.TE.LOCAL.REF
            AV = POS.AUTHNM
            ETEXT = "EB-REDO.WRONG.AUTH.NUM"
            CALL STORE.END.ERROR
        END

        IF (PGM.VERSION NE ',REDO.TDB.CHQ.GERENCIA') AND R.NEW(TT.TE.LOCAL.REF)<1,NOSTRO.ACC.POS> THEN
            R.NEW(TT.TE.ACCOUNT.1)  = R.NEW(TT.TE.LOCAL.REF)<1,NOSTRO.ACC.POS>
        END
    END

* End of Fix

RETURN
*----------------------------------------------------------------------------------------------------------------------
END
