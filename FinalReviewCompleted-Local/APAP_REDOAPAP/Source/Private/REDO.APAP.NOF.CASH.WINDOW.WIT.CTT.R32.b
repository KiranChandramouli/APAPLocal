* @ValidationCode : Mjo2NzQ4MTAzNTQ6Q3AxMjUyOjE2ODA3NTcxOTY4OTc6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 10:29:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.CTT.R32(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.CTT.R32
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.WIT.CTT is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.WIT.SAV.CUR, this routine is used to fetch the CASH TRANSFERS
*                    TO TELLERS anD TO OTHER BANKS
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.WIT
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*Files  Used       : TELLER                           As              I               Mode
*                    ACCOUNT.CLASS                    As              I               Mode
*                    ACCOUNT                          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 15 Jun 2011       Marimuthu S              ODR-2011-04-0007  35         Changes made in REDO.APAP.NOF.CASH.WINDOW.WIT.CTT
* Date                   who                   Reference
* 06-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM VM TO @VM AND $INCLUDE TO $INSERT AND F.READ TO CACHE.READ AND REMOVED F.ACCOUNT.CLASS
* 06-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON        ;*R22 AUTO CONVERSTION $INCLUDE TO $INSERT
    $INSERT I_EQUATE         ;*R22 AUTO CONVERSTION $INCLUDE TO $INSERT
    $INSERT I_ENQUIRY.COMMON   ;*R22 AUTO CONVERSTION $INCLUDE TO $INSERT
    $INSERT I_F.TELLER         ;*R22 AUTO CONVERSTION $INCLUDE TO $INSERT
    $INSERT I_F.ACCOUNT.CLASS   ;*R22 AUTO CONVERSTION $INCLUDE TO $INSERT
    $INSERT I_F.ACCOUNT          ;*R22 AUTO CONVERSTION $INCLUDE TO $INSERT
    $INSERT I_F.REDO.H.TELLER.TXN.CODES ;*R22 AUTO CONVERSTION $INCLUDE TAM.BP TO $INSERT
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
    TELLER.ID = YTELLER.ID
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

    FN.ACCOUNT.HST = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HST = ''
    CALL OPF(FN.ACCOUNT.HST,F.ACCOUNT.HST)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)
RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'##',1)
    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'##',2)
    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'##',3)
    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'##',4)
    R.REDO.H.TELLER.TXN.CODES = FIELD(Y.TT.PARAM.REC,'##',5)

    YTELLER.ID = ''; Y.TELLER.ID = ''; RET.VAL = 1
    YTELLER.ID = FIELD(TELLER.ID,'_',1)
    Y.TELLER.ID = FIELD(TELLER.ID,'_',2)
    Y.CASH.WIT.FLAG = FIELD(TELLER.ID,'_',3)
    Y.CHQ.WIT.FLAG = FIELD(TELLER.ID,'_',4)
    Y.TFR.WIT.FLAG = FIELD(TELLER.ID,'_',5)
    Y.CASH.CATEG    = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CASH.ACC.CATEG>
    CHANGE @VM TO @FM IN Y.CASH.CATEG

    YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
    YTELLER.ID1 = R.TELLER<TT.TE.TELLER.ID.1>
    YTELLER.ID2 = R.TELLER<TT.TE.TELLER.ID.2>
    Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.1>
    IF Y.TT.CCY EQ LCCY THEN
        Y.TT.AMT  = R.TELLER<TT.TE.AMOUNT.LOCAL.2,1>
        IF NOT(Y.TT.AMT) THEN
            Y.TT.AMT  = R.TELLER<TT.TE.AMOUNT.LOCAL.2,1>
        END
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.2>
        IF NOT(Y.TT.AMT) THEN
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
        END
    END
    GOSUB CASH.TFR.TO.TELLER
    GOSUB CASH.TFR.TO.CENTRAL.BANK
RETURN
*--------------------------------------------------------------------------------------------------------
*******************
CASH.TFR.TO.TELLER:
*******************
* In this para of the code, the CASH TRANSFER TO TELLER transactions are processed

    IF YTELLER.ID1 EQ YTELLER.ID2 THEN
        RETURN
    END

    IF YTELLER.ID1 EQ Y.TELLER.ID THEN
        Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
        Y.CR.ACC = R.TELLER<TT.TE.ACCOUNT.1>
        IF YTT.MARKER EQ 'DEBIT' THEN
            Y.TT.LIST<-1> = YTELLER.ID
            RETURN
        END
        RET.VAL =1
    END

    IF YTELLER.ID2 EQ Y.TELLER.ID THEN
        Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>
        Y.CR.ACC = R.TELLER<TT.TE.ACCOUNT.2>
        IF YTT.MARKER EQ 'CREDIT' THEN
            Y.TT.LIST<-1> = YTELLER.ID
            RETURN
        END
        RET.VAL = 1
    END
    IF RET.VAL EQ 0 THEN
        RETURN
    END

    Y.VM.POS  = 27
    Y.ADD.AMT = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
RETURN
*--------------------------------------------------------------------------------------------------------
*************************
CASH.TFR.TO.CENTRAL.BANK:
*************************
* In this para of the code, the CASH TRANSFER TO CENTRAL BANK transactions are processed

    ACCOUNT.CLASS.ID = 'NOSTRO'
    GOSUB READ.ACCOUNT.CLASS

    Y.NOSTRO.CATEG = R.ACCOUNT.CLASS<AC.CLS.CATEGORY>
    CHANGE @VM TO @FM IN Y.NOSTRO.CATEG

    ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
    GOSUB READ.ACCOUNT
    Y.NOS.POS = ''; Y.NOS.POST = ''
    LOCATE R.ACCOUNT<AC.CATEGORY> IN Y.NOSTRO.CATEG<1> SETTING Y.NOS.POS ELSE
        ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.1>
        GOSUB READ.ACCOUNT
        LOCATE R.ACCOUNT<AC.CATEGORY> IN Y.NOSTRO.CATEG<1> SETTING Y.NOS.POST ELSE
            RETURN
        END
    END

    Y.VM.POS  = 28
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

    IF SET.CUR EQ 'YES' AND Y.DUP.CUR NE Y.TT.CCY THEN
        RETURN
    END

    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4> += Y.ADD.AMT
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,7> += Y.ADD.AMT
    Y.TT.LIST<-1> = YTELLER.ID
RETURN
*--------------------------------------------------------------------------------------------------------
*******************
READ.ACCOUNT.CLASS:
*******************
* In this para of the code, file ACCOUNT.CLASS is read
    R.ACCOUNT.CLASS  = '';    ACCOUNT.CLASS.ER = ''
    CALL CACHE.READ(FN.ACCOUNT.CLASS, ACCOUNT.CLASS.ID, R.ACCOUNT.CLASS, ACCOUNT.CLASS.ER) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.ACCOUNT.CLASS
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
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
