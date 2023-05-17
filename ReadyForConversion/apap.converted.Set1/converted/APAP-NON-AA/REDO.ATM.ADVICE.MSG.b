SUBROUTINE REDO.ATM.ADVICE.MSG

**************************************************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Balagurunathan B
* PROGRAM NAME: REDO.ATM.ADVICE.MSG
* ODR NO      : ODR-2010-08-0469
*-----------------------------------------------------------------------------------------------------
*DESCRIPTION: It is a pre-Authorised message .In T24 only reference transaction will be stored
*The below routine will be attached to FT version to reject the transaction with response code NE 00
*Error message raised will be mapped with response code 00
*This will be attached as CHECK REC routine of FT version attached in 0220xxxxxx

*******************************************************************************************************
*linked with :VERSIONS
*In parameter:
*Out parameter:
*****************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AT.ISO.COMMON
    $INSERT I_F.REDO.CARD.BIN

    GOSUB OPEN.FILES

    IF AT$INCOMING.ISO.REQ(39) NE '00' THEN
        E="REJECTED ADVICE"
    END

    IF R.REDO.CARD.BIN AND AT$INCOMING.ISO.REQ(39) NE '55' THEN

        IF R.REDO.CARD.BIN<REDO.CARD.BIN.BIN.TYPE> EQ 'DEBIT' AND R.REDO.CARD.BIN<REDO.CARD.BIN.BIN.OWNER> EQ 'APAP' THEN

            E='APPROVED ADVICE'

        END

    END

    IF AT$INCOMING.ISO.REQ(1) EQ '0220' THEN
        BEGIN CASE

            CASE AT$INCOMING.ISO.REQ(3)[1,2] EQ '01'
                TXN.SOURCE='APAP ATM'
            CASE AT$INCOMING.ISO.REQ(3)[1,2] EQ '15'
                TXN.SOURCE='APAP POS TELLER'
            CASE OTHERWISE
                TXN.SOURCE='APAP POS'
        END CASE
    END



RETURN


OPEN.FILES:

    FN.REDO.CARD.BIN='F.REDO.CARD.BIN'
    F.REDO.CARD.BIN=''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)
    BIN.CARD.NO= AT$INCOMING.ISO.REQ(2)[1,6]
    R.REDO.CARD.BIN =''
    CALL F.READ(FN.REDO.CARD.BIN,BIN.CARD.NO,R.REDO.CARD.BIN,F.REDO.CARD.BIN,ERR.FILE)

RETURN


END
