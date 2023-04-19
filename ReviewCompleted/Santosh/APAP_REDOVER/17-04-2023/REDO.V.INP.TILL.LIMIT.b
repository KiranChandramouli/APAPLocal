* @ValidationCode : MjoyOTI0NDg2NzpDcDEyNTI6MTY4MTczNDIzNDQ3MTo5MTYzODotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 17:53:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 91638
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.TILL.LIMIT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH R
*Reference Number  :ODR-2010-08-0039
*Program   Name    :REDO.V.INP.TILL.LIMIT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to trigger override message if the till balance
*                   exceeds the maximum limit or if it is short of minimum limit
*LINKED WITH       :
*Modification history
*Date                Who               Reference                  Description
*17-04-2023      conversion tool     R22 Auto code conversion    FM TO @FM,VM TO @VM,SM TO @SM,++ TO +=1
*17-04-2023      Mohanraj R          R22 Manual code conversion   No changes

*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System

    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.EB.CONTRACT.BALANCES                ;*TUS S/E
    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*-----
*
    MIN.LIMIT=''
    MAX.LIMIT=''
    LOC.REF.APPLICATION="TELLER.ID":@FM:"TELLER"
    LOC.REF.FIELDS='L.TT.BRAN.LIM':@VM:'L.TT.TOL.CAT.RG':@VM:'L.TT.MIN.BR.LIM':@VM:'L.TT.MAX.BR.LIM':@VM:'L.TT.TILL.LIM':@VM:'L.TT.MIN.TL.LIM':@VM:'L.TT.MAX.TL.LIM':@VM:'L.TT.MN.VAU.LIM':@VM:'L.TT.MIN.LIM':@VM:'L.TT.MAX.LIM':@VM:'L.CI.CATEG.CARD':@VM:'L.TT.CURRENCY':@VM:'L.TT.USER.TYPE':@FM:'L.INITIAL.ID':@VM:'L.ACTUAL.VERSIO'
    LOC.REF.POS=''

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID = ''
    CALL OPF(FN.TELLER.ID, F.TELLER.ID)

    Y.FLAG = ''
    VAL.AMT = ''
    TT.TID.ID = ''
RETURN

PROCESS:
*-------
*Checking for the Category and the Currency with local fields

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    LOC.TT.BRAN.LIM.POS = LOC.REF.POS<1,1>
    LOC.TT.TOL.CAT.RG.POS = LOC.REF.POS<1,2>
    LOC.TT.MIN.BR.LIM.POS = LOC.REF.POS<1,3>
    LOC.TT.MAX.BR.LIM.POS = LOC.REF.POS<1,4>
    LOC.TT.TILL.LIM.POS = LOC.REF.POS<1,5>
    LOC.TT.MIN.TL.LIM.POS = LOC.REF.POS<1,6>
    LOC.TT.MAX.TL.LIM.POS = LOC.REF.POS<1,7>
    LOC.TT.MN.VAU.LIM.POS = LOC.REF.POS<1,8>
    LOC.TT.MIN.VAU.LIM.POS = LOC.REF.POS<1,9>
    LOC.TT.MAX.VAU.LIM.POS = LOC.REF.POS<1,10>
    LOC.TT.CATEG.POS = LOC.REF.POS<1,11>
    LOC.TT.CCY.POS = LOC.REF.POS<1,12>
    LOC.L.TT.USER.TYPE = LOC.REF.POS<1,13>
    LOC.L.INITIAL.ID = LOC.REF.POS<2,1>
    LOC.L.ACTUAL.VERSIO = LOC.REF.POS<2,2>

    IF APPLICATION EQ "TELLER" THEN

        IF PGM.VERSION EQ ',REDO.CASHWDL.LCY' THEN
            R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.ACTUAL.VERSIO> = APPLICATION:PGM.VERSION
        END

