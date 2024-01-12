* @ValidationCode : MjoxNjI5ODAyNzE6Q3AxMjUyOjE3MDQ3OTIyOTQyMjg6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Jan 2024 14:54:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CCRG.B.EXT(Y.CCRG.CUS.ID)
*-----------------------------------------------------------------------------
* Mutli-threaded Close of Business routine
* Description : Control Customer & Group Risk - Extraction process
*               Allows to update the "temporal repositories" with information of contracts by customer
*-----------------------------------------------------------------------------
* Modification History:
*                      2011.04.06 - APAP B5 : ODR-2011-03-0154
*                                   First Version
*-----------------------------------------------------------------------------
* 05/01/2012 - avelasco@temenos.com
*              PACS00172824 - correct the id to REDO.CCRG.B.TRACE.ERROR
*-----------------------------------------------------------------------------
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - FM TO @FM VM TO @VM AND I TO I.VAR
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -ADD PACKAGE TO CALL ROUTINE
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.Service
*
    $INSERT I_F.CUSTOMER
*
    $INSERT I_REDO.CCRG.B.EXT.COMMON
    $INSERT I_REDO.CCRG.CONSTANT.COMMON
*
    $INSERT I_F.REDO.CCRG.CUSTOMER
    $INSERT I_F.REDO.CCRG.PARAMETERS
    $INSERT I_F.REDO.CCRG.CONTRACT.BAL
*
*-----------------------------------------------------------------------------
* Perform the transaction/contract processing in this routine. All files & standard
* variables should be setup in REDO.CCRG.B.EXT.LOAD and passed using the named common I_REDO.CCRG.B.EXT.COMMON


    GOSUB INIT
    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.PRGRAPH.NAME = 'PROCESS'

* Process each, customer in the list
    LOOP
        REMOVE Y.CUSTOMER.ID FROM R.RCEQ SETTING X.MARK
    WHILE Y.CUSTOMER.ID : X.MARK
*
* Check if effective date was reached
*       PROCESS.GOAHEAD = 1
        Y.IS.EFF = @FALSE
        IF Y.IGNORE.EFFECTIVE EQ @FALSE THEN
            CALL S.REDO.CCRG.VAL.CUS.EFF(Y.CUSTOMER.ID, P.EFF.TIME, 'Q', Y.IS.EFF)
        END
*
* The customer information was not reached to effective date. Continue with the next
*
        IF Y.IS.EFF THEN
            CALL OCOMO("IGNORING [" :  Y.CCRG.CUS.ID : "] " : Y.CUSTOMER.ID)

        END ELSE

* Process customer

            GOSUB PROCESS.CUSTOMER

* Register REDO.CCRG.POP.QUEUE
            GOSUB SAVE.POP.QUEUE
        END
*
    REPEAT


* Delete Y.CCRG.CUS.ID from FN.REDO.CCRG.EXT.QUEUE
    CALL F.DELETE(FN.REDO.CCRG.EXT.QUEUE,Y.CCRG.CUS.ID)


*
RETURN
*-----------------------------------------------------------------------------
PROCESS.CUSTOMER:
*-----------------------------------------------------------------------------

    Y.PRGRAPH.NAME = 'PROCESS.CUSTOMER'

    CALL OCOMO("PROCESSING [" :  Y.CCRG.CUS.ID : "]" : " - " : Y.CUSTOMER.ID)
*
* Remove any contract for current customer
*
    Y.FILE.NAME    = FN.REDO.CCRG.CONTRACT.BAL
    Y.FILE.NAME<2> = 'PRIMARY.OWNER EQ ' : Y.CUSTOMER.ID
*    CALL EB.CLEAR.FILE(Y.FILE.NAME, F.REDO.CCRG.CONTRACT.BAL)
    EB.Service.ClearFile(Y.FILE.NAME, F.REDO.CCRG.CONTRACT.BAL);* R22 UTILITY AUTO CONVERSION
*
* Read Customer Information
*
    R.CUSTOMER = ''
    YERR = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,YERR)

*
* Process Sunnel
**
    GOSUB PROCESS.SUNNEL

