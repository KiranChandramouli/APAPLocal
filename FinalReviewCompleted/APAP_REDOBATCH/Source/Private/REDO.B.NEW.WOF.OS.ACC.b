* @ValidationCode : MjotMjAyNDQyMDA4NjpDcDEyNTI6MTY4NDg1NDM5NDEzODpJVFNTOi0xOi0xOjI0OTA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 2490
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.NEW.WOF.OS.ACC(Y.ID)
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.NEW.WOF.OS.ACC
*-----------------------------------------------------------------
* Description : This routine used to raise the entry for group of aa loans.
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017      23-OCT-2011          WOF ACCOUTING - PACS00202156
* Date                   who                   Reference              
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND ++ TO += 1 AND VAR1- TO -=
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.ACCT.MRKWOF.HIST
    $INSERT I_F.REDO.NEW.WORK.INT.CAP.OS
    $INSERT I_F.REDO.AA.INT.CLASSIFICATION
    $INSERT I_F.REDO.ACCT.MRKWOF.PARAMETER
    $INSERT I_REDO.B.NEW.WOF.OS.ACC.COMMON

*-----------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------

    GOSUB PROCESS
    GOSUB PGM.END
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    CALL OCOMO("Processing Start - ":Y.ID)
    Y.WRITE.FLAG = ''
    CALL F.READ(FN.REDO.ACCT.MRKWOF.HIST,Y.ID,R.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST,HIST.ERR)
    CALL F.READ(FN.AA.ARRANGEMENT,Y.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.AR.ERR)
    Y.LOAN.COMP = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
    Y.LOAN.CUR = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
    Y.LOAN.AC = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>

    CALL F.READ(FN.ACCOUNT,Y.LOAN.AC,R.ACC,F.ACCOUNT,AC.ERR)
    Y.LOAN.CATEG = R.ACC<AC.CATEGORY>

    CALL F.READ(FN.REDO.WOF.CONCAT.FILE,Y.ID,R.REDO.WOF.CONCAT.FILE,F.REDO.WOF.CONCAT.FILE,CNCT.ERR)

    GOSUB BEFORE.RAISE.ENTRIES          ;* All relates WOF accounts created.
    GOSUB GET.PRINCIPALINT.PROPERTY     ;* Get the Principal Interest Property
    GOSUB GET.OVERDUE.STATUS  ;* Get the overdue status
    R.STMT.ENTRY = ''
    GOSUB ENTRY.PRINCIPAL     ;* Raise Principal Amount entry
    GOSUB ENTRY.INTEREST      ;* Raise Interest Amount entry
    IF R.STMT.ENTRY THEN
        GOSUB CAL.ACCOUNTING
    END
    GOSUB MARK.SETTLED        ;* To check whether loan has been settled.
    IF Y.WRITE.FLAG EQ 'YES' THEN
        CALL F.WRITE(FN.REDO.WOF.CONCAT.FILE,Y.ID,R.REDO.WOF.CONCAT.FILE)
    END
    CALL OCOMO("Normal WOF accounting completed - ":Y.ID)
