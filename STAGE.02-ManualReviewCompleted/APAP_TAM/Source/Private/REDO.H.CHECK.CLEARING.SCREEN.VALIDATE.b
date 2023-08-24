* @ValidationCode : MjotMzU3NzczOTg3OkNwMTI1MjoxNjgxMjk1MjE1NjU5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:56:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.H.CHECK.CLEARING.SCREEN.VALIDATE
*----------------------------------------------------------------------------------------------------
* DESCRIPTION :  This routine is a validation routine for REDO.H.CHECK.SCREEN.VALIDATE which updates
*                the TT.DEP.AMOUNT ,Bank code and debit account number from the teller transactions
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU
* PROGRAM NAME : REDO.H.CHECK.CLEARING.SCREEN
*-----------------------------------------------------------------------------------------------------
* Modification History :
* Date             Author             Reference                   Description
* 29-Jun-2010      Naveenkumar N    ODR-2010-02-0290              Added gosub MANDAT validation for updation of TT.DEP.AMOUNT
* 15-Jul-2010      Naveenkumar N    ODR-2010-02-0290              Added gosub to throw error message if No of checks is not equal to check details entered in ccs
* 12.04.2023       Conversion Tool       R22                      Auto Conversion     - FM TO @FM, VM TO @VM, SM TO @SM
* 12.04.2023       Shanmugapriya M       R22                      Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.CHECK.CLEARING.SCREEN
    $INSERT I_F.REDO.H.ROUTING.NUMBER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER

    GOSUB INIT
    GOSUB PROCESS
    GOSUB PROGRAM.END
*****
INIT:
*****
    FN.ROUTING.NUMBER = 'F.REDO.H.ROUTING.NUMBER'
    F.ROUTING.NUMBER = ''
    R.ROUTING.NUMBER = ''
    E.ROUTING.NUMBER = ''
    CALL OPF(FN.ROUTING.NUMBER,F.ROUTING.NUMBER)
*
    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    R.TELLER = ''
    E.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)
*
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    R.FUNDS.TRANSFER = ''
    E.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
*
    FLAG.CNT = ''
    FLAG.VM = ""
    Y.AMT = ""
    Y.CCY = ""
RETURN
********
PROCESS:
*******
    GOSUB GET.MULTI.LOC.REF
    Y.ROUT.NOS = R.NEW(REDO.CHK.ROUTING.NO)
    Y.ROUT.NOS = CHANGE(Y.ROUT.NOS,@VM,@FM)
    Y.ROUT.CNT = DCOUNT(Y.ROUT.NOS,@FM)

    Y.INIT.DEP.REF = R.NEW(REDO.CHK.INIT.DEP.REF)
    Y.INIT.DEP.REF = CHANGE(Y.INIT.DEP.REF,@VM,@FM)
    IF ID.NEW[1,2] EQ 'FT' THEN
        CALL F.READ(FN.FUNDS.TRANSFER,ID.NEW,R.FT.TT,F.FUNDS.TRANSFER,FT.ERR)
        Y.ACC.DR = R.FT.TT<FT.DEBIT.ACCT.NO>
        Y.ACC.CR = R.FT.TT<FT.CREDIT.ACCT.NO>
    END

    IF ID.NEW[1,2] EQ 'TT' THEN
        CALL F.READ(FN.TELLER,ID.NEW,R.FT.TT,F.TELLER,TT.ERR)
        Y.ACC.DR = R.FT.TT<TT.TE.ACCOUNT.1>
        Y.ACC.CR = R.FT.TT<TT.TE.ACCOUNT.2>
    END

    LOOP
        REMOVE Y.ROT.NO FROM Y.ROUT.NOS SETTING POS
    WHILE Y.ROT.NO:POS
        FLAG.CNT += 1
        CALL F.READ(FN.ROUTING.NUMBER,Y.ROT.NO,R.ROUTING.NO,F.ROUTING.NUMBER,ROU.ERR)
        Y.BNK.CODE = R.ROUTING.NO<REDO.ROUT.BANK.CODE>
        R.NEW(REDO.CHK.BANK.CODE)<1,FLAG.CNT> = Y.BNK.CODE

        IF NOT(R.ROUTING.NO) THEN
            AF = REDO.CHK.ROUTING.NO
            AV = FLAG.CNT
            ETEXT = 'EB-INVALID.ROUT.NO'
            CALL STORE.END.ERROR
            GOSUB PROGRAM.END
        END

        Y.CHEQ.NOS = R.NEW(REDO.CHK.CHECK.NO)<1,FLAG.CNT>
        Y.CHEQ.NOS = CHANGE(Y.CHEQ.NOS,@SM,@FM)
        Y.CHEQ.NOS = CHANGE(Y.CHEQ.NOS,@VM,@FM)

        Y.TELLER.ID = Y.INIT.DEP.REF<FLAG.CNT>
        CALL F.READ(FN.TELLER,Y.TELLER.ID,R.TELLER,F.TELLER,TELLER.ERR)

* Validation for Updating Net amount in the field TT.DEP.AMOUNT and NO.OF.CHECKS in CCS table
        IF R.TELLER THEN
            Y.NET.AMT = R.TELLER<TT.TE.NET.AMOUNT>
            R.NEW(REDO.CHK.TT.DEP.AMOUNT)<1,FLAG.CNT> = Y.NET.AMT
*
            Y.CHECK.NUMBERS = R.TELLER<TT.TE.LOCAL.REF,L.TT.NO.OF.CHQ.POS>
            R.NEW(REDO.CHK.NO.OF.CHECKS)<1,FLAG.CNT> = Y.CHECK.NUMBERS
        END
