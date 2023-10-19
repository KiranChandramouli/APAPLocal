* @ValidationCode : MjotMTc0MTQzMzY5NTpDcDEyNTI6MTY4MTI4Mzk0MjA4MzpJVFNTOi0xOi0xOi0xMDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:49:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.AZ.FUND.PARAM.VALIDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.FUND.PARAM.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.AZ.FUND.PARAM.VALIDATE is a validation routine attached to the TEMPLATE
*                    - REDO.AZ.FUND.PARAM , the routine checks if the duplicate value entered in the
*                    CURRENCY field
*Linked With       : Template - REDO.AZ.FUND.PARAM
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.AZ.FUND.PARAM           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 01 Nov 2010       Sudharsanan S               CR.18                 Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AZ.FUND.PARAM
*-------------------------------------------------------------------------------------------------------
    GOSUB CHECK.DUP
RETURN
*--------------------------------------------------------------------------------------------------------
**********
CHECK.DUP:
**********
    AF = REDO.FUND.CURRENCY
    CALL DUP

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
