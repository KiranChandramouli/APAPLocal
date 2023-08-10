*-----------------------------------------------------------------------------
* <Rating>100</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.PROCESS.RABBIT.JSON.REQ.OFS(Request)
   $INSERT T24.BP I_COMMON
   $INSERT T24.BP I_EQUATE

   IF PUTENV('OFS_SOURCE=TAABS') THEN NULL
      CALL JF.INITIALISE.CONNECTION
      CALL OFS.BULK.MANAGER(Request, result, '')

      CHANGE ',' TO ',':CHAR(10) IN result
      Request = result

RETURN
END
