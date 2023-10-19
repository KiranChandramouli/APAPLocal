$PACKAGE APAP.TAM
SUBROUTINE REDO.R.GET.MID.RATE.CM(P.IN.CCY.ID, P.IN.MARKET.ID, P.OUT.MID.RATE)
******************************************************************************
*
*    Get the MiddleRate for the currency, using the currency market
*
* =============================================================================
*
*    First Release : TAM
*    Developed for : TAM
*    Developed by  : TAM
*    Date          : 2010-11-15
*
*=======================================================================
* Input/Output
*              P.IN.CCY.ID                  (in)            Currency Code
*              P.IN.MARKET.ID               (in)            Currency Market
*              P.OUT.MID.RATE               (out)           Middle Revaluation Rate
*
** 13-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 13-04-2023 Skanda R22 Manual Conversion - No changes
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.CURRENCY
    $INSERT I_F.COMPANY
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
*
    FIND P.IN.MARKET.ID IN R.CCY<EB.CUR.CURRENCY.MARKET,1> SETTING Y.FM.POS,Y.VM.POS THEN
        P.OUT.MID.RATE = R.CCY<EB.CUR.MID.REVAL.RATE,Y.VM.POS>
    END ELSE
        E = "CURRENCY MARKET & NOT DEF FOR CURRENCY &"
        E<2> = P.IN.MARKET.ID : @VM : P.IN.CCY.ID
    END
RETURN
*
*
* ---------
INITIALISE:
* ---------
*

* If Local Currency Then 1 will be returned
    Y.I = EB.COM.LOCAL.CURRENCY
    Y.I = R.COMPANY(Y.I)
    Y.I = Y.I++
    IF R.COMPANY(EB.COM.LOCAL.CURRENCY) EQ P.IN.CCY.ID THEN
        P.OUT.MID.RATE = 1
        PROCESS.GOAHEAD = 0
        RETURN
    END

    PROCESS.GOAHEAD = 1
    CALL CACHE.READ('F.CURRENCY', P.IN.CCY.ID, R.CCY ,YERR)
    IF YERR THEN
        E = "ST-REDO.COL.RECORD.NOT.FOUND"
        E<2> = P.IN.CCY.ID : @VM : 'F.CURRENCY'
        PROCESS.GOAHEAD = 0
    END
*
*
RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 2
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1

                IF P.IN.CCY.ID EQ "" THEN
                    PROCESS.GOAHEAD = 0
                    E = "PARAMETER P.IN.CCY.ID IS REQUIRED"
                END
*
                IF P.IN.MARKET.ID EQ "" THEN
                    PROCESS.GOAHEAD = 0
                    E = "PARAMETER P.IN.MARKET.ID IS REQUIRED"
                END
*
        END CASE
        LOOP.CNT +=1
    REPEAT
*
RETURN
*
END
