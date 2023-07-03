* @ValidationCode : MjotMTc4NTc1ODg2NTpVVEYtODoxNjg4MzY3NDIyODg2OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Jul 2023 12:27:02
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-55</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.INP.INTRANSIT.CHECK
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.INP.INTRANSIT.CHECK
*--------------------------------------------------------------------------------------------------------
*Description  : To check the balances and generate an override message
*Linked With  : VERSION.CONTROL of TT, FT,T24.FUNDS.SERVICE , DATA.CAPTURE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 23 Nov 2010    Mohammed Anies K      ODR-2010-09-0251       Initial Creation
* 15 JUL 2013    Arundev KR            PACS00305227           OVERRIDE message in FT for insufficient balance even though ACCOUNT has sufficient balance
* 02 Sep 2015    Vignesh Kumaar R      PACS00460448           Override for Transit/Blocked funds getting raised even with sufficient funds in account
*03-07-2023      Narmadha V            Manual R22 Conversion  Commented insert file, FM to @FM , VM to @VM
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DATA.CAPTURE
    $INSERT I_F.LIMIT
    $INSERT I_F.AC.LOCKED.EVENTS
*
*$INSERT I_F.T24.FUND.SERVICES ; * Manual R22 Conversion
*
    $INSERT I_REDO.TELLER.COMMON
    $INSERT I_F.REDO.INTRANSIT.LOCK
*
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    Y.LOCKED.AMOUNT = 0
    Y.DEBIT.AMOUNT = 0
    Y.WORKING.BALANCE = 0
    Y.ONLINE.ACTUAL.BAL = 0
    Y.ONLINE.CLEARED.BAL = 0
    Y.AC.TRANSIT.LIM = 0
    Y.LIMIT.AVAIL.AMT = 0
    Y.TRANSIT.USAGE = 0
    Y.LIMIT.AVAIL.AMT = 0
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

    FN.REDO.TRANSIT.LOCK = 'F.REDO.INTRANSIT.LOCK'
    F.REDO.TRANSIT.LOCK = ''
    CALL OPF(FN.REDO.TRANSIT.LOCK,F.REDO.TRANSIT.LOCK)

    FN.ALE = 'F.AC.LOCKED.EVENTS'
    F.ALE = ''
    CALL OPF(FN.ALE,F.ALE)

    TEMP.UTIL.AMT = ''
    R.ACCOUNT = ''
    ACCOUNT.ERR = ''
    Y.LOCKED.AMOUNT = ''
    GET.TRANSIT.LIM = ''
    TRANS.PLUS.DB.AMT = ''
    Y.REMAIN.LIMIT = ''
    Y.REMAIN.LIMIT = ''
    GET.AVAIL.LIM = ''

    GOSUB GET.LOCAL.REF.FIELDS

RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************


    BEGIN CASE

        CASE APPLICATION EQ 'FUNDS.TRANSFER'

            Y.DEBIT.ACCT = R.NEW(FT.DEBIT.ACCT.NO)
            Y.DEBIT.AMOUNT = R.NEW(FT.DEBIT.AMOUNT)
            CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),@VM)


        CASE APPLICATION EQ 'TELLER'

            CURR.NO = DCOUNT(R.NEW(TT.TE.CURR.NO),@VM)

            IF R.NEW(TT.TE.DR.CR.MARKER) EQ 'CREDIT' THEN
                Y.DEBIT.ACCT = R.NEW(TT.TE.ACCOUNT.2)
                IF R.NEW(TT.TE.CURRENCY.2) NE LCCY THEN
                    Y.DEBIT.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.1)<1,1>
                END ELSE
                    Y.DEBIT.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1>
                END
            END ELSE
                Y.DEBIT.ACCT = R.NEW(TT.TE.ACCOUNT.1)

                IF R.NEW(TT.TE.CURRENCY.1) NE LCCY THEN
                    Y.DEBIT.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.1)<1,1>
                END ELSE
                    Y.DEBIT.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1>
                END
            END

        CASE APPLICATION EQ 'DATA.CAPTURE'
            CURR.NO = DCOUNT(R.NEW(DC.DC.CURR.NO),@VM)

            IF R.NEW(DC.DC.SIGN) EQ 'D' THEN
                Y.DEBIT.ACCT = R.NEW(DC.DC.ACCOUNT.NUMBER)
                Y.DEBIT.AMOUNT = R.NEW(DC.DC.AMOUNT.FCY)
            END

    END CASE

    CALL F.READ(FN.REDO.TRANSIT.LOCK,Y.DEBIT.ACCT,R.REDO.TRANSIT.LOCK,F.REDO.TRANSIT.LOCK,ERR)
    IF R.REDO.TRANSIT.LOCK THEN
        TOTO.ALE.CNTR = DCOUNT(R.REDO.TRANSIT.LOCK,@FM)
    END

    LOOP.CNTR = 1
    LOOP
    WHILE LOOP.CNTR LE TOTO.ALE.CNTR
        ALE.ID = R.REDO.TRANSIT.LOCK<LOOP.CNTR>
        CALL F.READ(FN.ALE,ALE.ID,R.ALE,F.ALE,ALE.ERR)
        IF R.ALE THEN
            FROM.DATE = R.ALE<AC.LCK.FROM.DATE>
            IF FROM.DATE LE TODAY THEN
                Y.LOCKED.AMOUNT += R.ALE<AC.LCK.LOCKED.AMOUNT>
            END
        END
        LOOP.CNTR += 1

    REPEAT

    IF Y.LOCKED.AMOUNT THEN
        GOSUB FETCH.REQ.DETAILS
    END

