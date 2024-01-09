* @ValidationCode : MjotMTIxNjI5NDkxNDpDcDEyNTI6MTY4NDgzNjAzNDkzNjpJVFNTOi0xOi0xOi05OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -9
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   SM to @SM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.CLASSIFICATION.SEL.CRIT.24
*-----------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CLASSIFICATION.SEL.CRIT.24
*-----------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display header of REDO.EACH.TRANS.DETAILS.ENQ
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.PAY.ENQ.RPT
*-----------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------------------------
    GOSUB PROCESS
RETURN
*--------
PROCESS:
*********
    Y.CLASSIFICATION = '' ; Y.DATE = ''; Y.CLIENT.CODE = ''; Y.EMP.CODE = ''
    Y.FROM.MONTH = '' ; Y.TO.MONTH = ''; Y.CLOSE.LEN = ''

    LOCATE "DATE" IN ENQ.SELECTION<2,1> SETTING Y.CNV.DATE.VAL.POS THEN
        Y.DATE = ENQ.SELECTION<4,Y.CNV.DATE.VAL.POS>
    END

    LOCATE "CLIENT.CODE" IN ENQ.SELECTION<2,1> SETTING Y.TXN.TYPE.POS THEN
        Y.CLIENT.CODE = ENQ.SELECTION<4,Y.TXN.TYPE.POS>
    END

    LOCATE "EMP.CODE" IN ENQ.SELECTION<2,1> SETTING Y.AGENCY.POS THEN
        Y.EMP.CODE = ENQ.SELECTION<4,Y.AGENCY.POS>
    END

    IF Y.DATE THEN
        CHANGE " " TO @SM IN Y.DATE
        Y.CLOSE.LEN = LEN(Y.DATE)
        IF Y.CLOSE.LEN EQ 17 THEN
            Y.M1 = FIELD(Y.DATE,@SM,1)
            Y.M2 = FIELD(Y.DATE,@SM,2)
        END
        Y.CLOSE.LEN = LEN(Y.DATE)
        IF Y.CLOSE.LEN EQ 8 THEN
            Y.M1 = Y.DATE
            Y.M2 = ''
        END
        IF Y.M1 THEN
            Y.FROM.MONTH = Y.M1
            Y.FROM.MONTH=OCONV(Y.FROM.MONTH,'DI')
            Y.FROM.MONTH=OCONV(Y.FROM.MONTH,'D4')
        END
        IF Y.M2 THEN
            Y.TO.MONTH = Y.M2
            Y.TO.MONTH=OCONV(Y.TO.MONTH,'DI')
            Y.TO.MONTH=OCONV(Y.TO.MONTH,'D4')
        END

        IF Y.M2 EQ '' THEN
            Y.CLASSIFICATION = " FECHA: " : Y.FROM.MONTH
        END ELSE
            Y.CLASSIFICATION = " FECHA: " : Y.FROM.MONTH:' - ':Y.TO.MONTH
        END
    END

    IF Y.CLIENT.CODE THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':" CODIGO CLIENTE: ":Y.CLIENT.CODE
        END ELSE
            Y.CLASSIFICATION = "CODIGO CLIENTE:":Y.CLIENT.CODE
        END
    END

    IF Y.EMP.CODE THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':"AGENCIA: ":Y.EMP.CODE
        END ELSE
            Y.CLASSIFICATION =" AGENCIA: ":Y.EMP.CODE
        END
    END

    IF Y.DATE EQ '' AND Y.CLIENT.CODE EQ '' AND Y.EMP.CODE EQ '' THEN
        Y.CLASSIFICATION = 'ALL'
    END
    IF Y.CLASSIFICATION THEN
        O.DATA = Y.CLASSIFICATION
    END ELSE
        O.DATA = ''
    END

RETURN
************************************************************
END
*---------------------End of program ---------------------------------------------------
