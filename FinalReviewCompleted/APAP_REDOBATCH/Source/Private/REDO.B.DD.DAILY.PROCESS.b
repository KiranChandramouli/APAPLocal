<<<<<<< Updated upstream
* @ValidationCode : MjotNTM4OTI5MDcyOkNwMTI1MjoxNjkwMjY0MzY2MjY0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:22:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
* @ValidationCode : MjotMTQ0Njc4Mjc5ODpDcDEyNTI6MTY4NDg1NDM4NTAwODpJVFNTOi0xOi0xOjgzODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 838
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.DD.DAILY.PROCESS(ID)
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.DD.DAILY.PROCESS
* Primary Purpose : Batch routine selects AA.ACCOUNT.DETAILS having SET.STATUS as 'UNPAID'
*                   and for each AA.ACCOUNT.DETAILS, read the linked account through
*                   AA.ARRANGEMENT Calculate the Total Repayment Amount and FT transaction
*                   is done for the same amount through OFS message
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* JEEVA T              31-10-2011         B.9-DIRECT DEBIT
<<<<<<< Updated upstream
* Date                   who                   Reference
=======
* Date                   who                   Reference              
>>>>>>> Stashed changes
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND SM TO @SM AND VM TO @VM AND VAR1 - VAR2 TO -= VAR2
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_REDO.B.DD.DAILY.PROCESS.COMMON
    $INSERT I_F.REDO.W.DIRECT.DEBIT
<<<<<<< Updated upstream
    $USING APAP.AA
=======

>>>>>>> Stashed changes
    ARR.ID = ID
    Y.BILL.GEN.FLAG = ''
    Y.ERROR.MSG = ''
    Y.BILL.LIST.ID = ''
    Y.AMOUNT.LIST.AMT = ''
    CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,Y.ERR.ARR)
    Y.CURRENCY    = R.ARRANGEMENT<AA.ARR.CURRENCY>
    Y.CREDIT.ACCT = R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    Y.STATUS.AA   = R.ARRANGEMENT<AA.ARR.ARR.STATUS>

    IF Y.STATUS.AA EQ 'UNAUTH' OR Y.STATUS.AA EQ 'AUTH' ELSE
        GOSUB PROCESS
        IF Y.ERROR.MSG THEN
            CHANGE @FM TO @SM IN Y.ERROR.MSG
            CHANGE @FM TO @SM IN Y.AMOUNT.LIST.AMT
            CHANGE @FM TO @SM IN Y.BILL.LIST.ID
            Y.REJ.ID = TODAY:'-':ARR.ID
            CALL F.READ(FN.REDO.W.DIRECT.DEBIT,Y.REJ.ID,R.REDO.W.DIRECT.DEBIT.REJ,F.REDO.W.DIRECT.DEBIT,Y.ER.RJ)
*R.REDO.W.DIRECT.DEBIT.REJ<REDO.AA.DD.DEBIT.AC.ID> = Y.DEBIT.ACCT
*R.REDO.W.DIRECT.DEBIT.REJ<REDO.AA.DD.BILL.AMT.ARR.ID,-1> = Y.AMOUNT.LIST.AMT
*R.REDO.W.DIRECT.DEBIT.REJ<REDO.AA.DD.BILL.ID,-1> = Y.BILL.LIST.ID
*R.REDO.W.DIRECT.DEBIT.REJ<REDO.AA.DD.REASON,-1> = Y.ERROR.MSG
            CALL F.WRITE(FN.REDO.W.DIRECT.DEBIT,Y.REJ.ID,R.REDO.W.DIRECT.DEBIT.REJ)
        END
    END
RETURN

********
PROCESS:
********

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,F.ERR.ACC)

    Y.BILL.LIST    = R.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.BILL.TYPE    = R.ACCOUNT.DETAILS<AA.AD.BILL.TYPE>
    Y.BILL.STATUS  = R.ACCOUNT.DETAILS<AA.AD.SET.STATUS>

    CHANGE @SM TO @FM IN  Y.BILL.LIST
    CHANGE @SM TO @FM IN  Y.BILL.TYPE
    CHANGE @SM TO @FM IN  Y.BILL.STATUS

    CHANGE @VM TO @FM IN  Y.BILL.LIST
    CHANGE @VM TO @FM IN  Y.BILL.TYPE
    CHANGE @VM TO @FM IN  Y.BILL.STATUS
    LOCATE 'UNPAID' IN Y.BILL.STATUS SETTING POS ELSE
