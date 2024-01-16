* @ValidationCode : MjotNzA5NjY4MDpDcDEyNTI6MTY4NDgzNjA0NDk2MzpJVFNTOi0xOi0xOjE5NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 196
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.OTH.INC(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.FINAL.ARRAY,Y.TT.LIST)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.OTH.INC
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.OTH.INC is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR, this routine is used to fetch the OTHER INCOME
*                    details of DEPOSITS from the TELLER transactions
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    Y.COMPANY.LIST - The variable holds the list of third party payment companies
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
* 24 Aug 2011       Bharath G                   PACS00104858                Routine modified to check REDO.H.TELLER.TXN.CODES
* Date                   who                   Reference              
* 05-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM VM TO @VM AND SM TO @SM AND F.READ TO CACHE.READ AND REMOVED F.TELLER.TRANSACTION
* 05-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
    $INSERT I_F.REDO.TT.GROUP.PARAM
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

* PACS00104858 - S
    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    R.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.REDO.TT.GROUP.PARAM = 'F.REDO.TT.GROUP.PARAM'
    F.REDO.TT.GROUP.PARAM  = ''
    R.REDO.TT.GROUP.PARAM  = ''
*CALL OPF(FN.REDO.TT.GROUP.PARAM,F.REDO.TT.GROUP.PARAM)
* PACS00104858 - E

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    Y.OTH.CASH = '' ; Y.OTH.CHQ = '' ; Y.OTH.TFR = ''

    LOCATE TELLER.ID IN Y.TT.LIST SETTING POS.CK THEN
        RETURN
    END

    R.TELLER                     = FIELD(Y.TT.PARAM.REC,'$',1)
    R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'$',2)
    R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'$',3)
    R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'$',4)
    R.REDO.H.TELLER.TXN.CODES    = FIELD(Y.TT.PARAM.REC,'$',5)

    Y.TT.CCY  = R.TELLER<TT.TE.CURRENCY.1>
    IF Y.TT.CCY EQ LCCY THEN
        Y.TT.AMT  = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
    END

    Y.COMP.COUNT = DCOUNT(Y.COMPANY.LIST,@FM)
    GOSUB READ.TELLER.TRANS.AND.TT.GROUP.PARAM      ;*PACS00104858
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
* PACS00104858 - S
    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
        LOCATE R.TELLER<TT.TE.ACCOUNT.2>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
            RETURN
        END
    END
* PACS00104858 - E

    Y.OTH.CASH  = 1
    Y.VM.POS    = 20 + Y.COMP.COUNT + 3
    Y.ADD.AMT   = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.CHQ.TRANS:
****************
* In this para of the code, the transaction is checked if its a CHEQUE transaction

*PACS00104858 - S
*Y.ACCOUNT.LIST     = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>
*Y.ACCOUNT.LIST<-1> = R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ACCOUNT>
*Y.ACCOUNT.LIST<-1> = R.CERTIFIED.CHEQUE.PARAMETER<CERT.CHEQ.ACCOUNT.NO>
*Y.ACCOUNT.LIST = CHANGE(Y.ACCOUNT.LIST,VM,FM)
*LOCATE R.TELLER<TT.TE.ACCOUNT.1> IN Y.ACCOUNT.LIST<1> SETTING Y.CACC.POS ELSE
*LOCATE R.TELLER<TT.TE.ACCOUNT.2> IN Y.ACCOUNT.LIST<1> SETTING Y.CACC.POS ELSE
*RETURN
*END
*END

    LOCATE TRANS.1 IN R.REDO.H.TELLER.TXN.CODES<TT.TXN.CHQ.TXN.CODES,1> SETTING Y.CACC.POS ELSE
        LOCATE TRANS.2 IN R.REDO.H.TELLER.TXN.CODES<TT.TXN.CHQ.TXN.CODES,1> SETTING Y.CACC.POS ELSE
            RETURN
        END
    END

    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
        LOCATE R.TELLER<TT.TE.ACCOUNT.2>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
            RETURN
        END
    END

*PACS00104858 - E

    Y.OTH.CHQ   = 1
    Y.VM.POS    = 20 + Y.COMP.COUNT + 3
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
    IF R.ACCOUNT<AC.CUSTOMER> ELSE
        ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
        GOSUB READ.ACCOUNT
        IF R.ACCOUNT<AC.CUSTOMER> ELSE
            RETURN
        END
    END

* PACS00104858 - S
    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
        LOCATE R.TELLER<TT.TE.ACCOUNT.2>[3,5] IN Y.CATEGORY.PL<1> SETTING Y.CAT.POS ELSE
            RETURN
        END
    END
* PACS00104858 - E

    Y.OTH.TFR   = 1
    Y.VM.POS    = 20 + Y.COMP.COUNT + 3
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
    R.ACCOUNT  = ''   ;*  ACCOUNT.ER = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
**************************************
READ.TELLER.TRANS.AND.TT.GROUP.PARAM:
**************************************
*
    TELLER.TRANS.ID = R.TELLER<TT.TE.TRANSACTION.CODE>

    CALL CACHE.READ(FN.TELLER.TRANSACTION, TELLER.TRANS.ID, R.TELLER.TRANSACTION, TELLER.ERR)  ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.TELLER.TRANSACTION
    IF R.TELLER.TRANSACTION THEN
        TRANS.1 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
        TRANS.2 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
    END
    GRP.PARAM.ID = 'SYSTEM'
*  CALL F.READ(FN.REDO.TT.GROUP.PARAM,GRP.PARAM.ID,R.REDO.TT.GROUP.PARAM,F.REDO.TT.GROUP.PARAM,GRP.PARAM.ERR) ;*Tus Start
    CALL CACHE.READ(FN.REDO.TT.GROUP.PARAM,GRP.PARAM.ID,R.REDO.TT.GROUP.PARAM,GRP.PARAM.ERR) ; * Tus End
    IF R.REDO.TT.GROUP.PARAM THEN
        Y.GROUP    = R.REDO.TT.GROUP.PARAM<TEL.GRO.GROUP>
        Y.CATEGORY = R.REDO.TT.GROUP.PARAM<TEL.GRO.CATEGORY>
        CHANGE @VM TO @FM IN Y.GROUP
        CHANGE @VM TO @FM IN Y.CATEGORY
        CHANGE @SM TO @VM IN Y.CATEGORY
        LOCATE "OTHER.INCOMDE" IN Y.GROUP<1> SETTING GRP.POS THEN
            Y.CATEGORY.OTHER.INCOME = Y.CATEGORY<GRP.POS>
            CHANGE @VM TO @FM IN Y.CATEGORY.OTHER.INCOME
        END
        LOCATE "LOAN-COM" IN Y.GROUP<1> SETTING GRP.POS THEN
            Y.CATEGORY.LN.COM = Y.CATEGORY<GRP.POS>
            CHANGE @VM TO @FM IN Y.CATEGORY.LN.COM
        END
        Y.CATEGORY.PL = Y.CATEGORY.OTHER.INCOME:@FM:Y.CATEGORY.LN.COM
    END

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
