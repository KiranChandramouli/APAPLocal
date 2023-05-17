SUBROUTINE REDO.CONV.TEMP.REVERSE
**************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CONV.TEMP.REVERSE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.CONV.TEMP.REVERSE is a conversion routine attached to the ENQUIRY>
*                    REDO.APAP.ENQ.TEMP.CHQ.REV, the routine fetches the value from O.DATA delimited
*                    with stars and formats them according to the selection criteria and returns the value
*                     back to O.DATA
*Linked With       :
*In  Parameter     : N/A
*Out Parameter     : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 19 NOV 2010              Dhamu S             ODR-2010-03-0156            Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON



*********
MAIN.PARA:
**********

    GOSUB PROCESS.PARA

RETURN

*---------------------------------------------------------
PROCESS.PARA:
*************

    O.DATA = ''
    Y.RESULT = ''


    LOCATE 'ACCOUNT.NUMBER' IN ENQ.SELECTON<2,1> SETTING Y.AC.NO.POS THEN
        Y.RESULT := "NO.DE CUENTA - ":ENQ.SELECTION<4,Y.AC.NO.POS>:' '
    END

    LOCATE 'AMOUNT' IN ENQ.SELECTION<2,1> SETTING Y.AMT.POS THEN
        Y.RESULT := "MONTO - ":ENQ.SELECTION<4,Y.AMT.POS>:' '
    END

    LOCATE 'STATUS' IN ENQ.SELECTION<2,1> SETTING Y.STA.POS THEN
        Y.RESULT := "ESTATUS - ":ENQ.SELECTION<4,Y.STA.POS>:' '
    END

    O.DATA = Y.RESULT

RETURN

END
*-----------------------------------------------------------------------------------------------
