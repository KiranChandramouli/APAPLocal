*-----------------------------------------------------------------------------
* @(#) L.APAP.RTN.VAL.REST.LIST Ported to jBASE 16:16:59  28 NOV 2017
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.RTN.VAL.REST.LIST
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT TAM.BP I_F.REDO.ID.CARD.CHECK
    $INSERT T24.BP I_F.CUSTOMER

    Y.NUMERO.DOC = COMI

    Y.ERR = ''
    RL.LIST = ''
    RL.LIST.NAME = ''
    RL.SELECTED = ''
    RL.RETURN.CODE = ''
    TEXT = ''

* Abrimos la tabla de listas restrictivas de T24
    FN.REST = 'F.REDO.RESTRICTIVE.LIST'
    FV.REST = ''
    CALL OPF(FN.REST, FV.REST)

    Y.NUMERO.DOC.STRIPPED = OCONV(Y.NUMERO.DOC,"MCB")

    SELECT.STATEMENT = "SELECT ": FN.REST

    IF Y.NUMERO.DOC EQ Y.NUMERO.DOC.STRIPPED THEN
        SELECT.STATEMENT := " WITH NUMERO.DOCUMENTO EQ '" : Y.NUMERO.DOC: "'"
    END ELSE
        SELECT.STATEMENT := " WITH NUMERO.DOCUMENTO EQ '" : Y.NUMERO.DOC : "'OR NUMERO.DOCUMENTO EQ '" : Y.NUMERO.DOC.STRIPPED : "'"
    END

    CALL EB.READLIST(SELECT.STATEMENT, RL.LIST, RL.LIST.NAME, RL.SELECTED, RL.RETURN.CODE)

* Si esta en lista restrictiva devolvemos el valor YES

    APP.NOTIFY      = "RESTRICTIVA"
    IF RL.SELECTED GT 0 THEN
        CALL LAPAP.PLAF.INT.LIST.TR(Y.NUMERO.DOC)
        TEXT = "PERSONA EN LISTA RESTRICTIVA T24"
        ETEXT = TEXT
        E = TEXT
        CALL STORE.END.ERROR
    END

    IF TEXT EQ '' THEN

        IF R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) EQ 'PASAPORTE' THEN

*-- VARIALES PARA EJECUTAR SELECT
            SEL.LIST = ""
            NO.REC = ""
            SEL.ERR = ""
            SEL.CMD = "SELECT FBNK.CUSTOMER WITH L.CU.PASS.NAT LIKE " : Y.NUMERO.DOC : "..."

*-- EJECUTAMOS LA CONSULTA A LA TABLA CUSTOMER
            CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.REC, SEL.ERR)

            IF NO.REC GT 0 THEN

                REMOVE Y.CUS.NO FROM SEL.LIST SETTING Y.CUS.POS

*-- PARA ABRIR EL ACHIVO CUSTOMER
                FN.CUS = "F.CUSTOMER"
                FV.CUS = ""
                RS.CUS = ""
                ERR.CUS = ""

                CALL OPF(FN.CUS, FV.CUS)
                CALL F.READ(FN.CUS, Y.CUS.NO, RS.CUS, FV.CUS, ERR.CUS)

                R.NEW(REDO.CUS.PRF.PASSPORT.COUNTRY) = RS.CUS<EB.CUS.NATIONALITY>
            END

        END

* Rutina previamente invocada por la version
*CALL REDO.DEF.CUSTOMER.TYPE
        CALL LAPAP.DEF.CUSTOMER.TYPE
        IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP' THEN
            TEXT = 'NO ES CLIENTE APAP, LLENAR CAMPOS CLIENTE OCASIONAL'
            CALL REM

            CALL LAPAP.OCUS.SET.RT
        END ELSE
*Call check record routine to set occasional cus. fields as no input.
            CALL LAPAP.CHK.OCC.CUSTOMER
        END
    END

    RETURN
END