* Fix for PACS00305984 [CASHIER DEAL SLIP PRINT OPTION]

        IF PGM.VERSION EQ ',REDO.ACCOUNT.CLOSURE.ML' OR PGM.VERSION EQ ',REDO.ACCOUNT.CLOSURE.ME' OR PGM.VERSION EQ ',REDO.CHQ.OTHERS' THEN
            CALL System.setVariable("CURRENT.WTM.FIRST.ID",ID.NEW)
        END

* End of Fix

* Fix for PACS00313755 [TILL AUTO POPULATE RESTRICTION]

        IF PGM.VERSION EQ ',REDO.VAULT.TO.TILL.LCY' OR PGM.VERSION EQ ',REDO.VAULT.TO.TILL.FCY' THEN

            GET.TTID.1 = R.NEW(TT.TE.TELLER.ID.1)
            GET.TTID.2 = R.NEW(TT.TE.TELLER.ID.2)

            CALL F.READ(FN.TELLER.ID,GET.TTID.1,R.TT.TELLER.ID,F.TELLER.ID,TELLER.ID.ERR)
            GET.TELLER.USER = R.TT.TELLER.ID<TT.TID.USER>
            GET.TELLER.TYPE = R.TT.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.L.TT.USER.TYPE>

            IF (GET.TTID.1 EQ GET.TTID.2) OR (GET.TELLER.USER EQ OPERATOR) OR (GET.TELLER.TYPE EQ 'NONTELLER') THEN
                AF = TT.TE.TELLER.ID.1
                ETEXT = 'TT-NOT.ALLOW.SAME.TILL.OR.VAULT'
                CALL STORE.END.ERROR
            END

        END

* End of Fix

        GOSUB GET.TTID.AFFECT     ;* PACS00247803 - S/E

        CALL F.READ(FN.TELLER.ID, TT.TID.ID, R.TELLER.ID, F.TELLER.ID, TT.TID.ERR)

        FN.ACCOUNT = 'F.ACCOUNT'
        F.ACCOUNT = ''
        CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    END

    IF APPLICATION EQ 'TELLER' THEN
        VAR.CATEGORY.LIST = R.TELLER.ID<TT.TID.CATEGORY>
        VAR.LOC.CATEG.LIST = R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.CATEG.POS>
        VAR.TT.CCY         = R.NEW(TT.TE.CURRENCY.1)
    END ELSE
        VAR.CATEGORY.LIST = R.NEW(TT.TID.CATEGORY)
        VAR.LOC.CATEG.LIST = R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.CATEG.POS>
    END

    VAR.CATEG.COUNT = DCOUNT(VAR.CATEGORY.LIST,@VM)
    Y.COUNT = 1
    LOOP
    WHILE Y.COUNT LE VAR.CATEG.COUNT

        IF APPLICATION EQ 'TELLER' THEN
*            VAR.TILL.BALANCE = R.TELLER.ID<TT.TID.TILL.BALANCE><1,Y.COUNT>
            Y.CATEG = R.TELLER.ID<TT.TID.CATEGORY><1,Y.COUNT>
            VAR.CCY = R.TELLER.ID<TT.TID.CURRENCY><1,Y.COUNT>
            GOSUB GET.ACCT.ONLBAL   ;* PACS00247803 - S
        END ELSE
            VAR.TILL.BALANCE = R.NEW(TT.TID.TILL.CLOS.BAL)<1,Y.COUNT>       ;* PACS00247803 - S
            Y.CATEG = R.NEW(TT.TID.CATEGORY)<1,Y.COUNT>
            VAR.CCY = R.NEW(TT.TID.CURRENCY)<1,Y.COUNT>
        END

        GOSUB CHECK.CATEGORY

        IF Y.CATEG.FLAG EQ 0 THEN
            TEXT = "REDO.NO.CATEGORY":@FM:Y.CATEG
            CURR.NO = DCOUNT(R.NEW(V-9),@VM)+1
            CALL STORE.OVERRIDE(CURR.NO)
        END
        IF Y.CCY.FLAG EQ 0 THEN
            TEXT = "REDO.NO.CURRENCY":@FM:VAR.CCY:@VM:Y.CATEG
            CURR.NO = DCOUNT(R.NEW(V-9),@VM)+1
            CALL STORE.OVERRIDE(CURR.NO)
        END
        Y.COUNT += 1
    REPEAT
