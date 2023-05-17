SUBROUTINE REDO.E.CONV.CLASSIF
*-----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RAMKUMAR G
* PROGRAM NAME: REDO.E.CONV.CLASSIF
* ODR NO      : ODR-2010-08-0176
*----------------------------------------------------------------------
* DESCRIPTION  : This is a conversion routine attached to the Enquiry
*                REDO.ENQ.FROZ.ACCT which display the selection fields
*                based on Values inputted by the USER
*
* IN PARAMETER : O.DATA
* OUT PARAMETER: O.DATA
* LINKED WITH  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*    DATE        WHO           REFERENCE         DESCRIPTION
* 09 Mar 2011  RAMKUMAR G  ODR-2010-08-0176   INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*
    GOSUB PROCESS
*
RETURN

*-------
PROCESS:
*-------
    Y.FINAL = ''
* Locate the values
*
    LOCATE "TRANSACTION.DATE" IN D.FIELDS<1> SETTING Y.AC.TY.POS THEN
        Y.AC.TYPE               = D.RANGE.AND.VALUE<Y.AC.TY.POS>
        Y.COUNT = DCOUNT(Y.AC.TYPE,@SM)
        IF Y.COUNT EQ 2 THEN
            Y.AC.TYPE.1 = ICONV(Y.AC.TYPE<1,1,1>,'DJ')
            Y.AC.TYPE.1 = OCONV(Y.AC.TYPE.1,'D4E/')
            Y.AC.TYPE.2 = ICONV(Y.AC.TYPE<1,1,2>,'DJ')
            Y.AC.TYPE.2 = OCONV(Y.AC.TYPE.2,'D4E/')
            IF Y.FINAL THEN
                Y.FINAL := ",FECHA DE TRANSACCION - ":Y.AC.TYPE.1:" - ":Y.AC.TYPE.2
            END ELSE
                Y.FINAL = "FECHA DE TRANSACCION - ":Y.AC.TYPE.1:" - ":Y.AC.TYPE.2
            END
        END ELSE
            Y.AC.TYPE = ICONV(Y.AC.TYPE<1>,'DJ')
            Y.AC.TYPE = OCONV(Y.AC.TYPE<1>,'D4E/')
            IF Y.FINAL THEN
                Y.FINAL := ",FECHA DE TRANSACCION - ":Y.AC.TYPE
            END ELSE
                Y.FINAL = "FECHA DE TRANSACCION - ":Y.AC.TYPE
            END
        END
    END
*
    LOCATE "CHANNEL" IN D.FIELDS<1> SETTING Y.NOTIF.POS THEN
        Y.NOTIF                = D.RANGE.AND.VALUE<Y.NOTIF.POS>
        IF Y.FINAL THEN
            Y.FINAL := ",CANAL TRANSACCION - ":Y.NOTIF
        END ELSE
            Y.FINAL = "CANAL TRANSACCION - ":Y.NOTIF
        END
    END
*
    LOCATE "CURRENCY" IN D.FIELDS<1> SETTING Y.BLOCK.POS THEN
        Y.BLOCK.GARNISHMENT = D.RANGE.AND.VALUE<Y.BLOCK.POS>
        IF Y.FINAL THEN
            Y.FINAL := ",MONEDA - ":Y.BLOCK.GARNISHMENT
        END ELSE
            Y.FINAL = "MONEDA - ":Y.BLOCK.GARNISHMENT
        END
    END
*
    LOCATE "TRANSACTION.TYPE" IN D.FIELDS<1> SETTING Y.DATE.POS THEN
        Y.DATE               = D.RANGE.AND.VALUE<Y.DATE.POS>
        IF Y.FINAL THEN
            Y.FINAL := ",TIPO DE TRANSACCION - ":Y.DATE
        END ELSE
            Y.FINAL = "TIPO DE TRANSACCION - ":Y.DATE
        END
    END
*
    IF Y.FINAL EQ '' THEN
        O.DATA = 'ALL'
    END ELSE
        O.DATA = Y.FINAL
    END
*
    IF Y.AC.TYPE EQ "" AND Y.NOTIF EQ "" AND Y.BLOCK.GARNISHMENT EQ "" AND Y.DATE EQ "" THEN
        O.DATA = 'ALL'
    END
*
RETURN
END
