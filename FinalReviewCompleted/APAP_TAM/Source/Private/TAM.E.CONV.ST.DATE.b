* @ValidationCode : MjoxNDAzNDM0NTQ0OkNwMTI1MjoxNjg0ODQyMTU1OTg3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE TAM.E.CONV.ST.DATE
*-------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.CONV.ST.DATE
*--------------------------------------------------------------------------------------------------------
*Description  : TAM.E.CONV.ST.DATE is the Conversion routine
*               This routine is used to get the START date of the month for which COB is run
*In Parameter : N/A
*Out Parameter : N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                              Reference               Description
* -----------    ----------------                 ----------------         ----------------
* 30 DEC 2010      SABARIKUMAR A                     ODR-2010-0181          Initial Creation
*---------------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    Y.DATE = TODAY
    Y.YEAR.DATE = TODAY[1,6]
    Y.FIRST.DATE = Y.YEAR.DATE:'01'
    O.DATA = Y.FIRST.DATE
RETURN
END
