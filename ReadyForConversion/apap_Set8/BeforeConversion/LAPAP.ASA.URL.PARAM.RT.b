*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.ASA.URL.PARAM.RT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT BP I_F.ST.L.APAP.ASAMBLEA.VOTANTE

    GOSUB INITIAL
    GOSUB LEER
    O.DATA = QUERY.STRING
    RETURN
INITIAL:
    FN.VOT = "FBNK.ST.L.APAP.ASAMBLEA.VOTANTE"
    FV.VOT = ""
    CALL OPF(FN.VOT,FV.VOT)
    RETURN

LEER:
    REGISTRO.ID = O.DATA
    QUERY.STRING = ''
    CALL F.READ(FN.VOT, REGISTRO.ID, R.VOT, FV.VOT, VOT.ERR)
    IF R.VOT NE '' THEN
        Y.NOMBRE = R.VOT<ST.L.AV.NOMBRE>
        Y.APELLIDO = R.VOT<ST.L.AV.APELLIDO1>
        CHANGE ' ' TO '%20' IN Y.NOMBRE
        CHANGE ' ' TO '%20' IN Y.APELLIDO
        Y.NOMBRE.COMP =  Y.NOMBRE : "%20" : Y.APELLIDO
        Y.CUENTAS = R.VOT<ST.L.AV.CUENTAS>
        CHANGE @VM TO '*' IN Y.CUENTAS
        Y.VOTOS = R.VOT<ST.L.AV.VOTOS>
        QUERY.STRING = "ced=": REGISTRO.ID :"&nom=":Y.NOMBRE.COMP:"&votos=":Y.VOTOS:"&ctas=":Y.CUENTAS

    END
    RETURN
END
