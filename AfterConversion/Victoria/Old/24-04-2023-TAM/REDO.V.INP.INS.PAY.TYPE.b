$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.V.INP.INS.PAY.TYPE
*PACS00249234
************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.B2.FT.DATA


    Y.PAY.TYPE = R.NEW(PAY.DAT.PAYMENT.TYPE)

    IF Y.PAY.TYPE EQ 'CHEQUE' THEN
        Y.BEN = R.NEW(PAY.DAT.BEN.NAME)
        IF Y.BEN EQ '' THEN
            AF = PAY.DAT.BEN.NAME
            ETEXT = 'EB-BEN.MAND.CHEQ'
            CALL STORE.END.ERROR
        END
    END

    IF Y.PAY.TYPE EQ 'CREDITO' THEN
        Y.CR.AC = R.NEW(PAY.DAT.ACC.CREDIT)
        IF Y.CR.AC EQ '' THEN
            AF = PAY.DAT.ACC.CREDIT
            ETEXT = 'EB-CR.AC.MAND'
            CALL STORE.END.ERROR
        END
    END

RETURN

END
