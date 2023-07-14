$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.TD.OFU
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
    $INSERT I_F.LATAM.CARD.ORDER

    FN.LATAM = "F.LATAM.CARD.ORDER"
    F.LATAM = ""
    CALL OPF(FN.LATAM,F.LATAM)

    CALL F.READ(FN.LATAM,CARD.ID,R.LATAM,F.LATAM,LATAM.ERR)

    VALID = COMI

    COMI =  VALID[1,6] : 'XXXXXX' : VALID[13,4]

END
