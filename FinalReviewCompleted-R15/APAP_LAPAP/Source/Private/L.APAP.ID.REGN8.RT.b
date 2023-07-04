$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ID.REGN8.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE


    Y.ID = ''
    Y.ID = COMI


    IF Y.ID NE 'REDO.REGN8' THEN
        MESSAGE = "ESTA VERSION ES SOLO PARA EL REGISTRO REDO.REGN8."
        E = MESSAGE
        ETEXT = E
        CALL ERR
    END

END
