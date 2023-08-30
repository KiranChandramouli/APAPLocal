* @ValidationCode : MjotOTgwMTk0NzI6Q3AxMjUyOjE2ODExMjQ1NTcyNjQ6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 16:32:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.CALL.USD.EQV(Y.USD.AMOUNT,Y.REC.STATUS,Y.CURR.NO)
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: INPUT routine
*------------
*DESCRIPTION:
*------------
* This is Input routine attached to the versions of FX, TT and FT. The routine
* is used to raise override based on settings mentioned in the FX.PRAMETER table and
* is used to send mail to appropriate user regardings the transaction status
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : -na-
*
*---------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 23-NOV-2010   A.SabariKumar     ODR-2010-07-0075       Initial Creation
* 04-NOV-2014   Vignesh Kumaar R  PACS00402351           TT-FT Rate-Currency market Issue
*---------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM F.READ TO CACHE.READ
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.CURRENCY

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

*--------------------------------------------------------------------------------------------------------
INITIALISE:
*-----------
* Initialise/Open necesaary variables/Files

    FN.FOREX = 'F.FOREX'
    F.FOREX = ''
    CALL OPF(FN.FOREX,F.FOREX)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

RETURN

*--------------------------------------------------------------------------------------------------------
PROCESS:
*------------
* The section process the GOSUB's based on the application involved

    Y.APPLICATION = APPLICATION
    Y.USD.AMOUNT = ''

    BEGIN CASE
        CASE Y.APPLICATION EQ 'FOREX'
            Y.CCY.MKT.RATE = '1'      ;* Added for PACS00402351
            GOSUB FX.PROCESS
        CASE Y.APPLICATION EQ 'FUNDS.TRANSFER'
            Y.CCY.MKT.RATE = '21'     ;* Added for PACS00402351
            GOSUB FT.PROCESS
        CASE Y.APPLICATION EQ 'TELLER'
            Y.CCY.MKT.RATE = '10'     ;* Added for PACS00402351
            GOSUB TT.PROCESS
    END CASE
RETURN

*--------------------------------------------------------------------------------------------------------
FX.PROCESS:
*--------------

    Y.REC.STATUS = R.NEW(FX.RECORD.STATUS)
    Y.CURRENCY.BOUGHT = R.NEW(FX.CURRENCY.BOUGHT)
    Y.CURRENCY.SOLD = R.NEW(FX.CURRENCY.SOLD)
    Y.CURR.NO = DCOUNT(R.NEW(FX.OVERRIDE),@VM)

    IF Y.CURRENCY.BOUGHT EQ 'USD' THEN
        Y.USD.AMOUNT = R.NEW(FX.AMOUNT.BOUGHT)
    END

    IF Y.CURRENCY.SOLD EQ 'USD' THEN
        Y.USD.AMOUNT =  R.NEW(FX.AMOUNT.SOLD)
    END

    IF Y.USD.AMOUNT EQ '' ELSE
        RETURN
    END

    IF Y.CURRENCY.BOUGHT EQ 'DOP' THEN
        Y.DOP.AMOUNT = R.NEW(FX.AMOUNT.BOUGHT)
    END

    IF Y.CURRENCY.SOLD EQ 'DOP' THEN
        Y.DOP.AMOUNT = R.NEW(FX.AMOUNT.SOLD)
    END
    IF Y.DOP.AMOUNT EQ R.NEW(FX.AMOUNT.BOUGHT) THEN
        Y.ID1 = 'USD'
        CALL CACHE.READ(FN.CURRENCY, Y.ID1, R.CURR, ERR)   ;*R22 AUTO CODE CONVERSION
        Y.CCY.MKT = R.CURR<EB.CUR.CURRENCY.MARKET>
        CHANGE @VM TO @FM IN Y.CCY.MKT
        LOCATE 1 IN Y.CCY.MKT SETTING CCY.POS THEN
            Y.RATE = R.CURR<EB.CUR.SELL.RATE,CCY.POS>
        END
    END

    IF Y.DOP.AMOUNT EQ R.NEW(FX.AMOUNT.SOLD) THEN
        Y.ID1 = 'USD'
        CALL CACHE.READ(FN.CURRENCY, Y.ID1, R.CURR, ERR)   ;*R22 AUTO CODE CONVERSION
        Y.CCY.MKT = R.CURR<EB.CUR.CURRENCY.MARKET>
        CHANGE @VM TO @FM IN Y.CCY.MKT
        LOCATE 1 IN Y.CCY.MKT SETTING CCY.POS THEN
            Y.RATE = R.CURR<EB.CUR.BUY.RATE,CCY.POS>
        END
    END
    Y.EXCHANGE.RATE = Y.RATE
    Y.CCY.SELL = 'DOP'
    Y.SELL.AMT = Y.DOP.AMOUNT
    Y.CCY.BUY = 'USD'
    GOSUB CONV.CCY
    Y.USD.AMOUNT = Y.BUY.AMT
