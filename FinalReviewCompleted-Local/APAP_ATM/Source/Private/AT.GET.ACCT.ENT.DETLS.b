* @ValidationCode : MjoyMDg2MTkyNTUyOkNwMTI1MjoxNjg0NTAyMzc3ODIxOmFqaXRoOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 18:49:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM , F,READ to CACHE.READ,I to I.VAR, J to J.VAR, CONVERT into CHANGE
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE AT.GET.ACCT.ENT.DETLS(Y.ACCT.NO,NO.OF.TXNS,TXN.DETLS)
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.INTERCO.PARAMETER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CURRENCY
    $INSERT I_F.TRANSACTION
    $INSERT I_AT.ISO.COMMON

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*-------------------------------------------------------------------------------
GET.BRANCH:
*
    CALL GET.ACCT.BRANCH(Y.ACCT.NO,Y.ACCT.BR.MNE,Y.ACCT.COMP.CDE)

RETURN          ;* From Branch

*-------------------------------------------------------------------------------
INITIALISE:
*
* get the branch mnemonic using the account no

    CALL GET.ACCT.BRANCH(Y.ACCT.NO,Y.ACCT.BR.MNE,Y.ACCT.COMP.CDE)
    FN.ACCOUNT = 'F':Y.ACCT.BR.MNE:'.ACCOUNT'

* FN.ACCOUNT = 'F.ACCOUNT'
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)      ;*open after changing com
*
    FN.STMT.ENTRY = 'F':Y.ACCT.BR.MNE:'.STMT.ENTRY'
* FN.STMT.ENTRY = 'F.STMT.ENTRY'
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)          ;*open after changing com
*
    FN.ACCT.STMT.ENTRY = 'F':Y.ACCT.BR.MNE:'.ACCT.STMT.ENTRY'
* FN.ACCT.STMT.ENTRY = 'F.ACCT.STMT.ENTRY'
    CALL OPF(FN.ACCT.STMT.ENTRY,F.ACCT.STMT.ENTRY)          ;*open after changing com
*
    FN.ACCT.ENT.TODAY = 'F':Y.ACCT.BR.MNE:'.ACCT.ENT.TODAY'
* FN.ACCT.ENT.TODAY = 'F.ACCT.ENT.TODAY'
    CALL OPF(FN.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY)  ;*open after changing com
*
    FN.ACCT.STMT.PRINT = 'F':Y.ACCT.BR.MNE:'.ACCT.STMT.PRINT'
    CALL OPF(FN.ACCT.STMT.PRINT,F.ACCT.STMT.PRINT)
*
    FN.STMT.PRINTED = 'F':Y.ACCT.BR.MNE:'.STMT.PRINTED'
    FN.STMT.PRINTED = 'F.STMT.PRINTED'
    CALL OPF(FN.STMT.PRINTED,F.STMT.PRINTED)      ;*open after changing

    FN.FT.TRANS = 'F':Y.ACCT.BR.MNE:'.FUNDS.TRANSFER'
    F.FT.TRANS = ''
    CALL OPF(FN.FT.TRANS,F.FT.TRANS)

    FN.FT.TRANS.HIS = 'F':Y.ACCT.BR.MNE:'.FUNDS.TRANSFER$HIS'
    F.FT.TRANS.HIS = ''
    CALL OPF(FN.FT.TRANS.HIS,F.FT.TRANS.HIS)

*    FN.TRANSACTION = 'F':Y.ACCT.BR.MNE:'.TRANSACTION'
    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION, F.TRANSACTION)

    FN.FUNDS.TRANSFER = 'F':Y.ACCT.BR.MNE:'.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)

RETURN          ;*initialise

*-------------------------------------------------------------------------------
PROCESS:
*

    IF NO.OF.TXNS THEN
        REQ.NO.OF.STMTS = NO.OF.TXNS

    END

    GOSUB GET.STMT.IDS
    GOSUB READ.STMT.ENTRIES

RETURN          ;*From Process

