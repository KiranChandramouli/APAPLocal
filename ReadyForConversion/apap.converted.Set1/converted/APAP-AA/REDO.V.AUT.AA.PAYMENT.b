SUBROUTINE REDO.V.AUT.AA.PAYMENT
*DESCRIPTION:This AUTH routine will assign NCF for the AA advance payment
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : Y.CUSTOMER.ID
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 26-MAR-2010        Prabhu.N       ODR-2009-10-0321     Initial Creation
* 23-07-2010         Prabhu.N       ODR-2010-01-0081-N.82 Code Added to update NCF number to field L.NCF.NUMBER
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
*
    $INSERT I_F.REDO.L.NCF.UNMAPPED
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_F.REDO.L.NCF.STATUS
    $INSERT I_F.REDO.AA.REPAY
    $INSERT I_F.REDO.L.NCF.STOCK
*

    GOSUB INIT

RETURN
*----
INIT:
*-----
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.BILL.DETAILS='F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS =''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.REDO.L.NCF.ISSUED='F.REDO.NCF.ISSUED'
    F.REDO.NCF.ISSUED=''
    CALL OPF(FN.REDO.L.NCF.ISSUED,F.REDO.L.NCF.ISSUED)

    FN.REDO.L.NCF.STATUS='F.REDO.L.NCF.STATUS'
    F.REDO.L.NCF.STATUS=''
    CALL OPF(FN.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS)

    FN.REDO.L.NCF.UNMAPPED='F.REDO.L.NCF.UNMAPPED'
    F.REDO.L.NCF.UNMAPPED =''
    CALL OPF(FN.REDO.L.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED)

    FN.REDO.L.NCF.STOCK='F.REDO.L.NCF.STOCK'
    F.REDO.L.NCF.STOCK=''
    CALL OPF(FN.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK)

    FN.REDO.AA.REPAY='F.REDO.AA.REPAY'
    F.REDO.AA.REPAY=''
    CALL OPF(FN.REDO.AA.REPAY,F.REDO.AA.REPAY)
    IF V$FUNCTION EQ 'R' OR V$FUNCTION EQ 'D' THEN
        GOSUB DELETION
    END
    ELSE
        GOSUB SELECTION
    END
RETURN
*---------
SELECTION:
*---------

    LREF.APP   = APPLICATION
    LREF.FIELD = 'INTEREST.AMOUNT' : @VM : 'L.NCF.REQUIRED' : @VM : 'L.NCF.NUMBER'
    LREF.POS   = ''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    CHANGE @VM TO @FM IN LREF.POS

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN

        VAR.ACCOUNT.NO=R.NEW(FT.CREDIT.ACCT.NO)
        VAR.AMOUNT=R.NEW(FT.CREDIT.AMOUNT)
        VAR.CUSTOMER=R.NEW(FT.CREDIT.CUSTOMER)
        IF VAR.AMOUNT EQ '' THEN
            VAR.AMOUNT=R.NEW(FT.DEBIT.AMOUNT)
        END
        GOSUB PROCESS
        IF VAR.AA.ID NE '' THEN
            GOSUB FT.ASSIGN
        END
    END
    IF APPLICATION EQ 'TELLER' THEN
        IF R.NEW(TT.TE.DR.CR.MARKER) EQ 'CREDIT' THEN
            VAR.ACCOUNT.NO=R.NEW(TT.TE.ACCOUNT.1)
            VAR.CUSTOMER=R.NEW(TT.TE.CUSTOMER.1)
            IF R.NEW(TT.TE.CURRENCY.1) EQ 'DOP' THEN
                VAR.AMOUNT=R.NEW(TT.TE.AMOUNT.LOCAL.1)
            END
            ELSE
                VAR.AMOUNT=R.NEW(TT.TE.AMOUNT.FCY.1)
            END
        END
        ELSE
            VAR.ACCOUNT.NO=R.NEW(TT.TE.ACCOUNT.2)
            VAR.CUSTOMER=R.NEW(TT.TE.CUSTOMER.2)
            IF R.NEW(TT.TE.CURRENCY.2) EQ 'DOP' THEN
                VAR.AMOUNT=R.NEW(TT.TE.AMOUNT.LOCAL.2)
            END
            ELSE
                VAR.AMOUNT=R.NEW(TT.TE.AMOUNT.FCY.2)
            END
        END
        GOSUB PROCESS
        IF VAR.AA.ID NE '' THEN
            GOSUB TT.ASSIGN
        END
    END
