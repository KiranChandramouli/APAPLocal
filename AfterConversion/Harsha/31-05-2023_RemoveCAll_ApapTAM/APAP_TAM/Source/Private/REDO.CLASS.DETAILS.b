* @ValidationCode : MjotMzI5ODY0MDY2OkNwMTI1MjoxNjgwNjc0NzUxMjcwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 11:35:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

SUBROUTINE REDO.CLASS.DETAILS
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CLASS.DETAILS
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry
*Linked With       : REDO.CLASS.DETAILS
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date          Who               Reference             Description
*     ------         -----             -------------         -------------
* 27 JUNE 2011     DHAMU.S            ODR-2010-03-0165       Initial Creation
* 07 Jan 2014      Vignesh Kumaar R   PACS00311747           Report modification
* 05.04.2023       Conversion Tool       R22                 Auto Conversion     - No changes
* 05.04.2023       Shanmugapriya M       R22                 Manual Conversion   - No changes
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
******
    Y.VALUE.DATE = ''; Y.CO.CODE = ''; Y.STATUS1 = '' ; Y.STATUS2 = '';Y.CATEGORY = ''; Y.TYPE = ''
    Y.CLASSIFICATION = ''
RETURN
********
PROCESS:
********
    LOCATE "VALUE.DATE" IN ENQ.SELECTION<2,1> SETTING DATE.POS THEN
        Y.VALUE.DATE = ENQ.SELECTION<4,DATE.POS>
    END
    LOCATE "CO.CODE" IN ENQ.SELECTION<2,1> SETTING AGENCY.POS THEN
        Y.CO.CODE = ENQ.SELECTION<4,AGENCY.POS>
    END
    LOCATE "L.AC.STATUS1" IN ENQ.SELECTION<2,1> SETTING STATUS1.POS THEN
        Y.STATUS1 = ENQ.SELECTION<4,STATUS1.POS>
    END
    LOCATE "L.AC.STATUS2" IN ENQ.SELECTION<2,1> SETTING STATUS2.POS THEN
        Y.STATUS2 = ENQ.SELECTION<4,STATUS2.POS>
    END
    LOCATE "CATEGORY" IN ENQ.SELECTION<2,1> SETTING CATEGORY.POS THEN
        Y.CATEGORY = ENQ.SELECTION<4,CATEGORY.POS>
    END
    LOCATE "TRANSACTION.TYPE" IN ENQ.SELECTION<2,1> SETTING TYPE.POS THEN
        Y.TYPE = ENQ.SELECTION<4,TYPE.POS>
    END

* Fix for PACS00311747 [Report modification]

    IF Y.VALUE.DATE THEN
        Y.DATE.RANGE = FIELD(Y.VALUE.DATE,' ',2)
        IF Y.DATE.RANGE THEN
            Y.VALUE.DATE.1 = FIELD(Y.VALUE.DATE,' ',1)
            CALL EB.DATE.FORMAT.DISPLAY(Y.VALUE.DATE.1, Y.VALUE.DATE.1.FMT, '', '')
            Y.VALUE.DATE.2 = FIELD(Y.VALUE.DATE,' ',2)
            CALL EB.DATE.FORMAT.DISPLAY(Y.VALUE.DATE.2, Y.VALUE.DATE.2.FMT, '', '')
            Y.VALUE.DATE = Y.VALUE.DATE.1.FMT :' - ': Y.VALUE.DATE.2.FMT

        END ELSE
            CALL EB.DATE.FORMAT.DISPLAY(Y.VALUE.DATE, Y.VALUE.DATE.FMT, '', '')
            Y.VALUE.DATE = Y.VALUE.DATE.FMT
        END
    END

    IF Y.VALUE.DATE THEN
        Y.CLASSIFICATION = 'FECHA:':Y.VALUE.DATE
    END

* End of Fix

    IF Y.CO.CODE THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ': 'AGENCIA:' : Y.CO.CODE
        END ELSE
            Y.CLASSIFICATION = 'AGENCIA:':Y.CO.CODE
        END
    END

    IF Y.STATUS1 THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ': 'ESTATUS1:' : Y.STATUS1
        END ELSE
            Y.CLASSIFICATION = 'ESTATUS1:' : Y.STATUS1
        END
    END

    IF Y.STATUS2 THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ': 'ESTATUS2:' : Y.STATUS2
        END ELSE
            Y.CLASSIFICATION = 'ESTATUS2:' : Y.STATUS2
        END
    END
    IF Y.CATEGORY THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ': 'TIPO DE INVERSION:' : Y.CATEGORY
        END ELSE
            Y.CLASSIFICATION = 'TIPO DE INVERSION:' : Y.CATEGORY
        END
    END

    IF Y.TYPE THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION  = Y.CLASSIFICATION:' , ': 'TIPO DE TRANSACCION:' : Y.TYPE
        END ELSE
            Y.CLASSIFICATION = 'TIPO DE TRANSACCION:' : Y.TYPE
        END
    END
    IF Y.CLASSIFICATION THEN
        O.DATA = Y.CLASSIFICATION
    END ELSE
        O.DATA = ''
    END
RETURN
END