RETURN
*-----------------------------------------------------------------------------
BEFORE.RAISE.ENTRIES:
*-----------------------------------------------------------------------------

    Y.LOAN.STATUS = R.REDO.ACCT.MRKWOF.HIST<REDO.WH.L.LOAN.STATUS>
    LOCATE Y.LOAN.CATEG IN R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.PROD.CATEGORY,1> SETTING CATEG.POS THEN
        LOCATE Y.LOAN.STATUS IN R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.LOAN.STATUS,CATEG.POS,1> SETTING LOAN.POS THEN
            Y.DR.PRINCIPAL.CATEG = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.PRIN.DEB.CATEGORY,CATEG.POS,LOAN.POS>
            Y.DR.PRINCIPAL.TXN   = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.PRIN.DEB.TXN,CATEG.POS,LOAN.POS>
            Y.CR.PRINCIPAL.CATEG = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.PRIN.CRED.CATEGORY,CATEG.POS,LOAN.POS>
            Y.CR.PRINCIPAL.TXN   = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.PRIN.CRED.TXN,CATEG.POS,LOAN.POS>
            Y.DR.INTEREST.CATEG  = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.INT.DEB.CATEGORY,CATEG.POS,LOAN.POS>
            Y.DR.INTEREST.TXN    = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.INT.DEB.TXN,CATEG.POS,LOAN.POS>
            Y.CR.INTEREST.CATEG  = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.INT.CRED.CATEGORY,CATEG.POS,LOAN.POS>
            Y.CR.INTEREST.TXN    = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.INT.CRED.TXN,CATEG.POS,LOAN.POS>
            Y.PRINCIPAL.PL       = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.PRINCIPAL.INCOME>
            Y.INTEREST.PL        = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.INTEREST.INCOME>
            Y.SETTLE.ACC         = R.REDO.ACCT.MRKWOF.PARAMETER<RE.WOF.PAR.INT.SETTLE.ACC>

        END ELSE
            CALL OCOMO("Loan Status not found in Param - REDO.ACCT.MRKWOF.PARAMETER - ":Y.ID)
            GOSUB PGM.END
        END
    END ELSE
        CALL OCOMO("Category not found in Param - REDO.ACCT.MRKWOF.PARAMETER - ":Y.ID)
        GOSUB PGM.END
    END
    IF Y.DR.PRINCIPAL.TXN AND Y.CR.PRINCIPAL.TXN AND Y.DR.INTEREST.TXN AND Y.CR.INTEREST.TXN ELSE
        CALL OCOMO("TXN Codes Missing in REDO.ACCT.MRKWOF.PARAMETER - ":Y.ID)
        GOSUB PGM.END
    END

    IF Y.PRINCIPAL.PL AND Y.INTEREST.PL AND Y.SETTLE.ACC ELSE
        CALL OCOMO("Settlement Accounts Missing in REDO.ACCT.MRKWOF.PARAMETER - ":Y.ID)
        GOSUB PGM.END
    END


    CALL F.READ(FN.REDO.CONCAT.ACC.WOF,Y.LOAN.AC,R.REDO.CONCAT.ACC.WOF,F.REDO.CONCAT.ACC.WOF,CON.ERR)
    IF R.REDO.CONCAT.ACC.WOF THEN
        Y.CUST.PRIN.CNT.ACC = R.REDO.CONCAT.ACC.WOF<1>      ;* Principal Customer Contingent Account
        Y.CUST.PRIN.CNT.INT = R.REDO.CONCAT.ACC.WOF<2>      ;* Interest Customer Contingent Account
        IF Y.CUST.PRIN.CNT.ACC ELSE
            GOSUB CREATE.CUST.PRIN.CNT  ;* Creates Principal Customer Contingent Account
        END
        IF Y.CUST.PRIN.CNT.INT ELSE
            GOSUB CREATE.CUST.INT.CNT   ;* Creates Interest Customer Contingent Account
        END

    END ELSE
        GOSUB CREATE.CUST.PRIN.CNT      ;* Creates Principal Customer Contingent Account
        GOSUB CREATE.CUST.INT.CNT       ;* Creates Interest Customer Contingent Account
    END
    CALL F.WRITE(FN.REDO.CONCAT.ACC.WOF,Y.LOAN.AC,R.REDO.CONCAT.ACC.WOF)
    GOSUB CHECK.INT.ACCOUNTS  ;* Internal Accounts for WOF created or returned if exist

RETURN
*-----------------------------------------------------------------------------
CREATE.CUST.PRIN.CNT:
*-----------------------------------------------------------------------------
* Creates Principal Customer Contingent Account

    IF Y.DR.PRINCIPAL.CATEG ELSE
        CALL OCOMO("Principal Customer Contingent Account Category not found ":Y.ID)
        GOSUB PGM.END
    END

    R.OFS.ACC = ''
    R.OFS.ACC<AC.CATEGORY>                      = Y.DR.PRINCIPAL.CATEG
    R.OFS.ACC<AC.ACCOUNT.TITLE.2>               = "WOF Prin ":Y.ID
    GOSUB FILL.COMMON.ARRAY

    IF Y.LFG EQ 1 THEN
        R.REDO.CONCAT.ACC.WOF<1> = Y.NEW.AC
    END ELSE
        CALL OCOMO("Principal Customer Contingent Account not created  ":Y.ID:'- Response -':Y.RESP)
        GOSUB PGM.END
    END

