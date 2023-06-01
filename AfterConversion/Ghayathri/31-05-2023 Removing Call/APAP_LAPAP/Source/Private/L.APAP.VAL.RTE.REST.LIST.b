* @ValidationCode : MjotMTE3NDkzMDMwOTpDcDEyNTI6MTY4NTUzMjc4NTA4MTpoYWk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 17:03:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION           CALL RTN METHOD ADDED
*------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.RTE.REST.LIST
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON ;* AUTO R22 CODE CONVERSION END

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
    IF RL.SELECTED GT 0 THEN
        TEXT = "PERSONA EN LISTA RESTRICTIVA T24"
        ETEXT = TEXT
        E = TEXT

        CALL STORE.END.ERROR
    END

    IF TEXT EQ '' THEN
* Rutina previamente invocada por la version
        APAP.LAPAP.redoLapapDefCustType() ;*MANUAL R22 CODE CONVERSION
    END

RETURN
END
