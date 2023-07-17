* @ValidationCode : MjoxMzcyMjA5OTM3OkNwMTI1MjoxNjgxMjgyODE4NjIyOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:30:18
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
SUBROUTINE REDO.APAP.CONV.GET.CLASS
*************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: PRADEEP P
* PROGRAM NAME: REDO.APAP.CONV.GET.CLASS
* ODR NO      : ODR-2010-03-0099
*----------------------------------------------------------------------
* DESCRIPTION:   This is a conversion routine attached to the Enquiry
*                REDO.APAP.ENQ.REJ.DEBT.DET/REP which display the selection fields
*                based on Values inputted by the USER
* IN PARAMETER : O.DATA
* OUT PARAMETER: 0.DATA
* LINKED WITH  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE        WHO           REFERENCE         DESCRIPTION
* 10.Nov.2010  PRADEEP P    ODR-2010-03-0099  INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*

OPENFILES:
*----------

    FN.USER = 'F.USER'
    F.USER = ''
    CALL OPF(FN.USER,F.USER)
RETURN

PROCESS:
*-------
    Y.FINAL = ''

    LOCATE 'DATE' IN D.FIELDS<1> SETTING Y.DATE.POS THEN
        Y.DATE = D.RANGE.AND.VALUE<Y.DATE.POS>
        CALL EB.DATE.FORMAT.DISPLAY(Y.DATE,Y.DATE.2, '', '')
        Y.FINAL = "Fecha - ":Y.DATE.2
    END

    LOCATE 'CUSTOMER.CODE' IN D.FIELDS<1> SETTING Y.CUS.POS THEN
        Y.CLIENT = D.RANGE.AND.VALUE<Y.CUS.POS>
        IF Y.FINAL THEN
            Y.FINAL := ",":"Cliente - ":Y.CLIENT
        END ELSE
            Y.FINAL = "Cliente - ":Y.CLIENT
        END
    END

    LOCATE 'BENEFICIARY' IN D.FIELDS<1> SETTING Y.BEN.POS THEN
        Y.BENIFICIARY = D.RANGE.AND.VALUE<Y.BEN.POS>
        IF Y.FINAL THEN
            Y.FINAL := ",":"Pago Beneficiario - ":Y.BENIFICIARY
        END ELSE
            Y.FINAL = "Pago Beneficiario - ":Y.BENIFICIARY
        END
    END

    LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGEN.POS THEN
        Y.AGENCY = D.RANGE.AND.VALUE<Y.AGEN.POS>
        IF Y.FINAL THEN
            Y.FINAL := ",":"Agencia - ":Y.AGENCY
        END ELSE
            Y.FINAL = "Agencia - ":Y.AGENCY
        END
    END

    IF NOT(Y.FINAL) THEN
        Y.FINAL = 'TODOS'
    END


    O.DATA = Y.FINAL

RETURN
END