RETURN
*-----------------------------------------------------------------------------
CREATE.CUST.INT.CNT:
*-----------------------------------------------------------------------------
* Creates Interest Customer Contingent Account

    IF Y.DR.INTEREST.CATEG ELSE
        CALL OCOMO("Principal Customer Contingent Account Category not found ":Y.ID)
        GOSUB PGM.END
    END

    R.OFS.ACC = ''
    R.OFS.ACC<AC.CATEGORY>                      = Y.DR.INTEREST.CATEG
    R.OFS.ACC<AC.ACCOUNT.TITLE.2>               = "WOF Int ":Y.ID
    GOSUB FILL.COMMON.ARRAY

    IF Y.LFG EQ 1 THEN
        R.REDO.CONCAT.ACC.WOF<2> = Y.NEW.AC
    END ELSE
        CALL OCOMO("Interest Customer Contingent Account not created  ":Y.ID:'- Response -':Y.RESP)
        GOSUB PGM.END
    END

RETURN
*-----------------------------------------------------------------------------
FILL.COMMON.ARRAY:
*-----------------------------------------------------------------------------

    R.OFS.ACC<AC.ACCOUNT.TITLE.1>               = R.ACC<AC.ACCOUNT.TITLE.1>
    R.OFS.ACC<AC.CUSTOMER>                      = R.ACC<AC.CUSTOMER>
    R.OFS.ACC<AC.SHORT.TITLE>                   = R.ACC<AC.SHORT.TITLE>
    R.OFS.ACC<AC.CURRENCY>                      = R.ACC<AC.CURRENCY>
    R.OFS.ACC<AC.MNEMONIC>                      = R.ACC<AC.MNEMONIC>
    R.OFS.ACC<AC.POSITION.TYPE>                 = R.ACC<AC.POSITION.TYPE>
    R.OFS.ACC<AC.ACCOUNT.OFFICER>               = R.ACC<AC.ACCOUNT.OFFICER>
    R.OFS.ACC<AC.POSTING.RESTRICT>              = R.ACC<AC.POSTING.RESTRICT>
    R.OFS.ACC<AC.CONTINGENT.INT>                = 'C'
    R.OFS.ACC<AC.LOCAL.REF,POS.AV.BAL>          = R.ACC<AC.LOCAL.REF,POS.AV.BAL>
    R.OFS.ACC<AC.LOCAL.REF,POS.L.LOAN.STATUS>   = '3'
    R.OFS.ACC<AC.LOCAL.REF,POS.L.OD.STATUS>     = R.ACC<AC.LOCAL.REF,POS.L.OD.STATUS>
    R.OFS.ACC<AC.LOCAL.REF,POS.L.OD.STATUS.2>   = R.ACC<AC.LOCAL.REF,POS.L.OD.STATUS.2>
    R.OFS.ACC<AC.LOCAL.REF,POS.OR.RE>           = R.ACC<AC.LOCAL.REF,POS.OR.RE>

    APP.VAL     = 'ACCOUNT'
    OFSFUNCT    = 'I'
    OFS.VER     = 'ACCOUNT,REDO.NAB'
    NO.OF.AUTH  = 0
    AZ.ID       = ''
    GTS.MODE    = ''
    Y.COMPANY   = ID.COMPANY
    ID.COMPANY  = Y.LOAN.COMP
    CALL OFS.BUILD.RECORD(APP.VAL,OFSFUNCT,'PROCESS',OFS.VER,GTS.MODE,NO.OF.AUTH,AZ.ID,R.OFS.ACC,OFS.RECORD)
    ID.COMPANY   = Y.COMPANY
    CALL.INFO    = ''
    CALL.INFO<1> = 'REDO.NAB'
    THE.RESPONSE = ''
    TXN.CMM      = ''
    CALL OFS.CALL.BULK.MANAGER(CALL.INFO,OFS.RECORD,THE.RESPONSE,TXN.CMM)
    Y.AC.DE = FIELD(THE.RESPONSE,',',1)
    Y.NEW.AC = FIELD(Y.AC.DE,'/',1)
    Y.LFG = FIELD(Y.AC.DE,'/',3)
    Y.RESP= FIELD(THE.RESPONSE,',',2)
