$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.STATUS.TRADUCCION
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    BEGIN CASE

        CASE O.DATA EQ "DECEASED"
            Y.TRADUCCION = "FALLECIDO"

        CASE O.DATA EQ "GARNISHMENT"
            Y.TRADUCCION = "EMBARGADO"


        CASE O.DATA EQ "GUARANTEE STATUS"
            Y.TRADUCCION = "ESTADO DE GARANTMA"

    END CASE

    O.DATA = Y.TRADUCCION

RETURN

END
