*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.CONTROL.ESTADOS.RT.LOAD
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT BP I_F.ST.LAPAP.CONTROL.ESTADOS
    $INSERT T24.BP I_F.HOLD.CONTROL
    $INSERT LAPAP.BP I_CONTROL.ESTADOS.COMMON


    GOSUB OPENER
    GOSUB SEIS.MESES.ANTES

    RETURN

OPENER:
    FN.HC = "F.HOLD.CONTROL"
    FV.HC = ''
    CALL OPF(FN.HC,FV.HC)
    FN.CE = "FBNK.ST.LAPAP.CONTROL.ESTADOS"
    FV.CE = ""
    CALL OPF(FN.CE,FV.CE)
    FN.ES = "../bnk.interface/ESTADO"
    FV.ES = ""
    CALL OPF(FN.ES,FV.ES)

    RETURN

SEIS.MESES.ANTES:
    OLD.DATE = TODAY
    DAY.COUNT = "-180W"
    CALL CDT('', OLD.DATE, DAY.COUNT)
    CALL OCOMO("Fecha discriminante anterior: " : OLD.DATE)
    RETURN

END

