$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.1.V.RES.TYPE.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.LAPAP.MOD.DIRECCIONES

    Y.VALUE = COMI

    IF Y.VALUE EQ '' THEN
        ETEXT = 'ESTE CAMPO ES MANDATORIO'
        CALL STORE.END.ERROR
    END
END
