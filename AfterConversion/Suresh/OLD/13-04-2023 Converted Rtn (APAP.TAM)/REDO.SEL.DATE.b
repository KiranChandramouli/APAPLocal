* @ValidationCode : MjotMTgxMjkyODkzMjpDcDEyNTI6MTY4MTM4MDk2OTcyNDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 15:46:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.SEL.DATE
****************************************
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.SEL.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This is a Conversion routine to get the DATE
*
*Linked With       : Enquiry REDO.APAP.CARD.REQ.REPORT
*In  Parameter     : O.DATA
*Out Parameter     : O.DATA
*Files  Used       : ACCOUNT                    As              I               Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*     29.06.2011          Dhamu S              ODR-2010-03-0092            Initial Creation
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             SM TO @SM
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN

********
PROCESS:
********

    LOCATE "DATE" IN ENQ.SELECTION<2,1> SETTING DATE.POS THEN
        Y.DATE = ENQ.SELECTION<4,DATE.POS>
    END
    IF Y.DATE THEN
        CHANGE " " TO @SM IN Y.DATE
        Y.CLOSE.LEN = LEN(Y.DATE)
        IF Y.CLOSE.LEN EQ 17 THEN
            Y.M1 = FIELD(Y.DATE,@SM,1)
            Y.M2 = FIELD(Y.DATE,@SM,2)
        END
        IF Y.M1 THEN
            Y.FROM.MONTH = Y.M1
            Y.FROM.MONTH = OCONV(Y.FROM.MONTH,'DI')
            Y.FROM.MONTH = OCONV(Y.FROM.MONTH,'D4')
        END
        IF Y.M2 THEN
            Y.TO.MONTH = Y.M2
            Y.TO.MONTH = OCONV(Y.TO.MONTH,'DI')
            Y.TO.MONTH = OCONV(Y.TO.MONTH,'D4')
        END
        Y.CLASSIFICATION = Y.FROM.MONTH:'-':Y.TO.MONTH
    END
    IF Y.CLASSIFICATION THEN
        O.DATA = Y.CLASSIFICATION
    END
RETURN
*************************
END
*---------------------End of Program------------------------------------------------------------
