* @ValidationCode : MjotMjAyMTk5MDU3NzpDcDEyNTI6MTY4MjUxNDU5MTEzNTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Apr 2023 18:39:51
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.CHEQUE.PROCESS
*--------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the descriptions
*------------------------------------------------------------------------------------------------------------
* Modification History
* DATE         NAME          Reference        REASON
* 28-07-2012   SUDHARSANAN   PACS00208938     Initial creation
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified.
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER
    $USING APAP.REDOEB
    

    GOSUB PROCESS
RETURN
**********
PROCESS:
*********

    Y.LOOKUP.ID   = "L.PAYMT.TYPE"
    Y.LOOOKUP.VAL = O.DATA
    Y.DESC.VAL    = ''

    CALL APAP.REDOEB.redoEbLookupList(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2);*R22 Manual Conversion

    IF Y.DESC.VAL THEN
        O.DATA = Y.DESC.VAL
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------
END
