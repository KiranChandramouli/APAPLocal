*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.SRV.48H.CUS.INFO.RT.LOAD
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT BP I_F.ST.LAPAP.MOD.DIRECCIONES
    $INSERT LAPAP.BP I_SRV.48H.COMMON

    GOSUB INI
    RETURN

INI:
    FN.DIR = 'FBNK.ST.LAPAP.MOD.DIRECCIONES'
    F.DIR = ''

    CALL OPF(FN.DIR,F.DIR)

    Y.TODAY = TODAY
    PROCESS.DATE = Y.TODAY
*DAY.COUNT = "-2W"
*CALL CDT('', PROCESS.DATE, DAY.COUNT)

    RETURN

END