*---------------------------------------------------------------------------------------------*
GET.STMT.IDS:
*
*Changed by anitha for r6 release


    Y.SEL.STMT.PRINTED = 'SELECT ':FN.STMT.PRINTED:' BY.DSND @ID AND WITH @ID LIKE ':Y.ACCT.NO:'...'
    CALL EB.READLIST(Y.SEL.STMT.PRINTED,Y.SELECTED.PRINTED,'',Y.NO.OF.RECS,Y.SEL.PRINTED.ER)
    IF Y.SELECTED.PRINTED THEN
        I.VAR=0 ;*R22 AUTO CODE CONVERSION
        LOOP
            REMOVE Y.STMT.PRINTED.ID FROM Y.SELECTED.PRINTED SETTING T.POS
        WHILE T.POS:Y.STMT.PRINTED.ID AND I.VAR < REQ.NO.OF.STMTS


            Y.STMT.ID<-1>=Y.STMT.PRINTED.ID
            I.VAR+=1
        REPEAT
    END

    I.VAR=DCOUNT(Y.STMT.ID,@FM)

    FOR I1= 1 TO I.VAR
        LOOP
            I.VAR=0 ;*R22 AUTO CODE CONVERSION
            REMOVE Y.STMT.ID1 FROM Y.STMT.ID SETTING POSI1
        WHILE POSI1:Y.STMT.ID1 AND I.VAR < REQ.NO.OF.STMTS
            CALL F.READ(FN.STMT.PRINTED,Y.STMT.ID1,Y.STMT.PRINT.REC,F.STMT.PRINTED,Y.ERR)
            J.VAR = DCOUNT(Y.STMT.PRINT.REC,@FM)
            LOOP
            WHILE J.VAR GT '0' ;*R22 AUTO CODE CONVERSION
*AND I < REQ.NO.OF.STMTS      //commented by Divya for issue HD0805217
                Y.STMT.ID.LIST<-1> = Y.STMT.PRINT.REC<J.VAR>    ;*with in each record of STMT.PRINTED
                J.VAR-= 1
*Added by Divya for issue HD0805217

                I.VAR+=1 ;*R22 AUTO CODE CONVERSION
            REPEAT
        REPEAT
    NEXT I1

    IF  I.VAR GT REQ.NO.OF.STMTS THEN
        I.VAR = REQ.NO.OF.STMTS
    END

RETURN          ;*From get.stmt.ids

*-------------------------------------------------------------------------------
READ.STMT.ENTRIES:
*

* Read the STMT.ENTRY records using the id from ACCT.ENT.TODAY file
    J.VAR = DCOUNT (Y.STMT.ID.LIST,@FM)
    IF J.VAR GT REQ.NO.OF.STMTS THEN        ;*21/01/03
        J.VAR = REQ.NO.OF.STMTS
    END
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCT,F.ACCOUNT,AC.ER)
    LOOP

    WHILE J.VAR GT 0
        STMT.ENT.ID = Y.STMT.ID.LIST<J.VAR>
        CALL F.READ(FN.STMT.ENTRY,STMT.ENT.ID,Y.STMT.REC,F.STMT.ENTRY,Y.ERR.STMT.ENTRY)
        COM.CODE = Y.STMT.REC<AC.STE.COMPANY.CODE>
        COM.CODE=COM.CODE[7,3]
        COM.CODE=FMT(COM.CODE,'R%4')    ;*anitha
        Y.TXN.CODE=Y.STMT.REC<AC.STE.TRANSACTION.CODE>
*        TRANS.CODE=FMT(TRANS.CODE,'R%3')
* HD1028833 by Rajesh - Start
        TXN.CODE.LIT=''
        BEGIN CASE
            CASE Y.TXN.CODE EQ '971'
                TXN.CODE.LIT="AC"
            CASE Y.TXN.CODE EQ '972'
                TXN.CODE.LIT="ACAT"
            CASE Y.TXN.CODE EQ '973'
                TXN.CODE.LIT="ACAW"
            CASE Y.TXN.CODE EQ '974'
                TXN.CODE.LIT="ACPS"
        END CASE
        TXN.CODE.LIT=FMT(TXN.CODE.LIT,'R#8')

