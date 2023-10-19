* @ValidationCode : MjotMTc4MzY1MzIyMjpDcDEyNTI6MTY4MjU4MzY4NzYwNzp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Apr 2023 13:51:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.NV.E.AUTHOR(Y.FINAL.ARRAY)
*-----------------------------------------------------
* Description: This is the nofile enquiry to authorise the
* pending transaction in Next Version
* Development - Group 12.
*-----------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ , VM to @VM and ++ to +-=
* 13-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOENQ
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.TRANSACTION.CHAIN



    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------
    FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
    F.REDO.TRANSACTION.CHAIN = ""
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.TELLER = 'F.TELLER$NAU'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    LOC.REF.APPLICATION="TELLER"
    LOC.REF.FIELDS='L.TRAN.AMOUNT'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.TRAN.AMOUNT = LOC.REF.POS<1,1>

RETURN
*-----------------------------------------------------
PROCESS:
*-----------------------------------------------------
    Y.FINAL.ARRAY = ''
    CALL APAP.REDOENQ.RedoEFormSelStmt(FN.REDO.TRANSACTION.CHAIN, '', '', SEL.CMD)	;*R22 Manual Conversion - Added APAP.REDOENQ
    IF D.RANGE.AND.VALUE THEN
        SEL.CMD := " AND TRANS.AUTH EQ 'U' AND TRANS.DATE EQ "
        SEL.CMD := TODAY : " AND BRANCH.CODE EQ " : ID.COMPANY : " BY.DSND TRANS.DATE"
    END ELSE
        SEL.CMD := " WITH TRANS.AUTH EQ 'U' AND TRANS.DATE EQ "
        SEL.CMD := TODAY : " AND BRANCH.CODE EQ " : ID.COMPANY : " BY.DSND TRANS.DATE"
    END
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    IF SEL.LIST THEN
        GOSUB PROCESS.ARRAY
    END
RETURN
*----------------------------------
PROCESS.ARRAY:
*----------------------------------
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE NO.OF.REC
        Y.RTC.ID = SEL.LIST<Y.VAR1>
        CALL F.READ(FN.REDO.TRANSACTION.CHAIN,Y.RTC.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,RTC.ERR)
        IF R.REDO.TRANSACTION.CHAIN THEN
            GOSUB FORM.ARRAY
        END
        Y.VAR1 += 1
    REPEAT
RETURN
*----------------------------------
FORM.ARRAY:
*----------------------------------

    Y.FINAL.TRANS.DESC = ''
    Y.DEBIT.SIDE = ''
    Y.CREDIT.SIDE = ''
    Y.TRANS.ID = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>
    Y.TT.CCY = R.REDO.TRANSACTION.CHAIN<RTC.TRANS.CCY> ;* PACS00245686 - S/E
    Y.ID.CNT = DCOUNT(Y.TRANS.ID,@VM)
    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.ID.CNT
        Y.ID = Y.TRANS.ID<1,Y.VAR2>
        Y.PART.ID = Y.ID[1,2]
        IF Y.PART.ID EQ 'FT' THEN
            CALL F.READ(FN.FUNDS.TRANSFER,Y.ID,R.FT,F.FUNDS.TRANSFER,FT.ERR)
            Y.FTTC = R.FT<FT.TRANSACTION.TYPE>
            CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, Y.FTTC, R.FTTC, FTTC.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
            Y.TRANS.DESC = R.FTTC<FT6.DESCRIPTION,LNGG>
            IF Y.TRANS.DESC ELSE
                Y.TRANS.DESC = R.FTTC<FT6.DESCRIPTION,1>
            END
            Y.DEBIT.SIDE<1,-1> = R.FT<FT.CREDIT.AMOUNT>
            Y.CREDIT.SIDE<1,-1> = 0
        END ELSE
            CALL F.READ(FN.TELLER,Y.ID,R.TT,F.TELLER,TT.ERR)
            Y.TR.CODE = R.TT<TT.TE.TRANSACTION.CODE>
            Y.TRAN.AMOUNT = R.TT<TT.TE.LOCAL.REF,POS.L.TRAN.AMOUNT>
            CALL CACHE.READ(FN.TELLER.TRANSACTION, Y.TR.CODE, R.TELLER.TRANSACTION, TR.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
            Y.TRANS.DESC = R.TELLER.TRANSACTION<TT.TR.DESC,1,LNGG>
            IF Y.TRANS.DESC ELSE
                Y.TRANS.DESC = R.TELLER.TRANSACTION<TT.TR.DESC,1,1>
            END
            IF Y.TRAN.AMOUNT LT 0 THEN
                Y.DEBIT.SIDE<1,-1> = ABS(Y.TRAN.AMOUNT)
                Y.CREDIT.SIDE<1,-1> = 0
            END ELSE

                Y.DEBIT.SIDE<1,-1> = 0
                Y.CREDIT.SIDE<1,-1> = Y.TRAN.AMOUNT
            END


        END

        Y.FINAL.TRANS.DESC<1,-1> = Y.TRANS.DESC
        Y.TRANS.DESC = ''

        Y.VAR2 += 1
    REPEAT

* Y.FINAL.ARRAY<-1> = R.REDO.TRANSACTION.CHAIN<RTC.TELLER.ID>:"*":R.REDO.TRANSACTION.CHAIN<RTC.TRANS.DATE>:"*":Y.RTC.ID:"*":R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>:"*":Y.FINAL.TRANS.DESC:"*":R.REDO.TRANSACTION.CHAIN<RTC.TRANS.VERS>:"*":Y.DEBIT.SIDE:"*":Y.CREDIT.SIDE
    Y.FINAL.ARRAY<-1> = R.REDO.TRANSACTION.CHAIN<RTC.TELLER.ID>:"*":R.REDO.TRANSACTION.CHAIN<RTC.TRANS.DATE>:"*":Y.RTC.ID:"*":R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>:"*":Y.FINAL.TRANS.DESC:"*":R.REDO.TRANSACTION.CHAIN<RTC.TRANS.VERS>:"*":Y.DEBIT.SIDE:"*":Y.CREDIT.SIDE:"*":Y.TT.CCY

RETURN
END
