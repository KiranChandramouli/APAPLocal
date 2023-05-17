SUBROUTINE REDO.APAP.E.CNV.FORM.SEL
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.APAP.E.CNV.FORM.SEL
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.CNV.FORM.SEL is a conversion routine attached to the enquiries
*                    REDO.ENQ.FT.TRANSIT and REDO.ENQ.FT.TRANSIT.RPT the routine fetches
*                    the value from ENQ.SELECTION formats them according to the selection criteria and returns
*                    the value back to O.DATA
*In Parameter      : N/A
*Out Parameter     : O.DATA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date             Who                      Reference                 Description
*   ------          ------                     -------------             -------------
*  14 Dec 2010     MOhammed Anies K           ODR-2010-08-0172          Initial Creation
*
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    Y.CRITERIA = ''

    LOCATE 'Y.TRANSIT.DATE' IN ENQ.SELECTION<2,1> SETTING Y.TRANSIT.DATE.POS THEN
        Y.CRITERIA := ' Fecha es igual a ':ENQ.SELECTION<4,Y.TRANSIT.DATE.POS>
    END

    LOCATE 'Y.ACCOUNT.NO' IN ENQ.SELECTION<2,1> SETTING Y.ACCOUNT.NO.POS THEN
        IF Y.CRITERIA THEN
            Y.CRITERIA := ','
        END
        Y.CRITERIA := ' No.de cuenta es igual a ':ENQ.SELECTION<4,Y.ACCOUNT.NO.POS>:''
    END

    O.DATA =  Y.CRITERIA

RETURN
*--------------------------------------------------------------------------------------------------------
END
