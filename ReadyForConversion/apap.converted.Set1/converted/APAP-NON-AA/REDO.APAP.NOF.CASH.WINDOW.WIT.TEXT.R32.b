SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.TEXT.R32(Y.CCY.LIST,Y.FINAL.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.TEXT.R32
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.WIT.TEXT is  routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.WIT, this routine is used to amend the report with static text for
*                    display of WITHDRAWALS
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.WIT
*In  Parameter     : Y.CCY.LIST    - The variable which holds all the curiences processed
*                    Y.FINAL.ARRAY - The array holding the values to be displayed
*Out Parameter     : Y.FINAL.ARRAY - The array holding the amended values to be displayed
*Files  Used       : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 15 Jun 2011       Marimuthu S              ODR-2011-04-0007 32         Changes made in REDO.APAP.NOF.CASH.WINDOW.WIT.TEXT
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

    GOSUB AMEND.ARRAY

RETURN
*--------------------------------------------------------------------------------------------------------
************
AMEND.ARRAY:
************
* In this para of the code, the static text is added in the report for display

    Y.B.LIST    = 3:@FM:4:@FM:5:@FM:6
    Y.B.COUNT   = DCOUNT(Y.B.LIST,@FM)

    Y.REC.COUNT = DCOUNT(Y.FINAL.ARRAY,@FM)
    Y.REC.START = 1

    LOOP
    WHILE Y.REC.START LE Y.REC.COUNT
        Y.VALS = Y.FINAL.ARRAY<Y.REC.START>
        IF Y.VALS NE '' THEN
            GOSUB WITHDRAWALS
            GOSUB TERM.INST.CANCEL
            GOSUB TERM.INST.INTREST
            GOSUB CREDIT.CARD.ADV
            GOSUB OTHER.CHQ.PAY
            GOSUB OTHER.EXPENSES
            GOSUB CASH.TRANSFERS
            GOSUB SELL.CURRENCY
            GOSUB SHORTAGE
            GOSUB DEBIT.ADJUST
            GOSUB GET.TOTAL.EXP
        END
        Y.REC.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
************
WITHDRAWALS:
************
    Y.FINAL.ARRAY<Y.REC.START,1,1>   = Y.CCY.LIST<Y.REC.START>
*Y.FINAL.ARRAY<Y.REC.START,1,2>   = 'RETIROS'
    Y.FINAL.ARRAY<Y.REC.START,1,3>   = ''
    Y.FINAL.ARRAY<Y.REC.START,1,4>   = ''
    Y.FINAL.ARRAY<Y.REC.START,1,5>   = ''
    Y.FINAL.ARRAY<Y.REC.START,1,6>   = ''
    Y.FINAL.ARRAY<Y.REC.START,1,7>   = ''
    Y.FINAL.ARRAY<Y.REC.START,1,8>   = 'RETIROS'

    Y.FINAL.ARRAY<Y.REC.START,2,1>   = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,2,2>   = 'AHORROS'
    Y.FINAL.ARRAY<Y.REC.START,2,7>   = Y.FINAL.ARRAY<Y.REC.START,2,4>  + Y.FINAL.ARRAY<Y.REC.START,2,5>  + Y.FINAL.ARRAY<Y.REC.START,2,6>

    Y.A = 2
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,3,1>   = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,3,2>   = 'CORRIENTES'
    Y.FINAL.ARRAY<Y.REC.START,3,7>   = Y.FINAL.ARRAY<Y.REC.START,3,4>  + Y.FINAL.ARRAY<Y.REC.START,3,5>  + Y.FINAL.ARRAY<Y.REC.START,3,6>

    Y.A = 3
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,4,1>   = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,4,2>   = 'TARJETA DE DEBITO'
    Y.FINAL.ARRAY<Y.REC.START,4,7>   = Y.FINAL.ARRAY<Y.REC.START,4,4>  + Y.FINAL.ARRAY<Y.REC.START,4,5>  + Y.FINAL.ARRAY<Y.REC.START,4,6>

    Y.A = 4
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,5,1>   = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,5,2>   = 'TOTAL RETIROS CTAS.'
    Y.FINAL.ARRAY<Y.REC.START,5,3>   = Y.FINAL.ARRAY<Y.REC.START,2,3> + Y.FINAL.ARRAY<Y.REC.START,3,3> + Y.FINAL.ARRAY<Y.REC.START,4,3>
    Y.FINAL.ARRAY<Y.REC.START,5,9>   = 'TOTAL RETIROS CTAS.'
    Y.FINAL.ARRAY<Y.REC.START,5,7>   = Y.FINAL.ARRAY<Y.REC.START,2,7>  + Y.FINAL.ARRAY<Y.REC.START,3,7>  + Y.FINAL.ARRAY<Y.REC.START,4,7>

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
TERM.INST.CANCEL:
*****************
    Y.FINAL.ARRAY<Y.REC.START,6,1>   = Y.CCY.LIST<Y.REC.START>
* Y.FINAL.ARRAY<Y.REC.START,6,2>   = 'CANCELAC.INVERSIONES'
    Y.FINAL.ARRAY<Y.REC.START,6,3>   = ''
    Y.FINAL.ARRAY<Y.REC.START,6,4>   = ''
    Y.FINAL.ARRAY<Y.REC.START,6,5>   = ''
    Y.FINAL.ARRAY<Y.REC.START,6,6>   = ''
    Y.FINAL.ARRAY<Y.REC.START,6,7>   = ''
    Y.FINAL.ARRAY<Y.REC.START,6,8>   = 'CANCELAC.INVERSIONES'

    Y.FINAL.ARRAY<Y.REC.START,7,1>   = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,7,2>   = 'CERTIF. FINANCIEROS'
    Y.FINAL.ARRAY<Y.REC.START,7,7>   = Y.FINAL.ARRAY<Y.REC.START,7,4>  + Y.FINAL.ARRAY<Y.REC.START,7,5>  + Y.FINAL.ARRAY<Y.REC.START,7,6>

    Y.A = 7
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,8,1>   = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,8,2>   = 'DEP.  PLAZO FIJO'
    Y.FINAL.ARRAY<Y.REC.START,8,7>   = Y.FINAL.ARRAY<Y.REC.START,8,4>  + Y.FINAL.ARRAY<Y.REC.START,8,5>  + Y.FINAL.ARRAY<Y.REC.START,8,6>

    Y.A = 8
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,9,1>   = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,9,2>   = 'CPH'
    Y.FINAL.ARRAY<Y.REC.START,9,7>   = Y.FINAL.ARRAY<Y.REC.START,9,4>  + Y.FINAL.ARRAY<Y.REC.START,9,5>  + Y.FINAL.ARRAY<Y.REC.START,9,6>

    Y.A = 9
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,10,1>  = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,10,2>  = 'TOTAL CANC. INV,'
    Y.FINAL.ARRAY<Y.REC.START,10,9>  = 'TOTAL CANC. INV,'
    Y.FINAL.ARRAY<Y.REC.START,10,3>  = Y.FINAL.ARRAY<Y.REC.START,7,3> + Y.FINAL.ARRAY<Y.REC.START,8,3> + Y.FINAL.ARRAY<Y.REC.START,9,3>
    Y.FINAL.ARRAY<Y.REC.START,10,7>  = Y.FINAL.ARRAY<Y.REC.START,7,7>  + Y.FINAL.ARRAY<Y.REC.START,8,7>  + Y.FINAL.ARRAY<Y.REC.START,9,7>

RETURN
*--------------------------------------------------------------------------------------------------------
******************
TERM.INST.INTREST:
******************
    Y.FINAL.ARRAY<Y.REC.START,11,1>  = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,11,2>  = 'RETIRO INTS. REINV.'
    Y.FINAL.ARRAY<Y.REC.START,11,3>  = ''
    Y.FINAL.ARRAY<Y.REC.START,11,4>  = ''
    Y.FINAL.ARRAY<Y.REC.START,11,5>  = ''
    Y.FINAL.ARRAY<Y.REC.START,11,6>  = ''
    Y.FINAL.ARRAY<Y.REC.START,11,7>  = ''
    Y.FINAL.ARRAY<Y.REC.START,11,8>  = 'RETIRO INTS. REINV.'

    Y.FINAL.ARRAY<Y.REC.START,12,1>  = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,12,2>  = 'CERTIF. FINANCIEROS'
    Y.FINAL.ARRAY<Y.REC.START,12,7>  = Y.FINAL.ARRAY<Y.REC.START,12,4>  + Y.FINAL.ARRAY<Y.REC.START,12,5>  + Y.FINAL.ARRAY<Y.REC.START,12,6>

    Y.A = 12
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,13,1>  = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,13,2>  = 'DEP.  PLAZO FIJO'
    Y.FINAL.ARRAY<Y.REC.START,13,7>  = Y.FINAL.ARRAY<Y.REC.START,13,4>  + Y.FINAL.ARRAY<Y.REC.START,13,5>  + Y.FINAL.ARRAY<Y.REC.START,13,6>

    Y.A = 13
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,14,1>  = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,14,2>  = 'CPH'
    Y.FINAL.ARRAY<Y.REC.START,14,7>  = Y.FINAL.ARRAY<Y.REC.START,14,4>  + Y.FINAL.ARRAY<Y.REC.START,14,5>  + Y.FINAL.ARRAY<Y.REC.START,14,6>

    Y.A = 14
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,15,1>  = Y.CCY.LIST<Y.REC.START>
*   Y.FINAL.ARRAY<Y.REC.START,15,2>  = 'TOTAL RET.INTS.REINV'
    Y.FINAL.ARRAY<Y.REC.START,15,9>  = 'TOTAL RET.INTS.REINV'
    Y.FINAL.ARRAY<Y.REC.START,15,3>  = Y.FINAL.ARRAY<Y.REC.START,12,3>  + Y.FINAL.ARRAY<Y.REC.START,13,3>  + Y.FINAL.ARRAY<Y.REC.START,14,3>
    Y.FINAL.ARRAY<Y.REC.START,15,7>  = Y.FINAL.ARRAY<Y.REC.START,12,7>  + Y.FINAL.ARRAY<Y.REC.START,13,7>  + Y.FINAL.ARRAY<Y.REC.START,14,7>

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CREDIT.CARD.ADV:
****************
    Y.FINAL.ARRAY<Y.REC.START,16,1>  = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,16,2>  = 'AVANCE EFECT.T.CRED.'
    Y.FINAL.ARRAY<Y.REC.START,16,3>  = ''
    Y.FINAL.ARRAY<Y.REC.START,16,4>  = ''
    Y.FINAL.ARRAY<Y.REC.START,16,5>  = ''
    Y.FINAL.ARRAY<Y.REC.START,16,6>  = ''
    Y.FINAL.ARRAY<Y.REC.START,16,7>  = ''
    Y.FINAL.ARRAY<Y.REC.START,16,8> = 'AVANCE EFECT.T.CRED.'

    Y.FINAL.ARRAY<Y.REC.START,17,1>  = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,17,2>  = 'VISA'
    Y.FINAL.ARRAY<Y.REC.START,17,7>  = Y.FINAL.ARRAY<Y.REC.START,17,4>  + Y.FINAL.ARRAY<Y.REC.START,17,5>  + Y.FINAL.ARRAY<Y.REC.START,17,6>

    Y.A = 17
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,18,1>  = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,18,2>  = 'MASTERCARD'
    Y.FINAL.ARRAY<Y.REC.START,18,7>  = Y.FINAL.ARRAY<Y.REC.START,18,4>  + Y.FINAL.ARRAY<Y.REC.START,18,5>  + Y.FINAL.ARRAY<Y.REC.START,18,6>

    Y.A = 18
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,19,1>  = Y.CCY.LIST<Y.REC.START>
*  Y.FINAL.ARRAY<Y.REC.START,19,2>  = 'TOTAL AVANCE T.CRED.'
    Y.FINAL.ARRAY<Y.REC.START,19,9> = 'TOTAL AVANCE T.CRED.'
    Y.FINAL.ARRAY<Y.REC.START,19,3> = Y.FINAL.ARRAY<Y.REC.START,17,3>  + Y.FINAL.ARRAY<Y.REC.START,18,3>
    Y.FINAL.ARRAY<Y.REC.START,19,7>  = Y.FINAL.ARRAY<Y.REC.START,17,7>  + Y.FINAL.ARRAY<Y.REC.START,18,7>

RETURN
*--------------------------------------------------------------------------------------------------------
**************
OTHER.CHQ.PAY:
**************
    Y.FINAL.ARRAY<Y.REC.START,20,1>  = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,20,2>  = 'OTROS CKS. PAGADOS'
    Y.FINAL.ARRAY<Y.REC.START,20,3>  = ''
    Y.FINAL.ARRAY<Y.REC.START,20,4>  = ''
    Y.FINAL.ARRAY<Y.REC.START,20,5>  = ''
    Y.FINAL.ARRAY<Y.REC.START,20,6>  = ''
    Y.FINAL.ARRAY<Y.REC.START,20,7>  = ''
    Y.FINAL.ARRAY<Y.REC.START,20,8>  = 'OTROS CKS. PAGADOS'

    Y.FINAL.ARRAY<Y.REC.START,21,1>  = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,21,2>  = 'PAGO CKS. ADMINIST.'
    Y.FINAL.ARRAY<Y.REC.START,21,7>  = Y.FINAL.ARRAY<Y.REC.START,21,4>  + Y.FINAL.ARRAY<Y.REC.START,21,5>  + Y.FINAL.ARRAY<Y.REC.START,21,6>

    Y.A = 21
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,22,1>  = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,22,2>  = 'PAGO OTROS CKS.'
    Y.FINAL.ARRAY<Y.REC.START,22,7>  = Y.FINAL.ARRAY<Y.REC.START,22,4>  + Y.FINAL.ARRAY<Y.REC.START,22,5>  + Y.FINAL.ARRAY<Y.REC.START,22,6>

    Y.A = 22
    GOSUB CHECK.FOR.VALUE

    Y.FINAL.ARRAY<Y.REC.START,23,1>  = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,23,2>  = 'TOTAL OTROS CKS.'
    Y.FINAL.ARRAY<Y.REC.START,23,9> = 'TOTAL OTROS CKS.'
    Y.FINAL.ARRAY<Y.REC.START,23,3>  = Y.FINAL.ARRAY<Y.REC.START,21,3>  + Y.FINAL.ARRAY<Y.REC.START,22,3>
    Y.FINAL.ARRAY<Y.REC.START,23,7>  = Y.FINAL.ARRAY<Y.REC.START,21,7>  + Y.FINAL.ARRAY<Y.REC.START,22,7>

RETURN
*--------------------------------------------------------------------------------------------------------
***************
OTHER.EXPENSES:
***************
    Y.FINAL.ARRAY<Y.REC.START,24,1>  = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,24,2>  = 'OTROS EGRESOS'
    Y.FINAL.ARRAY<Y.REC.START,24,3>  = ''
    Y.FINAL.ARRAY<Y.REC.START,24,4>  = ''
    Y.FINAL.ARRAY<Y.REC.START,24,5>  = ''
    Y.FINAL.ARRAY<Y.REC.START,24,6>  = ''
    Y.FINAL.ARRAY<Y.REC.START,24,7>  = ''
    Y.FINAL.ARRAY<Y.REC.START,24,8>  = 'OTROS EGRESOS'

    Y.FINAL.ARRAY<Y.REC.START,25,1>  = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,25,2>  = 'EGRESO TIPO'
    Y.FINAL.ARRAY<Y.REC.START,25,7>  = Y.FINAL.ARRAY<Y.REC.START,25,4>  + Y.FINAL.ARRAY<Y.REC.START,25,5>  + Y.FINAL.ARRAY<Y.REC.START,25,6>

    Y.A = 25
    GOSUB CHECK.FOR.VALUE

RETURN
*--------------------------------------------------------------------------------------------------------
***************
CASH.TRANSFERS:
***************
    Y.FINAL.ARRAY<Y.REC.START,26,1>  = Y.CCY.LIST<Y.REC.START>
*   Y.FINAL.ARRAY<Y.REC.START,26,2>  = 'TRANSF. ENVIADAS'
    Y.FINAL.ARRAY<Y.REC.START,26,3>  = ''
    Y.FINAL.ARRAY<Y.REC.START,26,4>  = ''
    Y.FINAL.ARRAY<Y.REC.START,26,5>  = ''
    Y.FINAL.ARRAY<Y.REC.START,26,6>  = ''
    Y.FINAL.ARRAY<Y.REC.START,26,7>  = ''
    Y.FINAL.ARRAY<Y.REC.START,26,8>  = 'TRANSF. ENVIADAS'

    Y.FINAL.ARRAY<Y.REC.START,27,1>  = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,27,2>  = 'POR CAJEROS/BOV'

    Y.FINAL.ARRAY<Y.REC.START,28,1>  = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,28,2>  = 'BCENTRAL/OTROS BCOS.'

    IF NOT(Y.FINAL.ARRAY<Y.REC.START,27,3>) THEN
        Y.FINAL.ARRAY<Y.REC.START,27,3> = 0
    END

    IF NOT(Y.FINAL.ARRAY<Y.REC.START,27,7>) THEN
        Y.FINAL.ARRAY<Y.REC.START,27,7> = 0
    END

    IF NOT(Y.FINAL.ARRAY<Y.REC.START,28,3>) THEN
        Y.FINAL.ARRAY<Y.REC.START,28,3> = 0
    END

    IF NOT(Y.FINAL.ARRAY<Y.REC.START,28,7>) THEN
        Y.FINAL.ARRAY<Y.REC.START,28,7> = 0
    END

RETURN
*--------------------------------------------------------------------------------------------------------
**************
SELL.CURRENCY:
**************
    Y.FINAL.ARRAY<Y.REC.START,29,1>  = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,29,2>  = 'VENTA DE DIVISAS'
    Y.FINAL.ARRAY<Y.REC.START,29,3>  = ''
    Y.FINAL.ARRAY<Y.REC.START,29,4>  = ''
    Y.FINAL.ARRAY<Y.REC.START,29,5>  = ''
    Y.FINAL.ARRAY<Y.REC.START,29,6>  = ''
    Y.FINAL.ARRAY<Y.REC.START,29,7>  = ''
    Y.FINAL.ARRAY<Y.REC.START,29,8>  = 'VENTA DE DIVISAS'

    Y.FINAL.ARRAY<Y.REC.START,30,1>  = Y.CCY.LIST<Y.REC.START>
    Y.FINAL.ARRAY<Y.REC.START,30,2>  = 'DIVISA'
    Y.FINAL.ARRAY<Y.REC.START,30,7>  = Y.FINAL.ARRAY<Y.REC.START,30,4>  + Y.FINAL.ARRAY<Y.REC.START,30,5>  + Y.FINAL.ARRAY<Y.REC.START,30,6>

    Y.A = 30
    GOSUB CHECK.FOR.VALUE

*    Y.FINAL.ARRAY<Y.REC.START,31,1>  = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,31,2>  = 'DIVISA 2'
*    Y.FINAL.ARRAY<Y.REC.START,31,7>  = Y.FINAL.ARRAY<Y.REC.START,31,4>  + Y.FINAL.ARRAY<Y.REC.START,31,5>  + Y.FINAL.ARRAY<Y.REC.START,31,6>

*    Y.A = 31
*    GOSUB CHECK.FOR.VALUE

RETURN
*--------------------------------------------------------------------------------------------------------
**************
DEBIT.ADJUST:
**************
    Y.FINAL.ARRAY<Y.REC.START,31,1>  = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,31,2>  = 'FALTANTE'
    Y.FINAL.ARRAY<Y.REC.START,31,4>  = ''
    Y.FINAL.ARRAY<Y.REC.START,31,5>  = ''
    Y.FINAL.ARRAY<Y.REC.START,31,6>  = ''
    Y.FINAL.ARRAY<Y.REC.START,31,3>  = ''
    Y.FINAL.ARRAY<Y.REC.START,31,8>  = 'REVERSO FALTANTE'

*   IF NOT(Y.FINAL.ARRAY<Y.REC.START,32,3>) THEN
*       Y.FINAL.ARRAY<Y.REC.START,32,3> = 0
*   END

    IF NOT(Y.FINAL.ARRAY<Y.REC.START,31,7>) THEN
        Y.FINAL.ARRAY<Y.REC.START,31,7> = 0
    END
RETURN
*--------------------------------------------------------------------------------------------------------
**************
GET.TOTAL.EXP:
**************
    Y.FINAL.ARRAY<Y.REC.START,33,1>  = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,33,2>  = 'TOTAL PAGADO'
    Y.FINAL.ARRAY<Y.REC.START,33,9>  = 'TOTAL PAGADO'
    Y.FINAL.ARRAY<Y.REC.START,33,4>  = ''
    Y.FINAL.ARRAY<Y.REC.START,33,5>  = ''
    Y.FINAL.ARRAY<Y.REC.START,33,6>  = ''

    Y.FINAL.ARRAY<Y.REC.START,33,7> = Y.FINAL.ARRAY<Y.REC.START,5,7> + Y.FINAL.ARRAY<Y.REC.START,10,7> + Y.FINAL.ARRAY<Y.REC.START,15,7> + Y.FINAL.ARRAY<Y.REC.START,19,7> + Y.FINAL.ARRAY<Y.REC.START,23,7> + Y.FINAL.ARRAY<Y.REC.START,25,7> + Y.FINAL.ARRAY<Y.REC.START,27,7> + Y.FINAL.ARRAY<Y.REC.START,28,7> + Y.FINAL.ARRAY<Y.REC.START,30,7> + Y.FINAL.ARRAY<Y.REC.START,31,7> + Y.FINAL.ARRAY<Y.REC.START,32,7>

RETURN
*--------------------------------------------------------------------------------------------------------
*********
SHORTAGE:
*********
    Y.FINAL.ARRAY<Y.REC.START,32,1>  = Y.CCY.LIST<Y.REC.START>
*    Y.FINAL.ARRAY<Y.REC.START,32,2>  = 'FALTANTE'
    Y.FINAL.ARRAY<Y.REC.START,32,4>  = ''
    Y.FINAL.ARRAY<Y.REC.START,32,5>  = ''
    Y.FINAL.ARRAY<Y.REC.START,32,6>  = ''
    Y.FINAL.ARRAY<Y.REC.START,32,3>  = ''
    Y.FINAL.ARRAY<Y.REC.START,32,8>  = 'FALTANTE'

*    IF NOT(Y.FINAL.ARRAY<Y.REC.START,32,3>) THEN
*        Y.FINAL.ARRAY<Y.REC.START,32,3> = 0
*    END

    IF NOT(Y.FINAL.ARRAY<Y.REC.START,32,7>) THEN
        Y.FINAL.ARRAY<Y.REC.START,32,7> = 0
    END
RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.FOR.VALUE:
****************
* In this para of the code, the variable is checked if it holds any value else its amended with ZERO

    Y.B.START = 1
    LOOP
    WHILE Y.B.START LE Y.B.COUNT
        Y.B = Y.B.LIST<Y.B.START>
        IF NOT(Y.FINAL.ARRAY<Y.REC.START,Y.A,Y.B>) THEN
            Y.FINAL.ARRAY<Y.REC.START,Y.A,Y.B> = 0
        END
        Y.B.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
