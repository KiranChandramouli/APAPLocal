SUBROUTINE REDO.APAP.CONV.GET.TIME
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.GET.TIME
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the TIME
*                    from TIME.STAMP and returns it to O.DATA
*Linked With       : Enquiry
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date          Who                       Reference                                 Description
*     ------         -----                    -------------                             -------------
* 11 NOV 2010    SHIVA PRASAD              ODR-2010-03-0011                            Initial Creation
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
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.TIME.DATE = TIMEDATE()
    O.DATA = Y.TIME.DATE[1,8]

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
*---------------------------------------------------------------------------------------------------------
