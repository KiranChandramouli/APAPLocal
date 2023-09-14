$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.PAGOS.CXP.DELETEF
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    EXECUTE 'COPY FROM ../interface/FLAT.INTERFACE/PAGOS.CXP PAGOS.CXP.TXT TO ../interface/FLAT.INTERFACE/PAGOS.CXP/TEMP OVERWRITING DELETING'

RETURN

END
