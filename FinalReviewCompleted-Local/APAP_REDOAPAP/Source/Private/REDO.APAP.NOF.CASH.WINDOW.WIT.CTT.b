* @ValidationCode : MjoxMTQ5OTczNDYwOkNwMTI1MjoxNjgwNzU3MTQxNDQ5OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 10:29:01
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
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.CTT(Y.CCY.LIST,Y.AGENCY,Y.FINAL.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.CTT
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
* 22 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
* Date                   who                   Reference
* 06-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM VM TO @VM AND F.READ TO CACHE.READ AND REMOVED F.ACCOUNT.CLASS
* 06-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT.CLASS
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
    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
    F.ACCOUNT.CLASS  = ''
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

*    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'$',1)
*    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'$',2)
*    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'$',3)
*    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'$',4)


    SEL.CMD.CK = 'SELECT ':FN.TELLER:' WITH (TRANSACTION.CODE EQ 1 OR TRANSACTION.CODE EQ 102 OR TRANSACTION.CODE EQ 3) AND CO.CODE EQ ':Y.AGENCY
    CALL EB.READLIST(SEL.CMD.CK,SEL.LIST.CK,'',NO.OF.RECS,SEL.LIST.ERR)

    LOOP
        REMOVE Y.TT.ID FROM SEL.LIST.CK SETTING POS.TT
    WHILE Y.TT.ID:POS.TT
        CALL F.READ(FN.TELLER,Y.TT.ID,R.TELLER,F.TELLER,TELL.ERR)
        Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.1>
        IF Y.TT.CCY EQ LCCY THEN
            Y.TT.AMT  = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
        END ELSE
            Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
        END

        IF R.TELLER<TT.TE.TRANSACTION.CODE> EQ 1 OR R.TELLER<TT.TE.TRANSACTION.CODE> EQ 102 THEN
            GOSUB CASH.TFR.TO.TELLER
        END

        IF R.TELLER<TT.TE.TRANSACTION.CODE> EQ 3 THEN
            GOSUB CASH.TFR.TO.CENTRAL.BANK
        END
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
CASH.TFR.TO.TELLER:
*******************
* In this para of the code, the CASH TRANSFER TO TELLER transactions are processed

    IF R.TELLER<TT.TE.TELLER.ID.1> EQ R.TELLER<TT.TE.TELLER.ID.2> THEN
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
    LOCATE R.ACCOUNT<AC.CATEGORY> IN Y.NOSTRO.CATEG<1> SETTING Y.NOS.POS ELSE
        RETURN
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

    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,7> += Y.ADD.AMT

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
READ.ACCOUNT.CLASS:
*******************
* In this para of the code, file ACCOUNT.CLASS is read
    R.ACCOUNT.CLASS  = ''
    ACCOUNT.CLASS.ER = ''
    CALL CACHE.READ(FN.ACCOUNT.CLASS, ACCOUNT.CLASS.ID, R.ACCOUNT.CLASS, ACCOUNT.CLASS.ER) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.ACCOUNT.CLASS

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