RETURN
*-----------------------------------------------------------------------------
CHECK.INT.ACCOUNTS:
*-----------------------------------------------------------------------------
* Internal Accounts for WOF created or returned if exist

    IF Y.CR.PRINCIPAL.CATEG AND Y.CR.INTEREST.CATEG ELSE
        CALL OCOMO("Internal WOF Accounts not exist for Loan ":Y.ID)
        GOSUB PGM.END
    END

    CALL CACHE.READ(FN.COMPANY,Y.LOAN.COMP,R.COMP.REC,COM.ERR)
    Y.COMP.DIV.CODE = R.COMP.REC<EB.COM.SUB.DIVISION.CODE>
    Y.INT.ACC.CO = Y.CR.PRINCIPAL.CATEG[LEN(Y.CR.PRINCIPAL.CATEG)-3,4]
    IF Y.COMP.DIV.CODE EQ Y.INT.ACC.CO THEN
        Y.PRINCIPAL.INT.ACC = Y.CR.PRINCIPAL.CATEG
    END ELSE
        Y.PRINCIPAL.INT.ACC = Y.CR.PRINCIPAL.CATEG[1,LEN(Y.CR.PRINCIPAL.CATEG)-4]:Y.COMP.DIV.CODE
        CALL F.READ(FN.ACCOUNT,Y.PRINCIPAL.INT.ACC,R.ACC,F.ACCOUNT,ACC.ERR)

        IF R.ACC ELSE         ;* If account not exist then create.
            CALL INT.ACC.OPEN (Y.PRINCIPAL.INT.ACC,PRETURN.CODE)
        END
    END

    Y.INT.ACC.CO = Y.CR.INTEREST.CATEG[LEN(Y.CR.INTEREST.CATEG)-3,4]
    IF Y.COMP.DIV.CODE EQ Y.INT.ACC.CO THEN
        Y.INTEREST.INT.ACC = Y.CR.INTEREST.CATEG
    END ELSE
        Y.INTEREST.INT.ACC = Y.CR.INTEREST.CATEG[1,LEN(Y.CR.INTEREST.CATEG)-4]:Y.COMP.DIV.CODE
        CALL F.READ(FN.ACCOUNT,Y.INTEREST.INT.ACC,R.ACC,F.ACCOUNT,ACC.ERR)

        IF R.ACC ELSE         ;* If account not exist then create.
            CALL INT.ACC.OPEN (Y.INTEREST.INT.ACC,PRETURN.CODE)
        END
    END
    IF Y.PRINCIPAL.INT.ACC AND Y.INTEREST.INT.ACC ELSE
        CALL OCOMO("Internal WOF Accounts not created for Loan ":Y.ID)
        GOSUB PGM.END
    END

RETURN
*----------------------------------------------------------------------
MARK.SETTLED:
*----------------------------------------------------------------------

    IF Y.PRINCIPAL.BAL EQ 0 AND Y.INTEREST.BAL EQ 0 THEN
        R.REDO.ACCT.MRKWOF.HIST<REDO.WH.STATUS> = 'LIQUIDATED'
        CALL F.WRITE(FN.REDO.ACCT.MRKWOF.HIST,Y.ID,R.REDO.ACCT.MRKWOF.HIST)
        CALL OCOMO("Loan has been settled/Liquidated - ":Y.ID)
    END

