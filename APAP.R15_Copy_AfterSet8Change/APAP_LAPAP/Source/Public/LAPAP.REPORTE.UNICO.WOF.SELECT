*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.REPORTE.UNICO.WOF.SELECT
*----------------------------------------------------------------------------------------------------
* Description           : Rutina de selecion de registros para la generación, del reporte unico posterior
*                         para prestamo castigados WOFF
* Developed On          : 19-11-2019
* Developed By          : APAP
* Development Reference : GDC-704
*----------------------------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT BP I_F.ST.LAPAP.INFILEPRESTAMO
    $INSERT T24.BP I_F.AA.ARRANGEMENT
    $INSERT LAPAP.BP I_LAPAP.REPORTE.UNICO.WOF.COMMON

    CALL EB.CLEAR.FILE(FN.ST.LAPAP.INFILEPRESTAMO, FV.ST.LAPAP.INFILEPRESTAMO)

    SEL.CMD = " SELECT " : FN.AA.ARRANGEMENT :" WITH PRODUCT.GROUP EQ PRODUCTOS.WOF AND ARR.STATUS EQ CURRENT EXPIRED"
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

    RETURN
END
