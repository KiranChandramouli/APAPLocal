$PACKAGE APAP.IBS

*-----------------------------------------------------------------------------
* <Rating>100</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE GIBS.OFS.REQUEST(theRequests, theResponses, requestCommitted)
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*----------------------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON

    FN.OFS.SOURCE = "F.OFS.SOURCE"
    F.OFS.SOURCE = ""
    CALL OPF(FN.OFS.SOURCE,F.OFS.SOURCE)

    env = PUTENV("OFS_SOURCE=APAP.MOBILE")
    OFS$SOURCE.ID = "APAP.MOBILE"
    READ OFS$SOURCE.REC FROM F.OFS.SOURCE,OFS$SOURCE.ID ELSE NULL
    IF OFS$SOURCE.REC THEN
        CALL JF.INITIALISE.CONNECTION
        CALL OFS.BULK.MANAGER(theRequests, theResponses, requestCommitted)
    END
RETURN
