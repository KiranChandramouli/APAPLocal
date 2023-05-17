SUBROUTINE REDO.APAP.CONV.SELL
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.SELL
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry for header values(classification)
*                    the routine fetch values from the selection criteria and returns it to O.DATA
*Linked With       : Enquiry ENQ.REDO.OVERDRAFT.ACCOUNT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date           Who               Reference                                 Description
*     ------         -----             -------------                             -------------
* 02 DEC 2010       NATCHIMUTHU.P        ODR-2010-03-0089                         Initial Creation
*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON

    GOSUB INIT
    GOSUB SEL.LOCATE
    GOSUB PROCESS


INIT:
******

    Y.CO.CODE = ''
    Y.ACCOUNT.OFFICER = ''
    Y.CLASSIFICATION = ''

RETURN

SEL.LOCATE:
**********

    LOCATE "CO.CODE" IN D.FIELDS<1> SETTING Y.CO.CODE.POS THEN
        Y.CO.CODE = D.RANGE.AND.VALUE<Y.CO.CODE.POS>
    END

    LOCATE "ACCOUNT.OFFICER" IN D.FIELDS<1> SETTING Y.ACC.POS THEN
        Y.ACCOUNT.OFFICER   = D.RANGE.AND.VALUE<Y.ACC.POS>
    END

    LOCATE "CUSTOMER" IN D.FIELDS<1> SETTING Y.CUSTOMER.POS THEN
        Y.CUSTOMER  = D.RANGE.AND.VALUE<Y.CUSTOMER.POS>
    END
RETURN

PROCESS:
********
    IF Y.CO.CODE THEN
        Y.CLASSIFICATION = 'AGENCIA : ':Y.CO.CODE:''
    END

    IF Y.ACCOUNT.OFFICER THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION :=',':'OFICIAL DE CUENTA : ':Y.ACCOUNT.OFFICER
        END ELSE
            Y.CLASSIFICATION='OFICIAL DE CUENTA -':Y.ACCOUNT.OFFICER:''
        END
    END
    IF Y.CUSTOMER THEN
        IF Y.CLASSIFICATION THEN
            Y.CLASSIFICATION :=',':'CODIGO DE CLIENTE : ':Y.CUSTOMER
        END ELSE
            Y.CLASSIFICATION='CODIGO DE CLIENTE -':Y.CUSTOMER
        END

    END


    IF Y.CO.CODE AND Y.ACCOUNT.OFFICER AND Y.CUSTOMER THEN
        TEMP.RANGE.AND.VALUE = D.RANGE.AND.VALUE
        CHANGE @FM TO ',' IN TEMP.RANGE.AND.VALUE
    END

    IF Y.CLASSIFICATION THEN
        O.DATA = Y.CLASSIFICATION
    END ELSE
        O.DATA = 'ALL'
    END

RETURN
END
*---------------------------------------------------------------------------------------------------------------------
* PROGRAM END
*----------------------------------------------------------------------------------------------------------------------