*        LOCATE ARR.ID IN R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.ARR.ID,1> SETTING POS THEN
*            DEL R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.ARR.ID,POS>
        Y.DEL.ID = 'DEL-':ARR.ID
        R.REDO.W.DIRECT.DEBIT.BK<REDO.AA.DD.ARR.ID,-1> = ARR.ID
        CALL F.WRITE(FN.REDO.W.DIRECT.DEBIT,Y.DEL.ID,R.REDO.W.DIRECT.DEBIT.BK)
        RETURN
*       END
    END
    GOSUB ACCOUNT.CHECK

    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE DCOUNT(Y.BILL.LIST,@FM)
        IF Y.BILL.STATUS<Y.CNT> EQ 'UNPAID' AND Y.BILL.TYPE<Y.CNT> EQ 'PAYMENT' THEN
            Y.BILL.ID = Y.BILL.LIST<Y.CNT>
            GOSUB FT.PROCESS
        END
        Y.CNT += 1
    REPEAT

RETURN

*----------------------
ACCOUNT.CHECK:
*----------------------
    GOSUB DEBIT.ACCOUNT.CK
    CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACCT,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
    Y.TRANSIT.AMOUNT = R.ACCOUNT<AC.LOCAL.REF,POS.TRANS.AMT>
    Y.STATUS.LIST =  R.ACCOUNT<AC.LOCAL.REF,POS.STATUS.2>
    CHANGE @VM TO @FM IN Y.STATUS.LIST
    CHANGE @SM TO @FM IN Y.STATUS.LIST
    Y.AC.STAUS.FLAG = ''
    Y.DEC.MSG = ''
    LOCATE 'DECEASED' IN Y.STATUS.LIST SETTING POS THEN
        Y.AC.STAUS.FLAG = '1'
        Y.DEC.MSG = 'Debit Account is in Deceased Status'
        LOCATE Y.DEC.MSG IN Y.ERROR.MSG SETTING POS.MS ELSE
            Y.ERROR.MSG<-1> = Y.DEC.MSG
        END
    END ELSE
        Y.ACTUAL.AMOUNT = R.ACCOUNT<AC.LOCAL.REF,POS.AVL.BAL> + Y.TRANSIT.AMOUNT
    END

RETURN
*----------------------
GET.TAX.AMT:
*----------------------

    CALL F.READ(FN.FTTC,'ACPY',R.FTTC,F.FTTC,Y.ERR)
    Y.TAX = R.FTTC<FT6.COMM.TYPES>
    LOOP
        REMOVE Y.TAX.ID FROM Y.TAX SETTING POS.TAX
    WHILE Y.TAX.ID:POS.TAX
        CALL F.READ(FN.FT.COMMISSION.TYPE,Y.TAX.ID,R.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE,Y.ERR.FC)
        Y.PERCT = R.FT.COMMISSION.TYPE<FT4.PERCENTAGE>
        Y.TAX.AMOUNT = Y.PERCT<1,1,1>/100
        Y.TOT.AMOUNT = Y.TOT.AMOUNT * Y.TAX.AMOUNT
        Y.TOT.AMOUNT += Y.TOT.AMT   ;*R22 AUTO CONVERSTION VAR1 - VAR2 TO -= VAR2
        CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.TOT.AMOUNT,"","")
    REPEAT
RETURN
*----------------------
FT.PROCESS:
*----------------------
* Get the Account Details of the Arrangement

    Y.TOT.AMT = 0
    LS.LC.FLAG = ''
    GOSUB CREDIT.ACCOUNT.CK
    CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,Y.ERR.BILL)
    Y.TOT.BILL.AMT = SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
    Y.TOT.AMT = SUM(Y.TOT.BILL.AMT)
    Y.TOT.AMOUNT = Y.TOT.AMT
    GOSUB GET.TAX.AMT
    Y.BILL.LIST.ID<-1> = Y.BILL.ID
    Y.AMOUNT.LIST.AMT<-1> = Y.TOT.AMT
    IF Y.TOT.AMOUNT AND Y.TOT.AMOUNT LE Y.ACTUAL.AMOUNT THEN
        Y.ACTUAL.AMOUNT -= Y.TOT.AMOUNT   ;*R22 AUTO CONVERSTION VAR1 - VAR2 TO -= VAR2
    END ELSE
        LS.LC.FLAG = '1'
        Y.AMT.FLG = '1'
        Y.FUND.MSG = 'Insufficient Fund in Debit Account'
    END
    IF NOT(Y.DEC.MSG) AND Y.FUND.MSG THEN
        LOCATE Y.FUND.MSG IN Y.ERROR.MSG SETTING POS ELSE
            Y.ERROR.MSG<-1> = Y.FUND.MSG
        END
    END

    IF NOT(LS.LC.FLAG) AND Y.STATUS.DD EQ 'Direct Debit' THEN
        IF NOT(LS.LC.FLAG.WR) THEN
            GOSUB EXECUTE.FT
        END
    END
