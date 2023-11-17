* @ValidationCode : MjotMjExNTkwMTM4ODpDcDEyNTI6MTY5ODQwNTUzOTYyODpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:48:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>100</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ITSS.OFS.REQUEST(theRequests, theResponses, requestCommitted)

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                Nochange
*-----------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON

    FN.OFS.SOURCE = "F.OFS.SOURCE"
    F.OFS.SOURCE = ""
    CALL OPF(FN.OFS.SOURCE,F.OFS.SOURCE)

    requestCommitted = "OFS_SOURCE=APAP.MOBILE"

    env = PUTENV(requestCommitted)

    OFS$SOURCE.ID = FIELD(requestCommitted,"=",2)

    READ OFS$SOURCE.REC FROM F.OFS.SOURCE,OFS$SOURCE.ID ELSE NULL
    IF OFS$SOURCE.REC THEN
        CALL JF.INITIALISE.CONNECTION
        CALL OFS.BULK.MANAGER(theRequests, theResponses, requestCommitted)
    END

    RETURN
