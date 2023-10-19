* @ValidationCode : MjoxNzI1MTU1MTIzOkNwMTI1MjoxNjg1NTM2MDM3Njk3OnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 17:57:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.CCY.RATE
*---------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Chandra Prakash T
* Program Name : REDO.V.VAL.CCY.RATE
* ODR NUMBER : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description : This VALIDATION routine will do check the foreign currency and currency market defintion in the transaction, will pick the
* exchange rate for the currency based on the Buy/Sell type of transaction involved
* In parameter : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date Author Reference Description
* 13-Jul-2010 Chandra Prakash T ODR-2010-01-0213 Initial creation
* 17-Sep-2010 Chandra Prakash T ODR-2010-09-0014 Change Request CR 023 - CURRENCY MARKET & Exchange Rates
* 21-Jul-2011 Pradeep S PACS00082438 Pool Rate value will not be re-calculated for FX
*----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,F.READ TO CACHE.READ
*13-04-2023              Samaran T                R22 Manual Code conversion                        Call Routine Format Modified
*---------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.CURRENCY
    $INSERT I_F.REDO.CCY.MKT.FXSN

    GOSUB OPEN.FILES
    GOSUB LOCAL.REF.POSITIONS
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------------
    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.REDO.CCY.MKT.FXSN = 'F.REDO.CCY.MKT.FXSN'
    F.REDO.CCY.MKT.FXSN = ''
    CALL OPF(FN.REDO.CCY.MKT.FXSN,F.REDO.CCY.MKT.FXSN)

RETURN
*----------------------------------------------------------------------------------
LOCAL.REF.POSITIONS:
*----------------------------------------------------------------------------------
    L.FX.POOL.RATE.POS = ''
    CALL GET.LOC.REF("FOREX","L.FX.POOL.RATE",L.FX.POOL.RATE.POS)

RETURN
*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------
    R.REDO.CCY.MKT.FXSN = ''
    REDO.CCY.MKT.FXSN.ERR = ''
    CALL CACHE.READ(FN.REDO.CCY.MKT.FXSN,"SYSTEM",R.REDO.CCY.MKT.FXSN,REDO.CCY.MKT.FXSN.ERR)

    CCY.MKT.CODES = R.REDO.CCY.MKT.FXSN<REDO.CMKT.CCY.MKT.CODE>
    CHANGE @VM TO @FM IN CCY.MKT.CODES

    BEGIN CASE
        CASE APPLICATION EQ 'FOREX'
            GOSUB PROCESS.FOREX
        CASE APPLICATION EQ 'TELLER'
* GOSUB PROCESS.TELLER
        CASE APPLICATION EQ 'FUNDS.TRANSFER'
            GOSUB PROCESS.FUNDS.TRANSFER
    END CASE
RETURN
*----------------------------------------------------------------------------------
PROCESS.FOREX:
*----------------------------------------------------------------------------------
    BUY.FLAG = 0
    SELL.FLAG = 0
    CURR.MARKET = R.NEW(FX.CURRENCY.MARKET)
    CCY.BOUGHT = R.NEW(FX.CURRENCY.BOUGHT)
    CCY.SOLD = R.NEW(FX.CURRENCY.SOLD)
*PACS00082438 - S
    Y.POOL.RATE = R.NEW(FX.LOCAL.REF)<1,L.FX.POOL.RATE.POS>
    IF Y.POOL.RATE NE '' THEN
        RETURN
    END
