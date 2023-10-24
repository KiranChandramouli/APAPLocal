* @ValidationCode : MjotMjA1NDkzODA0NDpDcDEyNTI6MTY4NDgzNjAzNzgwNTpJVFNTOi0xOi0xOi0xNDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
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
SUBROUTINE REDO.APAP.E.CNV.FORM.SEL
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.APAP.E.CNV.FORM.SEL
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.CNV.FORM.SEL is a conversion routine attached to the enquiries
*                    REDO.ENQ.FT.TRANSIT and REDO.ENQ.FT.TRANSIT.RPT the routine fetches
*                    the value from ENQ.SELECTION formats them according to the selection criteria and returns
*                    the value back to O.DATA
*In Parameter      : N/A
*Out Parameter     : O.DATA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date             Who                      Reference                 Description
*   ------          ------                     -------------             -------------
*  14 Dec 2010     MOhammed Anies K           ODR-2010-08-0172          Initial Creation
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
    Y.CRITERIA = ''

    LOCATE 'Y.TRANSIT.DATE' IN ENQ.SELECTION<2,1> SETTING Y.TRANSIT.DATE.POS THEN
        Y.CRITERIA := ' Fecha es igual a ':ENQ.SELECTION<4,Y.TRANSIT.DATE.POS>
    END

    LOCATE 'Y.ACCOUNT.NO' IN ENQ.SELECTION<2,1> SETTING Y.ACCOUNT.NO.POS THEN
        IF Y.CRITERIA THEN
            Y.CRITERIA := ','
        END
        Y.CRITERIA := ' No.de cuenta es igual a ':ENQ.SELECTION<4,Y.ACCOUNT.NO.POS>:''
    END

    O.DATA =  Y.CRITERIA

RETURN
*--------------------------------------------------------------------------------------------------------
END
