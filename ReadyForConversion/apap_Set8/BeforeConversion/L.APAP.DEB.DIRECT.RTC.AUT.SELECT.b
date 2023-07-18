*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.DEB.DIRECT.RTC.AUT.SELECT

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT LAPAP.BP I_L.APAP.DEB.DIRECT.RTC.AUT.COMMON

    CALL EB.CLEAR.FILE(FN.LAPAP.CONCATE.DEB.DIR,F.LAPAP.CONCATE.DEB.DIR)
    R.CHK.DIR1 = '' ; CHK.DIR.ERROR1 = '';
    CALL F.READ(FN.CHK.DIR1,Y.ARCHIVO.CARGA,R.CHK.DIR1,F.CHK.DIR1,CHK.DIR.ERROR1)
    IF NOT(R.CHK.DIR1) THEN
        RETURN
    END

    SEL.LIST = R.CHK.DIR1;
    CALL BATCH.BUILD.LIST('',SEL.LIST)

    RETURN

END
