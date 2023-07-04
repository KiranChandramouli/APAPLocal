* @ValidationCode : MjotMTE0NDczMzMyNDpDcDEyNTI6MTY4MjQxMjMzNDE3ODpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.DISB.BRANCH.POST.FT
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*  This routine is an AUTH routine attached to FUNDS.TRANSFER,INT.BRANCH.TRANSFER
*  post FT for disbursement to Branch Account and to update REDO.AA.DISB.LOAN
*
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*-----------------------------------------------------------------------------
*   Date            who           Reference                          Description
* 04-28-2011       Bharath G         N.45                         INITIAL CREATION
*06-04-2023       Conversion Tool    R22 Auto Code conversion        VM TO @VM, SM TO @SM, I TO I.VAR, J TO J.VAR
*06-04-2023       Samaran T          R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.LOCKING
    $INSERT I_F.REDO.AA.DISB.LOAN
    $INSERT I_F.REDO.AA.DISBURSE.UPDATE
    $INSERT I_F.REDO.BRANCH.INT.ACCT.PARAM

    GOSUB INIT
    GOSUB READ.REDO.AA.DISB.LOAN

RETURN
*-----------------------------------------------------------------------------
******
INIT:
******
* Initialize all the variables

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    R.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    R.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.REDO.AA.DISB.LOAN = 'F.REDO.AA.DISB.LOAN'
    F.REDO.AA.DISB.LOAN  = ''
    R.REDO.AA.DISB.LOAN  = ''
    CALL OPF(FN.REDO.AA.DISB.LOAN,F.REDO.AA.DISB.LOAN)

    FN.LOCKING = 'F.LOCKING'
    F.LOCKING = ''
    R.LOCKING = ''
    CALL OPF(FN.LOCKING,F.LOCKING)

    FN.REDO.AA.DISBURSE.UPDATE = 'F.REDO.AA.DISBURSE.UPDATE'
    F.REDO.AA.DISBURSE.UPDATE = ''
    R.REDO.AA.DISBURSE.UPDATE = ''
    CALL OPF(FN.REDO.AA.DISBURSE.UPDATE,F.REDO.AA.DISBURSE.UPDATE)

    Y.LOCK.ID = 'F.REDO.AA.DISBURSE.UPDATE'

    RETRY = ''

RETURN
*-----------------------------------------------------------------------------
READ.REDO.AA.DISB.LOAN:
*-----------------------------------------------------------------------------
*
    Y.DISB.ID = R.NEW(FT.PAYMENT.DETAILS)<1,1>

    CALL F.READ(FN.REDO.AA.DISB.LOAN,Y.DISB.ID,R.REDO.AA.DISB.LOAN,F.REDO.AA.DISB.LOAN,DISB.LN.ERR)
    IF R.REDO.AA.DISB.LOAN THEN
        Y.AA.ID      = R.REDO.AA.DISB.LOAN<DISB.LN.ARRANGEMENT.ID>
        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
        Y.CURRENCY   = R.REDO.AA.DISB.LOAN<DISB.LN.LOAN.CCY>
        Y.BRANCH.ID  = R.REDO.AA.DISB.LOAN<DISB.LN.DISB.BRANCH.ID>
        Y.DISB.TYPE  = R.REDO.AA.DISB.LOAN<DISB.LN.BR.DISB.TYPE>
        Y.DISB.AMT   = R.REDO.AA.DISB.LOAN<DISB.LN.BR.DISB.AMT>
        Y.BR.DISB.AC = R.REDO.AA.DISB.LOAN<DISB.LN.BR.DISB.AC>
        Y.LN.DIS.AMT = R.REDO.AA.DISB.LOAN<DISB.LN.BR.TOT.AMT>
        Y.LN.DIS.AC  = R.REDO.AA.DISB.LOAN<DISB.LN.MN.BRANCH.AC>
        CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
        Y.TOT.BRANCH = DCOUNT(Y.BRANCH.ID,@VM)
        FOR I.VAR = 1 TO Y.TOT.BRANCH   ;*R22 AUTO CODE CONVERSION
            Z.BRANCH.ID  = Y.BRANCH.ID<1,I.VAR>    ;*R22 AUTO CODE CONVERSION
            Z.DISB.TYPE  = Y.DISB.TYPE<1,I.VAR>   ;*R22 AUTO CODE CONVERSION
            Z.DISB.AMT   = Y.DISB.AMT<1,I.VAR>    ;*R22 AUTO CODE CONVERSION
            Z.BR.DISB.AC = Y.BR.DISB.AC<1,I.VAR>   ;*R22 AUTO CODE CONVERSION

            Y.TOT.DISB.TYPE = DCOUNT(Z.DISB.TYPE,@SM)
            Y.BR.DISB.AMT = 0
            FOR J.VAR = 1 TO Y.TOT.DISB.TYPE   ;*R22 AUTO CODE CONVERSION
                X.DISB.TYPE = Z.DISB.TYPE<1,1,J.VAR>  ;*R22 AUTO CODE CONVERSION
                Y.BR.DISB.AMT = Z.DISB.AMT<1,1,J.VAR>  ;*R22 AUTO CODE CONVERSION
                IF Y.BR.DISB.AMT GT 0 THEN
                    GOSUB UPDATE.FUNDS.TRANSFER.TO.BRANCH
                END
            NEXT J.VAR   ;*R22 AUTO CODE CONVERSION
        NEXT I.VAR   ;*R22 AUTO CODE CONVERSION
        Y.MAIN.BRANCH.ID = R.REDO.AA.DISB.LOAN<DISB.LN.MAIN.BRANCH.ID>
        Y.MN.DISB.TYPE   = R.REDO.AA.DISB.LOAN<DISB.LN.MN.DISB.TYPE>
        Y.MN.DISB.AMT    = R.REDO.AA.DISB.LOAN<DISB.LN.MN.DISB.AMT>
        Y.MN.BRANCH.AC   = R.REDO.AA.DISB.LOAN<DISB.LN.MN.BRANCH.AC>
        Y.MN.TOT.AMT     = R.REDO.AA.DISB.LOAN<DISB.LN.MN.TOT.AMT>

        Y.TOT.DISB.TYPE = DCOUNT(Y.MN.DISB.TYPE,@VM)
        Y.BR.DISB.AMT = 0

        FOR J.VAR = 1 TO Y.TOT.DISB.TYPE  ;*R22 AUTO CODE CONVERSION
            X.DISB.TYPE   = Y.MN.DISB.TYPE<1,J.VAR>     ;*R22 AUTO CODE CONVERSION
            Y.BR.DISB.AMT = Y.MN.DISB.AMT<1,J.VAR>      ;*R22 AUTO CODE CONVERSION
            IF Y.BR.DISB.AMT GT 0 THEN
                GOSUB UPD.REDO.AA.DISBURSE.UPDATE
            END
        NEXT J.VAR  ;*R22 AUTO CODE CONVERSION
    END

    R.REDO.AA.DISB.LOAN<DISB.LN.MN.DISB.REF> = ID.NEW
    CALL F.WRITE(FN.REDO.AA.DISB.LOAN,Y.DISB.ID,R.REDO.AA.DISB.LOAN)

