$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.ASA.URL.PARAM.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ST.L.APAP.ASAMBLEA.VOTANTE

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