RETURN

*--------------------------------------------------------------------------------------------------------
FT.PROCESS:
*-------------

    Y.REC.STATUS = R.NEW(FT.RECORD.STATUS)
    Y.DEBIT.CURRENCY = R.NEW(FT.DEBIT.CURRENCY)
    Y.CREDIT.CURRENCY = R.NEW(FT.CREDIT.CURRENCY)
    Y.DEBIT.AMT =R.NEW(FT.AMOUNT.DEBITED)
    Y.CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),@VM)
    Y.DEBIT.AMT.LEN = LEN(Y.DEBIT.AMT)
    Y.DEBIT.AMT = Y.DEBIT.AMT[4,(Y.DEBIT.AMT.LEN-3)]

    Y.CREDIT.AMT = R.NEW(FT.AMOUNT.CREDITED)
    Y.CREDIT.AMT.LEN = LEN(Y.CREDIT.AMT)
    Y.CR.CCY = Y.CREDIT.AMT[1,3]
    Y.CREDIT.AMT = Y.CREDIT.AMT[4,(Y.CREDIT.AMT.LEN-3)]

    IF Y.DEBIT.CURRENCY EQ 'USD' THEN
        Y.USD.AMOUNT = Y.DEBIT.AMT
    END

    IF Y.CREDIT.CURRENCY EQ 'USD' AND Y.USD.AMOUNT EQ '' THEN
        Y.USD.AMOUNT = Y.CREDIT.AMT
    END

    IF Y.USD.AMOUNT EQ '' THEN
        GOSUB FT.USD.CONVERSION
        Y.USD.AMOUNT = Y.BUY.AMT
    END
RETURN

*--------------------------------------------------------------------------
TT.PROCESS:
*-------------

    Y.CURRENCY.1 = ''
    Y.CURRENCY.2 = ''
    Y.REC.STATUS = R.NEW(TT.TE.RECORD.STATUS)
    Y.CURRENCY.1 = R.NEW(TT.TE.CURRENCY.1)
    Y.CURRENCY.2 = R.NEW(TT.TE.CURRENCY.2)
    Y.DC.MARKER = R.NEW(TT.TE.DR.CR.MARKER)
    Y.LOCAL.AMT1 = R.NEW(TT.TE.AMOUNT.LOCAL.1)
    Y.LOCAL.AMT2 = R.NEW(TT.TE.AMOUNT.LOCAL.2)
    Y.FCY.AMT1 = R.NEW(TT.TE.AMOUNT.FCY.1)
    Y.FCY.AMT2 = R.NEW(TT.TE.AMOUNT.FCY.2)
    Y.CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)
    Y.DEAL.RATE = R.NEW(TT.TE.DEAL.RATE)

    IF Y.CURRENCY.1 EQ 'USD' THEN
        Y.USD.AMOUNT = Y.FCY.AMT1
    END

    IF Y.CURRENCY.2 EQ 'USD' AND Y.USD.AMOUNT EQ '' THEN
        Y.USD.AMOUNT = Y.FCY.AMT2
    END

    IF Y.USD.AMOUNT EQ '' THEN
        GOSUB TT.USD.CONVERSION
        Y.USD.AMOUNT = Y.BUY.AMT
    END

