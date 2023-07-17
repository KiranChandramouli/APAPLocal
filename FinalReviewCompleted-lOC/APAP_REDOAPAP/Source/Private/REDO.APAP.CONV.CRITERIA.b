* @ValidationCode : MjoxODYzNDE0MzE0OkNwMTI1MjoxNjgwNjA1NDk5NzIwOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:21:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CONV.CRITERIA
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.CRITERIA
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.CONV.CRITERIA is a conversion routine attached to the ENQUITY>
*                    REDO.APAP.NOF.CHEQUE.REFERRED, the routine fetches the value from O.DATA delimited
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
* 23 MARCH 2010          Mudassir V             ODR-2010-08-0175            Initial Creation
* Date                  who                   Reference              
* 04-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 04-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY
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
    LOCATE 'ACCOUNT.OFFICER' IN ENQ.SELECTION<2,1> SETTING Y.CO.POS THEN
        Y.RESULT     := "OFICIAL DE CUENTA - ":ENQ.SELECTION<4,Y.CO.POS>:' '
    END
    LOCATE 'AGENCY' IN ENQ.SELECTION<2,1> SETTING Y.CAT.POS THEN
        Y.AGENCY = ENQ.SELECTION<4,Y.CAT.POS>
        GOSUB AGENCY.PROCESS
        IF Y.RESULT THEN
            Y.RESULT  :   = ',': " AGENCIA  - ":Y.AGENCY

        END ELSE
            Y.RESULT     :="AGENCIA  - ":Y.AGENCY
        END
    END
    IF Y.RESULT EQ '' THEN
        Y.RESULT ="ALL"
    END
    O.DATA = Y.RESULT

RETURN

AGENCY.PROCESS:
*=============
    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    Y.COM.ERR = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    CALL CACHE.READ(FN.COMPANY,Y.AGENCY,R.COM.REC,Y.COM.ERR)
    Y.AGENCY = R.COM.REC<EB.COM.COMPANY.NAME>

RETURN

END


*------------------------------------------------------------------------------------------------------
