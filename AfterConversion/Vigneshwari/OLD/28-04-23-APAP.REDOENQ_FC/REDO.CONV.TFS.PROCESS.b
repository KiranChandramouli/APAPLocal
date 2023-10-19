* @ValidationCode : Mjo4ODMyMTkyODU6Q3AxMjUyOjE2ODI1MTQ4MjM5MDA6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 18:43:43
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
SUBROUTINE REDO.CONV.TFS.PROCESS
*--------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the descriptions
*------------------------------------------------------------------------------------------------------------
* Modification History
* DATE         NAME          Reference        REASON
* 28-07-2012   SUDHARSANAN   PACS00208938     Initial creation
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
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

    Y.LOOKUP.ID   = "L.AZ.METHOD.PAY"
    Y.LOOOKUP.VAL = O.DATA
    Y.DESC.VAL    = ''

    BEGIN CASE
        CASE Y.LOOOKUP.VAL EQ 'CASHDEPOSIT'
            Y.LOOOKUP.VAL = 'CASHDEPOSIT'
        CASE Y.LOOOKUP.VAL EQ 'CHQDEP'
            Y.LOOOKUP.VAL = 'CHEQUE.DEPOSIT'
        CASE Y.LOOOKUP.VAL EQ 'FROM'
            Y.LOOOKUP.VAL = 'FROM.CUST.ACC'
    END CASE

    CALL APAP.REDOEB.redoEbLookupList(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2);*R22 Manual Conversion

    IF Y.DESC.VAL THEN
        O.DATA = Y.DESC.VAL
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------
END