RETURN
*----------------------------------------------------------------------
ENTRY.PRINCIPAL:
*----------------------------------------------------------------------
* Principal Amount Entry.

    IF R.REDO.WOF.CONCAT.FILE<1> THEN
        Y.PRINCIPAL.RAISED = R.REDO.WOF.CONCAT.FILE<1>
    END ELSE
        Y.PRINCIPAL.RAISED = 0
    END
    BALANCE.TYPE = Y.OVERDUE.STATUS:@FM:'DUE':@FM:'CUR'
    Y.SP = ''
    Y.BAL.PROPERTY = Y.ACCOUNT.PROPERTY
    GOSUB GET.OUTSTANDING
    Y.PRINCIPAL.BAL = Y.BALANCE.AMOUNT
    BALANCE.TYPE = 'UNC'
    Y.SP = ''
    Y.BAL.PROPERTY = Y.ACCOUNT.PROPERTY
    GOSUB GET.OUTSTANDING
    Y.PRINCIPLE.UNC = Y.BALANCE.AMOUNT
    Y.PRINCIPAL.BAL -= Y.PRINCIPLE.UNC     ;* UNC balance is also income, so subracted

    Y.NEW.BALANCE = Y.PRINCIPAL.BAL - Y.PRINCIPAL.RAISED
    IF Y.NEW.BALANCE EQ 0 THEN
        CALL OCOMO("No change in Principle Amount")
        RETURN
    END

    DR.ACCOUNT.NUMBER = R.REDO.CONCAT.ACC.WOF<1>
    CR.ACCOUNT.NUMBER = Y.PRINCIPAL.INT.ACC

    R.ACCOUNT.DR = ''
    CALL F.READ(FN.ACCOUNT,DR.ACCOUNT.NUMBER,R.ACCOUNT.DR,F.ACCOUNT,AC.ERR)

    R.DR.STMT.ENTRY = ''
    IF Y.NEW.BALANCE GT 0 THEN
        R.DR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.DR.PRINCIPAL.TXN
        R.DR.STMT.ENTRY<AC.STE.NARRATIVE>        = 'WOF ENTRY PRINCIPLE'
    END ELSE
        R.DR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.CR.PRINCIPAL.TXN
        R.DR.STMT.ENTRY<AC.STE.NARRATIVE>        = 'WOF PRINCIPLE REVERSAL'
    END
    GOSUB FORM.DEBIT.ENTRY

    R.ACCOUNT.CR = ''
    CALL F.READ(FN.ACCOUNT,CR.ACCOUNT.NUMBER,R.ACCOUNT.CR,F.ACCOUNT,AC.ERR)

    R.CR.STMT.ENTRY = ''
    IF Y.NEW.BALANCE GT 0 THEN
        R.CR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.CR.PRINCIPAL.TXN
        R.CR.STMT.ENTRY<AC.STE.NARRATIVE> = 'WOF ENTRY PRINCIPLE'
    END ELSE
        R.CR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.DR.PRINCIPAL.TXN
        R.CR.STMT.ENTRY<AC.STE.NARRATIVE> = 'WOF PRINCIPLE REVERSAL'
    END
    GOSUB FORM.CREDIT.ENTRY
    IF Y.NEW.BALANCE LT 0 THEN          ;* Settle to PL for repayment.

        Y.PL.AMT          = ABS(Y.NEW.BALANCE)
        DR.ACCOUNT.NUMBER = Y.SETTLE.ACC
        Y.CR.CATEG        = Y.PRINCIPAL.PL
        R.DR.STMT.ENTRY = ''
        R.DR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.DR.PRINCIPAL.TXN
        R.DR.STMT.ENTRY<AC.STE.NARRATIVE>        = 'WOF SETTLE PRINCIPLE'
        R.CATEG.ENT                              = ''
        R.CATEG.ENT<AC.CAT.TRANSACTION.CODE>     = Y.CR.PRINCIPAL.TXN
        R.CATEG.ENT<AC.CAT.NARRATIVE>           = 'WOF SETTLE PRINCIPLE'
        GOSUB PAY.PL.CATEG
    END
    R.REDO.WOF.CONCAT.FILE<1> = R.REDO.WOF.CONCAT.FILE<1> + Y.NEW.BALANCE
    Y.WRITE.FLAG = 'YES'

