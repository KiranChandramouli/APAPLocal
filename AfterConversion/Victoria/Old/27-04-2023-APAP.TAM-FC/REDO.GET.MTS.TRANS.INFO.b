* @ValidationCode : MjotMTA2ODgwODg1NTpDcDEyNTI6MTY4MTIwNzY0NTY1NDpJVFNTMTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 15:37:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.MTS.TRANS.INFO
******************************************************************************
* =============================================================================
*
*=======================================================================
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/Apr/06
*
** 10-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 10-04-2023 Skanda R22 Manual Conversion - line no 409
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER.ID
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_System
*
    $INSERT I_REDO.NV.COMMON
    $INSERT I_F.REDO.MULTITXN.PARAMETER
*
*  DEBUG
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
*--------
PROCESS:
*--------
*
    GOSUB ANALISE.INPUT.TRANSACTIONS
*
    IF NOT(W.ENTREGA) THEN
        GOSUB ANALISE.NORMAL.TRANSACTIONS
    END
*
    GOSUB LOAD.TRAN.AMOUNT
    GOSUB CALCULATE.NEW.BALANCE
*
    IF Y.ERR.MSG THEN
        GOSUB CONTROL.MSG.ERROR
    END ELSE
* PACS00280731 - S/E        R.NEW(TT.TE.LOCAL.REF)<1,WPOSAMT> = WTRAN.AMOUNT
        CALL System.setVariable("CURRENT.WTM.MONEDA",WMONEDA)
        CALL System.setVariable("CURRENT.WTM.AMOUNT",WTRAN.AMOUNT)
        CALL System.setVariable("CURRENT.WTM.RESULT",WRESULT)
        CALL System.setVariable("CURRENT.WTM.TYPE",WTM.TYPE)
        CALL System.setVariable("CURRENT.SIDE",WTM.SIDE)
        CALL System.setVariable("CURRENT.CATEGORI",WTM.CATEGORI)
        CALL System.setVariable("CURRENT.CATEGNEW",WTM.CATEGNEW)
    END
*
RETURN
*
* =========================
ANALISE.INPUT.TRANSACTIONS:
* =========================
*
    WCHECK.TRAN = R.REDO.MULTITXN.PARAMETER<RMP.CHECK.TRANSACT>
    FLAG.CHECK  = ""
    FLAG.SIDE   = ""
    IF WTRCODE1 EQ WCHECK.TRAN THEN
        FLAG.CHECK  = "1"
        FLAG.SIDE   = "1"
        WTM.TYPE    = "CHECK"
        CALL System.setVariable("CURRENT.SIDE",FLAG.SIDE)
    END ELSE
        IF WTRCODE2 EQ WCHECK.TRAN THEN
            FLAG.CHECK  = "1"
            FLAG.SIDE   = "2"
            WTM.TYPE    = "CHECK"
            CALL System.setVariable("CURRENT.SIDE",FLAG.SIDE)
        END ELSE
            WTM.TYPE = "CASH"
        END
    END
*
    W.ENTREGA = ""
*
    LOCATE WCATEG1 IN R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,1> SETTING YPOS THEN
        W.ENTREGA = "1"
        WMONEDA      = R.NEW(TT.TE.CURRENCY.1)
        WTM.SIDE     = "1"
        WTM.CATEGORI = WCATEG1
        WTM.CATEGNEW = WCATEG1
    END ELSE
        LOCATE WCATEG2 IN R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,1> SETTING YPOS THEN
            W.ENTREGA       = "1"
            WMONEDA         = R.NEW(TT.TE.CURRENCY.2)
            WTM.SIDE     = "2"
            WTM.CATEGORI = WCATEG2
            WTM.CATEGNEW = WCATEG2
        END
    END
*
RETURN
*
* ==========================
ANALISE.NORMAL.TRANSACTIONS:
* ==========================
*
    IF WTM.TYPE EQ "CHECK" THEN
        GOSUB HANDLE.CHECK.TRANS
    END ELSE
        GOSUB HANDLE.CASH.TRANS
    END
