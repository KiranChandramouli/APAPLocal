SUBROUTINE S.REDO.CONV.LOCAL.CURR(P.CURRENCY.ID,P.CURR.MARKET,P.RETURN)
*
*--------------------------------------------------------------------------------------------
* Company Name : Bank Name
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description: This program get REVAL.RATE for an specific Currency & Currency.Market
*
*
* Linked With:
*               Get Balance Routines for : AA,LI,FX,MM & SC applications
*
*
* In Parameter:
*               P.CURRENCY.ID    (in)  Currency Id.
*               P.CURR.MARKET    (in)  Currency Market
*
* Out Parameter:
*               P.RETURN     (out)  Returns REVAL.RATE
*               E            (out)  Message in case Error
*
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 14/07/2011 - ODR-2011-03-0154
*              Get the local currency
*              avelasco@temenos.com
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*

*

    $INSERT I_F.CURRENCY

*
*--------------------------------------------------------------------------------------------
*

    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------


*Initialise

    CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY.ID, R.CCY, YERR)
    IF NOT(R.CCY) THEN
        E = "ST-REDO.CCRG.PARAMETER.IS.EMPTY" : @FM : "R.CCY" : @VM : "S.REDO.CCRG.MM.GET.BAL"
        PROCESS.GOAHEAD = @FALSE
    END
    IF PROCESS.GOAHEAD THEN
*Send the value of REVAL.RATE
        GOSUB GET.RATE
        IF PROCESS.GOAHEAD THEN
            P.RETURN = Y.REVAL.RATE
        END
    END


RETURN

*--------------------------------------------------------------------------------------------
GET.RATE:
*--------------------------------------------------------------------------------------------
*avelasco
* Get Rate
    Y.REVAL.RATE = ''

    LOCATE Y.CURRENCY.MARKET IN R.CCY<EB.CUR.CURRENCY.MARKET,1> SETTING Y.POS THEN
        Y.REVAL.RATE =  R.CCY<EB.CUR.REVAL.RATE,Y.POS>
    END

    IF NOT(Y.REVAL.RATE) THEN
        E = 'ST-REDO.CCRG.MID.REVAL.RATE.NO.DEF'  : @FM : "CURRENCY:": @VM :Y.CURRENCY.ID
        PROCESS.GOAHEAD = @FALSE
    END


RETURN

*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

    LOOP.CNT          = 1
    MAX.LOOPS         = 2
    PROCESS.GOAHEAD   = @TRUE
    P.RETURN          = ''
    Y.CURRENCY.ID     = ''
    Y.CURRENCY.MARKET = ''
    Y.REVAL.RATE  = ''


    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY  = ''
    R.CCY       = ''

    CALL OPF(FN.CURRENCY,F.CURRENCY)


RETURN


*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF NOT(P.CURRENCY.ID) THEN
                    E = "ST-REDO.CCRG.PARAMETER.IS.EMPTY" : @FM : "P.CURRENCY.ID" : @VM : "S.REDO.CONV.LOCAL.CURR"
                    PROCESS.GOAHEAD = @FALSE
                END ELSE
                    Y.CURRENCY.ID     = P.CURRENCY.ID
                END
            CASE LOOP.CNT EQ 2
                IF NOT(P.CURR.MARKET) THEN
                    P.CURR.MARKET = 1
                END
                Y.CURRENCY.MARKET = P.CURR.MARKET
        END CASE

        LOOP.CNT +=1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------

END