*
* Get the list of the contracts for curren customer
*
    R.RCTC = ''
    YERR   = ''
    CALL F.READ(FN.REDO.CUS.TXN.CONCAT,Y.CUSTOMER.ID,R.RCTC,F.REDO.CUS.TXN.CONCAT,YERR)
    IF R.RCTC EQ '' THEN
        CALL OCOMO("No contracts for customer " : Y.CUSTOMER.ID)
        RETURN
    END

    LOOP
        REMOVE Y.CTC.ID FROM R.RCTC SETTING Y.CONTRACT.MARK
    WHILE Y.CTC.ID : Y.CONTRACT.MARK
*
* Check if the module is AA, MM, FX, SC or LI
*
        Y.CONTRACT.ID = Y.CTC.ID[" ",2,1]
        Y.APPLICATION = Y.CTC.ID[" ",1,1]

*
*The process get balances for LIMITS from Arrangement Contract, no directly from Limit Operation
*
* << AV
        Y.IS.AA.LI = @FALSE       ;* Used for triggered a AA associated with LIMIT (Linea Credito interina)
        P.RETURN   = ''
        IF Y.APPLICATION NE 'LI' THEN

* Process Contract
*
            LOOP
                GOSUB PROCESS.CONTRACT
            WHILE Y.IS.AA.LI
            REPEAT
        END
* >> AV
    REPEAT

*
RETURN
*-----------------------------------------------------------------------------
PROCESS.CONTRACT:
*-----------------------------------------------------------------------------

    Y.PRGRAPH.NAME = 'PROCESS.CONTRACT'

    CALL OCOMO("Processing Contract " : Y.APPLICATION : "-" : Y.CONTRACT.ID)
*
* Check if the application exists in the Parameters Table
    R.RCBTP = ''
*    CALL CACHE.READ('F.REDO.CCRG.BALANCE.TYPE.PARAM',Y.APPLICATION,R.RCBTP,YERR)
    FN.REDO.CCRG.BALANCE.TYPE.PARAM = 'F.REDO.CCRG.BALANCE.TYPE.PARAM';* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.CCRG.BALANCE.TYPE.PARAM,Y.APPLICATION,R.RCBTP,YERR);* R22 UTILITY AUTO CONVERSION
    IF R.RCBTP EQ '' THEN
        RETURN
    END
*
* Check if the application was presented in REDO.CCRG.PARAMTERS
    LOCATE Y.APPLICATION IN R.RCP<REDO.CCRG.P.PRODUCT,1> SETTING Y.POS ELSE
        RETURN
    END
*
* Call Evaluation Routine
    Y.EVAL.RTN.NAME = ''
    Y.EVAL.RTN.NAME = R.RCP<REDO.CCRG.P.EVALUATOR.RTN, Y.POS>
    R.CONTRACT      = ''
    E = ''
    CALL @Y.EVAL.RTN.NAME(Y.CONTRACT.ID, R.RCBTP, R.CUSTOMER, R.CONTRACT, P.RETURN)
    IF E THEN
        P.NON.FATAL = @TRUE       ;* Just Ignore contract
        GOSUB RAISE.ERROR
        RETURN
    END

*
* If this a "Linea Credito interina" disbursment ? Then, try again with limit.reference as contract.id

    IF P.RETURN<1> EQ @FALSE OR NOT(P.RETURN<1>) THEN
        IF Y.APPLICATION EQ 'AA' AND P.RETURN<4> NE '' THEN
            Y.APPLICATION = 'LI'
            Y.CONTRACT.ID = P.RETURN<4>
            Y.IS.AA.LI    = @TRUE
        END ELSE
            Y.IS.AA.LI = @FALSE
        END
        RETURN
    END

    Y.OTHER.PARTY = P.RETURN<2>
    Y.ROLE        = P.RETURN<3>
    Y.CATEGORY    = P.RETURN<5>
    Y.BAL.TYPE    = P.RETURN<1>
* << PP
    IF NOT("TOTAL" MATCHES P.RETURN<1>) THEN
        Y.BAL.TYPE<1,-1> =  "TOTAL"
    END
