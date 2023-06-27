* @ValidationCode : MjozNTcyNDc2OTg6Q3AxMjUyOjE2ODQ4MzYwMzc5MTE6SVRTUzotMTotMToxNzU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 175
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   SM to@SM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.E.CONV.SEL.CRIT.102
*----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.E.CONV.SEL.CRIT.102
*----------------------------------------------------------------------------
*Description : REDO.APAP.E.CONV.SEL.CRIT.102 is a conversion routine attached to the enquiry REDO.INVST.RPT.ENQ,
*             this routine fetches the value from ENQ.SELECTION, formats them according to the selection criteria
*             and returns the value back to O.DATA
*Attached To :Enquiry REDO.INVST.RPT.ENQ
*Attached As :Conversion Routine
*Arguments-IN :NA
*Arguments-OUT : O.DATA  User selection
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.CATEGORY
*-----------------------------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS
RETURN
INIT:
*======
    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY  = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

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

    LOCATE "ACCOUNT" IN ENQ.SELECTION<2,1> SETTING Y.TXN.TYPE.POS THEN
        Y.ACCOUNT = ENQ.SELECTION<4,Y.TXN.TYPE.POS>
    END

    LOCATE "ACCOUNT.TYPE" IN ENQ.SELECTION<2,1> SETTING Y.AGENCY.POS THEN
        Y.ACCOUNT.TYPE = ENQ.SELECTION<4,Y.AGENCY.POS>
    END

    LOCATE "COMP.CODE" IN ENQ.SELECTION<2,1> SETTING Y.TXN.USER.POS THEN
        Y.COMP.CODE = ENQ.SELECTION<4,Y.TXN.USER.POS>
    END

    LOCATE "CUSTOMER" IN ENQ.SELECTION<2,1> SETTING Y.COMPANY.NAME.POS THEN
        Y.CUSTOMER = ENQ.SELECTION<4,Y.COMPANY.NAME.POS>
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
            Y.CLASSIFICATION = "FECHA DE TRANSACCION : " : Y.FROM.MONTH
        END ELSE
            Y.CLASSIFICATION = "FECHA DE TRANSACCION : " : Y.FROM.MONTH:' - ':Y.TO.MONTH
        END
    END

    IF Y.ACCOUNT THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':" NUMERO DE CUENTA : ":Y.ACCOUNT
        END ELSE
            Y.CLASSIFICATION = "NUMERO DE CUENTA :":Y.ACCOUNT
        END
    END

    IF Y.ACCOUNT.TYPE THEN
        IF Y.CLASSIFICATION THEN
            Y.CATEG.DESC=Y.ACCOUNT.TYPE
            GOSUB GET.CATEG.DESC
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':"TIPO DE CUENTA :":Y.CATEG.DESC
        END ELSE
            Y.CLASSIFICATION =" TIPO DE CUENTA : ":Y.CATEG.DESC
        END
    END

    IF Y.COMP.CODE THEN
        IF Y.CLASSIFICATION THEN
            GOSUB AGENCY.PROCESS
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':"AGENCIA :":Y.COMP.CODE
        END ELSE
            Y.CLASSIFICATION = "AGENCIA : ":Y.COMP.CODE
        END
    END
    IF Y.CUSTOMER THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION = Y.CLASSIFICATION:' , ':" CODIGO(S) CLIENTE(S) :":Y.CUSTOMER
        END ELSE
            Y.CLASSIFICATION = "CODIGO(S) CLIENTE(S) :":Y.CUSTOMER
        END
    END

    IF Y.CLOSE.MONTH EQ '' AND Y.ACCOUNT EQ '' AND Y.ACCOUNT.TYPE EQ '' AND Y.COMP.CODE EQ '' AND Y.CUSTOMER EQ '' THEN
        Y.CLASSIFICATION = 'ALL'
    END
    IF Y.CLASSIFICATION THEN
        O.DATA = Y.CLASSIFICATION
    END ELSE
        O.DATA = ''
    END

RETURN

AGENCY.PROCESS:
*=============

    CALL CACHE.READ(FN.COMPANY,Y.COMP.CODE,R.COM.REC,Y.COM.ERR)
    Y.COMP.CODE = R.COM.REC<EB.COM.COMPANY.NAME>

RETURN

GET.CATEG.DESC:
*==============
    R.COM.REC = ''
    CALL CACHE.READ(FN.CATEGORY,Y.ACCOUNT.TYPE,R.COM.REC,Y.COM.ERR)
    Y.CATEG.DESC = R.COM.REC<EB.CAT.DESCRIPTION>
RETURN
END
