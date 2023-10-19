* @ValidationCode : MjoxMjU1MzI1MzgzOkNwMTI1MjoxNjkzOTAyMjU0NjU0OnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Sep 2023 13:54:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.UPD.ATM.WITHDRAW.STATUS

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
* 25/03/2013  Sudharsanan                            INITIAL CREATION
* 27/05/2013  Vignesh Kumaar R   PACS00280709        TO UPDATE THE STATUS IN ATM.REVERSAL TABLE
* 24 AUG 2017 PACS00618031 Authorization issue
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          VM TO @VM,IF CONDITION ADDED
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_REDO.DEBIT.CARD.COMMON
    $INSERT I_System          ;*

    GOSUB INIT
    GOSUB PROCESS

********
INIT:
********
    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    F.ATM.REVERSAL = ''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    LRF.APP = 'TELLER'
    LRF.FLD = 'L.TT.CR.CARD.NO':@VM:'L.TT.POS.AUTHNM':@VM:'L.TT.CR.ACCT.NO'
    LRF.POS = ''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FLD,LRF.POS)

    POS.CR.CARD = LRF.POS<1,1>
    POS.AUTHNM  = LRF.POS<1,2>
    YL.TT.CR.ACCT.NO = LRF.POS<1,3>
RETURN

*********
PROCESS:
*********
    Y.CR.CARD = TEMP.VAR
    Y.AUTHNM  = R.NEW(TT.TE.LOCAL.REF)<1,POS.AUTHNM>
    IF NOT(Y.CR.CARD) THEN
        Y.CR.CARD = R.NEW(TT.TE.LOCAL.REF)<1,YL.TT.CR.ACCT.NO>
    END

* Fix for PACS00280709 [TO UPDATE THE STATUS IN ATM.REVERSAL TABLE]

    IF LEN(Y.CR.CARD) NE 16 THEN

        FN.REDO.CASHIER.DEALSLIP.INFO = 'F.REDO.CASHIER.DEALSLIP.INFO'
        F.REDO.CASHIER.DEALSLIP.INFO = ''
        CALL OPF(FN.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO)

        CALL F.READ(FN.REDO.CASHIER.DEALSLIP.INFO,Y.AUTHNM,R.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO,R.REDO.CASHIER.DEALSLIP.INFO.ERR)
        IF R.REDO.CASHIER.DEALSLIP.INFO THEN      ;* Tus End
            Y.CR.CARD = R.REDO.CASHIER.DEALSLIP.INFO
        END


        IF NOT(Y.CR.CARD) THEN
            Y.CR.CARD = System.getVariable("CURRENT.CARD.NUM")
            IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
                Y.CR.CARD = ""
            END ;*AUTO R22 CODE CONVERSION - END

        END
    END

* End of Fix

    Y.ATM.ID = Y.CR.CARD:'.':Y.AUTHNM

    CALL F.READ(FN.ATM.REVERSAL,Y.ATM.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERR)
    IF R.ATM.REVERSAL THEN
        R.ATM.REVERSAL<AT.REV.WITHDRAW.STATUS> = 'PROCESSED'
        CALL F.WRITE(FN.ATM.REVERSAL,Y.ATM.ID,R.ATM.REVERSAL)
        IF R.REDO.CASHIER.DEALSLIP.INFO THEN
            CALL F.DELETE(FN.REDO.CASHIER.DEALSLIP.INFO,Y.AUTHNM)     ;*Tus End
        END
    END
    R.NEW(TT.TE.LOCAL.REF)<1,YL.TT.CR.ACCT.NO> = ''
RETURN

END
