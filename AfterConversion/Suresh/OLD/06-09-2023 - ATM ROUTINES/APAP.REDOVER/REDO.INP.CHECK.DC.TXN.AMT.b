* @ValidationCode : MjoxMzgzMTM2MzQ4OkNwMTI1MjoxNjgyNDEyMzMwMzc5OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.CHECK.DC.TXN.AMT
*----------------------------------------------------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Ganesh R
* PROGRAM NAME: REDO.POPULATE.FT.CREDIT.DETAILS
* ODR NO      : ODR-2011-03-0150
*----------------------------------------------------------------------------------------------------------------------
*DESCRIPTION: This routine is to get the FT details from a Work File REDO.AUTH.CODE.DETAILS and populate in Teller Version
*----------------------------------------------------------------------------------------------------------------------
*linked with :
*In parameter:
*Out parameter:
*----------------------------------------------------------------------------------------------------------------------
*Modification History
*  Date         Who                  Reference           Description
* 16 jan 2011   Ganesh R             ODR-2011-03-0150    Will Store the Detils
* 04-08-2013    Vignesh Kumaar M R   PACS00254281        NUMERO DE AUTORIZACION INCORRECTO
* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 FM to @FM, VM to @VM, SM to @SM
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_REDO.DEBIT.CARD.COMMON
    $INSERT I_F.ATM.REVERSAL
    IF V$FUNCTION NE 'R' THEN ;* PACS00633126
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END   ;* PACS00633126

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

    LOCAL.APP = 'TELLER'
    LOCAL.FIELD = 'L.TT.POS.AUTHNM':@VM:'L.TT.BENEFICIAR'
    LOCAL.REF.POS = ''

    CALL MULTI.GET.LOC.REF(LOCAL.APP,LOCAL.FIELD,LOCAL.REF.POS)
    L.AUTHNM.POS = LOCAL.REF.POS<1,1>
    L.BENEF.POS = LOCAL.REF.POS<1,2>
RETURN
**********
PROCESS:
**********
*Get the Value of Auth Code.

* Fix for PACS00254281 [NUMERO DE AUTORIZACION INCORRECTO]

*    Y.CCARD.NO = TEMP.VAR
    Y.CCARD.NO = System.getVariable("CURRENT.CARD.NUM")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN 		;*AUTO R22 CODE CONVERSION
        Y.CCARD.NO = "" 			;*AUTO R22 CODE CONVERSION
    END 					;*AUTO R22 CODE CONVERSION
    IF APPLICATION EQ 'TELLER' AND PGM.VERSION EQ ',REDO.CHQ.ADM.OTROS.TFR.CHQ' THEN

        Y.BENE = R.NEW(TT.TE.LOCAL.REF)<1,L.BENEF.POS>
        CHANGE @SM TO @FM IN Y.BENE

        IF NOT(Y.BENE<1>) THEN
            AF = TT.TE.LOCAL.REF
            AV = L.BENEF.POS
            AS = 1
            ETEXT = "AC-MAND.FLD"
            CALL STORE.END.ERROR
        END
    END

* End of Fix

    Y.AUTH.ID = R.NEW(TT.TE.LOCAL.REF)<1,L.AUTHNM.POS>
    Y.AUTH.ID = Y.CCARD.NO:'.':Y.AUTH.ID

    CALL F.READ(FN.ATM.REVERSAL,Y.AUTH.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERR)
    IF R.ATM.REVERSAL THEN
        GOSUB CHECK.PROCESS
    END ELSE
        AF = TT.TE.LOCAL.REF
        AV = L.AUTHNM.POS
        ETEXT = "EB-REDO.WRONG.AUTH.NUM"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
*Read the FT id and get the details

    Y.NET.AMOUNT =  R.NEW(TT.TE.NET.AMOUNT)
    Y.TRANSACTION.AMOUNT = R.ATM.REVERSAL<AT.REV.TRANSACTION.AMOUNT>

    IF Y.NET.AMOUNT NE Y.TRANSACTION.AMOUNT THEN
        ETEXT = 'EB-DEBIT.TOTAL.TXN.AMOUNT'
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
RETURN

*****************
CHECK.PROCESS:
*****************
    Y.WITHDRAW.STATUS = R.ATM.REVERSAL<AT.REV.WITHDRAW.STATUS>
    IF NOT(Y.WITHDRAW.STATUS) THEN
        Y.FT.ID = R.ATM.REVERSAL<AT.REV.TRANSACTION.ID>
    END ELSE
        AF = TT.TE.LOCAL.REF
        AV = L.AUTHNM.POS
        ETEXT = "EB-NUM.ALREADY.USED"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
RETURN
*************
PGM.END:
************
END