* HD1028833 by Rajesh - End


        CCY.CDE=Y.STMT.REC<AC.STE.CURRENCY>
        CALL F.READ(FN.CURRENCY,CCY.CDE,R.CCY,F.CURRENCY,ER.CCY)
        NUM.CCY = R.CCY<EB.CUR.NUMERIC.CCY.CODE>
        NUM.CCY = FMT(NUM.CCY,'R%3')

        IF R.ACCT<AC.CURRENCY> EQ LCCY THEN
            Y.TXN.AMT = Y.STMT.REC<AC.STE.AMOUNT.LCY>
        END ELSE
            Y.TXN.AMT = Y.STMT.REC<AC.STE.AMOUNT.FCY>
        END

        OUR.REF = Y.STMT.REC<AC.STE.OUR.REFERENCE>
        CALL F.READ(FN.FUNDS.TRANSFER,OUR.REF,R.FT,F.FUNDS.TRANSFER,ER.FT)
        FT.TXN.TYPE = R.FT<FT.TRANSACTION.TYPE>
        FT.TXN.TYPE=FMT(FT.TXN.TYPE,"L#8")

        Y.TXN.AMT1=FIELD(Y.TXN.AMT,'.',1)
        Y.TXN.AMT2=FIELD(Y.TXN.AMT,'.',2)
        Y.TXN.AMT=Y.TXN.AMT1:Y.TXN.AMT2
        Y.TXN.AMT = FMT(Y.TXN.AMT,'R%12')
        IF INDEX(Y.TXN.AMT,'-',1) THEN
            Y.TXN.AMT = FIELD(Y.TXN.AMT,'-',2)
            Y.TXN.AMT=FMT(Y.TXN.AMT,'R%12')
            Y.SYMBL='-'
            Y.DESC = 'Cashes withdraw from ATM'
            Y.SIG ='D'
        END ELSE
            Y.SYMBL='+'
            Y.DESC = 'SALARY'
            Y.SIG ='C'
        END
        Y.DESC = FMT(Y.DESC,"L#40")
        Y.DT.TXN = Y.STMT.REC<AC.STE.BOOKING.DATE>
        Y.DT.TXN.LEN=LEN(Y.DT.TXN)
*        Y.DT.TXN=Y.DT.TXN[7,2]:Y.DT.TXN[5,2]:Y.DT.TXN[1,4]
        TXN.STAN=AT$INCOMING.ISO.REQ(11)

        TRANSACTION.REC = ''
        TRAN.READ.ERR = ''
        CALL CACHE.READ(FN.TRANSACTION, Y.TXN.CODE, TRANSACTION.REC, TRAN.READ.ERR) ;*R22 AUTO CODE CONVERSION
*        ONE.LINE = COM.CODE:TRANS.CODE:Y.DT.TXN:NUM.CCY:Y.SYMBL:Y.TXN.AMT:Y.SIG
*        ONE.LINE = NO.OF.TXNS:COM.CODE:TRANS.CODE:Y.SYMBL:Y.TXN.AMT:Y.SIG:Y.DT.TXN:TXN.STAN
        ONE.LINE = Y.DT.TXN:TXN.CODE.LIT:NUM.CCY:Y.DESC:Y.SIG:Y.TXN.AMT
        STMT.TXT<-1> = ONE.LINE

        J.VAR-=1 ; ;*R22 AUTO CODE CONVERSION
    REPEAT

    TXN.DETLS = LOWER(STMT.TXT)
    NO.OF.TXNS = FMT(DCOUNT(TXN.DETLS,@VM),"R%2")

    CHANGE @VM TO '' IN TXN.DETLS ;*R22 AUTO CODE CONVERSION
*    TXN.DETLS = TXN.DETLS:" "
    TXN.DETLS = TXN.DETLS

RETURN          ;*From READ.STMT.ENTRIES
*-------------------------------------------------------------------------------
