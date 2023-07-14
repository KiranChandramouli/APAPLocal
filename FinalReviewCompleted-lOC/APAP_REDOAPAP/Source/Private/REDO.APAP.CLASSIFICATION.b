* @ValidationCode : MjotODkwMDM5MzYwOkNwMTI1MjoxNjgxMjE2MDc3ODY1OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 17:57:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CLASSIFICATION
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.INV.SEL
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.CLASSIFICATION is a conversion routine attached to the ENQUIRY>
*                    REDO.APAP.NOF.LINK.RPT, the routine fetches the value from O.DATA delimited
*                    with stars and formats them according to the selection criteria and returns the value
*                     back to O.DATA
*Linked With       :
*In  Parameter     : N/A
*Out Parameter     : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*--------------------------------------------------------------------------------------------------------
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 20 OCT 2010              Dhamu S             ODR-2010-03-0098            Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
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

    LOCATE 'CLIENT.CODE' IN ENQ.SELECTION<2,1> SETTING Y.CO.POS THEN
        Y.RESULT     := "NO CLIENTE VINCULADO EQ ":ENQ.SELECTION<4,Y.CO.POS>:' '
    END

    LOCATE 'RELATION.TYPE' IN ENQ.SELECTION<2,1> SETTING Y.CAT.POS THEN
        Y.RESULT     := " , TIPO DE VINCULACION EQ ":ENQ.SELECTION<4,Y.CAT.POS>:' '
    END

    IF NOT(Y.RESULT) THEN
        Y.RESULT = "TODO"
    END

    O.DATA = Y.RESULT

RETURN
END
*------------------------------------------------------------------------------------------------------