RETURN
*----------
EXECUTE.FT:
*----------
*-----------------------------------------------------------
* This section creates FT using OFS
*-----------------------------------------------------------

    FT.ID = ''
    VAR.GTSMODE = ''
    R.FUNDS.TRANSFER = ''
    R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE> =  'ACPY'
    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>    =  Y.DEBIT.ACCT
    R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>  =  Y.CURRENCY
    R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>    =  Y.TOT.AMT
    R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE> =  TODAY
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>   =  Y.CREDIT.ACCT

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,VAR.GTSMODE,NO.OF.AUTH,FT.ID,R.FUNDS.TRANSFER,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN
*----------------------
CREDIT.ACCOUNT.CK:
*----------------------
    LS.LC.FLAG = ''
    LS.LC.FLAG.WR = ''
    PROP.CLASS = 'OVERDUE'
    PROPERTY = ''
    R.Condition = ''
    ERR.MSG = ''
    EFF.DATE = ''
<<<<<<< Updated upstream
*    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG) ;* R22 Manual Code Conversion
=======
    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
>>>>>>> Stashed changes
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>

    IF LOAN.STATUS EQ '' AND LOAN.COND EQ '' THEN
        RETURN
    END

    CHANGE @SM TO @VM IN LOAN.STATUS
    CHANGE @SM TO @VM IN LOAN.COND
    IF ('JudicialCollection' MATCHES LOAN.STATUS) OR ('Write-off' MATCHES LOAN.STATUS) OR ('Legal' MATCHES LOAN.COND) THEN
        LS.LC.FLAG = 1
        LS.LC.FLAG.WR = 1
    END

    IF ('JudicialCollection' MATCHES LOAN.STATUS) THEN
        Y.JUD.MSG = 'Loan Account has Judicial Collection Status'
    END
    IF ('Write-off' MATCHES LOAN.STATUS) THEN
        Y.WRITE.MSG = 'Loan Account has Write-off Status'
    END
    IF ('Legal' MATCHES LOAN.COND) THEN
        Y.LEGAL.MSG = 'Loan Account has Legal Condition'
    END
    IF Y.JUD.MSG THEN
        LOCATE Y.JUD.MSG IN Y.ERROR.MSG SETTING POS.J ELSE
            Y.ERROR.MSG<-1> = Y.JUD.MSG
        END
    END
    IF Y.WRITE.MSG THEN
        LOCATE Y.WRITE.MSG IN Y.ERROR.MSG SETTING POS.J ELSE
            Y.ERROR.MSG<-1> = Y.WRITE.MSG
        END
    END
    IF Y.LEGAL.MSG THEN
        LOCATE Y.LEGAL.MSG IN Y.ERROR.MSG SETTING POS.J ELSE
            Y.ERROR.MSG<-1> = Y.LEGAL.MSG
        END
    END

RETURN
*----------------------
DEBIT.ACCOUNT.CK:
*----------------------
    Y.STATUS.DD = ''
    Y.ARRG.ID = ARR.ID
    PROPERTY.CLASS = 'PAYMENT.SCHEDULE'
    PROPERTY = ''
    EFF.DATE = ''
    ERR.MSG = ''
    R.INT.ARR.COND = ''
<<<<<<< Updated upstream
*    CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PAY.ARR.COND,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PAY.ARR.COND,ERR.MSG) ;*R22 Manual Code Conversion
=======
    CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PAY.ARR.COND,ERR.MSG)

>>>>>>> Stashed changes
    IF R.PAY.ARR.COND NE '' THEN
        Y.DEBIT.ACCT = R.PAY.ARR.COND<AA.PS.LOCAL.REF><1,DEBIT.ACCT.POS>
        Y.STATUS.DD  = R.PAY.ARR.COND<AA.PS.LOCAL.REF><1,PAYMT.METHOD.POS>
    END

RETURN
END
