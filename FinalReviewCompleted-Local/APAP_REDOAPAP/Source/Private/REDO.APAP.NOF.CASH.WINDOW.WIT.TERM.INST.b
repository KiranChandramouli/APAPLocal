* @ValidationCode : MjoxODU3ODQ5NjcwOkNwMTI1MjoxNjgxNzI2MDk0ODQ3OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 15:38:14
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
SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.WIT.TERM.INST(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.CASH.CATEG,Y.FINAL.ARRAY,Y.TT.LIST)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.WIT.TERM.INST
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.WIT.TERM.INST is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.WIT.SAV.CUR, this routine is used to fetch the term instrument
*                    details for WITHDRAWALS
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.WIT
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    Y.CASH.CATEG   - The cash category list
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.TT.LIST      - This variable holds the processed TELLER records
*Files  Used       : TELLER                           As              I               Mode
*                    AZ.ACCOUNT                       As              I               Mode
*                    REDO.ADMIN.CHQ.PARAM             As              I               Mode
*                    REDO.MANAGER.CHQ.PARAM           As              I               Mode
*                    CERTIFIED.CHEQUE.PARAMETER       As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 11 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM ,VM to @VM,F.READ toCACHE.READ
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.TRANSACTION
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
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT  = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.AZ.ACCOUNT.HIS = 'F.AZ.ACCOUNT$HIS'
    F.AZ.ACCOUNT.HIS = ''
    CALL OPF(FN.AZ.ACCOUNT.HIS,F.AZ.ACCOUNT.HIS)

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION  = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION  = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
* DEBUG
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
    IF R.TELLER<TT.TE.LOCAL.REF,LOC.POS.AZ.ACC.REF> NE '' THEN
        AZ.ACCOUNT.ID = R.TELLER<TT.TE.LOCAL.REF,LOC.POS.AZ.ACC.REF>
        GOSUB READ.AZ.ACCOUNT
        IF R.AZ.ACCOUNT THEN
            RETURN
        END ELSE
            CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT.HIS,AZ.ACCOUNT.ID,R.AZ.ACCOUNT,AZ.AC.HIS.ER)
            IF R.AZ.ACCOUNT THEN
                RETURN
            END
        END
    END
    GOSUB CHECK.FIN.FT.MG.CASH
    GOSUB CHECK.FIN.FT.MG.CHQ
    GOSUB CHECK.FIN.FT.MG.TFR

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
CHECK.FIN.FT.MG.CASH:
*********************
* In this para of the code, the term instruments CASH transaction are checked

    IF R.TELLER<TT.TE.TRANSACTION.CODE> EQ 51 ELSE
        RETURN
    END

    LOCATE R.TELLER<TT.TE.ACCOUNT.1>[4,5] IN Y.CASH.CATEG<1> SETTING Y.CACC.POS ELSE
        RETURN
    END

    AZ.ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
    GOSUB READ.AZ.ACCOUNT

    IF NOT(R.AZ.ACCOUNT) THEN
        CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT.HIS,AZ.ACCOUNT.ID,R.AZ.ACCOUNT,AZ.AC.HIS.ER)
        IF NOT(R.AZ.ACCOUNT) THEN
            RETURN
        END
    END

    Y.DEPOSIT.NAME = R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.DEP.NAME.POS>

    IF Y.DEPOSIT.NAME EQ 'CF' THEN
        Y.VM.POS  = 7
        Y.FIN.FT.MG.CASH = 1
    END
    IF Y.DEPOSIT.NAME EQ 'DP' OR Y.DEPOSIT.NAME EQ 'DX' THEN
        Y.VM.POS  = 8
        Y.FIN.FT.MG.CASH = 1
    END
    IF Y.DEPOSIT.NAME EQ 'CP' THEN
        IF NOT(R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.MG.ACT.NO.POS,1>) THEN
            RETURN
        END
        Y.VM.POS  = 9
        Y.FIN.FT.MG.CASH = 1
    END

    IF Y.FIN.FT.MG.CASH THEN
        Y.ADD.AMT = Y.TT.AMT
        GOSUB AMEND.FINAL.ARRAY
    END

