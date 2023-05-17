SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.TERM.INST.OPEN(Y.CCY.LIST,TELLER.ID,R.TELLER,Y.FINAL.ARRAY,Y.TT.LIST)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.TERM.INST.OPEN
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.TERM.INST.OPEN is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP, this routine is used to fetch the term instrument openings
*                    details from AZ.ACCOUNT records
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : R.REDO.H.TELLER.TXN.CODES - The record of REDO.H.TELLER.TXN.CODES
*                    Y.CCY.LIST - This variable holds the processed currency list
*Out Parameter     : Y.FINAL.ARRAY - THe final Array to be passed out
*                    Y.CCY.LIST - This variable holds the processed currency list
*Files  Used       : AZ.ACCOUNT                       As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 15 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
* 23 Aug 2011           Riyas                       PACS00104133     Modification(report displays all the transaction happened for a AZ.ACCOUNT ON day)
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.TELLER
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

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES'
    F.T24.FUND.SERVICES  = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

*    GOSUB FORM.SEL.CMD
*
*    IF NOT(SEL.LIST.AZ) THEN
*        RETURN
*    END

    GOSUB GET.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
*************
FORM.SEL.CMD:
*************
* In this para of the code, the SELECT command is formed to get the TELLER transactions IDs for processing

    LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGY.POS  THEN
        Y.AGENCY = D.RANGE.AND.VALUE<Y.AGY.POS>
    END

    SEL.CMD.AZ = 'SELECT ':FN.AZ.ACCOUNT:' WITH CO.CODE EQ ':Y.AGENCY
    CALL EB.READLIST(SEL.CMD.AZ,SEL.LIST.AZ,'',NO.OF.REC.AZ,SEL.ERR.AZ)

RETURN
*--------------------------------------------------------------------------------------------------------
************
GET.DETAILS:
************
* In this para of the code, the GOSUBs to fetch all the details are written

    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB TERM.INST.OPEN.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
TERM.INST.OPEN.DETAILS:
***********************
* In this para of the code, the TERM INSTRUMENT OPENING details are being extracted

*PACS00104133-S
    Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>

    IF Y.TT.CCY EQ LCCY THEN
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
    END ELSE
        Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
    END
*PACS00104133-E

    GOSUB GET.TERM.INST.OPEN.DETAILS

*  LOOP
*      REMOVE AZ.ACCOUNT.ID FROM SEL.LIST.AZ SETTING Y.AZ.POS
*  WHILE AZ.ACCOUNT.ID : Y.AZ.POS
*      GOSUB READ.AZ.ACCOUNT
*      GOSUB GET.TERM.INST.OPEN.DETAILS
*  REPEAT
*
RETURN
*--------------------------------------------------------------------------------------------------------
***************************
GET.TERM.INST.OPEN.DETAILS:
***************************
* In this para of the code, the term instrument details are fetced corss checked with conditions and
** processed further

*PACS00104133-S
    Y.DR.CR.MARK = R.TELLER<TT.TE.DR.CR.MARKER>
    IF Y.DR.CR.MARK EQ 'DEBIT' THEN
        Y.CR.ACC = R.TELLER<TT.TE.ACCOUNT.2>
    END ELSE
        Y.CR.ACC = R.TELLER<TT.TE.ACCOUNT.1>
    END
*PACS00104133-E

    GOSUB READ.AZ.ACCOUNT

    IF NOT(R.AZ.ACCOUNT) THEN
        CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT,Y.CR.ACC,R.AZ.ACCOUNT,AZ.AC.ERR)
        IF NOT(R.AZ.ACCOUNT) THEN
            RETURN
        END
    END

    IF NOT(R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.REF.NO.POS>) THEN
        RETURN
    END

    T24.FUND.SERVICES.ID = R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.REF.NO.POS>
    GOSUB READ.T24.FUND.SERVICES
    IF NOT(R.T24.FUND.SERVICES) THEN
        RETURN
    END

    Y.DEPOSIT.NAME = R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.DEP.NAME.POS>

    IF Y.DEPOSIT.NAME EQ 'CF' THEN
        GOSUB CHECK.FIN.CATEG
        Y.VM.POS = 6
        GOSUB AMEND.FINAL.ARRAY
    END

    IF Y.DEPOSIT.NAME EQ 'DP' OR Y.DEPOSIT.NAME EQ 'DX' THEN
        GOSUB CHECK.FIN.CATEG
        Y.VM.POS = 7
        GOSUB AMEND.FINAL.ARRAY
    END

    IF Y.DEPOSIT.NAME EQ 'CP' THEN
        IF NOT(R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.MG.ACT.NO.POS,1>) THEN
