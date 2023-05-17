SUBROUTINE REDO.E.BUILD.CHECK.DATES(ENQ.DATA)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.BUILD.CHECK.DATES
*--------------------------------------------------------------------------------------------------------
*Description       : This is a BUILD routine, attached to enquiry to check the selection dates
*Linked With       : Enquiry
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                 Description
*   ------             -----               -------------              -------------
* 28 Dec 2010      Shiva Prasad Y                                    Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    LOCATE 'BOOKING.DATE' IN ENQ.DATA<2,1> SETTING Y.DATE.POS ELSE
        RETURN
    END

    Y.DATES = ENQ.DATA<4,Y.DATE.POS>
    CHANGE ' ' TO @FM IN Y.DATES
    Y.DATE.COUNT = DCOUNT(Y.DATES,@FM)
    Y.DATE.START = 1

    LOOP
    WHILE Y.DATE.START LE Y.DATE.COUNT
        COMI  = Y.DATES<Y.DATE.START>
        ETEXT = ""
        CALL IN2D("10","D")
        IF ETEXT OR LEN(Y.DATES<Y.DATE.START>) NE 8 THEN
            ENQ.ERROR<1> = 'EB-ENTER.VALID.BOOK.DATES'
            EXIT
        END
        IF Y.DATES<Y.DATE.START> GT TODAY THEN
            ENQ.ERROR<1> = 'EB-NO.FUTURE.DATE'
            EXIT
        END
        Y.DATE.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
END