RETURN
*--------------------------------------------------------------------------------------------------------
********************
CHECK.FIN.FT.MG.CHQ:
********************
* In this para of the code, the term instruments CASH transaction are checked
    Y.LOC.ACCOUNT.1 = ''
    Y.LOC.ACCOUNT.2 = ''

    Y.ACCOUNT.LIST = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>

    GOSUB LOCATE.ACCOUNTS
    IF Y.LOC.ACCOUNT.1 OR Y.LOC.ACCOUNT.2 THEN
        GOSUB CHECK.AZ.ACCOUNT
        RETURN
    END

    Y.ACCOUNT.LIST = R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ACCOUNT>

    GOSUB LOCATE.ACCOUNTS
    IF Y.LOC.ACCOUNT.1 OR Y.LOC.ACCOUNT.2 THEN
        GOSUB CHECK.AZ.ACCOUNT
        RETURN
    END

    Y.ACCOUNT.LIST = R.CERTIFIED.CHEQUE.PARAMETER<CERT.CHEQ.ACCOUNT.NO>

    GOSUB LOCATE.ACCOUNTS
    IF Y.LOC.ACCOUNT.1 OR Y.LOC.ACCOUNT.2 THEN
        GOSUB CHECK.AZ.ACCOUNT
    END

RETURN
*--------------------------------------------------------------------------------------------------------
****************
LOCATE.ACCOUNTS:
****************
* In this para of the code, the ACCOUNT.1 and ACCOUNT.2 are located in the account lists of cheques
** transaction accounts
    CHANGE @VM TO @FM IN Y.ACCOUNT.LIST
    LOCATE R.TELLER<TT.TE.ACCOUNT.1> IN Y.ACCOUNT.LIST<1> SETTING Y.ACC.POS THEN
        Y.LOC.ACCOUNT.1 = 1
        RETURN
    END

    LOCATE R.TELLER<TT.TE.ACCOUNT.2> IN Y.ACCOUNT.LIST<1> SETTING Y.ACC.POS THEN
        Y.LOC.ACCOUNT.2 = 1
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
CHECK.AZ.ACCOUNT:
*****************
* In this para of the code, the ACCOUNT.1 or ACCOUNT.2 of the teller is checked for AZ.ACCOUNT
    IF Y.LOC.ACCOUNT.1 THEN
        AZ.ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
    END ELSE
        AZ.ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.1>
    END
    GOSUB READ.AZ.ACCOUNT

    IF NOT(R.AZ.ACCOUNT) THEN
        CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT.HIS,AZ.ACCOUNT.ID,R.AZ.ACCOUNT,AZ.AC.HIS.ER)
        IF NOT(R.AZ.ACCOUNT) THEN
            RETURN
        END
    END


    Y.DEPOSIT.NAME = R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.DEP.NAME.POS>

    IF Y.DEPOSIT.NAME EQ 'CF' THEN
        Y.VM.POS  = 7
        Y.FIN.FT.MG.CHQ = 1
    END
    IF Y.DEPOSIT.NAME EQ 'DP' OR Y.DEPOSIT.NAME EQ 'DX' THEN
        Y.VM.POS  = 8
        Y.FIN.FT.MG.CHQ = 1
    END
    IF Y.DEPOSIT.NAME EQ 'CP' THEN
        IF NOT(R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.MG.ACT.NO.POS,1>) THEN
            RETURN
        END
        Y.VM.POS  = 9
        Y.FIN.FT.MG.CHQ = 1
    END

    IF Y.FIN.FT.MG.CHQ THEN
        Y.ADD.AMT = Y.TT.AMT
        GOSUB AMEND.FINAL.ARRAY
    END

