* @ValidationCode : MjotMTczNzgzMTIwOkNwMTI1MjoxNjg0ODM2MDQ2NDg0OklUU1M6LTE6LTE6MzEzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 313
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.OTH.EXP.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.OTH.EXP.R32
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
* 15 Jun 2011       marimuthu S              ODR-2011-04-0007 32         Changes made in REDO.APAP.NOF.CASH.WINDOW.WIT.OTH.EXP
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
    $INSERT I_F.ACCOUNT.CLASS
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
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB PROCESS.PARA
    TELLER.ID = YTELLER.ID
RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HST  = ''
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)
RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    Y.OTH.CASH = '' ; Y.OTH.CHQ = '' ; Y.OTH.TFR = ''

    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'##',1)
    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'##',2)
    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'##',3)
    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'##',4)
    R.REDO.H.TELLER.TXN.CODES = FIELD(Y.TT.PARAM.REC,'##',5)

    YTELLER.ID = ''
    YTELLER.ID = FIELD(TELLER.ID,'_',1)
    Y.CASH.WIT.FLAG = FIELD(TELLER.ID,'_',2)
    Y.CHQ.WIT.FLAG = FIELD(TELLER.ID,'_',3)
    Y.TFR.WIT.FLAG = FIELD(TELLER.ID,'_',4)

    YTELLER.ID1 = R.TELLER<TT.TE.TELLER.ID.1>
    YTELLER.ID2 = R.TELLER<TT.TE.TELLER.ID.2>
    LOCATE YTELLER.ID IN Y.TT.LIST SETTING POS.IOT THEN
        RETURN
    END

    YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
    IF YTT.MARKER EQ 'CREDIT' AND R.TELLER<TT.TE.CURRENCY.1> NE LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
    END
    Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.1>
    IF Y.TT.CCY NE LCCY THEN
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
    IF Y.CASH.WIT.FLAG NE 1 THEN
        RETURN
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

    IF Y.CHQ.WIT.FLAG NE 1 THEN
        RETURN
    END
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

    IF Y.TFR.WIT.FLAG NE 1 THEN
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

    IF SET.CUR EQ 'YES' AND Y.DUP.CUR NE Y.TT.CCY THEN
        RETURN
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

    Y.TT.LIST<-1> = YTELLER.ID

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
    R.ACCOUNT  = '';    ACCOUNT.ER = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)
    IF NOT(R.ACCOUNT) THEN
        ACCOUNT.IDH = ACCOUNT.ID; ERR.AC = ''
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HST,ACCOUNT.IDH,R.ACCOUNT,ERR.AC)
    END
RETURN

*******************
READ.ACCOUNT.CLASS:
*******************
* In this para of the code, file ACCOUNT.CLASS is read
    R.ACCOUNT.CLASS  = '';    ACCOUNT.CLASS.ER = ''
    CALL F.READ(FN.ACCOUNT.CLASS,ACCOUNT.CLASS.ID,R.ACCOUNT.CLASS,F.ACCOUNT.CLASS,ACCOUNT.CLASS.ER)
RETURN

*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.DEBIT.AMOUNT':@VM:'L.CREDIT.AMOUNT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.DEBIT.AMOUNT.POS = FLD.POS<1,2>
    LOC.L.CREDIT.AMOUNT.POS = FLD.POS<1,3>
RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
