*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*----------------------------------------
* Limpieza de DEBIT.DIRECT - 2da Fase - Proyecto COVID19
* Fecha: 31/03/2020
* Autor: Oliver Fermin
*----------------------------------------

SUBROUTINE LAPAP.DEBIT.DIRECT.COVID19.SELECT

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_F.AA.PAYMENT.SCHEDULE
    $INSERT T24.BP I_F.AA.ARRANGEMENT
    $INSERT LAPAP.BP I_LAPAP.DEBIT.DIRECT.COVID19.COMO

    CALL EB.CLEAR.FILE(FN.LAPAP.DEBIT.DIRECT.COVID19, F.LAPAP.DEBIT.DIRECT.COVID19)

    R.CHK.DIR = '' ; CHK.DIR.ERROR = ''
    CALL F.READ(FN.CHK.DIR,Y.ARCHIVO.NOMBRE.ARCHIVO.IN,R.CHK.DIR,F.CHK.DIR,CHK.DIR.ERROR)
    IF NOT(R.CHK.DIR) THEN
        RETURN
    END

    SEL.LIST = R.CHK.DIR
    CALL BATCH.BUILD.LIST('',SEL.LIST)
    
    RETURN

END
