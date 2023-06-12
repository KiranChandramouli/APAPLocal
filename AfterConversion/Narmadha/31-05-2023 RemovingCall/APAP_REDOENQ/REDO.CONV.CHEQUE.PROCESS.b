* @ValidationCode : MjoxNDYzNjAzNDM1OlVURi04OjE2ODU1MzAxNTM0Mzk6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 16:19:13
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
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

    APAP.REDOEB.redoEbLookupList(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2);*R22 Manual Conversion

    IF Y.DESC.VAL THEN
        O.DATA = Y.DESC.VAL
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------
END
