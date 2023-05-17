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