* >>



*
* Get Balances
    P.RETURN       = ''
    Y.BAL.RTN.NAME = ''
    Y.BAL.RTN.NAME = R.RCP<REDO.CCRG.P.GET.BAL.RTN, Y.POS>
    E = ''
    CALL @Y.BAL.RTN.NAME(Y.CONTRACT.ID, R.CONTRACT, P.RETURN)

    IF E THEN
        P.NON.FATAL = @TRUE       ;* Just Ignore contract
        GOSUB RAISE.ERROR
        RETURN
    END

*  Save values in Contract Bal
    GOSUB SAVE.CONTRACT.BAL
*

RETURN

*-----------------------------------------------------------------------------
PROCESS.SUNNEL:
*-----------------------------------------------------------------------------
*
*  Extract Balances from SUNNEL System
*
    Y.PRGRAPH.NAME = 'PROCESS.SUNNEL'
*
*  Get identification by Related Customer

* (1) Identity Card
    Y.CUS.ID = R.CUSTOMER<EB.CUS.LOCAL.REF><1,CIDENT.POS>

* (2) Passport
    IF Y.CUS.ID EQ '' THEN
        Y.CUS.ID = R.CUSTOMER<EB.CUS.LEGAL.ID>
    END
* (3) RNC Number

    IF Y.CUS.ID EQ '' THEN
        Y.CUS.ID = R.CUSTOMER<EB.CUS.LOCAL.REF><1,RNC.POS>
    END

* Get Balance from SUNNEL
    E = ''
    CALL S.REDO.CCRG.SUNNEL.GET.BAL(Y.CUS.ID,P.RETURN)

    IF P.RETURN<1> EQ 'ERROR' THEN
* Error in process SUNNEL
        E    = P.RETURN<2>  : @FM : Y.CUS.ID : @VM : 'SUNNEL'
        P.NON.FATAL = @FALSE
        GOSUB RAISE.ERROR
    END ELSE
* Save Contract Balance
        Y.CONTRACT.ID = Y.CUSTOMER.ID
        Y.APPLICATION = 'SU'      ;*SUNNEL, external system to Credit Card in APAP client
        Y.OTHER.PARTY = ''
        Y.ROLE        = ''
        Y.CATEGORY    = ''
        Y.BAL.TYPE    = 'UNSECURED' : @VM : 'TOTAL'    ;* PP, I've added UNSECURED balance
        GOSUB SAVE.CONTRACT.BAL
    END
*
RETURN

*-----------------------------------------------------------------------------
SAVE.CONTRACT.BAL:
*-----------------------------------------------------------------------------
*
* Save detalle in REDO.CCRG.CONTRACT.BAL
*
    Y.PRGRAPH.NAME = 'SAVE.CONTRACT.BAL'
*
* Set Balances
    Y.BD = P.RETURN<1>
    Y.RC = P.RETURN<2>
    Y.BC = P.RETURN<3>


* By every Type Balance, the values has to repeat, this is necesary to populate tables to enquiries
    Y.CNT.TYP.BAL = ''
    Y.CNT.TYP.BAL = DCOUNT(Y.BAL.TYPE,@VM)
    FOR I.VAR = 1 TO Y.CNT.TYP.BAL - 1
        Y.BD := @VM : P.RETURN<1>
        Y.RC := @VM : P.RETURN<2>
        Y.BC := @VM : P.RETURN<3>
    NEXT
    CALL OCOMO('Saving Contract balances, DB:':Y.BD:' - RB:':Y.RC:' - CB:':Y.BC)
    IF NOT(Y.BD) AND NOT(Y.RC) AND NOT(Y.BC) THEN
        RETURN
    END

