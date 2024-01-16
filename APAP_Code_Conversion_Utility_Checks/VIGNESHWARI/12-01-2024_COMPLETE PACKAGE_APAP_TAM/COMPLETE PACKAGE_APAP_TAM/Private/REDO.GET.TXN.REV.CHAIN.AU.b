* @ValidationCode : MjotNjk2NzcwNTY5OkNwMTI1MjoxNzA1MDQzODY5MTI4OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jan 2024 12:47:49
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
$PACKAGE APAP.TAM

*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             VM TO @VM, ++ TO +=,F.READ TO CACHE.READ
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           CALL Rtn format modified
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.GET.TXN.REV.CHAIN.AU(Y.FINAL.ARRAY)
*-----------------------------------------------------
* Description: This is the nofile enquiry to authorise the
* pending transaction in Next Version
* Development - Group 12.
*-----------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $USING APAP.REDOENQ
   $USING EB.LocalReferences



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

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    LOC.REF.APPLICATION="TELLER"
    LOC.REF.FIELDS='L.TRAN.AMOUNT'
    LOC.REF.POS=''
*    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
EB.LocalReferences.GetLocRef(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS);* R22 UTILITY AUTO CONVERSION

    POS.L.TRAN.AMOUNT = LOC.REF.POS<1,1>

RETURN
*-----------------------------------------------------
PROCESS:
*-----------------------------------------------------


    Y.FINAL.ARRAY = ''
*   CALL REDO.E.FORM.SEL.STMT(FN.REDO.TRANSACTION.CHAIN, '', '', SEL.CMD)
    APAP.REDOENQ.redoEFormSelStmt(FN.REDO.TRANSACTION.CHAIN, '', '', SEL.CMD) ;*MANUAL R22 CODE CONVERSION
    IF D.RANGE.AND.VALUE THEN
        SEL.CMD := " AND TRANS.AUTH EQ 'IR' AND "
        SEL.CMD := " BRANCH.CODE EQ " : ID.COMPANY : " AND TRANS.DATE EQ ":TODAY:" BY.DSND TRANS.DATE"
    END ELSE
        SEL.CMD := " WITH TRANS.AUTH EQ 'IR' AND "
        SEL.CMD := " BRANCH.CODE EQ " : ID.COMPANY : " AND TRANS.DATE EQ ":TODAY:" BY.DSND TRANS.DATE"
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
        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
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
            CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, Y.FTTC, R.FTTC, FTTC.ERR) ;*AUTO R22 CODE CONVERSION
            Y.TRANS.DESC = R.FTTC<FT6.DESCRIPTION,LNGG>
            IF Y.TRANS.DESC ELSE
                Y.TRANS.DESC = R.FTTC<FT6.DESCRIPTION,1>
            END
            Y.DEBIT.SIDE<1,-1> = R.FT<FT.CREDIT.AMOUNT>
            Y.CREDIT.SIDE<1,-1> = 0
            Y.TRANS.VER<1,-1> = 'FUNDS.TRANSFER,REDO.REV.TXN'
        END ELSE
            CALL F.READ(FN.TELLER,Y.ID,R.TT,F.TELLER,TT.ERR)
            Y.TR.CODE = R.TT<TT.TE.TRANSACTION.CODE>
            Y.TRAN.AMOUNT = R.TT<TT.TE.LOCAL.REF,POS.L.TRAN.AMOUNT>
            CALL CACHE.READ(FN.TELLER.TRANSACTION, Y.TR.CODE, R.TELLER.TRANSACTION, TR.ERR) ;*AUTO R22 CODE CONVERSION
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
            Y.TRANS.VER<1,-1> = 'TELLER,REDO.REV.TXN'

        END

        Y.FINAL.TRANS.DESC<1,-1> = Y.TRANS.DESC
        Y.TRANS.DESC = ''

        Y.VAR2 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

* Y.FINAL.ARRAY<-1> = R.REDO.TRANSACTION.CHAIN<RTC.TELLER.ID>:"*":R.REDO.TRANSACTION.CHAIN<RTC.TRANS.DATE>:"*":Y.RTC.ID:"*":R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>:"*":Y.FINAL.TRANS.DESC:"*":Y.TRANS.VER:"*":Y.DEBIT.SIDE:"*":Y.CREDIT.SIDE
    Y.FINAL.ARRAY<-1> = R.REDO.TRANSACTION.CHAIN<RTC.TELLER.ID>:"*":R.REDO.TRANSACTION.CHAIN<RTC.TRANS.DATE>:"*":Y.RTC.ID:"*":R.REDO.TRANSACTION.CHAIN<RTC.TRANS.ID>:"*":Y.FINAL.TRANS.DESC:"*":Y.TRANS.VER:"*":Y.DEBIT.SIDE:"*":Y.CREDIT.SIDE:"*":Y.TT.CCY

RETURN
END
