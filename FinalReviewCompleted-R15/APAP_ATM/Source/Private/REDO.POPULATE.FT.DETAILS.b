* @ValidationCode : MjotMTUyNjg1NTk6Q3AxMjUyOjE3MDQ5ODgwNTUzOTA6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Jan 2024 21:17:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
SUBROUTINE REDO.POPULATE.FT.DETAILS
**************************************************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Ganesh R
* PROGRAM NAME: REDO.POPULATE.FT.DETAILS
* ODR NO      : ODR-2011-03-0150
*-----------------------------------------------------------------------------------------------------
*DESCRIPTION: This routine is to get the FT details from a Work File REDO.AUTH.CODE.DETAILS and populate in Teller Version
*******************************************************************************************************
*linked with :
*In parameter:
*Out parameter:
*****************************************************************************************************
*Modification History
*  Date       Who             Reference       Description
* 16 jan 2011 Ganesh R    ODR-2011-03-0150    Will Store the Detils
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - New condition added
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*09-01-2024	   VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES          SQA-12211 � By Santiago
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_REDO.DEBIT.CARD.COMMON
    $INSERT I_F.ATM.TRANSACTION		;*Fix SQA-12211 � By Santiago-new line is added
    

    IF OFS$HOT.FIELD EQ 'L.TT.POS.AUTHNM' THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END
    GOSUB PGM.END
RETURN
************
OPEN.FILES:
************
;*Fix SQA-12211 � By Santiago-new line is added-start
    FN.ATM.TRANSACTION = 'F.ATM.TRANSACTION'
    F.ATM.TRANSACTION  = ''
    CALL OPF(FN.ATM.TRANSACTION,F.ATM.TRANSACTION)
;*Fix SQA-12211 � By Santiago-new line is added-end
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
;*Fix SQA-12211 � By Santiago-new line is added-start
*INICIAN CAMBIOS FELICITAS
    Y.LT.APP = 'TELLER':@FM:'ATM.TRANSACTION'
    Y.LT.FLD = 'L.TT.POS.AUTHNM':@VM:'L.TT.CR.CARD.NO':@FM:'L.WITHDRAW.STAT'
    Y.LT.POS = ''
 
    CALL MULTI.GET.LOC.REF(Y.LT.APP, Y.LT.FLD, Y.LT.POS)
    Y.POS.AUTH = Y.LT.POS<1,1>
    Y.CARD.NUM = Y.LT.POS<1,2>
    L.WITHDRAW.STATUS.POS = Y.LT.POS<2,1>
*    Y.AUTH.NO = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.POS.AUTH>
*TERMINAN CAMBIOS FELICITAS
 ;*Fix SQA-12211 � By Santiago-new line is added-end   
RETURN
**********
PROCESS:
***********
*Get the Value of Auth Code.
*    Y.CCARD.NO = TEMP.VAR
    Y.CCARD.NO = System.getVariable("CURRENT.CARD.NUM")
    Y.AUTH.ID = COMI
    Y.AUTH.ID = Y.CCARD.NO:'.':Y.AUTH.ID

    Y.DR.CR.MARKER = R.NEW(TT.TE.DR.CR.MARKER)
    CALL F.READ(FN.ATM.TRANSACTION,Y.AUTH.ID,R.ATM.TRANSACTION,F.ATM.TRANSACTION,ATM.ERR)	;*Fix SQA-12211 � By Santiago-new line is added-start
    IF R.ATM.TRANSACTION THEN	;*Fix SQA-12211 � By Santiago-new line is added-start
        GOSUB CHECK.PROCESS
    END ELSE
        ETEXT = "EB-REDO.WRONG.AUTH.NUM"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
    
*Read the FT id and get the details

    CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.ERR)
    IF FUNDS.ERR THEN
        FUNDS.ERR = ''
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.FT.ID,R.FUNDS.TRANSFER,FUNDS.ERR)
    END
    
    IF R.FUNDS.TRANSFER THEN
        Y.DEBIT.ACCOUNT = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
        Y.ACC.ID        = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
        Y.DEBIT.AMOUNT  = R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
        IF NOT(Y.DEBIT.AMOUNT) THEN
            Y.DEBIT.AMOUNT = R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>
            Y.DEBIT.CCY    = R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>
        END
        Y.DEBIT.CCY     = R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>

*        R.NEW(TT.TE.ACCOUNT.2)  = Y.DEBIT.ACCOUNT	;*Fix SQA-12211 � By Santiago-commented
*        R.NEW(TT.TE.CURRENCY.2) = Y.DEBIT.CCY		;*Fix SQA-12211 � By Santiago-commented
        R.NEW(TT.TE.ACCOUNT.2)  = Y.ACC.ID	;*Fix SQA-12211 � By Santiago-new line is added
        R.NEW(TT.TE.CURRENCY.2) = R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>	;*Fix SQA-12211 � By Santiago-new line is added
        
        
        
        IF Y.DEBIT.CCY EQ LCCY THEN
            R.NEW(TT.TE.AMOUNT.LOCAL.2) = Y.DEBIT.AMOUNT
            R.NEW(TT.TE.AMOUNT.LOCAL.1) = Y.DEBIT.AMOUNT
        END ELSE
            R.NEW(TT.TE.AMOUNT.FCY.2) = Y.DEBIT.AMOUNT
            R.NEW(TT.TE.AMOUNT.FCY.1) = Y.DEBIT.AMOUNT
        END
    END ELSE
        ETEXT = "EB-REDO.WRONG.AUTH.NUM"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    R.NEW(TT.TE.CUSTOMER.1) = R.ACCOUNT<AC.CUSTOMER>
RETURN

*****************
CHECK.PROCESS:
*****************
;*Fix SQA-12211 � By Santiago-new line is added-start
    Y.WITHDRAW.STATUS = ''
    Y.WITHDRAW.STATUS = R.ATM.TRANSACTION<AT.REV.LOCAL.REF, L.WITHDRAW.STATUS.POS>
    IF Y.WITHDRAW.STATUS EQ '' THEN
        Y.FT.ID = R.ATM.TRANSACTION<AT.REV.TRANS.REF>
	;*Fix SQA-12211 � By Santiago-new line is added-end
    END ELSE
        ETEXT = "EB-NUM.ALREADY.USED"
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
RETURN
*************
PGM.END:
************
END