RETURN
*-------
PROCESS:
*-------
    CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    VAR.AA.ID=R.ACCOUNT<AC.ARRANGEMENT.ID>
    IF VAR.AA.ID NE '' THEN
        CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.ERR)
        VAR.SET.STATUS.LIST=R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
        VAR.BILL.ID.ARRAY=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
        CHANGE @VM TO @FM IN VAR.SET.STATUS.LIST
        CHANGE @SM TO @FM IN VAR.SET.STATUS.LIST
        CHANGE @VM TO @FM IN VAR.BILL.ID.ARRAY
        CHANGE @SM TO @FM IN VAR.BILL.ID.ARRAY
        LOOP
            REMOVE VAR.SET.STATUS FROM VAR.SET.STATUS.LIST SETTING POS
            REMOVE VAR.BILL.ID FROM VAR.BILL.ID.ARRAY SETTING BILL.POS
        WHILE VAR.SET.STATUS:POS
            IF   VAR.SET.STATUS EQ 'UNPAID' THEN
                VAR.BILL.LIST<-1>=VAR.BILL.ID
            END
        REPEAT
        IF VAR.BILL.LIST NE '' THEN
            LOOP
                REMOVE VAR.BILL.ID FROM VAR.BILL.LIST SETTING BILL.POS
            WHILE  VAR.BILL.ID:BILL.POS
                GOSUB BILL.PROCESS
            REPEAT
        END
    END