*
* Write Contract to Contract Balance reposistory
    R.REDO.CCRG.CONTRACT.BAL = ''
    R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.SYSTEM.ID>      = Y.APPLICATION
    R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.PRIMARY.OWNER>  = Y.CUSTOMER.ID
    R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.OTHER.PARTY>    = Y.OTHER.PARTY
    R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.ROLE>           = Y.ROLE

    R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.CATEGORY>       = Y.CATEGORY
    R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.BALANCE.TYPE>   = Y.BAL.TYPE
    R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.DIR.BALANCE>    = Y.BD
    R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.INT.RECEIVABLE> = Y.RC
    R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.CON.BALANCE>    = Y.BC

* Don't use cache

*  WRITE R.REDO.CCRG.CONTRACT.BAL TO F.REDO.CCRG.CONTRACT.BAL,Y.CONTRACT.ID ;*Tus Start
    CALL F.WRITE(FN.REDO.CCRG.CONTRACT.BAL,Y.CONTRACT.ID,R.REDO.CCRG.CONTRACT.BAL);*Tus End

RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
*
* Initialise
*
    Y.IGNORE.EFFECTIVE = @FALSE
*
    Y.RNT.NAME     = 'REDO.CCRG.B.EXT'
    Y.PRGRAPH.NAME = 'INIT'
    Y.CP.ID = Y.CCRG.CUS.ID["-",2,1]
    Y.CC.ID = Y.CCRG.CUS.ID["-",1,1]
*
* Check if the EFFECTIVE DATE must be checked ?
*
    P.EFF.TIME = R.RCP<REDO.CCRG.P.EFFECTIVE.TIME>  ;* This was initialized on LOAD routine
    R.RCC      = ''
    YERR       = ''
    CALL F.READ(FN.REDO.CCRG.CUSTOMER,Y.CC.ID,R.RCC,F.REDO.CCRG.CUSTOMER,YERR)
    IF R.RCC NE '' THEN
        Y.IGNORE.EFFECTIVE = R.RCC<REDO.CCRG.CUS.IGNORE.EFFECTIVE> EQ 'SI'
        Y.CUS.ID           = R.RCC<REDO.CCRG.CUS.CUSTOMER.ID>
    END
*
* Read list of customer to be extracted
*
    R.RCEQ = ''
    YERR   = ''
    E = ''
*    CALL F.READ(FN.REDO.CCRG.EXT.QUEUE,Y.CCRG.CUS.ID,R.RCEQ,F.REDO.CCRG.EXT.QUEUE,YERR)
    CALL F.READU(FN.REDO.CCRG.EXT.QUEUE,Y.CCRG.CUS.ID,R.RCEQ,F.REDO.CCRG.EXT.QUEUE,YERR,'');* R22 UTILITY AUTO CONVERSION
    IF R.RCEQ EQ '' THEN
        E    = K.REC.NOT.FOUND
        E<2> = Y.CCRG.CUS.ID : @VM : FN.REDO.CCRG.EXT.QUEUE
        P.NON.FATAL = @FALSE
        GOSUB RAISE.ERROR
    END

*
RETURN
*-----------------------------------------------------------------------------
SAVE.POP.QUEUE:
*-----------------------------------------------------------------------------
*
*  Register Queue to Populate Process
*

    Y.PRGRAPH.NAME = 'SAVE.POP.QUEUE'
*

*CALL F.WRITE(FN.REDO.CCRG.POP.QUEUE,Y.CUS.ID,R.REDO.CCRG.POP.QUEUE)
    CALL F.WRITE(FN.REDO.CCRG.POP.QUEUE,Y.CC.ID,R.REDO.CCRG.POP.QUEUE)


RETURN
*-----------------------------------------------------------------------------
RAISE.ERROR:
*-----------------------------------------------------------------------------
    Y.ERROR = E
    R.SOURCE.INFO    = ''
    R.SOURCE.INFO<1> = Y.RNT.NAME
    R.SOURCE.INFO<2> = Y.PRGRAPH.NAME
    R.SOURCE.INFO<4> = Y.CP.ID
    APAP.REDOBATCH.redoCcrgBTraceError(R.SOURCE.INFO, Y.ERROR, P.NON.FATAL, Y.CC.ID, @TRUE) ;*R22 MANUAL CONVERSTION ADD PACKAGE
RETURN
*-----------------------------------------------------------------------------
END
