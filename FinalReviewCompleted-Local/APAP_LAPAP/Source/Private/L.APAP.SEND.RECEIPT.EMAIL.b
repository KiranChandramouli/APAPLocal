$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.SEND.RECEIPT.EMAIL
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER

    TEXT = 'L.APAP.SEND.RECEIPT.EMAIL'
    CURR.NO = 1
    CALL STORE.OVERRIDE(CURR.NO)

END
