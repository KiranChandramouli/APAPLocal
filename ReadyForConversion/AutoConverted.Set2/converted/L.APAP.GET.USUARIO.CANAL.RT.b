SUBROUTINE L.APAP.GET.USUARIO.CANAL.RT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

    Y.NUM.TXN = COMI

    GOSUB INIT
    GOSUB PROCESS

    COMI = Y.USER.ID

RETURN

*---------------
INIT:
*---------------
    Y.USER.ID = ''

    APPLS = 'FUNDS.TRANSFER'
    F.FIELDS = 'L.CHANNEL.USER':@VM:'L.INP.USER.ID'

    CALL MULTI.GET.LOC.REF(APPLS,F.FIELDS,POS.VAL)

    POS.CHANNEL.USER = POS.VAL<1,1>
    POS.INP.USER.ID = POS.VAL<1,2>

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'; F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

RETURN

*---------------
PROCESS:
*---------------
    CALL F.READ(FN.FUNDS.TRANSFER, Y.NUM.TXN, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER, ERR.FT)

    IF NOT(ERR.FT) THEN
        Y.CHANNEL.USER = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.CHANNEL.USER>
        Y.INP.USER.ID = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.INP.USER.ID>

        IF Y.CHANNEL.USER NE '' THEN
            Y.USER.ID = Y.CHANNEL.USER
        END ELSE
            Y.USER.ID = Y.INP.USER.ID
        END
    END

RETURN
END