RETURN

CHECK.CATEGORY:
* Checking for Local categories and Currency

    Y.CATEG.FLAG = 0
    Y.CCY.FLAG = 0
    VAR.LOC.COUNT = DCOUNT(VAR.LOC.CATEG.LIST,@SM)
    LOC.COUNT = 1
    LOOP
    WHILE LOC.COUNT LE VAR.LOC.COUNT

        IF APPLICATION EQ 'TELLER' THEN
            VAR.LOC.CATEGORY = R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.CATEG.POS,LOC.COUNT>
            VAR.LOC.CCY = R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.CCY.POS,LOC.COUNT>
        END ELSE
            VAR.LOC.CATEGORY = R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.CATEG.POS,LOC.COUNT>
            VAR.LOC.CCY = R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.CCY.POS,LOC.COUNT>
        END

        IF Y.CATEG EQ VAR.LOC.CATEGORY THEN
            Y.CATEG.FLAG = 1
            IF VAR.CCY EQ VAR.LOC.CCY AND Y.CATEG.FLAG EQ 1 THEN
                Y.CCY.FLAG = 1
                GOSUB CHECK.LIMIT
                RETURN
            END
            ELSE
                Y.CCY.FLAG = 0
            END

        END
        ELSE
            Y.CATEG.FLAG = 0
        END
        LOC.COUNT += 1
    REPEAT
RETURN

CHECK.LIMIT:
*Check for the limit and raise the override

    IF APPLICATION EQ 'TELLER' THEN
        BRANCH.LIMIT = R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.BRAN.LIM.POS,LOC.COUNT>
        TILL.LIMIT = R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.TILL.LIM.POS,LOC.COUNT>
        VAULT.LIMIT = R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.MN.VAU.LIM.POS,LOC.COUNT>
    END ELSE
        BRANCH.LIMIT = R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.BRAN.LIM.POS,LOC.COUNT>
        TILL.LIMIT = R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.TILL.LIM.POS,LOC.COUNT>
        VAULT.LIMIT = R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.MN.VAU.LIM.POS,LOC.COUNT>
    END

    IF BRANCH.LIMIT NE '' THEN
        IF APPLICATION EQ 'TELLER' THEN
            MIN.LIMIT=R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.MIN.BR.LIM.POS,LOC.COUNT>
            MAX.LIMIT=R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.MAX.BR.LIM.POS,LOC.COUNT>
        END ELSE
            MIN.LIMIT=R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.MIN.BR.LIM.POS,LOC.COUNT>
            MAX.LIMIT=R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.MAX.BR.LIM.POS,LOC.COUNT>
        END

        GOSUB CHECK.AMOUNT
    END

    IF TILL.LIMIT NE '' THEN
        IF APPLICATION EQ 'TELLER' THEN
            MIN.LIMIT=R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.MIN.TL.LIM.POS,LOC.COUNT>
            MAX.LIMIT=R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.MAX.TL.LIM.POS,LOC.COUNT>
        END ELSE
            MIN.LIMIT=R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.MIN.TL.LIM.POS,LOC.COUNT>
            MAX.LIMIT=R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.MAX.TL.LIM.POS,LOC.COUNT>
        END

        GOSUB CHECK.AMOUNT
    END

    IF VAULT.LIMIT NE '' THEN
        IF APPLICATION EQ 'TELLER' THEN
            MIN.LIMIT=R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.MIN.VAU.LIM.POS,LOC.COUNT>
            MAX.LIMIT=R.TELLER.ID<TT.TID.LOCAL.REF><1,LOC.TT.MAX.VAU.LIM.POS,LOC.COUNT>
        END ELSE
            MIN.LIMIT=R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.MIN.VAU.LIM.POS,LOC.COUNT>
            MAX.LIMIT=R.NEW(TT.TID.LOCAL.REF)<1,LOC.TT.MAX.VAU.LIM.POS,LOC.COUNT>
        END

        GOSUB CHECK.AMOUNT
    END

