SUBROUTINE REDO.CCY.MKT.FXSN.VALIDATE

*------------------------------------------------------------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Chandra Prakash T
* Program Name  : REDO.V.ANC.FXSN.VAL
*------------------------------------------------------------------------------------------------------------------------------------------------------
*Description    : This VALIDATE routine to validate the TELLER applications are provided along with TELLER VERSION and TELLER.TRANSACTION codes and for
*                 non-TELLER applications, the CURRENCY MARKET requires to be entered
* In parameter  : None
* out parameter : None
*------------------------------------------------------------------------------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 15-Sep-2010      Chandra Prakash T  ODR-2010-09-0014  Change Request CR 023 - CURRENCY MARKET & Exchange Rates
*------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.REDO.CCY.MKT.FXSN

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    CCY.MKT.CODES = R.NEW(REDO.CMKT.CCY.MKT.CODE)
    CCY.MKT.CODES.TOTAL = DCOUNT(CCY.MKT.CODES,@VM)

    CCY.MARKETS = R.NEW(REDO.CMKT.CCY.MKT)
    TT.VERSIONS = R.NEW(REDO.CMKT.TT.VERSION)
    TT.VER.CODES = R.NEW(REDO.CMKT.TT.TRANS.CODE)

    CCY.MKT.CNT = 1
    LOOP
    WHILE CCY.MKT.CNT LE CCY.MKT.CODES.TOTAL
        CURR.CCY.MKT.CODE = CCY.MKT.CODES<1,CCY.MKT.CNT>
        CURR.TT.VERSION = TT.VERSIONS<1,CCY.MKT.CNT>
        TT.VER.CODE = TT.VER.CODES<1,CCY.MKT.CNT>
        CCY.MARKET = CCY.MARKETS<1,CCY.MKT.CNT>

        IF CURR.CCY.MKT.CODE[1,2] EQ "TT" THEN
            IF CURR.TT.VERSION EQ "" OR  TT.VER.CODE EQ "" THEN
                AF = REDO.CMKT.TT.VERSION
                AV = CCY.MKT.CNT
                ETEXT = "EB-VERSION.CODE.MAND"
                CALL STORE.END.ERROR
            END
            IF CURR.TT.VERSION NE "" AND CURR.TT.VERSION[1,6] NE "TELLER" THEN
                AF = REDO.CMKT.TT.VERSION
                AV = CCY.MKT.CNT
                ETEXT = "EB-TT.VERSIONS.ONLY"
                CALL STORE.END.ERROR
            END
            IF TT.VER.CODE NE "" THEN
                R.TELLER.TRANSACTION = ''
                TELLER.TRANSACTION.ERR = ''
                CALL CACHE.READ(FN.TELLER.TRANSACTION, TT.VER.CODE, R.TELLER.TRANSACTION, TELLER.TRANSACTION.ERR)
                R.NEW(REDO.CMKT.CCY.MKT)<1,CCY.MKT.CNT> = R.TELLER.TRANSACTION<TT.TR.CURR.MKT.1>
            END
        END

        IF CURR.CCY.MKT.CODE[1,2] NE "TT" AND CCY.MARKET EQ "" THEN
            AF = REDO.CMKT.CCY.MKT
            AV = CCY.MKT.CNT
            ETEXT = "EB-CCY.MKT.MAND"
            CALL STORE.END.ERROR
        END

        IF CURR.CCY.MKT.CODE[1,2] NE "TT" AND (CURR.TT.VERSION NE "" OR TT.VER.CODE NE "") THEN
            AF = REDO.CMKT.CCY.MKT.CODE
            AV = CCY.MKT.CNT
            ETEXT = "EB-VERSION.CODE.NOT.ALLOW"
            CALL STORE.END.ERROR
        END
        CCY.MKT.CNT += 1
    REPEAT
RETURN
END