RETURN
*--------------------------------------------------------------------------------------------------------
********************
CHECK.FIN.FT.MG.TFR:
********************
* In this para of the code, the term instruments TRANSFER transaction are checked
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

    TELLER.TRANSACTION.ID = R.TELLER<TT.TE.TRANSACTION.CODE>
    GOSUB READ.TELLER.TRANSACTION
    IF NOT(R.TELLER.TRANSACTION) THEN
        RETURN
    END

    TRANSACTION.ID = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
    GOSUB READ.TRANSACTION

    IF R.TRANSACTION<AC.TRA.DEBIT.CREDIT.IND> EQ 'DEBIT' THEN
        AZ.ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.1>
    END ELSE
        AZ.ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
    END

    GOSUB READ.AZ.ACCOUNT
    IF NOT(R.AZ.ACCOUNT) THEN
        CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT.HIS,AZ.ACCOUNT.ID,R.AZ.ACCOUNT,AZ.AC.HIS.ER)
        IF NOT(R.AZ.ACCOUNT) THEN
            RETURN
        END
    END

*IF NOT(R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.MG.ACT.NO.POS,1>) THEN
*    RETURN
*END

    Y.DEPOSIT.NAME = R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.DEP.NAME.POS>

    IF Y.DEPOSIT.NAME EQ 'CF' THEN
        Y.VM.POS  = 7
        Y.FIN.FT.MG.TFR = 1
    END
    IF Y.DEPOSIT.NAME EQ 'DP' OR Y.DEPOSIT.NAME EQ 'DX' THEN
        Y.VM.POS  = 8
        Y.FIN.FT.MG.TFR = 1
    END
    IF Y.DEPOSIT.NAME EQ 'CP' THEN
        IF NOT(R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.MG.ACT.NO.POS,1>) THEN
            RETURN
        END
        Y.VM.POS  = 9
        Y.FIN.FT.MG.TFR = 1
    END

    IF Y.FIN.FT.MG.TFR THEN
        Y.ADD.AMT = Y.TT.AMT
        GOSUB AMEND.FINAL.ARRAY
    END

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

    IF Y.FIN.FT.MG.CASH THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4>  += Y.ADD.AMT
    END

    IF Y.FIN.FT.MG.CHQ THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5>  += Y.ADD.AMT
    END

    IF Y.FIN.FT.MG.TFR THEN
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3>  += 1
        Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6>  += Y.ADD.AMT
    END

    Y.TT.LIST<-1> = TELLER.ID

RETURN
*--------------------------------------------------------------------------------------------------------
****************
READ.AZ.ACCOUNT:
****************
* In this para of the code, file AZ.ACCOUNT is read
    R.AZ.ACCOUNT  = ''
    AZ.ACCOUNT.ER = ''
    CALL F.READ(FN.AZ.ACCOUNT,AZ.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
************************
READ.TELLER.TRANSACTION:
************************
* In this para of the code, file TELLER.TRANSACTION is read
    R.TELLER.TRANSACTION  = ''
    TELLER.TRANSACTION.ER = ''
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TELLER.TRANSACTION.ID, R.TELLER.TRANSACTION, TELLER.TRANSACTION.ER)  ;*R22 AUTO CODE CONVERSION

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
READ.TRANSACTION:
*****************
* In this para of the code, file TRANSACTION is read
    R.TRANSACTION  = ''
    TRANSACTION.ER = ''
    CALL CACHE.READ(FN.TRANSACTION, TRANSACTION.ID, R.TRANSACTION, TRANSACTION.ER) ;*R22 AUTO CODE CONVERSION

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
    APPL.ARRAY = 'AZ.ACCOUNT':@FM:'TELLER'
    FLD.ARRAY  = 'L.AZ.DEP.NAME':@VM:'L.MG.ACT.NO':@FM:'L.TT.AZ.ACC.REF'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.AZ.DEP.NAME.POS  =  FLD.POS<1,1>
    LOC.L.MG.ACT.NO.POS    =  FLD.POS<1,2>
    LOC.POS.AZ.ACC.REF = FLD.POS<2,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
