SUBROUTINE L.APAP.STATUS.TRADUCCION

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    BEGIN CASE

        CASE O.DATA EQ "DECEASED"
            Y.TRADUCCION = "FALLECIDO"

        CASE O.DATA EQ "GARNISHMENT"
            Y.TRADUCCION = "EMBARGADO"


        CASE O.DATA EQ "GUARANTEE STATUS"
            Y.TRADUCCION = "ESTADO DE GARANTMA"

    END CASE

    O.DATA = Y.TRADUCCION

RETURN

END