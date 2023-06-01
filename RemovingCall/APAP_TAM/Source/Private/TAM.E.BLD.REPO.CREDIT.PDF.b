* @ValidationCode : MjotMTE5NzY4NjQ5OkNwMTI1MjoxNjgxMjAyMzY0OTIzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 14:09:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE TAM.E.BLD.REPO.CREDIT.PDF(ENQ.DATA)
*-----------------------------------------------------------------------------

*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : AM.E.BLD.REPO.CREDIT.PDF

*---------------------------------------------------------------------------------------------------

*Description       : This is the Build routine to reset the glodal variables.
*In  Parameter     : ENQ.DATA
*Out Parameter     : ENQ.DATA
*ODR Number        : ODR-2010-08-0031

*---------------------------------------------------------------------------------------------------
*Modification History:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*---------------------------------------------------------------------------------------------------
*    Initial Development for APAP
*---------------------------------------------------------------------------------------------------
*Insert Files
*---------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_ENQ.SES.VAR.CREDIT.COMMON

    PDF.CREDIT.HEADER = ''
    PDF.CREDIT.DATA = ''
RETURN
END