*
RETURN
*
* =================
HANDLE.CHECK.TRANS:
* =================
*
    IF FLAG.SIDE EQ "1" THEN
        WCHECK.ACCOUNT = R.REDO.MULTITXN.PARAMETER<RMP.CHECK.ACCOUNT>
        WTT.ACCOUNT    = R.NEW(TT.TE.ACCOUNT.1)[4,13]
        IF WTT.ACCOUNT EQ WCHECK.ACCOUNT THEN
            LOCATE WCATEG1 IN R.REDO.MULTITXN.PARAMETER<RMP.ACTUAL.CATEG,1> SETTING YPOS THEN
                GOSUB CHANGE.ACCT.TRANS1
            END
        END
    END ELSE
        IF FLAG.SIDE EQ "2" THEN
            WTT.ACCOUNT    = R.NEW(TT.TE.ACCOUNT.2)[4,13]
            IF WTT.ACCOUNT EQ WCHECK.ACCOUNT THEN
                LOCATE WCATEG2 IN R.REDO.MULTITXN.PARAMETER<RMP.ACTUAL.CATEG,1> SETTING YPOS THEN
                    GOSUB CHANGE.ACCT.TRANS2
                END
            END
        END
    END

*
RETURN
*
* ================
HANDLE.CASH.TRANS:
* ================
* PACS00249338 - S
    IF WTT.DEAL.RT EQ "" THEN
        GOSUB HANDLE.CASH.TRANS.LCY
    END
*
    IF WTT.DEAL.RT NE "" THEN
        GOSUB HANDLE.EXCH.CASH.LCY
    END
* PACS00249338 - E
RETURN
* ====================
HANDLE.CASH.TRANS.LCY:
* ====================
*
    WTT.CHANGED = ""
*
    IF WCATEG1 EQ WCATEG.CASH THEN
        GOSUB CHANGE.ACCT.TRANS1
    END
*
    IF WTT.CHANGED NE "YES" AND WCATEG2 EQ WCATEG.CASH THEN
        GOSUB CHANGE.ACCT.TRANS2
    END
*
RETURN
*
* ===================
HANDLE.EXCH.CASH.LCY:
* ===================
*
    IF WTT.DC.MARK EQ "CREDIT" AND R.NEW(TT.TE.CURRENCY.1) NE LCCY THEN
        GOSUB CHANGE.ACCT.TRANS2
    END
*
    IF WTT.DC.MARK EQ "DEBIT" AND R.NEW(TT.TE.CURRENCY.1) EQ LCCY THEN
        GOSUB CHANGE.ACCT.TRANS1
    END

    IF WTT.DC.MARK EQ "DEBIT" AND R.NEW(TT.TE.CURRENCY.1) NE LCCY THEN
        GOSUB CHANGE.ACCT.TRANS1
        GOSUB CHANGE.ACCT.TRANS2
    END

*
RETURN
*
* =================
CHANGE.ACCT.TRANS1:
* =================
*
    LOCATE WCATEG1 IN R.REDO.MULTITXN.PARAMETER<RMP.ACTUAL.CATEG,1> SETTING YPOS THEN
        WCATEGN         = R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,YPOS>
        WMONEDA         = R.NEW(TT.TE.CURRENCY.1)
        IF R.NEW(TT.TE.ACCOUNT.1) THEN
            R.NEW(TT.TE.ACCOUNT.1) = CHANGE(R.NEW(TT.TE.ACCOUNT.1),WCATEG1,WCATEGN)
            WTT.ID                 = R.NEW(TT.TE.TELLER.ID.1)
            WCO.ID                 = R.COMPANY(EB.COM.SUB.DIVISION.CODE)
            R.NEW(TT.TE.ACCOUNT.1) = R.NEW(TT.TE.ACCOUNT.1)[1,8] : WTT.ID : WCO.ID
            WCATEG1 = WCATEGN
            CALL System.setVariable("CURRENT.CHANGED","YES")
            CALL System.setVariable("CURRENT.NV.ACCT.OLD",Y.BACKUP.ACCT.1)      ;* Fix for PACS00463713
        END
        WTM.SIDE     = "1"
        WTM.CATEGORI = WCATEG1
        WTM.CATEGNEW = WCATEGN
    END
