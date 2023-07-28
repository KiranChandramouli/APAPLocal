* @ValidationCode : MjotMTEzNzI4NjU3NzpDcDEyNTI6MTY4NDg0MjA4NzU2NDpJVFNTOi0xOi0xOi04OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHK.CUSTOMER.TYPE
*--------------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION :
*
* Note    : Passport number number validation will not be done against Padrones interface, user manually checks for non apap customers
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Shankar Raju
* PROGRAM NAME : REDO.CHK.CUSTOMER.TYPE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date             Author             Reference         Description
*
* 11-10-2011      Shankar Raju       PACS00142987  Making CUSTOMER.NAME field as non-inputable field
*                                                  to achieve the if Client is Non-APAP & using Passport, CUSTOMER.NAME
*                                                  need to be an inputtable field.
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ID.CARD.CHECK

    GOSUB MAKE.NO.INPUT

RETURN
*---------------------------------------------------------------------------------------------------------------------------------------------------
MAKE.NO.INPUT:
*-------------

    T(REDO.CUS.PRF.CUSTOMER.NAME)<3> = 'NOINPUT'
    T(REDO.CUS.PRF.PASSPORT.COUNTRY)<3> = 'NOINPUT'
RETURN
*---------------------------------------------------------------------------------------------------------------------------------------------------
END
