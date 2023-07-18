*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.ASA.L.V.RT.SELECT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT BP I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT LAPAP.BP I_LAPAP.ASA.L.V.COMMON

    GOSUB DO.SELECT
    RETURN

DO.SELECT:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.PA

    CALL OCOMO("COMANDO SELECCION: " : SEL.CMD)

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.REC)

    RETURN


END
