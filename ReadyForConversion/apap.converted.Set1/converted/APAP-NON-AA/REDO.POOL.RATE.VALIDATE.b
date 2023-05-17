SUBROUTINE REDO.POOL.RATE.VALIDATE
*-----------------------------------------------------------------------------
*  Description
* ------------------------------------------------------------------------
* Its a .VALIDATE Routine
* If Bank Product Equal to ASSET Then Sell Rate Field is Made Mandatory
* If Bank Product Equal to LIABILITY Then Buy Rate Field is Mandatory
*
*-----------------------------------------------------------------------------
* COMPANY      : APAP
* DEVELOPED BY : Kishore.SP
* PROGRAM NAME : REDO.POOL.RATE.VALIDATE
* REFERENCE    : ODR-2009-10-0325
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.POOL.RATE
*-----------------------------------------------------------------------------
    GOSUB GET.VALUES
RETURN
*-----------------------------------------------------------------------------
GET.VALUES:
*----------
*Get The Value from Bank Product
*
    Y.BANK.PRODUCT.ARR = R.NEW(PL.RATE.BANK.PRODUCT)
    Y.SELL.RATE.ARR = R.NEW(PL.RATE.SELL.RATE)
    Y.BUY.RATE.ARR = R.NEW(PL.RATE.BUY.RATE)
    Y.BANK.PRODUCT.CNT = DCOUNT(Y.BANK.PRODUCT.ARR,@VM)
    Y.CNTR = 1
    LOOP
    WHILE Y.CNTR LE Y.BANK.PRODUCT.CNT
*
* Locating the Asset and Liablity
*
        LOCATE 'ASSET' IN Y.BANK.PRODUCT.ARR<1,Y.CNTR> SETTING Y.POS.ASS THEN
            Y.SELL.RATE = Y.SELL.RATE.ARR<1,Y.POS.ASS,1>
            GOSUB ASSET.PROCESS
        END
*
        LOCATE 'LIABILITY' IN Y.BANK.PRODUCT.ARR<1,Y.CNTR> SETTING Y.POS.LIAB THEN
            Y.BUY.RATE = Y.BUY.RATE.ARR<1,Y.POS.LIAB,1>
            GOSUB LIAB.PROCESS
        END
        Y.CNTR += 1
    REPEAT
*
RETURN
*-----------------------------------------------------------------------------
ASSET.PROCESS:
*-------------
*If Bank Product Equal to ASSET Then Sell Rate Field is Mandatory
*
    IF Y.POS.ASS NE '' AND Y.SELL.RATE EQ '' THEN
        ETEXT = 'AA-REDO.POOL.RATE.ASSET'
        CALL STORE.END.ERROR
    END
*
RETURN
*------------------------------------------------------------------------------
LIAB.PROCESS:
*-------------
*If Bank Product Equal to LIABILITY Then Buy Rate Field is Mandatory
*
    IF Y.POS.LIAB NE '' AND Y.BUY.RATE EQ '' THEN
        ETEXT = 'AA-REDO.POOL.RATE.LIAB'
        CALL STORE.END.ERROR
    END
*
RETURN
*-----------------------------------------------------------------------------
END
