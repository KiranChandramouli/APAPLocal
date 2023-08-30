$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.PROCESS.RABBIT.JSON.REQ.OFS(Request)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - CHAR to CHARX and T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    IF PUTENV('OFS_SOURCE=TAABS') THEN
        NULL
    END
    CALL JF.INITIALISE.CONNECTION
    CALL OFS.BULK.MANAGER(Request, result, '')

    CHANGE ',' TO ',':CHARX(10) IN result
    Request = result

RETURN
END