*
RETURN
*
* =================
CHANGE.ACCT.TRANS2:
* =================
*
    LOCATE WCATEG2 IN R.REDO.MULTITXN.PARAMETER<RMP.ACTUAL.CATEG,1> SETTING YPOS THEN
        WCATEGN         = R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,YPOS>
        WMONEDA         = R.NEW(TT.TE.CURRENCY.2)
        IF R.NEW(TT.TE.ACCOUNT.2) THEN
            R.NEW(TT.TE.ACCOUNT.2) = CHANGE(R.NEW(TT.TE.ACCOUNT.2),WCATEG2,WCATEGN)
            WTT.ID                 = R.NEW(TT.TE.TELLER.ID.2)
            WCO.ID                 = R.COMPANY(EB.COM.SUB.DIVISION.CODE)
            R.NEW(TT.TE.ACCOUNT.2) = R.NEW(TT.TE.ACCOUNT.2)[1,8] : WTT.ID : WCO.ID
            WCATEG2 = WCATEGN
            CALL System.setVariable("CURRENT.CHANGED","YES")
            CALL System.setVariable("CURRENT.NV.ACCT.OLD",Y.BACKUP.ACCT.2)      ;* Fix for PACS00463713
        END
        IF R.NEW(TT.TE.ACCOUNT.2) AND R.NEW(TT.TE.CHARGE.ACCOUNT) THEN          ;* PACS00627318 -S
            R.NEW(TT.TE.CHARGE.ACCOUNT) = R.NEW(TT.TE.ACCOUNT.2)
        END         ;* PACS00627318 -E
        WTM.SIDE     = "2"
        WTM.CATEGORI = WCATEG2
        WTM.CATEGNEW = WCATEGN
    END
*
RETURN
*
* ===============
LOAD.TRAN.AMOUNT:
* ===============
*
    WTM.SIGN = R.NEW(TT.TE.DR.CR.MARKER)
*
    IF WTM.SIGN EQ "DEBIT" THEN
        IF WTM.SIDE EQ "1" THEN
            WTRAN.AMOUNT = WAMOUNT.DB
        END ELSE
            WTRAN.AMOUNT = WAMOUNT.CR
        END
    END ELSE
        IF WTM.SIDE EQ "1" THEN
            WTRAN.AMOUNT = WAMOUNT.CR
        END ELSE
            WTRAN.AMOUNT = WAMOUNT.DB
        END
    END
*
    IF (WTM.SIGN EQ "DEBIT" AND WTM.SIDE EQ "1") OR (WTM.SIGN EQ "CREDIT" AND WTM.SIDE EQ "2") THEN
        WTRAN.AMOUNT = WTRAN.AMOUNT * -1
    END
    IF V$FUNCTION EQ "D" THEN
        WTRAN.AMOUNT = WTRAN.AMOUNT * -1
    END
*
RETURN
*
* ====================
CALCULATE.NEW.BALANCE:
* ====================
*
*     CALCULA LOS NUEVOS SALDOS SEGUN EL TIPO DE MONEDA Y DE MOVIMIENTO (EFECTIVO O CHEQUE)
*
    WEFECTIVO = 0
    WCHEQUE   = 0
    WRESULT   = 0
*
    CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
    WVCCY         = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCCY>))
    WVALCASH      = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCASH>))
    WVALCHECK     = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCHECK>))
    CCY.BALANCE   = WVCCY
    CASH.BALANCE  = WVALCASH
    CHECK.BALANCE = WVALCHECK
*
    LOCATE WMONEDA IN WVCCY<1> SETTING YPOS THEN
        WEFECTIVO = CASH.BALANCE<YPOS>
        WCHEQUE   = CHECK.BALANCE<YPOS>
        WRESULT   = WEFECTIVO + WCHEQUE
        IF FLAG.CHECK THEN
            CHECK.BALANCE<YPOS> = CHECK.BALANCE<YPOS> + WTRAN.AMOUNT
            IF CHECK.BALANCE<YPOS> LT 0 THEN
                CASH.BALANCE<YPOS>  = CASH.BALANCE<YPOS> + CHECK.BALANCE<YPOS>
                CHECK.BALANCE<YPOS> = 0
                WEFECTIVO           = CASH.BALANCE<YPOS>
            END
            WCHEQUE   = CHECK.BALANCE<YPOS>
        END ELSE
            CASH.BALANCE<YPOS>  = CASH.BALANCE<YPOS> + WTRAN.AMOUNT
            WEFECTIVO           = CASH.BALANCE<YPOS>
        END
    END ELSE
        CCY.BALANCE<-1> = WMONEDA
        IF FLAG.CHECK THEN
            CHECK.BALANCE<-1> = WTRAN.AMOUNT
            WEFECTIVO         = WTRAN.AMOUNT
        END ELSE
            CASH.BALANCE<-1>  = WTRAN.AMOUNT
            WCHEQUE           = WTRAN.AMOUNT
        END
    END
*
    WSALDO.CHEQUE   = SUM(CHECK.BALANCE)
    WSALDO.EFECTIVO = SUM(CASH.BALANCE)
    WRESULT         = WSALDO.CHEQUE + WSALDO.EFECTIVO
