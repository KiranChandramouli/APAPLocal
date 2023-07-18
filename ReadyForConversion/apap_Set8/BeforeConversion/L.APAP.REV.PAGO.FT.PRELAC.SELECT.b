*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.REV.PAGO.FT.PRELAC.SELECT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT  BP I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT BP I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT LAPAP.BP I_L.APAP.REV.PAGO.FT.PRELAC.COMMON
    GOSUB PROCESS

    RETURN

PROCESS:
********
    SEL.CMD = '' ; SEL.LIST = '' ; NO.OF.REC = '' ; RET.CODE = ''
    SEL.CMD = "SELECT ":FN.ST.L.APAP.PRELACION.COVID19.DET
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
    RETURN

END
