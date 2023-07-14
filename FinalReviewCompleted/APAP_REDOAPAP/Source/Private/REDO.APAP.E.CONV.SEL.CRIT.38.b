* @ValidationCode : Mjo3MjU4NjA3OTpDcDEyNTI6MTY4NDgzNjAzNzk0OTpJVFNTOi0xOi0xOi0xOToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -19
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.CONV.SEL.CRIT.38
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.APAP.E.CONV.SEL.CRIT.38
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.CONV.SEL.CRIT.38 is a conversion routine attached to the enquiry
*                    REDO.CASHIER.RPT.ENQ, this routine fetches the value from ENQ.SELECTION,
*                    formats them according to the selection criteria and returns the value back to O.DATA
*Linked With       : Enquiry REDO.CASHIER.RPT.ENQ
*In Parameter      : N/A
*Out Parameter     : O.DATA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date              Who                      Reference                Description
*   ------            ------                  -------------             -------------
* 14 Dec 2010      Shiva Prasad Y            ODR-2010-03-0175          Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*
*********************************************************************************************************
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

    LOCATE 'USER.NAME' IN ENQ.SELECTION<2,1> SETTING Y.USER.POS THEN
        Y.CRITERIA := 'Nomre del cajero -  ':ENQ.SELECTION<4,Y.USER.POS>
    END
    IF Y.CRITERIA THEN
        Y.CRITERIA := ', ':
    END
    LOCATE 'COMPANY.CODE' IN ENQ.SELECTION<2,1> SETTING Y.COMP.POS THEN
        Y.CRITERIA := 'Agencia - ':ENQ.SELECTION<4,Y.COMP.POS>
    END
    IF Y.CRITERIA EQ '' THEN
        Y.CRITERIA = 'ALL'
    END

    O.DATA =  Y.CRITERIA

RETURN
*--------------------------------------------------------------------------------------------------------
END
