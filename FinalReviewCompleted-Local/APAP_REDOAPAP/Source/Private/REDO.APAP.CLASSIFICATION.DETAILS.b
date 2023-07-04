* @ValidationCode : MjoxMTg0ODg2NTMxOkNwMTI1MjoxNjgxMjE2MTA1NjAyOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 17:58:25
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
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   SM to @SM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.CLASSIFICATION.DETAILS
*-----------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CLASSIFICATION.DETAILS
*-----------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display header of REDO.EACH.TRANS.DETAILS.ENQ
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.EACH.TRANS.DETAILS.ENQ
*----------------------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------------------------
    GOSUB PROCESS
RETURN
*--------
PROCESS:
*********
    Y.CLASSIFICATION = '' ; Y.TXN.TYPE = '' ;Y.TXN.USER = ''
    Y.TIME = ''
    Y.CLOSE.MONTH = ''
    Y.CLOSE.LEN = ''
    Y.COMPANY.NAME = ''
    Y.M1 = ''
    Y.M2 = ''
    Y.AGENCY = ''
    Y.INVST.TYPE = ''

    LOCATE "TXN.DATE" IN ENQ.SELECTION<2,1> SETTING Y.CNV.DATE.VAL.POS THEN
        Y.CLOSE.MONTH = ENQ.SELECTION<4,Y.CNV.DATE.VAL.POS>
    END

    LOCATE "TXN.TYPE" IN ENQ.SELECTION<2,1> SETTING Y.TXN.TYPE.POS THEN
        Y.TXN.TYPE = ENQ.SELECTION<4,Y.TXN.TYPE.POS>
    END

    LOCATE "AGENCY" IN ENQ.SELECTION<2,1> SETTING Y.AGENCY.POS THEN
        Y.AGENCY = ENQ.SELECTION<4,Y.AGENCY.POS>
    END

    LOCATE "TXN.USER" IN ENQ.SELECTION<2,1> SETTING Y.TXN.USER.POS THEN
        Y.TXN.USER = ENQ.SELECTION<4,Y.TXN.USER.POS>
    END

    LOCATE "COMPANY.NAME" IN ENQ.SELECTION<2,1> SETTING Y.COMPANY.NAME.POS THEN
        Y.COMPANY.NAME = ENQ.SELECTION<4,Y.COMPANY.NAME.POS>
    END

    IF Y.CLOSE.MONTH THEN
        CHANGE " " TO @SM IN Y.CLOSE.MONTH
        Y.CLOSE.LEN = LEN(Y.CLOSE.MONTH)
        IF Y.CLOSE.LEN EQ 17 THEN
            Y.M1 = FIELD(Y.CLOSE.MONTH,@SM,1)
            Y.M2 = FIELD(Y.CLOSE.MONTH,@SM,2)
        END
        Y.CLOSE.LEN = LEN(Y.CLOSE.MONTH)
        IF Y.CLOSE.LEN EQ 8 THEN
            Y.M1 = Y.CLOSE.MONTH
            Y.M2 = ''
        END
        IF Y.M1 THEN
            CALL EB.DATE.FORMAT.DISPLAY(Y.M1,Y.FROM.MONTH, '', '')
        END
        IF Y.M2 THEN
            CALL EB.DATE.FORMAT.DISPLAY(Y.M2,Y.TO.MONTH, '', '')
        END

        IF Y.M2 EQ '' THEN
            Y.CLASSIFICATION = Y.FROM.MONTH
        END ELSE
            Y.CLASSIFICATION = " FECHA: " : Y.FROM.MONTH:' - ':Y.TO.MONTH
        END
    END

    IF Y.TXN.TYPE THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':" TIPO TXN.: ":Y.TXN.TYPE
        END ELSE
            Y.CLASSIFICATION = "TIPO TXN.:":Y.TXN.TYPE
        END
    END

    IF Y.AGENCY THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':"AGENCIA: ":Y.AGENCY
        END ELSE
            Y.CLASSIFICATION =" AGENCIA: ":Y.AGENCY
        END
    END

    IF Y.TXN.USER THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':" USUARIO PROCESA: ":Y.TXN.USER
        END ELSE
            Y.CLASSIFICATION = "USUARIO PROCESA: ":Y.TXN.USER
        END
    END
    IF Y.COMPANY.NAME THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':" NOMBRE BENEFICIARIO: ":Y.COMPANY.NAME
        END ELSE
            Y.CLASSIFICATION = "NOMBRE BENEFICIARIO: ":Y.COMPANY.NAME
        END
    END

    IF Y.CLOSE.MONTH EQ '' AND Y.TXN.TYPE EQ '' AND Y.AGENCY EQ '' AND Y.TXN.USER EQ '' AND Y.COMPANY.NAME EQ '' THEN
        Y.CLASSIFICATION = 'ALL'
    END
    IF Y.CLASSIFICATION THEN
        O.DATA = Y.CLASSIFICATION
    END ELSE
        O.DATA = ''
    END

RETURN
END
