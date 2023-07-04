* @ValidationCode : MjoxNjc4OTcyMjE2OkNwMTI1MjoxNjgyNTI4NDc0MzY4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:14
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
SUBROUTINE REDO.REPORT.NAME.VALUE

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : JEEVA T
* Program Name : REDO.E.CNV.PROD.CODE
*---------------------------------------------------------

* Description : This subroutine is attached as a conversion routine to enquiry REDO.PLASTIC.CARD.BRANCH
* to calculate total no of card lost for the request

*----------------------------------------------------------
* Linked With : Enquiry REDO.E.CNV.COUNT.LOST
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
* Modification History:
*----------------------------------------------------------
*
* 31-May-2010 - HD1021443
* This section of routine will remove entries, which has RELATION.CODE specified not in range from 1 to 299
*
* 02-Jun-2010 - HD1021443
* Modification made on referring to gosub WITH.RG.1.299.ONLY section for the ENQUIRY REDO.CUST.RELATION.VINC only
*----------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*18-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    Y.VALUE = O.DATA
    O.DATA = Y.VALUE:"zado"
RETURN
END
