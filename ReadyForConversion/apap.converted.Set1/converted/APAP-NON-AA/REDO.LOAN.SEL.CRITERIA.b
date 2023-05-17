SUBROUTINE REDO.LOAN.SEL.CRITERIA
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.LOAN.SEL.CRITERIA
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       : Enquiry REDO.LOAN.PAYMENT.COB
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*    23 12 2011           Ganesh R          ODR-2010-03-0142- 166         Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB PROCESS.PARA

RETURN
*-------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.CRITERIA = ''
    Y.FLAG = ''
    Y.PORTFOLIO.TYPE  = FIELD(O.DATA,'*',1)
    Y.FROM.DATE       = FIELD(O.DATA,'*',2)
    Y.TO.DATE         = FIELD(O.DATA,'*',3)
    Y.USER.ID         = FIELD(O.DATA,'*',4)
    Y.AUTHORISER.ID   = FIELD(O.DATA,'*',5)
    Y.CO.CODE         = FIELD(O.DATA,'*',6)
    Y.PORT2           = FIELD(O.DATA,'*',7)
    Y.CO.CODE2        = FIELD(O.DATA,'*',8)

    IF Y.PORTFOLIO.TYPE THEN
        Y.CRITERIA = Y.PORT2:' - ':Y.PORTFOLIO.TYPE:' '
        Y.FLAG = 1
    END

    IF Y.FROM.DATE THEN
        Y.CRITERIA := 'Desde la fecha - ':Y.FROM.DATE:' '
        Y.FLAG = 1
    END

    IF Y.TO.DATE THEN
        Y.CRITERIA := 'Hasta la fecha - ':Y.TO.DATE:' '
        Y.FLAG = 1
    END

    IF Y.USER.ID THEN
        Y.CRITERIA := 'Usuario Genera Trx - ':Y.USER.ID:' '
        Y.FLAG = 1
    END

    IF Y.AUTHORISER.ID THEN
        Y.CRITERIA := 'Usuario que Autoriza - ':Y.AUTHORISER.ID:' '
        Y.FLAG = 1
    END

    IF Y.CO.CODE THEN
        Y.CRITERIA := Y.CO.CODE2:' - ':Y.CO.CODE:' '
        Y.FLAG = 1
    END

    IF Y.FLAG EQ '' THEN
        Y.CRITERIA = 'ALL'
    END

    O.DATA = Y.CRITERIA

RETURN
*-------------------------------------------------------------
END       ;* End of program