*
RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph that control the error in the subroutine
*
    IF Y.ERR.MSG THEN
        ETEXT           = Y.ERR.MSG
        CALL STORE.END.ERROR
        ETEXT           = ""
    END
*
RETURN
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD    = 1
*
    WCATEG1            = ""
    WCATEG2            = ""
    Y.ERR.MSG          = ""
    WMONEDA            = ""
    WTM.SIDE           = ""
    WTM.CATEGORI       = ""
    WTM.CATEGNEW       = ""
    WTM.AMOUNT         = 0
    WCATEG.CHECK       = ""
    WCATEG.CASH        = ""

*
    WTT.TRANS          = R.NEW(TT.TE.TRANSACTION.CODE)
    WTT.ID             = R.NEW(TT.TE.TELLER.ID.1)
    WTT.DEAL.RT        = R.NEW(TT.TE.DEAL.RATE)
    WTT.DC.MARK        = R.NEW(TT.TE.DR.CR.MARKER)
    Y.BACKUP.ACCT.1    = R.NEW(TT.TE.ACCOUNT.1)
    Y.BACKUP.ACCT.2    = R.NEW(TT.TE.ACCOUNT.2)
*
    IF WTT.ID EQ "" THEN
        WTT.ID = System.getVariable("CURRENT.TID.ID")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;* R22 Auto conversion
            WTT.ID = "" ;* R22 Auto conversion
        END ;* R22 Auto conversion
    END
*
    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""
*
    FN.TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
    F.TELLER.TRANSACTION  = ""
*
    FN.REDO.MULTITXN.PARAMETER = "F.REDO.MULTITXN.PARAMETER"
    F.REDO.MULTITXN.PARAMETER  = ""
*
    WRMP.ID = "SYSTEM"
*
    WAPP.LST = "TELLER.ID" : @FM : "TELLER"
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST  = WCAMPO
    WCAMPO    = "L.NEXT.VERSION"
    WCAMPO<2> = "L.ACTUAL.VERSIO"
    WCAMPO<3> = "L.TRAN.AMOUNT"
    WCAMPO<4> = "L.INITIAL.ID"
    WCAMPO<5> = "L.DEBIT.AMOUNT"
    WCAMPO<6> = "L.CREDIT.AMOUNT"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST := @FM : WCAMPO
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    WPOSLI    = YPOS<1,1>
    WPOSCASH  = YPOS<1,2>
    WPOSCHECK = YPOS<1,3>
    WPOSCCY   = YPOS<1,4>
*
    WPOSNV    = YPOS<2,1>
    WPOSACV   = YPOS<2,2>
    WPOSAMT   = YPOS<2,3>
    WPOS.LI   = YPOS<2,4>
    WPOS.DB   = YPOS<2,5>
    WPOS.CR   = YPOS<2,6>
*
    WAMOUNT.DB = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.DB>
    WAMOUNT.CR = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.CR>
*
RETURN
*
* =========
OPEN.FILES:
* =========
*

*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 2
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                CALL CACHE.READ(FN.TELLER.TRANSACTION, WTT.TRANS, R.TELLER.TRANSACTION, ERR.MSJ) ;* R22 Auto conversion
                IF R.TELLER.TRANSACTION THEN
                    WCATEG1  = R.TELLER.TRANSACTION<TT.TR.CAT.DEPT.CODE.1>
                    WCATEG2  = R.TELLER.TRANSACTION<TT.TR.CAT.DEPT.CODE.2>
                    WTRCODE1 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
                    WTRCODE2 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
                END

            CASE LOOP.CNT EQ 2

*      CALL F.READ(FN.REDO.MULTITXN.PARAMETER,WRMP.ID,R.REDO.MULTITXN.PARAMETER,F.REDO.MULTITXN.PARAMETER,ERR.MSJ) ;*Tus Start
                CALL CACHE.READ(FN.REDO.MULTITXN.PARAMETER,WRMP.ID,R.REDO.MULTITXN.PARAMETER,ERR.MSJ)   ;* Tus End
                WCATEG.CHECK = R.REDO.MULTITXN.PARAMETER<RMP.CATEG.CHECK>
                WCATEG.CASH  = R.REDO.MULTITXN.PARAMETER<RMP.CATEG.CASH>

        END CASE
*       Message Error
        GOSUB CONTROL.MSG.ERROR
*       Increase
        LOOP.CNT += 1

*
    REPEAT
*
RETURN
*
END