RETURN
*----------------------------------------------------------------------
ENTRY.INTEREST:
*----------------------------------------------------------------------
* Interest Amount Entry.

    Y.NEW.BALANCE = 0
    IF R.REDO.WOF.CONCAT.FILE<2> THEN
        Y.INTEREST.RAISED = R.REDO.WOF.CONCAT.FILE<2>
    END ELSE
        Y.INTEREST.RAISED = 0
    END

    BALANCE.TYPE = Y.OVERDUE.STATUS:@FM:'DUE':@FM:'ACC'
    Y.SP = ''
    Y.BAL.PROPERTY = Y.INT.PROPERTY
    GOSUB GET.OUTSTANDING
    Y.INTEREST.BAL = Y.BALANCE.AMOUNT
    Y.SP = 'SP'
    Y.BAL.PROPERTY = Y.INT.PROPERTY
    GOSUB GET.OUTSTANDING
    Y.INTEREST.SP.BAL = Y.BALANCE.AMOUNT

    Y.TOTAL.INTEREST.BAL =  Y.INTEREST.BAL - Y.INTEREST.SP.BAL        ;* Excluding the SP balances.

    Y.NEW.BALANCE = Y.TOTAL.INTEREST.BAL - Y.INTEREST.RAISED
    IF Y.NEW.BALANCE EQ 0 THEN
        CALL OCOMO("No change in Interest Amount")
        RETURN
    END

    DR.ACCOUNT.NUMBER = R.REDO.CONCAT.ACC.WOF<2>
    CR.ACCOUNT.NUMBER = Y.INTEREST.INT.ACC

    R.ACCOUNT.DR = ''
    CALL F.READ(FN.ACCOUNT,DR.ACCOUNT.NUMBER,R.ACCOUNT.DR,F.ACCOUNT,AC.ERR)

    R.DR.STMT.ENTRY = ''
    IF Y.NEW.BALANCE GT 0 THEN
        R.DR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.DR.INTEREST.TXN
        R.DR.STMT.ENTRY<AC.STE.NARRATIVE>        = 'WOF ENTRY INTEREST'
    END ELSE
        R.DR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.CR.INTEREST.TXN
        R.DR.STMT.ENTRY<AC.STE.NARRATIVE>        = 'WOF INTEREST REVERSAL'
    END
    GOSUB FORM.DEBIT.ENTRY

    R.ACCOUNT.CR = ''
    CALL F.READ(FN.ACCOUNT,CR.ACCOUNT.NUMBER,R.ACCOUNT.CR,F.ACCOUNT,AC.ERR)

    R.CR.STMT.ENTRY = ''
    IF Y.NEW.BALANCE GT 0 THEN
        R.CR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.CR.INTEREST.TXN
        R.CR.STMT.ENTRY<AC.STE.NARRATIVE> = 'WOF ENTRY INTEREST'
    END ELSE
        R.CR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.DR.INTEREST.TXN
        R.CR.STMT.ENTRY<AC.STE.NARRATIVE> = 'WOF INTEREST REVERSAL'
    END
    GOSUB FORM.CREDIT.ENTRY
    IF Y.NEW.BALANCE LT 0 THEN          ;* Settle to PL for repayment.

        Y.PL.AMT                                 = ABS(Y.NEW.BALANCE)
        DR.ACCOUNT.NUMBER                        = Y.SETTLE.ACC
        Y.CR.CATEG                               = Y.INTEREST.PL
        R.DR.STMT.ENTRY                          = ''
        R.DR.STMT.ENTRY<AC.STE.TRANSACTION.CODE> = Y.DR.INTEREST.TXN
        R.DR.STMT.ENTRY<AC.STE.NARRATIVE>        = 'WOF SETTLE INTEREST'
        R.CATEG.ENT                              = ''
        R.CATEG.ENT<AC.CAT.TRANSACTION.CODE>     = Y.CR.INTEREST.TXN
        R.CATEG.ENT<AC.CAT.NARRATIVE>            = 'WOF SETTLE INTEREST'
        GOSUB PAY.PL.CATEG
    END
    R.REDO.WOF.CONCAT.FILE<2> = R.REDO.WOF.CONCAT.FILE<2> + Y.NEW.BALANCE
    Y.WRITE.FLAG = 'YES'

RETURN
*----------------------------------------------------------------------
FORM.DEBIT.ENTRY:
*----------------------------------------------------------------------
* Form the debit Side Entry.

    R.DR.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>   = DR.ACCOUNT.NUMBER
    R.DR.STMT.ENTRY<AC.STE.COMPANY.CODE>     = R.ACCOUNT.DR<AC.CO.CODE>
    R.DR.STMT.ENTRY<AC.STE.AMOUNT.LCY>       = Y.NEW.BALANCE * (-1)
    R.DR.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT.DR<AC.CATEGORY>
    R.DR.STMT.ENTRY<AC.STE.VALUE.DATE>       = TODAY
    R.DR.STMT.ENTRY<AC.STE.CURRENCY>         = R.ACCOUNT.DR<AC.CURRENCY>
    R.DR.STMT.ENTRY<AC.STE.OUR.REFERENCE>    = Y.LOAN.AC
    R.DR.STMT.ENTRY<AC.STE.EXPOSURE.DATE>    = TODAY
    R.DR.STMT.ENTRY<AC.STE.CURRENCY.MARKET>  = '1'
    R.DR.STMT.ENTRY<AC.STE.TRANS.REFERENCE>  = Y.LOAN.AC
    R.DR.STMT.ENTRY<AC.STE.SYSTEM.ID>        = 'AC'
    R.DR.STMT.ENTRY<AC.STE.BOOKING.DATE>     = TODAY

    CHANGE @FM TO @SM IN R.DR.STMT.ENTRY
    CHANGE @SM TO @VM IN R.DR.STMT.ENTRY

    R.STMT.ENTRY<-1> = R.DR.STMT.ENTRY

