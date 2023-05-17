SUBROUTINE REDO.ENQ.CONV.GET.DATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ENQ.CONV.GET.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the TIME
*                    from TIME.STAMP and returns it to O.DATA
*Linked With       : Enquiry REDO.ENQ.ATH.ACQUIRER,REDO.ENQ.STLMT.0420,REDO.ATH.STLMT.REJ
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date              Who                  Reference                                 Description
*     ------            -----                -------------                             -------------
*    20.12.2010     Akthar Rasool S         ODR-2010-08-0469                         Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para


    Y.TIME.DATE = TIMEDATE()

    O.DATA = Y.TIME.DATE[9,12]

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