RETURN

*-----------------------------------------------------------------------------
FT.USD.CONVERSION:
*--------------------

    IF Y.DEBIT.CURRENCY EQ 'DOP' THEN
        Y.CCY = Y.CREDIT.CURRENCY
        Y.EXCH.AMT = R.NEW(FT.CREDIT.AMOUNT)
    END ELSE
        Y.CCY = Y.DEBIT.CURRENCY
        Y.EXCH.AMT = R.NEW(FT.DEBIT.AMOUNT)
    END

    GOSUB CHECK.FOR.CROSS.CCY.SELL

RETURN

*-----------------------------------------------------------------------------
TT.USD.CONVERSION:
*--------------------
* Gets the USD conversion of the Amount involved in Transaction

    Y.DOP.AMOUNT = Y.LOCAL.AMT2
    Y.EXCH.AMT = ''
    IF Y.CURRENCY.1 NE 'DOP' THEN
        Y.CCY = Y.CURRENCY.1
        GOSUB CHECK.FOR.CROSS.CCY.SELL
    END

RETURN

*--------------------------------------------------------------------------------------------------------
GET.USD.DETS:
*--------------
* The section reads the currency table with USD as ID and gets the position of
* the currency market '1'

    Y.CCY = 'USD'
    CALL CACHE.READ(FN.CURRENCY, Y.CCY, R.CURR, CCY.ERR)    ;*R22 AUTO CODE CONVERSION
    Y.CCY.MKT = R.CURR<EB.CUR.CURRENCY.MARKET>
    CHANGE @VM TO @FM IN Y.CCY.MKT
    LOCATE Y.CCY.MKT.RATE IN Y.CCY.MKT SETTING CCY.POS THEN   ;* Added for PACS00402351
        RETURN
    END
RETURN
*------------------------*
CHECK.FOR.CROSS.CCY.SELL:
*------------------------*

    CALL CACHE.READ(FN.CURRENCY, Y.CCY, R.CURR, CCY.ERR)   ;*R22 AUTO CODE CONVERSION
    Y.CCY.MKT = R.CURR<EB.CUR.CURRENCY.MARKET>
    CHANGE @VM TO @FM IN Y.CCY.MKT
    LOCATE Y.CCY.MKT.RATE IN Y.CCY.MKT SETTING CCY.POS THEN   ;* Added for PACS00402351
        IF NOT(Y.EXCH.AMT) THEN
            Y.EXCH.AMT = Y.DOP.AMOUNT / Y.DEAL.RATE
        END
        Y.EXCH.RATE = R.CURR<EB.CUR.BUY.RATE,CCY.POS>
        Y.DOP.AMOUNT = Y.EXCH.AMT * Y.EXCH.RATE
    END

    GOSUB GET.USD.DETS
    Y.EXCHANGE.RATE = R.CURR<EB.CUR.SELL.RATE,CCY.POS>
    Y.CCY.SELL = 'DOP'
    Y.SELL.AMT = Y.DOP.AMOUNT
    Y.CCY.BUY = 'USD'
    GOSUB CONV.CCY

RETURN

*--------------------------------------------------------------------------------------------------------
CONV.CCY:
*------------
* The section calls the core routine EXCHRATE with the arguments sent and gets the
* value of the conversion amount
    Y.BUY.AMT = ''
    CALL EXCHRATE(Y.CCY.MKT.RATE,Y.CCY.BUY,Y.BUY.AMT,Y.CCY.SELL,Y.SELL.AMT,Y.BASE.CCY,Y.EXCHANGE.RATE,Y.DIFFERENCE,Y.LCY.AMT,Y.RETURN.CODE)

RETURN
*--------------------------------------------------------------------------------------------------------
END
