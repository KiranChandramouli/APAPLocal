* @ValidationCode : MjoyMDQxMzExMzcxOkNwMTI1MjoxNjg0ODQyMTU0NTMyOklUU1M6LTE6LTE6LTMwOjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -30
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE S.REDO.CCRG.LI.GET.BAL(P.CONTRACT.ID, R.LI, P.RETURN)
*
*--------------------------------------------------------------------------------------------
* Company Name : Bank Name
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description: This program get the balances for the contract in ARRANGEMENT application
*
*
* Linked With:
*               SERVICE      REDO.CCRG.B.EXT
*               PARAMETER in REDO.CCRG.PARAMETERS field P.EVALUATOR.RTN
*
* In Parameter:
*               P.CONTRACT.ID    (in)  Contranct Id.
*               R.LI             (in)  Record of the contract in process
*
* Out Parameter:
*               P.RETURN     (out)  Returns balances related: 1 Direct Balance, 2 Income Receivable, 3 Balance Contingent
*               E            (out)  Message in case Error
*
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 18/04/2011 - ODR-2011-03-0154
*              Description of the development associated
*              anoriega@temenos.com
*REM Just for compile
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          FM TO @FM, VM TO @VM
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION        NOCHANGE, CALL routine format modified
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.LIMIT
*
    $INSERT I_REDO.CCRG.B.EXT.COMMON
    $INSERT I_REDO.CCRG.CONSTANT.COMMON
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
    Y.DB = 0
    Y.RB = 0
    Y.CB = 0

*Get Direct Balance
    Y.DB = R.LI<LI.TOTAL.OS>
    IF LCCY NE Y.CURR.CONTRACT THEN
        P.CURRENCY.ID = Y.CURR.CONTRACT
        P.CURR.MARKET = 1
        APAP.TAM.sRedoConvLocalCurr(P.CURRENCY.ID,P.CURR.MARKET,X.RETURN) ;*MANUAL R22 CODE CONVERSION
     
        Y.DB = Y.DB * X.RETURN
        CALL EB.ROUND.AMOUNT(LCCY, Y.DB, "", "")
    END


*Get Contingent Balance
    Y.CB = R.LI<LI.AVAIL.AMT>
    IF LCCY NE Y.CURR.CONTRACT THEN
        P.CURRENCY.ID = Y.CURR.CONTRACT
        P.CURR.MARKET = 1
        APAP.TAM.sRedoConvLocalCurr(P.CURRENCY.ID,P.CURR.MARKET,X.RETURN) ;*MANUAL R22 CODE CONVERSION
        Y.CB = Y.CB * X.RETURN
        CALL EB.ROUND.AMOUNT(LCCY, Y.CB, "", "")
    END

*Balances to send go out
    P.RETURN<1> = ABS(Y.DB)
    P.RETURN<2> = ABS(Y.RB)
    P.RETURN<3> = ABS(Y.CB)

RETURN


*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

    LOOP.CNT         = 1
    MAX.LOOPS        = 2
    PROCESS.GOAHEAD  = @TRUE
    P.RETURN         = ''

    Y.CURR.CONTRACT = R.LI<LI.LIMIT.CURRENCY>

RETURN


*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF NOT(P.CONTRACT.ID) THEN
                    E = K.PARAMETER.IS.EMPTY : @FM : "P.CONTRACT.ID" : @VM : "S.REDO.CCRG.LI.GET.BAL"
                    PROCESS.GOAHEAD = @FALSE
                END
            CASE LOOP.CNT EQ 2
                IF NOT(R.LI) THEN
                    E = K.PARAMETER.IS.EMPTY : @FM : "R.LI" : @VM : "S.REDO.CCRG.LI.GET.BAL"
                    PROCESS.GOAHEAD = @FALSE
                END
        END CASE

        LOOP.CNT +=1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------

END