RETURN

GET.ACCT.ONLBAL:

    WCOM.ID = R.COMPANY(EB.COM.SUB.DIVISION.CODE)
    WACCOUNT.ID = ''
    WACCOUNT.ID = VAR.CCY : Y.CATEG : TT.TID.ID : WCOM.ID

    R.ACCOUNT = '' ; YERR = ''
    CALL F.READ(FN.ACCOUNT,WACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,YERR)
    CALL EB.READ.HVT ('EB.CONTRACT.BALANCES', WACCOUNT.ID, R.ECB, ECB.ERR)                ;*TUS START
    IF R.ACCOUNT NE "" THEN
*VAR.TILL.BALANCE = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
        VAR.TILL.BALANCE = R.ECB<ECB.ONLINE.ACTUAL.BAL>                ;*TUS END
    END

RETURN

GET.TTID.AFFECT:

    WTTE.ID.1 = R.NEW(TT.TE.TELLER.ID.1) ; WTTE.ID.2 = R.NEW(TT.TE.TELLER.ID.2)
    IF WTTE.ID.1 NE WTTE.ID.2 THEN
        GOSUB GETTID.CASHFLOW.TXNS
    END
*
    IF WTTE.ID.1 EQ WTTE.ID.2 THEN
        TT.TID.ID = WTTE.ID.1
    END
*
RETURN

GETTID.CASHFLOW.TXNS:

    W.SIGN = R.NEW(TT.TE.DR.CR.MARKER)
    IF W.SIGN EQ "CREDIT" THEN
        TT.TID.ID = WTTE.ID.1
    END
*
    IF W.SIGN EQ "DEBIT" THEN
        TT.TID.ID = WTTE.ID.2
    END
*
RETURN

CHECK.AMOUNT:
*Raising the Override depending on the limit
    IF VAR.TILL.BALANCE EQ '' THEN
        VAR.TILL.BALANCE = 0
    END
* PACS00247803 - S
    IF VAR.TILL.BALANCE LT 0 THEN
        VAR.TILL.BALANCE = ABS(VAR.TILL.BALANCE)
    END
*
    IF APPLICATION EQ "TELLER" AND VAR.TT.CCY EQ VAR.CCY THEN
        GOSUB RAISE.AMT.OVE
    END
*
    IF APPLICATION EQ "TELLER.ID" THEN
        GOSUB RAISE.AMT.OVE
    END
* PACS00247803 - E
RETURN

RAISE.AMT.OVE:

    IF VAR.TILL.BALANCE GT MAX.LIMIT THEN
        VAL.AMT = VAR.TILL.BALANCE - MAX.LIMIT
        VAR.AMT = ABS(VAL.AMT)
        VAR.AMT = TRIM(FMT(VAR.AMT,'R2,$#19'),' ','B')          ;* PACS00247803 - S/E
        TEXT="EXCEEDED.LIMIT":@FM:VAR.CCY:@VM:VAR.AMT

        CURR.NO=DCOUNT(R.NEW(V-9),@VM) + 1

        CALL STORE.OVERRIDE(CURR.NO)
    END
    ELSE
        IF VAR.TILL.BALANCE LT MIN.LIMIT THEN
            VAL.AMT = VAR.TILL.BALANCE - MIN.LIMIT
            VAR.AMT = ABS(VAL.AMT)
            VAR.AMT = TRIM(FMT(VAR.AMT,'R2,$#19'),' ','B')        ;* PACS00247803 - S/E
            TEXT="CASH.SHORTAGE":@FM:VAR.CCY:@VM:VAR.AMT
            CURR.NO=DCOUNT(R.NEW(V-9),@VM) + 1
            CALL STORE.OVERRIDE(CURR.NO)
        END
    END
RETURN
END