* @ValidationCode : MjoxNjE5MjE2MzUyOkNwMTI1MjoxNjg0ODM2MDM1NjkxOklUU1M6LTE6LTE6LTE0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:35
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
SUBROUTINE REDO.APAP.CONV.CLASS
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.CLASS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.CONV.CLASS is a conversion routine attached to the ENQUITY>
*                    REDO.APAP.NOF.SERIES.REPORT.NO, the routine fetches the value from O.DATA delimited
*                    with stars and formats them according to the selection criteria and returns the value
*                     back to O.DATA
*Linked With       :
*In  Parameter     : N/A
*Out Parameter     : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 19 OCT 2010          Mudassir V             ODR-2010-03-0182            Initial Creation
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
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB PROCESS.PARA

RETURN
*------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    Y.RESULT = ''
    O.DATA = ''
    LOCATE 'AGENCY' IN ENQ.SELECTION<2,1> SETTING Y.CO.POS THEN
        Y.RESULT     := "Agencia - ":ENQ.SELECTION<4,Y.CO.POS>:' '
    END
    LOCATE 'ACCOUNT.TYPE' IN ENQ.SELECTION<2,1> SETTING Y.CAT.POS THEN
        IF Y.RESULT THEN
            Y.RESULT     := ',':" Tipo De Cuenta  - ":ENQ.SELECTION<4,Y.CAT.POS>:' '
        END ELSE
            Y.RESULT     := "Tipo De Cuenta  - ":ENQ.SELECTION<4,Y.CAT.POS>:' '
        END
    END
    IF Y.RESULT EQ '' THEN
        Y.RESULT ="ALL"
    END
    O.DATA = Y.RESULT

RETURN
END

*------------------------------------------------------------------------------------------------------
