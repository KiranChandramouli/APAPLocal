* @ValidationCode : MjotMTY0NzEyMDQzNDpDcDEyNTI6MTY4NDIzMzQyNDA4MjpJVFNTOi0xOi0xOjI4NzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 16:07:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 287
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* @(#) L.APAP.RTN.VAL.REST.LIST Ported to jBASE 16:16:59  28 NOV 2017
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.RTN.VAL.REST.LIST
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion  - REM to DISPLAY.MESSAGE
* 13-APRIL-2023      Harsha                R22 Manual Conversion - CALL routine format modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.ID.CARD.CHECK
    $INSERT I_F.CUSTOMER

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
        CALL APAP.LAPAP.lapapPlafIntListTr(Y.NUMERO.DOC);* R22 Manual conversion
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
        CALL APAP.LAPAP.lapapDefCustomerType() ;*R22 Manual Conversion
        IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) EQ 'NO CLIENTE APAP' THEN
            TEXT = 'NO ES CLIENTE APAP, LLENAR CAMPOS CLIENTE OCASIONAL'
            CALL DISPLAY.MESSAGE(TEXT, '')  ;*R22 Auto Conversion  - REM to DISPLAY.MESSAGE

            CALL APAP.LAPAP.lapapOcusSetRt();* R22 Manual conversion
        END ELSE
*Call check record routine to set occasional cus. fields as no input.
            CALL APAP.LAPAP.lapapChkOccCustomer() ;*R22 Manual Conversion
        END
    END

RETURN
END