*  RETURN
        END
        GOSUB CHECK.FIN.CATEG
        Y.VM.POS = 8
        GOSUB AMEND.FINAL.ARRAY
    END

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.FIN.CATEG:
****************
* In this para of the code, the transaction with FINANCIAL CATEGORY of the AZ.ACCOUNT are processed
    Y.METHOD.PAY.COUNT = DCOUNT(R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.METHOD.PAY.POS>,@SM)
    Y.METHOD.PAY.START = 1
    Y.CASH.AMT = 0 ; Y.CHQ.AMT = 0 ; Y.TFR.AMT = 0

    LOOP
    WHILE Y.METHOD.PAY.START LE Y.METHOD.PAY.COUNT
        IF R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.METHOD.PAY.POS,Y.METHOD.PAY.START> EQ 'CASHDEPOSIT' THEN
            Y.CASH.AMT += R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.AMOUNT.POS,Y.METHOD.PAY.START>
        END
        IF R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.METHOD.PAY.POS,Y.METHOD.PAY.START> EQ 'CHEQUE.DEPOSIT' THEN
            Y.CHQ.AMT  += R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.AMOUNT.POS,Y.METHOD.PAY.START>
        END
        IF R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.METHOD.PAY.POS,Y.METHOD.PAY.START> NE 'CASHDEPOSIT' AND R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.METHOD.PAY.POS,Y.METHOD.PAY.START> NE 'CHEQUE.DEPOSIT' THEN
            Y.TFR.AMT  += R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.AMOUNT.POS,Y.METHOD.PAY.START>
        END
        Y.METHOD.PAY.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
******************
AMEND.FINAL.ARRAY:
******************
* In this para of the code, the Y.FINAL.ARRAY is amended with increment in the total number of transactions
** and the amount is added up

    LOCATE R.AZ.ACCOUNT<AZ.CURRENCY> IN Y.CCY.LIST<1> SETTING Y.CCY.POS ELSE
        Y.CCY.LIST<-1> = R.AZ.ACCOUNT<AZ.CURRENCY>
        Y.CCY.POS = DCOUNT(Y.CCY.LIST,@FM)
    END

    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4> += Y.CASH.AMT
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5> += Y.CHQ.AMT
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6> += Y.TFR.AMT
    Y.TT.LIST<-1> = TELLER.ID
RETURN
*--------------------------------------------------------------------------------------------------------
****************
READ.AZ.ACCOUNT:
****************
* In this para of the code, file AZ.ACCOUNT is read
    R.AZ.ACCOUNT  = ''
    AZ.ACCOUNT.ER = ''
    CALL F.READ(FN.AZ.ACCOUNT,Y.CR.ACC,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
READ.T24.FUND.SERVICES:
***********************
* In this para of the code, file T24.FUND.SERVICES is read
    R.T24.FUND.SERVICES  = ''
    T24.FUND.SERVICES.ER = ''
    CALL F.READ(FN.T24.FUND.SERVICES,T24.FUND.SERVICES.ID,R.T24.FUND.SERVICES,F.T24.FUND.SERVICES,T24.FUND.SERVICES.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'AZ.ACCOUNT'
    FLD.ARRAY  = 'L.AZ.REF.NO':@VM:'L.AZ.DEP.NAME':@VM:'L.AZ.METHOD.PAY':@VM:'L.AZ.AMOUNT':@VM:'L.MG.ACT.NO'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.AZ.REF.NO.POS     = FLD.POS<1,1>
    LOC.L.AZ.DEP.NAME.POS   = FLD.POS<1,2>
    LOC.L.AZ.METHOD.PAY.POS = FLD.POS<1,3>
    LOC.L.AZ.AMOUNT.POS     = FLD.POS<1,4>
    LOC.L.MG.ACT.NO.POS     = FLD.POS<1,5>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