RETURN
*---------------------------------------------
FETCH.REQ.DETAILS:

    CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACCT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    IF R.ACCOUNT THEN
        GET.TRANSIT.LIM = R.ACCOUNT<AC.LOCAL.REF><1,LOC.L.AC.TRANSIT.LIM>
        INTRANSIT.FUND = R.ACCOUNT<AC.LOCAL.REF,TRAN.AVAIL.POS>
        LOC.EXP.DATE = R.ACCOUNT<AC.LOCAL.REF><1,LOC.L.AC.EXP.DATE>
        L.AC.AV.BAL = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS>         ;*PACS00305227 - L.AC.AV.BAL should not be null
    END

    IF LOC.EXP.DATE GE TODAY THEN
        IF INTRANSIT.FUND GT GET.TRANSIT.LIM THEN
            Y.AC.TRANSIT.LIM = GET.TRANSIT.LIM
        END ELSE
            Y.AC.TRANSIT.LIM = INTRANSIT.FUND
        END
    END

    R.LIMIT = ''

    Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    Y.LIMIT.REF = R.ACCOUNT<AC.LIMIT.REF>
    IF Y.LIMIT.REF THEN
        Y.LIMIT.FIRST.PART = FIELD(Y.LIMIT.REF,'.',1,1)
        Y.LIMIT.SECOND.PART = FIELD(Y.LIMIT.REF,'.',2,1)
        Y.LIMIT.FIRST.PART = FMT(Y.LIMIT.FIRST.PART,'7"0"R')
        Y.LIMIT.REF.ID = Y.CUSTOMER:'.':Y.LIMIT.FIRST.PART:'.':Y.LIMIT.SECOND.PART
        CALL F.READ(FN.LIMIT,Y.LIMIT.REF.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)
        IF R.LIMIT THEN
            Y.LIMIT.AVAIL.AMT = R.LIMIT<LI.AVAIL.AMT,1>
        END
    END

* Fix for PACS00460448 [Override for Transit/Blocked funds getting raised even with sufficient funds in account]

    OVER.RAISE.1 = L.AC.AV.BAL + Y.AC.TRANSIT.LIM + Y.DEBIT.AMOUNT
    OVER.RAISE.2 = L.AC.AV.BAL + Y.LOCKED.AMOUNT + Y.LIMIT.AVAIL.AMT + Y.DEBIT.AMOUNT

* End of Fix

    IF Y.DEBIT.AMOUNT GT OVER.RAISE.1 THEN
*** Code review
*       CURR.NO = DCOUNT(CURR.NO,0) + 1
        CURR.NO = CURR.NO + 1
        TEXT = "NO.ENOUGH.LIMIT":@FM:Y.DEBIT.ACCT
        CALL STORE.OVERRIDE(CURR.NO)

    END

    IF Y.DEBIT.AMOUNT GT OVER.RAISE.2 THEN
        CURR.NO = CURR.NO + 1
        TEXT='NO.CREDIT.LIMIT':@FM:Y.DEBIT.ACCT
        CALL STORE.OVERRIDE(CURR.NO)
    END

    L.AC.AV.BAL = ''


RETURN
*--------------------------------------------------------------------------------------------------------
********************
GET.LOCAL.REF.FIELDS:
********************

    LF.APP = 'ACCOUNT'
    LF.FLD = 'L.AC.TRANS.LIM':@VM:'L.AC.LIMIT.EXP':@VM:'L.AC.AV.BAL':@VM:'L.AC.TRAN.AVAIL'
    LF.POS = ''
    CALL MULTI.GET.LOC.REF(LF.APP,LF.FLD,LF.POS)
    LOC.L.AC.TRANSIT.LIM  = LF.POS<1,1>
    LOC.L.AC.EXP.DATE = LF.POS<1,2>
    LOC.L.AC.AV.BAL.POS = LF.POS<1,3>
    TRAN.AVAIL.POS = LF.POS<1,4>

RETURN
*--------------------------------------------------------------------------------------------------------
END
