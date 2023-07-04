* @ValidationCode : MjotNDY2MzU4MzE6Q3AxMjUyOjE2ODE3MTEyMTI1NDA6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 11:30:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.CTFT(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.FINAL.ARRAY,Y.TT.LIST,R.REDO.H.TELLER.TXN.CODES)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.CTFT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.CTFT is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR, this routine is used to fetch the CASH TRANSFERS
*                    FROM TELLERS and FROM OTHER BANKS
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    Y.COMPANY.LIST - The variable holds the list of third party payment companies
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.TT.LIST      - This variable holds the processed TELLER records
*Files  Used       : TELLER                           As              I               Mode
*                    ACCOUNT.CLASS                    As              I               Mode
*                    ACCOUNT                          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 22 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM ,VM to @VM, F.READ to CACHE.READ ,SM to @SM
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB OPEN.PARA

    GOSUB GET.TXN.CODE.DETAILS
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------

*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.TT.POS.AUTHNM':@VM:'T24.FS.REF'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.POS.AUTHNM.POS  =  FLD.POS<1,1>
    LOC.T24.FS.REF = FLD.POS<1,2>

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
    F.ACCOUNT.CLASS  = ''
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    LOCATE TELLER.ID IN Y.TT.LIST SETTING PS.CK THEN
        RETURN
    END

    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'$',1)
    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'$',2)
    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'$',3)
    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'$',4)

    Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.1>
    IF Y.TT.CCY EQ LCCY THEN
        Y.TT.AMT  = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
    END
    Y.COMP.COUNT = DCOUNT(Y.COMPANY.LIST,@FM)

    GOSUB CHECK.TXN.CODE
    IF R.TELLER<TT.TE.TRANSACTION.CODE> EQ 1 OR R.TELLER<TT.TE.TRANSACTION.CODE> EQ 102 THEN
        GOSUB CASH.TFR.FROM.TELLER
    END

    IF R.TELLER<TT.TE.TRANSACTION.CODE> EQ 2 THEN
        GOSUB CASH.TFR.FROM.CENTRAL.BANK
    END

RETURN

***************
CHECK.TXN.CODE:
***************
* In this para of the code, the TXN.CODE is checked with transaction type and payment mode
    Y.CASH.WIT.FLAG = '' ; Y.CHQ.WIT.FLAG  = ''  ;  Y.TFR.WIT.FLAG = ''

    Y.TT.TXN.CODE = R.TELLER<TT.TE.TRANSACTION.CODE>

    LOCATE Y.TT.TXN.CODE IN Y.CASH.TXN.CODE<1> SETTING Y.TXN.POS THEN
*        IF Y.CASH.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' AND R.TELLER<TT.TE.DR.CR.MARKER> EQ 'DEBIT' THEN
        IF Y.CASH.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' THEN
            Y.CASH.DEP.FLAG = 1
        END
    END

    LOCATE Y.TT.TXN.CODE IN Y.CHQ.TXN.CODE<1> SETTING Y.TXN.POS THEN
*        IF Y.CHQ.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' AND R.TELLER<TT.TE.DR.CR.MARKER> EQ 'DEBIT' THEN
        IF Y.CHQ.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' THEN
            Y.CHQ.DEP.FLAG = 1
        END
    END

    LOCATE Y.TT.TXN.CODE IN Y.TFR.TXN.CODE<1> SETTING Y.TXN.POS THEN
*        IF Y.TFR.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' AND R.TELLER<TT.TE.DR.CR.MARKER> EQ 'DEBIT' THEN
        IF Y.TFR.TXN.TYPE<Y.TXN.POS> EQ 'DEPOSITS' THEN
            Y.TFR.DEP.FLAG = 1
        END
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
CASH.TFR.FROM.TELLER:
*********************
* In this para of the code, the CASH TRANSFER FROM TELLER transactions are processed

    IF R.TELLER<TT.TE.TELLER.ID.1> EQ R.TELLER<TT.TE.TELLER.ID.2> THEN
        RETURN
    END

    Y.VM.POS  = 20 + Y.COMP.COUNT + 5
    Y.ADD.AMT = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY

RETURN
*--------------------------------------------------------------------------------------------------------
***************************
CASH.TFR.FROM.CENTRAL.BANK:
***************************
* In this para of the code, the CASH TRANSFER FROM CENTRAL BANK transactions are processed

    ACCOUNT.CLASS.ID = 'NOSTRO'
    GOSUB READ.ACCOUNT.CLASS

    Y.NOSTRO.CATEG = R.ACCOUNT.CLASS<AC.CLS.CATEGORY>
    CHANGE @VM TO @FM IN Y.NOSTRO.CATEG

    ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
    GOSUB READ.ACCOUNT
    LOCATE R.ACCOUNT<AC.CATEGORY> IN Y.NOSTRO.CATEG SETTING Y.NOS.POS ELSE
        RETURN
    END

    Y.VM.POS  = 20 + Y.COMP.COUNT + 6
    Y.ADD.AMT = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY

RETURN
*--------------------------------------------------------------------------------------------------------
******************
AMEND.FINAL.ARRAY:
******************
* In this para of the code, the Y.FINAL.ARRAY is amended with increment in the total number of transactions
** and the amount is added up

    LOCATE Y.TT.CCY IN Y.CCY.LIST<1> SETTING Y.CCY.POS ELSE
        Y.CCY.LIST<-1> = Y.TT.CCY
        Y.CCY.POS = DCOUNT(Y.CCY.LIST,@FM)
    END

    BEGIN CASE
        CASE Y.CASH.DEP.FLAG
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4>  += Y.ADD.AMT
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,7>  += Y.ADD.AMT

        CASE Y.CHQ.DEP.FLAG
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5>  += Y.ADD.AMT
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,7>  += Y.ADD.AMT

        CASE Y.TFR.DEP.FLAG
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6>  += Y.ADD.AMT
            Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,7>  += Y.ADD.AMT
    END CASE

    Y.TT.LIST<-1> = TELLER.ID

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
READ.ACCOUNT.CLASS:
*******************
* In this para of the code, file ACCOUNT.CLASS is read
    R.ACCOUNT.CLASS  = ''
    ACCOUNT.CLASS.ER = ''
    CALL CACHE.READ(FN.ACCOUNT.CLASS, ACCOUNT.CLASS.ID, R.ACCOUNT.CLASS, ACCOUNT.CLASS.ER) ;*R22 AUTO CODE CONVERSION

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
    R.ACCOUNT  = ''
    ACCOUNT.ER = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
GET.TXN.CODE.DETAILS:
*********************
* In this para of the code, the TXN.CODES for the payment type and transaction type are segregated

    Y.TT.TXN.CODES = R.REDO.H.TELLER.TXN.CODES<TT.TXN.PAYMENT.MODE>
    LOCATE 'CASH' IN Y.TT.TXN.CODES<1,1> SETTING Y.CASH.POS THEN
        Y.CASH.TXN.TYPE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.TYPE,Y.CASH.POS>
        Y.CASH.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE,Y.CASH.POS>
        CHANGE @SM TO @FM IN Y.CASH.TXN.TYPE
        CHANGE @SM TO @FM IN Y.CASH.TXN.CODE
    END

    LOCATE 'CHEQUE' IN Y.TT.TXN.CODES<1,1> SETTING Y.CHQ.POS THEN
        Y.CHQ.TXN.TYPE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.TYPE,Y.CHQ.POS>
        Y.CHQ.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE,Y.CHQ.POS>
        CHANGE @SM TO @FM IN Y.CHQ.TXN.TYPE
        CHANGE @SM TO @FM IN Y.CHQ.TXN.CODE
    END

    LOCATE 'TRANSFER' IN Y.TT.TXN.CODES<1,1> SETTING Y.TFR.POS THEN
        Y.TFR.TXN.TYPE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.TYPE,Y.TFR.POS>
        Y.TFR.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE,Y.TFR.POS>
        CHANGE @SM TO @FM IN Y.TFR.TXN.TYPE
        CHANGE @SM TO @FM IN Y.TFR.TXN.CODE
    END

RETURN
END       ;* End of Program