*PACS00082438 - E
    IF CCY.BOUGHT NE LCCY THEN
        CURR.ID = CCY.BOUGHT
        BUY.FLAG = 1
    END ELSE
        CURR.ID = CCY.SOLD
        SELL.FLAG = 1
    END

    LOCATE "FX.POOL.RATE" IN CCY.MKT.CODES SETTING FX.TR.POS THEN
        FX.TREASURY.MKT = R.REDO.CCY.MKT.FXSN<REDO.CMKT.CCY.MKT,FX.TR.POS>
    END

    TXN.FCY = CURR.ID
    GOSUB GET.CURRENCY.REC

    LOCATE CURR.MARKET IN CCY.MKTS SETTING CURR.MARKET.POS THEN
        IF BUY.FLAG EQ 1 THEN
            EFFECTIVE.RATE = R.CURRENCY.REC<EB.CUR.BUY.RATE,CURR.MARKET.POS>
        END
        IF SELL.FLAG EQ 1 THEN
            EFFECTIVE.RATE = R.CURRENCY.REC<EB.CUR.SELL.RATE,CURR.MARKET.POS>
        END
    END

    LOCATE FX.TREASURY.MKT IN CCY.MKTS SETTING TREASURY.MKT.POS THEN
        IF BUY.FLAG EQ 1 THEN
            R.NEW(FX.LOCAL.REF)<1,L.FX.POOL.RATE.POS>= R.CURRENCY.REC<EB.CUR.BUY.RATE,TREASURY.MKT.POS>
        END
        IF SELL.FLAG EQ 1 THEN
            R.NEW(FX.LOCAL.REF)<1,L.FX.POOL.RATE.POS>= R.CURRENCY.REC<EB.CUR.SELL.RATE,TREASURY.MKT.POS>
        END
    END

    BEGIN CASE
        CASE R.NEW(FX.DEAL.TYPE) EQ 'SP'
            IF R.NEW(FX.SPOT.RATE) EQ "" THEN
                R.NEW(FX.SPOT.RATE) = EFFECTIVE.RATE
            END
        CASE R.NEW(FX.DEAL.TYPE) EQ 'FW'
            IF R.NEW(FX.FORWARD.RATE) EQ "" THEN
                R.NEW(FX.FORWARD.RATE) = EFFECTIVE.RATE
            END
    END CASE

RETURN
*----------------------------------------------------------------------------------
PROCESS.FUNDS.TRANSFER:
*----------------------------------------------------------------------------------
    IF R.NEW(FT.DEBIT.CURRENCY) EQ R.NEW(FT.CREDIT.CURRENCY) THEN
        RETURN
    END

    IF R.NEW(FT.DEBIT.CURRENCY) NE LCCY THEN
        TXN.FCY = R.NEW(FT.DEBIT.CURRENCY)
    END ELSE
        TXN.FCY = R.NEW(FT.CREDIT.CURRENCY)
    END

    LOCATE "FT.ACCT.TRANSFER" IN CCY.MKT.CODES SETTING FT.MKT.POS THEN
        CURR.MARKET = R.REDO.CCY.MKT.FXSN<REDO.CMKT.CCY.MKT,FT.MKT.POS>
    END
    GOSUB GET.CURRENCY.REC
* LOCATE CURR.MARKET IN CCY.MKTS SETTING CURR.MARKET.POS THEN
* IF R.NEW(FT.CUSTOMER.RATE) EQ "" THEN
* R.NEW(FT.CUSTOMER.RATE) = R.CURRENCY.REC<EB.CUR.MID.REVAL.RATE,CURR.MARKET.POS>
* END
* END
*This part is used for charge and commision calculation
    IF PGM.VERSION EQ ",REDO.BUY.ACTR" OR PGM.VERSION EQ ",REDO.SELL.ACTR" THEN
*CALL APAP.REDOVER.REDO.V.FT.CALC.COMM
        APAP.REDOVER.redoVFtCalcComm()    ;*R22 MANUAL CODE CONVERSION
        IF R.NEW(FT.DEBIT.CUSTOMER) THEN
            R.NEW(FT.PROFIT.CENTRE.CUST) = R.NEW(FT.DEBIT.CUSTOMER)
            RETURN
        END
        IF R.NEW(FT.CREDIT.CUSTOMER) THEN
            R.NEW(FT.PROFIT.CENTRE.CUST) = R.NEW(FT.CREDIT.CUSTOMER)
            RETURN
        END
    END

RETURN
*----------------------------------------------------------------------------------
GET.CURRENCY.REC:
*----------------------------------------------------------------------------------
    R.CURRENCY.REC = ""
    CURRENCY.ERR = ""
    CALL CACHE.READ(FN.CURRENCY, TXN.FCY, R.CURRENCY.REC, CURRENCY.ERR)   ;*R22 AUTO CODE CONVERSION
    CCY.MKTS = R.CURRENCY.REC<EB.CUR.CURRENCY.MARKET>
    CHANGE @VM TO @FM IN CCY.MKTS

RETURN
END