RETURN
*--------------------------------------------------------------------------------
UPD.REDO.AA.DISBURSE.UPDATE:
*--------------------------------------------------------------------------------
*
    GOSUB GET.ID

    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.DISB.REF.ID> = Y.DISB.ID
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.ARR.REF.ID>  = Y.AA.ID
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.BRANCH.ID>   = Y.MAIN.BRANCH.ID
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.INTERNAL.AC> = Y.MN.BRANCH.AC
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.DISB.TYPE>   = X.DISB.TYPE
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.DISB.AMT>    = Y.BR.DISB.AMT
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.CREDIT.ACC>  = ''
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.TRANS.REF>   = ''
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.CHEQUE.TYPE> = ''
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.BENEFICIARY> = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.NARRATIVE>   = ''
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.REMARKS>     = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
    R.REDO.AA.DISBURSE.UPDATE<DISB.UPD.DISB.INDICATOR> = 'NOT.DISB'

    CALL F.WRITE(FN.REDO.AA.DISBURSE.UPDATE,Y.DISB.UPD.ID,R.REDO.AA.DISBURSE.UPDATE)

RETURN
*--------------------------------------------------------------------------------
GET.ID:
*--------------------------------------------------------------------------------
* update the LOCKING Application with the today's date and extract the SEQ.NO
*
    CALL F.READU(FN.LOCKING,Y.LOCK.ID,R.LOCKING,F.LOCKING,LOCK.ERR,RETRY)
    IF R.LOCKING EQ '' THEN
        SEQ.NO = '000001'
        R.LOCKING<EB.LOK.REMARK> = TODAY
        R.LOCKING<EB.LOK.CONTENT> = SEQ.NO
    END
    ELSE
        IF  R.LOCKING<EB.LOK.REMARK> EQ TODAY THEN
            Y.CONTENT = R.LOCKING<EB.LOK.CONTENT>
            SEQ.NO = Y.CONTENT + 1
            R.LOCKING<EB.LOK.CONTENT> = SEQ.NO
        END
        ELSE
            SEQ.NO = '000001'
            R.LOCKING<EB.LOK.REMARK> = TODAY
            R.LOCKING<EB.LOK.CONTENT> = SEQ.NO
        END
    END
    CALL F.WRITE(FN.LOCKING,Y.LOCK.ID,R.LOCKING)
    CALL JULDATE(TODAY,Y.JUL.DATE)
    Y.DISB.UPD.ID = Y.JUL.DATE:FMT(SEQ.NO,"R%6")

RETURN
*-----------------------------------------------------------------------------
UPDATE.FUNDS.TRANSFER.TO.BRANCH:
*-----------------------------------------------------------------------------
*
    IF R.AA.ARRANGEMENT THEN
        R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>     = Y.LN.DIS.AC
        R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>    = Y.CURRENCY
        R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>      = Y.BR.DISB.AMT
        R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>    = Z.BR.DISB.AC
        R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>   = Y.CURRENCY
        R.FUNDS.TRANSFER<FT.PAYMENT.DETAILS,1> = R.NEW(FT.PAYMENT.DETAILS)<1,1>
        R.FUNDS.TRANSFER<FT.PAYMENT.DETAILS,2> = R.REDO.AA.DISB.LOAN<DISB.LN.ARRANGEMENT.ID>
        R.FUNDS.TRANSFER<FT.PAYMENT.DETAILS,3> = Z.BRANCH.ID
        R.FUNDS.TRANSFER<FT.PAYMENT.DETAILS,4> = X.DISB.TYPE
        R.FUNDS.TRANSFER<FT.ORDERING.CUST>     = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>

        GOSUB FORM.FUNDS.TRANSFER.OFS.MSG
    END

RETURN
*--------------------------------------------------------------------------------
FORM.FUNDS.TRANSFER.OFS.MSG:
*--------------------------------------------------------------------------------
*
    APP.NAME = "FUNDS.TRANSFER"
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'FUNDS.TRANSFER,BRANCH.TO.BRANCH'
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = ''
    OFSRECORD = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.FUNDS.TRANSFER,OFSRECORD)
    OFS.SOURCE.ID = 'REDO.LOAN.DISB'
    OFS.MSG.ID = ''
    OPTIONS = ''
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OPTIONS)

RETURN
*--------------------------------------------------------------------------------
END
