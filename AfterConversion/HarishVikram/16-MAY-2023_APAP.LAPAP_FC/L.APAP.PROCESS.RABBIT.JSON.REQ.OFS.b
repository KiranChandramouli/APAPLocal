* @ValidationCode : MjoxODU3ODY0NDE5OkNwMTI1MjoxNjg0MTQ0MjM2MzgzOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 May 2023 15:20:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
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
