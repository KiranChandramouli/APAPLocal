* @ValidationCode : MjoyMTg4MDg1MTM6Q3AxMjUyOjE2ODE3MTcyMzQwNzc6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 13:10:34
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
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.CCCA(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,Y.TT.LIST)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.CCCA
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.WIT.CCCA is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.WIT.SAV.CUR, this routine is used to fetch CREDIT CARD
*                    ADVANCES details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.WIT
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    R.REDO.H.TELLER.TXN.CODES - The teller transaction code details record
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.TT.LIST      - This variable holds the processed TELLER records
*Files  Used       : TELLER                           As              I               Mode
*                    ACCOUNT                          As              I               Mode
*                    REDO.H.TELLER.TXN.CODES          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 14 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FMto@FM,VMto@VM
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
    $INSERT I_F.ACCOUNT
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************


* This is the main processing para
    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'$',1)
    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'$',2)
    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'$',3)
    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'$',4)

    Y.FIN.FT.MG.CASH = ''
    Y.FIN.FT.MG.CHQ  = ''
    Y.FIN.FT.MG.TFR  = ''

    Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>

    IF Y.TT.CCY EQ LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
    END

    GOSUB FIND.MULTI.LOCAL.REF
    IF NOT(R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CR.CARD.NO.POS>) THEN
        RETURN
    END

    Y.CASH.CATEG    = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CASH.ACC.CATEG>
    CHANGE @VM TO @FM IN Y.CASH.CATEG

    Y.INT.ACCT.APAP = R.REDO.H.TELLER.TXN.CODES<TT.TXN.INTAC.APAP.CASH>
    CHANGE @VM TO @FM IN Y.INT.ACCT.APAP

    Y.INT.ACCT.OTHR = R.REDO.H.TELLER.TXN.CODES<TT.TXN.INTAC.OTH.CASH>
    CHANGE @VM TO @FM IN Y.INT.ACCT.OTHR

    Y.APAP.CASH = '' ;  Y.OTHER.CASH = ''
    Y.APAP.TFR  = '' ;  Y.OTHER.TFR  = ''

    GOSUB CHECK.APAP.CASH
    GOSUB CHECK.APAP.TFR
    GOSUB CHECK.OTHER.CASH
    GOSUB CHECK.OTHER.TFR

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.APAP.CASH:
****************
* In this para of the code, the credit card advences of APAP CASH transaction are checked

    LOCATE R.TELLER<TT.TE.ACCOUNT.2> IN Y.INT.ACCT.APAP SETTING Y.APAP.POS ELSE
        RETURN
    END

    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[4,5] IN Y.CASH.CATEG SETTING Y.CACC.POS ELSE
        RETURN
    END

    Y.APAP.CASH = 1
    Y.VM.POS    = 17
    Y.ADD.AMT   = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY

RETURN
*--------------------------------------------------------------------------------------------------------
***************
CHECK.APAP.TFR:
***************
* In this para of the code, the credit card advences of APAP TRANSFER transaction are checked

    LOCATE TELLER.ID IN Y.TT.ARR.IDS SETTING POS.ID THEN
        RETURN
    END

    LOCATE R.TELLER<TT.TE.ACCOUNT.1> IN Y.INT.ACCT.APAP SETTING Y.APAP.POS ELSE
        RETURN
    END

    ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
    GOSUB READ.ACCOUNT
    IF NOT(R.ACCOUNT<AC.CUSTOMER>) THEN
        RETURN
    END

    Y.APAP.TFR = 1
    Y.VM.POS   = 17
    Y.ADD.AMT  = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
CHECK.OTHER.CASH:
*****************
* In this para of the code, the credit card advences of other bank CASH transaction are checked

    LOCATE TELLER.ID IN Y.TT.ARR.IDS SETTING POS.ID THEN
        RETURN
    END

    LOCATE R.TELLER<TT.TE.ACCOUNT.2> IN Y.INT.ACCT.OTHR SETTING Y.OTHR.POS ELSE
        RETURN
    END

    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[4,5] IN Y.CASH.CATEG SETTING Y.CACC.POS ELSE
        RETURN
    END

    Y.OTHER.CASH = 1
    Y.VM.POS     = 18
    Y.ADD.AMT    = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.OTHER.TFR:
****************
* In this para of the code, the credit card advences of other bank TRANSFER transaction are checked

    LOCATE TELLER.ID IN Y.TT.ARR.IDS SETTING POS.ID THEN
        RETURN
    END

    LOCATE R.TELLER<TT.TE.ACCOUNT.1> IN Y.INT.ACCT.OTHR SETTING Y.OTHR.POS ELSE
        RETURN
    END

    ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
    GOSUB READ.ACCOUNT
    IF NOT(R.ACCOUNT<AC.CUSTOMER>) THEN
        RETURN
    END

    Y.OTHER.TFR = 1
    Y.VM.POS    = 18
    Y.ADD.AMT   = Y.TT.AMT
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

    IF Y.APAP.CASH THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4>  += Y.ADD.AMT
        Y.TT.ARR.IDS<-1> = TELLER.ID
    END
    IF Y.APAP.TFR THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6>  += Y.ADD.AMT
        Y.TT.ARR.IDS<-1> = TELLER.ID
    END

    IF Y.OTHER.CASH THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4>  += Y.ADD.AMT
        Y.TT.ARR.IDS<-1> = TELLER.ID
    END
    IF Y.OTHER.TFR THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6>  += Y.ADD.AMT
        Y.TT.ARR.IDS<-1> = TELLER.ID
    END

    Y.TT.LIST<-1> = TELLER.ID

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
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.TT.CR.CARD.NO'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.CR.CARD.NO.POS  =  FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
