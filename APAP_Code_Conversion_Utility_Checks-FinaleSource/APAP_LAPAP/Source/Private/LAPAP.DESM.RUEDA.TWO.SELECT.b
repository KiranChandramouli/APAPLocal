$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.DESM.RUEDA.TWO.SELECT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.DATES
    $INSERT I_LAPAP.DESM.RUEDA.TWO.COMO

*Limpiando tabla temporal
    CALL EB.CLEAR.FILE(FN.LAPAP.DESM.RUEDA.TWO,F.LAPAP.DESM.RUEDA.TWO)

    R.CHK.DIR = '' ; CHK.DIR.ERROR = ''
    CALL F.READ(FN.CHK.DIR,Y.ARCHIVO.CARGA,R.CHK.DIR,F.CHK.DIR,CHK.DIR.ERROR)
    IF NOT(R.CHK.DIR) THEN
        RETURN
    END

    SEL.LIST = R.CHK.DIR;
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