RETURN
*----------------------------------------------------------------------
FORM.CREDIT.ENTRY:
*----------------------------------------------------------------------
* Form the Credit Side Entry.

    R.CR.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>   = CR.ACCOUNT.NUMBER
    R.CR.STMT.ENTRY<AC.STE.COMPANY.CODE>     = R.ACCOUNT.CR<AC.CO.CODE>
    R.CR.STMT.ENTRY<AC.STE.AMOUNT.LCY>       = Y.NEW.BALANCE
    R.CR.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT.CR<AC.CATEGORY>
    R.CR.STMT.ENTRY<AC.STE.VALUE.DATE>       = TODAY
    R.CR.STMT.ENTRY<AC.STE.CURRENCY>         = R.ACCOUNT.CR<AC.CURRENCY>
    R.CR.STMT.ENTRY<AC.STE.OUR.REFERENCE>    = Y.LOAN.AC
    R.CR.STMT.ENTRY<AC.STE.EXPOSURE.DATE>    = TODAY
    R.CR.STMT.ENTRY<AC.STE.CURRENCY.MARKET>  = '1'
    R.CR.STMT.ENTRY<AC.STE.TRANS.REFERENCE>  = Y.LOAN.AC
    R.CR.STMT.ENTRY<AC.STE.SYSTEM.ID>        = 'AC'
    R.CR.STMT.ENTRY<AC.STE.BOOKING.DATE>     = TODAY

    CHANGE @FM TO @SM IN R.CR.STMT.ENTRY
    CHANGE @SM TO @VM IN R.CR.STMT.ENTRY

    R.STMT.ENTRY<-1> = R.CR.STMT.ENTRY

RETURN
*----------------------------------------------------------------------
PAY.PL.CATEG:
*----------------------------------------------------------------------

    R.ACCOUNT.DR = ''

    CALL F.READ(FN.ACCOUNT,DR.ACCOUNT.NUMBER,R.ACCOUNT.DR,F.ACCOUNT,AC.ERR)
    R.DR.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>   = DR.ACCOUNT.NUMBER
    R.DR.STMT.ENTRY<AC.STE.COMPANY.CODE>     = R.ACCOUNT.DR<AC.CO.CODE>
    R.DR.STMT.ENTRY<AC.STE.AMOUNT.LCY>       = Y.PL.AMT * (-1)
    R.DR.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT.DR<AC.CATEGORY>
    R.DR.STMT.ENTRY<AC.STE.VALUE.DATE>       = TODAY
    R.DR.STMT.ENTRY<AC.STE.CURRENCY>         = R.ACCOUNT.DR<AC.CURRENCY>
    R.DR.STMT.ENTRY<AC.STE.OUR.REFERENCE>    = Y.LOAN.AC
    R.DR.STMT.ENTRY<AC.STE.EXPOSURE.DATE>    = TODAY
    R.DR.STMT.ENTRY<AC.STE.CURRENCY.MARKET>  = '1'
    R.DR.STMT.ENTRY<AC.STE.TRANS.REFERENCE>  = Y.LOAN.AC
    R.DR.STMT.ENTRY<AC.STE.SYSTEM.ID>        = 'AC'
    R.DR.STMT.ENTRY<AC.STE.BOOKING.DATE>     = TODAY

    CHANGE @FM TO @SM IN R.DR.STMT.ENTRY
    CHANGE @SM TO @VM IN R.DR.STMT.ENTRY

    R.STMT.ENTRY<-1> = R.DR.STMT.ENTRY

*R.CATEG.ENT = ''
    R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER>   = ''
    R.CATEG.ENT<AC.CAT.COMPANY.CODE>     = Y.LOAN.COMP
    R.CATEG.ENT<AC.CAT.AMOUNT.LCY>       = Y.PL.AMT
    R.CATEG.ENT<AC.CAT.CUSTOMER.ID>      = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