*
        Y.APAP = R.ROUTING.NO<REDO.ROUT.APAP>
        FLAG.CHQ.CNT = 0
        FLAG.VM += 1
        GOSUB CHECK.CHEQUE
    REPEAT
RETURN
************
CHECK.CHEQUE:
*************
    LOOP
        REMOVE Y.CHEQUE.NO FROM Y.CHEQ.NOS SETTING CHEQ.POS
    WHILE Y.CHEQUE.NO:CHEQ.POS
        FLAG.CHQ.CNT += 1
        R.NEW(REDO.CHK.DR.ACCOUNT)<1,FLAG.CNT,FLAG.CHQ.CNT> = Y.ACC.DR
*
        GOSUB MANDAT
        Y.AMT += R.NEW(REDO.CHK.AMOUNT)<1,FLAG.CNT,FLAG.CHQ.CNT>
        Y.CCY = R.NEW(REDO.CHK.CCY)<1,FLAG.CNT,FLAG.CHQ.CNT>
    REPEAT
    GOSUB THRO.OVERRIDE
    GOSUB NO.OF.CHECK
    R.TELLER = ''
RETURN
**************
THRO.OVERRIDE:
**************
* This Gosub is to Throw override where ever the Total Amt is Greater or Lesser than the Teller Amt
    IF R.TELLER THEN
        IF Y.AMT GT R.TELLER<TT.TE.NET.AMOUNT> THEN
            AF = REDO.CHK.AMOUNT
            AV = FLAG.VM
            AS = FLAG.CHQ.CNT
            Y.LOCAL=Y.AMT-R.TELLER<TT.TE.NET.AMOUNT>
            TEXT = 'AMOUNT.GT':@FM:Y.LOCAL:@VM:Y.CCY
            CNT.CURR.NO = DCOUNT(R.NEW(REDO.CHK.OVERRIDE),@VM)
            CALL STORE.OVERRIDE(CNT.CURR.NO+1)
        END
        IF Y.AMT LT R.TELLER<TT.TE.NET.AMOUNT> THEN
            AF = REDO.CHK.AMOUNT
            AV = FLAG.VM
            AS = FLAG.CHQ.CNT
            Y.LOCAL = R.TELLER<TT.TE.NET.AMOUNT>-Y.AMT
            TEXT = 'AMOUNT.LESS':@FM:Y.LOCAL:@VM:Y.CCY
            CNT.CURR.NO = DCOUNT(R.NEW(REDO.CHK.OVERRIDE),@VM)
            CALL STORE.OVERRIDE(CNT.CURR.NO+1)
        END
    END
RETURN
************
NO.OF.CHECK:
************
* This gosub is to throw the override when the No.of.Checks and Check details details  count mismatches
    Y.TELLER.ID = Y.INIT.DEP.REF<FLAG.CNT>
    Y.CHECK.COUNT = R.NEW(REDO.CHK.NO.OF.CHECKS)<1,FLAG.CNT>
    Y.CHECK.DETAIL = R.NEW(REDO.CHK.CHECK.NO)<1,FLAG.CNT>
    Y.CHECH.DETAIL.COUNT = DCOUNT(Y.CHECK.DETAIL,@SM)
    IF Y.CHECK.COUNT NE Y.CHECH.DETAIL.COUNT THEN
        TEXT = "CHECK.NO":@FM:Y.TELLER.ID
        CURR.NO.CHECH = DCOUNT(R.NEW(REDO.CHK.OVERRIDE),@VM)
        CURR.NO.CHECH += 1
        CALL STORE.OVERRIDE(CURR.NO.CHECH)
    END
RETURN
********
MANDAT:
********
*This gosub is to make the Debit account,Credit account, Check Amount and Check Curremcy Fields Mandatory

    IF NOT(R.NEW(REDO.CHK.DR.ACCOUNT)<1,FLAG.CNT,FLAG.CHQ.CNT>) THEN
        AF = REDO.CHK.DR.ACCOUNT
        AV = FLAG.VM
        AS = FLAG.CHQ.CNT
        ETEXT = "EB-INPUT.MANDATORY"
        CALL STORE.END.ERROR
    END
    IF NOT(R.NEW(REDO.CHK.CR.ACCOUNT)<1,FLAG.CNT,FLAG.CHQ.CNT>) THEN
        AF = REDO.CHK.CR.ACCOUNT
        AV = FLAG.VM
        AS = FLAG.CHQ.CNT
        ETEXT = "EB-INPUT.MANDATORY"
        CALL STORE.END.ERROR
    END
    IF NOT(R.NEW(REDO.CHK.AMOUNT)<1,FLAG.CNT,FLAG.CHQ.CNT>) THEN
        AF = REDO.CHK.AMOUNT
        AV = FLAG.VM
        AS = FLAG.CHQ.CNT
        ETEXT = "EB-INPUT.MANDATORY"
        CALL STORE.END.ERROR
    END
    IF NOT(R.NEW(REDO.CHK.CCY)<1,FLAG.CNT,FLAG.CHQ.CNT>) THEN
        AF = REDO.CHK.CCY
        AV = FLAG.VM
        AS = FLAG.CHQ.CNT
        ETEXT = "EB-INPUT.MANDATORY"
        CALL STORE.END.ERROR
    END
RETURN
******************
GET.MULTI.LOC.REF:
******************
    Y.APPLICATION.ID = 'TELLER'
    FIELD.NAME = 'L.TT.NO.OF.CHQ'
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPLICATION.ID,FIELD.NAME,FIELD.POS)
    L.TT.NO.OF.CHQ.POS = FIELD.POS<1,1>
RETURN
************
PROGRAM.END:
************
END
