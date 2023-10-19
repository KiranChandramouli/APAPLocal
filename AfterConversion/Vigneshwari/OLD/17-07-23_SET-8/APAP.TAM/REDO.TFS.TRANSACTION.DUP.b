* @ValidationCode : MjotMjA1MzQ5NzAzODpDcDEyNTI6MTY4OTU4MTI4MDA4NTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Jul 2023 13:38:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TFS.TRANSACTION.DUP
*--------------------------------------------------
* Description: This is the Validation routine for the TFS to avoid the duplicate
*               of TRANSACTION.
*--------------------------------------------------
* Date          Who              Reference                      Comments
* 14 Apr 2013  H Ganesh         PACS00255601 - TFS ISSUE       Initial Draft
*13/07/2023    CONVERSION TOOL   AUTO R22 CODE CONVERSION        NOCHANGE
*13/07/2023     VIGNESHWARI     MANUAL R22 CODE CONVERSION      NOCHANGE
*--------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.T24.FUND.SERVICES

    GOSUB PROCESS

RETURN
*--------------------------------------------------
PROCESS:
*--------------------------------------------------


    IF FIELD(OFS$HOT.FIELD,'.',1) EQ 'TRANSACTION' THEN
        R.NEW(TFS.WAIVE.CHARGE)<1,AV> = 'NO'
    END

    LOCATE COMI IN R.NEW(TFS.TRANSACTION)<1,1> SETTING POS THEN
        IF POS NE AV THEN
            ETEXT = 'SC-DUPLICATES.NOT.ALLOW'
            CALL STORE.END.ERROR
        END

    END


RETURN
END