*R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>
    R.CATEG.ENT<AC.CAT.PL.CATEGORY>      = Y.CR.CATEG
    R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY> = Y.LOAN.CATEG
    R.CATEG.ENT<AC.CAT.VALUE.DATE>       = TODAY
    R.CATEG.ENT<AC.CAT.CURRENCY>         = R.ACCOUNT.DR<AC.CURRENCY>
    R.CATEG.ENT<AC.CAT.EXCHANGE.RATE>    = ''
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET>  = "1"
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE>  = Y.LOAN.AC
    R.CATEG.ENT<AC.CAT.SYSTEM.ID>        = "AC"
    R.CATEG.ENT<AC.CAT.BOOKING.DATE>     = TODAY

    R.CATEG.ENT<AC.CAT.CRF.TYPE>         = "CREDIT"
    R.CATEG.ENT = LOWER(R.CATEG.ENT)

    R.STMT.ENTRY<-1> = R.CATEG.ENT


RETURN
*----------------------------------------------------------------------
CAL.ACCOUNTING:
*----------------------------------------------------------------------
* Raise the Accounting.
    IF Y.LOAN.COMP THEN
        CALL LOAD.COMPANY(Y.LOAN.COMP)
    END
    ACC.PRODUCT = 'AC'
    ACC.TYPE = 'SAO'
    CALL EB.ACCOUNTING(ACC.PRODUCT,ACC.TYPE,R.STMT.ENTRY,'')

RETURN
*------------------------------------------------------------
GET.PRINCIPALINT.PROPERTY:
*------------------------------------------------------------

    OUT.PROP = ''
    ERR = ''
    PROP.NAME = 'PRINCIPAL'
    CALL REDO.GET.INTEREST.PROPERTY(Y.ID,PROP.NAME,OUT.PROP,ERR)
    Y.INT.PROPERTY = OUT.PROP
    IF Y.INT.PROPERTY EQ '' AND ERR NE '' THEN
        CALL  OCOMO("Not able to find principal interest property - ":Y.ID)
        GOSUB PGM.END         ;* Problem in identifying the principal interest property
    END

    Y.ACCOUNT.PROPERTY = ''
    OUT.ERR = ''
    CALL REDO.GET.PROPERTY.NAME(Y.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR)

    IF Y.ACCOUNT.PROPERTY EQ '' AND OUT.ERR NE '' THEN
        CALL  OCOMO("Not able to find Account property - ":Y.ID)
        GOSUB PGM.END         ;* Problem in identifying the account property
    END

RETURN
*------------------------------------------------------------
GET.OVERDUE.STATUS:
*------------------------------------------------------------
    EFF.DATE = ''
    PROP.CLASS='OVERDUE'
    PROPERTY = ''
    R.CONDITION.OVERDUE = ''
    ERR.MSG = ''; Y.BILL.TYPE = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
    Y.BILL.TYPE = R.CONDITION.OVERDUE<AA.OD.BILL.TYPE>
    LOCATE 'PAYMENT' IN Y.BILL.TYPE<1,1> SETTING YPOSN THEN
        Y.OVERDUE.STATUS = R.CONDITION.OVERDUE<AA.OD.OVERDUE.STATUS,YPOSN>
    END
*  CHANGE VM TO FM IN Y.OVERDUE.STATUS
* 20/09/2016 fixed the issue
    CHANGE @SM TO @FM IN Y.OVERDUE.STATUS
RETURN
*------------------------------------------------------------
GET.OUTSTANDING:
*------------------------------------------------------------
    Y.BALANCE.AMOUNT = 0
    Y.BALANCE.CNT = DCOUNT(BALANCE.TYPE,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.BALANCE.CNT
        BALANCE.TO.CHECK = BALANCE.TYPE<Y.VAR1>:Y.BAL.PROPERTY:Y.SP
        EFFECTIVE.DATE   = TODAY
* Start--Changed on 29/09/2016 for upgrade
        DATE.OPTIONS     = ''
*        DATE.OPTIONS<4>='ECB'
        DATE.OPTIONS<2>  = 'ALL'
* End--Changed on 29/09/2016 for upgrade
        BALANCE.AMOUNT   = ""
        CALL AA.GET.PERIOD.BALANCES(Y.LOAN.AC, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
        Y.BALANCE.AMOUNT += ABS(BAL.DETAILS<4>)
        Y.VAR1 += 1
    REPEAT
    Y.BALANCE.AMOUNT = ABS(Y.BALANCE.AMOUNT)
RETURN
*----------------------------------------------------------------------
PGM.END:
*----------------------------------------------------------------------

END