RETURN
*------------
BILL.PROCESS:
*------------

    Y.FOUND = 1
    CALL F.READ(FN.AA.BILL.DETAILS,VAR.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
    VAR.OS.TOT.PROP.AMOUNT=SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
    Y.PROPRTY.ARRAY=R.AA.BILL.DETAILS<AA.BD.PROPERTY>
    Y.OS.PROP.AMT.ARRAY=R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>
    Y.PROPERTY.ARRAY=CHANGE(Y.PROPRTY.ARRAY,@VM,@FM)
    Y.PROPERTY.ARRAY=CHANGE(Y.PROPRTY.ARRAY,@SM,@FM)
    Y.OS.PROP.AMT.ARRAY=CHANGE(Y.OS.PROP.AMT.ARRAY,@VM,@FM)
    Y.OS.PROP.AMT.ARRAY=CHANGE(Y.OS.PROP.AMT.ARRAY,@SM,@FM)
    Y.OS.PROP.AMT.TOT += VAR.OS.TOT.PROP.AMOUNT
    LOOP
        REMOVE Y.PROPERTY FROM Y.PROPERTY.ARRAY SETTING PROP.POS
        REMOVE Y.OS.PROP.AMT  FROM Y.OS.PROP.AMT.ARRAY SETTING OS.POS
    WHILE Y.PROPERTY:PROP.POS AND Y.FOUND
        IF Y.PROPERTY EQ 'PRINCIPALINT' THEN
            Y.OS.PROP.AMT.INT += Y.OS.PROP.AMT
            Y.FOUND = ""
        END
    REPEAT
RETURN
*----------
FT.ASSIGN:
*----------

    IF Y.OS.PROP.AMT.TOT NE '' THEN
        R.NEW(FT.LOCAL.REF)<1,LREF.POS<1>>=Y.OS.PROP.AMT.INT
        R.REDO.AA.REPAY<AA.RP.AMOUNT>=VAR.AMOUNT-Y.OS.PROP.AMT.TOT
        R.REDO.AA.REPAY<AA.RP.DATE.PAYMENT>=TODAY
        R.REDO.AA.REPAY<AA.RP.TXN.ID>=ID.NEW
        GOSUB GET.NCF
        GOSUB ASSIGN.NCF.FT
    END
RETURN
*---------
TT.ASSIGN:
*---------

    IF Y.OS.PROP.AMT.TOT NE '' THEN
        R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS<1>>=Y.OS.PROP.AMT.INT
        R.REDO.AA.REPAY<AA.RP.AMOUNT>=VAR.AMOUNT-Y.OS.PROP.AMT.TOT
        R.REDO.AA.REPAY<AA.RP.DATE.PAYMENT>=TODAY
        R.REDO.AA.REPAY<AA.RP.TXN.ID>=ID.NEW
        GOSUB GET.NCF
        GOSUB ASSIGN.NCF.TT
    END
RETURN
*----------
GET.NCF:
*----------
    CALL F.READU(FN.REDO.L.NCF.STOCK,'SYSTEM',R.NCF.STOCK,F.REDO.L.NCF.STOCK,ST.ERR,'')


    IF R.NCF.STOCK<ST.QTY.AVAIL.ORG> GT '0' THEN
        R.NCF.ISSUED<ST.IS.NCF>=R.NCF.STOCK<ST.SERIES>:R.NCF.STOCK<ST.BUSINESS.DIV>:R.NCF.STOCK<ST.PECF>:R.NCF.STOCK<ST.AICF>:R.NCF.STOCK<ST.TCF>:R.NCF.STOCK<ST.SEQUENCE.NO>
        VAR.PREV.RANGE=R.NCF.STOCK<ST.PRE.ED.RG.OR>
        VAR.PREV.RANGE=VAR.PREV.RANGE<DCOUNT(VAR.PREV.RANGE,@VM)>
        IF R.NCF.STOCK<ST.SEQUENCE.NO> EQ VAR.PREV.RANGE THEN
            R.NCF.STOCK<ST.SEQUENCE.NO>=R.NCF.STOCK<ST.L.STRT.RNGE.ORG>
        END
        ELSE
            R.NCF.STOCK<ST.SEQUENCE.NO>=R.NCF.STOCK<ST.SEQUENCE.NO>+1
        END
        R.NCF.STOCK<ST.SEQUENCE.NO>=FMT(R.NCF.STOCK<ST.SEQUENCE.NO>,'8"0"R')
        R.NCF.STOCK<ST.NCF.ISSUED.ORG>=R.NCF.STOCK<ST.NCF.ISSUED.ORG>+1
        R.NCF.STOCK<ST.QTY.AVAIL.ORG>=R.NCF.STOCK<ST.QTY.AVAIL.ORG>-1
        IF  R.NCF.STOCK<ST.QTY.AVAIL.ORG> GE R.NCF.STOCK<ST.L.MIN.NCF.ORG>  THEN
            R.NCF.STOCK<ST.NCF.STATUS.ORG>='AVAILABLE'
        END
        ELSE
            R.NCF.STOCK<ST.NCF.STATUS.ORG>='UNAVAILABLE'
        END
    END
RETURN
*-------------
ASSIGN.NCF.FT:
*-------------

    R.REDO.AA.REPAY<AA.RP.ACCOUNT>=R.NEW(FT.DEBIT.ACCT.NO)
    R.REDO.AA.REPAY<AA.RP.CUSTOMER>=VAR.CUSTOMER
    R.NCF.ISSUED<ST.IS.TXN.ID>=ID.NEW
    R.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>=Y.OS.PROP.AMT.INT
    R.NCF.ISSUED<ST.IS.ACCOUNT>=R.NEW(FT.DEBIT.ACCT.NO)
    R.NCF.ISSUED<ST.IS.CUSTOMER>=VAR.CUSTOMER
    R.NCF.ISSUED<ST.IS.TXN.TYPE>=R.NEW(FT.TRANSACTION.TYPE)
    R.NCF.ISSUED<ST.IS.DATE>=R.NEW(FT.CREDIT.VALUE.DATE)
    R.NCF.STATUS<NCF.ST.TRANSACTION.ID>=ID.NEW
    R.NCF.STATUS<NCF.ST.CUSTOMER.ID>=R.NEW(FT.DEBIT.CUSTOMER)
    R.NCF.STATUS<NCF.ST.STATUS>='AVAILABLE'
    R.NCF.STATUS<NCF.ST.DATE>  =R.NEW(FT.CREDIT.VALUE.DATE)
    R.NCF.STATUS<NCF.ST.CHARGE.AMOUNT> =Y.OS.PROP.AMT.INT
    R.NCF.UNMAPPED<ST.UN.TXN.TYPE>=R.NEW(FT.TRANSACTION.TYPE)
    R.NCF.UNMAPPED<ST.UN.CHARGE.AMOUNT>=Y.OS.PROP.AMT.INT
    R.NCF.UNMAPPED<ST.UN.TXN.ID>= ID.NEW
    R.NCF.UNMAPPED<ST.UN.DATE>  =R.NEW(FT.CREDIT.VALUE.DATE)
    R.NCF.UNMAPPED<ST.UN.BATCH> ='NO'
    R.NCF.UNMAPPED<ST.UN.ACCOUNT>=R.NEW(FT.DEBIT.ACCT.NO)
    R.NCF.UNMAPPED<ST.UN.CUSTOMER>=VAR.CUSTOMER
    R.NCF.ID=R.NEW(FT.DEBIT.ACCT.NO):'.':R.NEW(FT.CREDIT.VALUE.DATE):'.':ID.NEW
    GOSUB WRITE.NCF
RETURN
*-------------
ASSIGN.NCF.TT:
*-------------
    R.REDO.AA.REPAY<AA.RP.ACCOUNT>=VAR.ACCOUNT.NO
    R.REDO.AA.REPAY<AA.RP.CUSTOMER>=VAR.CUSTOMER
    R.NCF.ISSUED<ST.IS.TXN.ID>=ID.NEW
    R.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>=Y.OS.PROP.AMT.INT
    R.NCF.ISSUED<ST.IS.ACCOUNT>=VAR.ACCOUNT.NO
    R.NCF.ISSUED<ST.IS.CUSTOMER>=VAR.CUSTOMER
    R.NCF.ISSUED<ST.IS.TXN.TYPE>=R.NEW(TT.TE.TRANSACTION.CODE)
    R.NCF.ISSUED<ST.IS.DATE>=R.NEW(TT.TE.VALUE.DATE.1)
    R.NCF.STATUS<NCF.ST.TRANSACTION.ID>=ID.NEW
    R.NCF.STATUS<NCF.ST.CUSTOMER.ID>=VAR.CUSTOMER
    R.NCF.STATUS<NCF.ST.STATUS>='AVAILABLE'
    R.NCF.STATUS<NCF.ST.DATE>  =R.NEW(TT.TE.VALUE.DATE.1)
    R.NCF.STATUS<NCF.ST.CHARGE.AMOUNT> =Y.OS.PROP.AMT.INT
    R.NCF.UNMAPPED<ST.UN.TXN.TYPE>=R.NEW(TT.TE.TRANSACTION.CODE)
    R.NCF.UNMAPPED<ST.UN.CHARGE.AMOUNT>=Y.OS.PROP.AMT.INT
    R.NCF.UNMAPPED<ST.UN.TXN.ID>= ID.NEW
    R.NCF.UNMAPPED<ST.UN.DATE>  =R.NEW(TT.TE.VALUE.DATE.1)
    R.NCF.UNMAPPED<ST.UN.BATCH> ='NO'
    R.NCF.UNMAPPED<ST.UN.ACCOUNT>=VAR.ACCOUNT.NO
    R.NCF.UNMAPPED<ST.UN.CUSTOMER>=VAR.CUSTOMER
    R.NCF.ID=VAR.ACCOUNT.NO:'.':R.NEW(TT.TE.VALUE.DATE.1):'.':ID.NEW
    GOSUB WRITE.NCF
RETURN
*---------
WRITE.NCF:
*---------
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        VAR.NCF.REQUIRED=R.NEW(FT.LOCAL.REF)<1,LREF.POS<2>>
        IF VAR.NCF.REQUIRED NE 'NO' THEN
            R.NEW(FT.LOCAL.REF)<1,LREF.POS<3>>=R.NCF.ISSUED<ST.IS.NCF>
        END
    END
    IF APPLICATION EQ 'TELLER' THEN
        VAR.NCF.REQUIRED=R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS<2>>
        IF VAR.NCF.REQUIRED NE 'NO' THEN
            R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS<3>>=R.NCF.ISSUED<ST.IS.NCF>
        END
    END
    IF R.NCF.STOCK<ST.QTY.AVAIL.ORG>  GT '0' AND VAR.NCF.REQUIRED NE 'NO' THEN
        CALL F.WRITE(FN.REDO.L.NCF.ISSUED,R.NCF.ID,R.NCF.ISSUED)
    END
    ELSE
        CALL F.WRITE(FN.REDO.L.NCF.UNMAPPED,R.NCF.ID,R.NCF.UNMAPPED)
    END
    CALL F.WRITE(FN.REDO.L.NCF.STOCK,'SYSTEM',R.NCF.STOCK)
    CALL F.WRITE(FN.REDO.L.NCF.STATUS,R.NCF.ID,R.NCF.STATUS)
    CALL F.WRITE(FN.REDO.AA.REPAY,VAR.AA.ID,R.REDO.AA.REPAY)
    CALL F.RELEASE(FN.REDO.L.NCF.STOCK,'SYSTEM', F.REDO.L.NCF.STOCK)
RETURN
*----------
DELETION:
*----------
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        VAR.ACCOUNT.NO=R.NEW(FT.CREDIT.ACCT.NO)
    END
    IF APPLICATION EQ 'TELLER' THEN
        IF R.NEW(TT.TE.DR.CR.MARKER) EQ 'CREDIT' THEN
            VAR.ACCOUNT.NO=R.NEW(TT.TE.ACCOUNT.1)
        END
        ELSE
            VAR.ACCOUNT.NO=R.NEW(TT.TE.ACCOUNT.2)
        END
    END
    CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    VAR.AA.ID=R.ACCOUNT<AC.ARRANGEMENT.ID>
    CALL F.DELETE(FN.REDO.AA.REPAY,VAR.AA.ID)
RETURN
END