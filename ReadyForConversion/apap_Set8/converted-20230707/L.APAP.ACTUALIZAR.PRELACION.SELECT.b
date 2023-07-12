*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.ACTUALIZAR.PRELACION.SELECT
*-----------------------------------------------------------------------------

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT T24.BP I_F.FUNDS.TRANSFER
    $INSERT T24.BP I_F.AA.PAYMENT.SCHEDULE
    $INSERT  BP I_F.ST.L.APAP.PRELACION.COVI19.DET
    $INSERT BP I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT LAPAP.BP I_L.APAP.ACTUALIZAR.PRELACION.COMMON


    GOSUB PROCESS
    RETURN

PROCESS:
    SEL.CMD = ''; NO.OF.RECS = ''; ERROR.DETAILS = '' ; SEL.LIST = '';
    CALL F.READ(FN.DIRECTORIO,Y.INFILE,R.DIRECTORIO,FV.DIRECTORIO,ERROR.DIRECTORIO)
    SEL.LIST = R.DIRECTORIO
    CALL BATCH.BUILD.LIST('',SEL.LIST)
    RETURN
END
