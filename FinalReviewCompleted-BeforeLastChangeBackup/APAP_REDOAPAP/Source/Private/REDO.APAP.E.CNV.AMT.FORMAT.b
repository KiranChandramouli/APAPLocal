* @ValidationCode : MjoxMjczNzQ5MDY1OkNwMTI1MjoxNjg0ODM2MDM3NzkwOklUU1M6LTE6LTE6LTE0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -14
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.CNV.AMT.FORMAT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    :
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.CNV.FORM.SEL is a conversion routine attached to the enquiries
*                    REDO.ENQ.FT.TRANSIT and REDO.ENQ.FT.TRANSIT.RPT. The routine formats the amount &
*                    the value back to O.DATA
*In Parameter      : N/A
*Out Parameter     : O.DATA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date             Who                      Reference                 Description
*   ------          ------                     -------------             -------------
*  23 Dec 2010     MOhammed Anies K           ODR-2010-08-0172          Initial Creation
* Date                  who                   Reference              
* 05-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    Y.COUNT.AMOUNT = O.DATA

    Y.AMOUNT = ''
    Y.DEC.POINT = ''
    Y.CHQ.COUNT = ''

    Y.CHQ.COUNT = FIELD(Y.COUNT.AMOUNT,'/',1,1)

    Y.AMOUNT = FIELD(Y.COUNT.AMOUNT,'/',2,1)

    Y.DEC.POINT = FIELD(Y.AMOUNT,'.',2,1)

    IF Y.DEC.POINT EQ '' THEN
        Y.AMOUNT = Y.AMOUNT:'.00'
    END

    O.DATA = Y.CHQ.COUNT:'/':Y.AMOUNT

RETURN
*--------------------------------------------------------------------------------------------------------
END
