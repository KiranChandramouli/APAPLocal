SUBROUTINE REDO.APAP.E.CNV.AMT.FORMAT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    :
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.CNV.FORM.SEL is a conversion routine attached to the enquiries
*                    REDO.ENQ.FT.TRANSIT and REDO.ENQ.FT.TRANSIT.RPT. The routine formats the amount &
*                    the value back to O.DATA
*In Parameter      : N/A
*Out Parameter     : O.DATA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date             Who                      Reference                 Description
*   ------          ------                     -------------             -------------
*  23 Dec 2010     MOhammed Anies K           ODR-2010-08-0172          Initial Creation
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

    Y.COUNT.AMOUNT = O.DATA

    Y.AMOUNT = ''
    Y.DEC.POINT = ''
    Y.CHQ.COUNT = ''

    Y.CHQ.COUNT = FIELD(Y.COUNT.AMOUNT,'/',1,1)

    Y.AMOUNT = FIELD(Y.COUNT.AMOUNT,'/',2,1)

    Y.DEC.POINT = FIELD(Y.AMOUNT,'.',2,1)

    IF Y.DEC.POINT EQ '' THEN
        Y.AMOUNT = Y.AMOUNT:'.00'
    END

    O.DATA = Y.CHQ.COUNT:'/':Y.AMOUNT

RETURN
*--------------------------------------------------------------------------------------------------------
END
