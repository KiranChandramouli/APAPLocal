* @ValidationCode : MjoxMDEzODU4Nzg0OkNwMTI1MjoxNjg0ODM2MDQ2NTM3OklUU1M6LTE6LTE6MTI5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 129
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.OTH.EXP(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,R.REDO.H.TELLER.TXN.CODES,Y.FINAL.ARRAY,Y.TT.LIST)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.OTH.EXP
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.WIT.OTH.EXP is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.WIT.SAV.CUR, this routine is used to fetch the OTHER EXPENSE
*                    details of WITHDRAWALS from the TELLER transactions
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
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 17 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VMto@VM,FMto@FM
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
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
    Y.OTH.CASH = '' ; Y.OTH.CHQ = '' ; Y.OTH.TFR = ''

    LOCATE TELLER.ID IN Y.TT.LIST SETTING POS.IOT THEN
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

    GOSUB CHECK.CASH.TRANS
    GOSUB CHECK.CHQ.TRANS
    GOSUB CHECK.TFR.TRANS

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
CHECK.CASH.TRANS:
*****************
* In this para of the code, the transaction is checked if its a CASH transaction
    Y.CASH.CATEG = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CASH.ACC.CATEG>
    CHANGE @VM TO @FM IN Y.CASH.CATEG

    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[4,5] IN Y.CASH.CATEG<1> SETTING Y.CACC.POS ELSE
        LOCATE R.TELLER<TT.TE.ACCOUNT.2>[4,5] IN Y.CASH.CATEG<1> SETTING Y.CACC.POS ELSE
            RETURN
        END
    END

    Y.OTH.CASH  = 1
    Y.VM.POS    = 25
    Y.ADD.AMT   = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.CHQ.TRANS:
****************
* In this para of the code, the transaction is checked if its a CHEQUE transaction

    Y.ACCOUNT.LIST     = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>
    Y.ACCOUNT.LIST<-1> = R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ACCOUNT>
    Y.ACCOUNT.LIST<-1> = R.CERTIFIED.CHEQUE.PARAMETER<CERT.CHEQ.ACCOUNT.NO>
    Y.ACCOUNT.LIST = CHANGE(Y.ACCOUNT.LIST,@VM,@FM)

    LOCATE R.TELLER<TT.TE.ACCOUNT.1> IN Y.ACCOUNT.LIST<1> SETTING Y.CACC.POS ELSE
        LOCATE R.TELLER<TT.TE.ACCOUNT.2> IN Y.ACCOUNT.LIST<1> SETTING Y.CACC.POS ELSE
            RETURN
        END
    END

    Y.OTH.CHQ   = 1
    Y.VM.POS    = 25
    Y.ADD.AMT   = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.TFR.TRANS:
****************
* In this para of the code, the transaction is checked if its a TRANSFER transaction

    ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.1>
    GOSUB READ.ACCOUNT
    IF NOT(R.ACCOUNT<AC.CUSTOMER>) THEN
        RETURN
    END

    ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
    GOSUB READ.ACCOUNT
    IF NOT(R.ACCOUNT<AC.CUSTOMER>) THEN
        RETURN
    END

    Y.OTH.TFR   = 1
    Y.VM.POS    = 25
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

    IF Y.OTH.CASH THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4>  += Y.ADD.AMT
    END

    IF Y.OTH.CHQ THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5>  += Y.ADD.AMT
    END

    IF Y.OTH.TFR THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6>  += Y.ADD.AMT
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
END       ;* End of Program
