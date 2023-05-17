SUBROUTINE REDO.VAL.MTS.AMOUNT.FT
*
* =============================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/Apr/06
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.VERSION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TRANSACTION
    $INSERT I_System
    $INSERT I_F.COMPANY
*
    $INSERT I_F.REDO.MULTITXN.PARAMETER
    $INSERT I_F.REDO.TRANSACTION.CHAIN
*

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
    WCATEG.DEB = R.NEW(FT.DEBIT.ACCT.NO)[4,5]
    LOCATE WCATEG.DEB IN R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,1> SETTING YPOS THEN       ;* Changed
        W.ENTREGA       = "1"     ;* Changed
        WTRAN.AMOUNT    = COMI * -1         ;* Changed
        WMONEDA         = R.NEW(FT.DEBIT.CURRENCY)    ;* Changed
    END     ;* Changed

    IF V$FUNCTION EQ "D" THEN
        WTRAN.AMOUNT = WTRAN.AMOUNT * -1
    END
*
    IF WMONEDA EQ "" THEN
        WMONEDA = LCCY
    END
    WTM.AMOUNT = WTRAN.AMOUNT
*
    GOSUB CALCULATE.NEW.BALANCE
*
    IF WINITIAL.ID NE "" AND PROCESS.GOAHEAD AND V$FUNCTION NE "D" THEN
        GOSUB BALANCE.CHECK
    END

    IF Y.ERR.MSG THEN
        GOSUB CONTROL.MSG.ERROR
    END ELSE
        IF WINITIAL.ID EQ "" THEN
            WINITIAL.ID = ID.NEW
        END
        R.NEW(FT.LOCAL.REF)<1,WPOS.LI> = WINITIAL.ID
        CALL System.setVariable("CURRENT.WTM.MONEDA",WMONEDA)
        CALL System.setVariable("CURRENT.WTM.TYPE",WTM.TYPE)
        CALL System.setVariable("CURRENT.WTM.RESULT",WRESULT)   ;* Changed
    END
*
RETURN
*
* =========================
ANALISE.INPUT.TRANSACTIONS:
* =========================
*
*   DETERMINES IF TRANSACTION IS CASH OR CHECK
*
    WACCT.DEB  = R.NEW(FT.DEBIT.ACCT.NO)
    WCATEG.DEB = WACCT.DEB[4,5]
*
*  If DEBIT TRANSACTION CODE for TRANSACTION TYPE in process is equal to CHECK.TRANSACT
*  in REDO.MULTITXN.PARAMETER, then transaction will affect CHECK BALANCES
*
    WCHECK.ACCT = R.REDO.MULTITXN.PARAMETER<RMP.CHECK.ACCOUNT>
    FLAG.CHECK  = ""
    IF R.FT.TXN.TYPE.CONDITION<FT6.TXN.CODE.DR> EQ R.REDO.MULTITXN.PARAMETER<RMP.CHECK.TRANSACT> THEN
        FLAG.CHECK  = "1"
        WTM.TYPE    = "CHECK"
    END ELSE
        WTM.TYPE = "CASH"
    END
*
*  Determines if CATEGORY in DEBIT ACCOUNT is one of the NEW TEMPORARY CATEGORIES
*  defined in REDO.MULTITXN.PARAMETER - normally used to RECEIVE CHECKS
*
    W.ENTREGA = ""    ;* Flag to indicate that it is a TEMPORARY ACCOUNT
*
    LOCATE WCATEG.DEB IN R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,1> SETTING YPOS THEN
        W.ENTREGA       = "1"
*WTRAN.AMOUNT    = COMI * -1
        WMONEDA         = R.NEW(FT.DEBIT.CURRENCY)
    END
*
RETURN
*
* ==========================
ANALISE.NORMAL.TRANSACTIONS:
* ==========================
*
*   Only for NOT RECEIVING FUNDS transactions
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
    WCHECK.ACCOUNT = R.REDO.MULTITXN.PARAMETER<RMP.CHECK.ACCOUNT>
    WTT.ACCOUNT    = R.NEW(FT.DEBIT.ACCT.NO)[4,13]
    IF WTT.ACCOUNT EQ WCHECK.ACCOUNT THEN
        WCATEG1 = WTT.ACCOUNT[1,5]
        LOCATE WCATEG1 IN R.REDO.MULTITXN.PARAMETER<RMP.ACTUAL.CATEG,1> SETTING YPOS THEN
            GOSUB CHANGE.ACCT.TRANS
        END
    END
*
RETURN
*
* ================
HANDLE.CASH.TRANS:
* ================
*
    WTT.ACCOUNT    = R.NEW(FT.DEBIT.ACCT.NO)[4,13]
    WCATEG1 = WTT.ACCOUNT[1,5]

    LOCATE WCATEG1 IN R.REDO.MULTITXN.PARAMETER<RMP.ACTUAL.CATEG,1> SETTING YPOS THEN
        GOSUB CHANGE.ACCT.TRANS
    END
*
RETURN
*
* ================
CHANGE.ACCT.TRANS:
* ================
*

    WCATEGN         = R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,YPOS>
    WTRAN.AMOUNT    = COMI
    WMONEDA         = R.NEW(FT.DEBIT.CURRENCY)

    Y.COMP = ID.COMPANY
*CALL F.READ(FN.COMPANY,Y.COMP,R.COMP,F.COMPANY,COMP.ERR) ;*Tus Start
    CALL CACHE.READ(FN.COMPANY,Y.COMP,R.COMP,COMP.ERR) ;*Tus End
    Y.DIV.CODE = R.COMP<EB.COM.SUB.DIVISION.CODE>
    WNEW.ACCT       = R.NEW(FT.DEBIT.ACCT.NO)[1,3] : WCATEGN : WTT.ID : Y.DIV.CODE          ;* Changed

    CALL INT.ACC.OPEN(WNEW.ACCT,PAR.M)

    R.NEW(FT.DEBIT.ACCT.NO) = WNEW.ACCT   ;* Changed
*
RETURN
*
* ====================
CALCULATE.NEW.BALANCE:
* ====================
*
* Calculates NEW BALANCES per CURRENCY and MOVEMENT TYPE (Cash or Check)
*
    WEFECTIVO = 0
    WCHEQUE   = 0
    WRESULT   = 0
*
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
            WCHEQUE           = WTRAN.AMOUNT
        END ELSE
            CASH.BALANCE<-1>  = WTRAN.AMOUNT
            WEFECTIVO         = WTRAN.AMOUNT
        END
    END
*
    WSALDO.CHEQUE   = SUM(CHECK.BALANCE)
    WSALDO.EFECTIVO = SUM(CASH.BALANCE)
*
    WVCCY     = LOWER(CCY.BALANCE)
    WVALCASH  = LOWER(CASH.BALANCE)
    WVALCHECK = LOWER(CHECK.BALANCE)
*
RETURN
*
* -----------
BALANCE.CHECK:
* -----------
*
* Validates if BALANCE is enough for the transaction AMOUNT
*
    WRESULT   = 0
    Y.ERR.MSG = ""
    IF WCHEQUE EQ "" THEN
        WCHEQUE = 0
    END
    IF WEFECTIVO EQ "" THEN
        WEFECTIVO = 0
    END
*
    GOSUB VALIDATE.RTC.STATUS
*

    BEGIN CASE
*
* If BALANCE after transaction is negative, and funds are going OUT, generate error message
* If CASH is going OUT but CHEQUE BALANCE is available, generate ERROR message
*

        CASE Y.ERR.MSG NE ""
*AF        = FT.DEBIT.AMOUNT         ;* Changed
            AF        = FT.CREDIT.AMOUNT        ;* Changed

        CASE WEFECTIVO LT 0 AND (W.ENTREGA EQ "" OR WTRAN.AMOUNT LT 0)
*Y.ERR.MSG = "EB-NOT.ENOUGH.BALANCE:&":FM:WEFECTIVO ;* This error has been commented for Multiple AA payment issue.
*AF        = FT.DEBIT.AMOUNT
*AF        = FT.CREDIT.AMOUNT    ;* Changed

        CASE NOT(FLAG.CHECK) AND (WCHEQUE NE 0 OR WSALDO.CHEQUE NE 0) AND (W.ENTREGA EQ "" OR WTRAN.AMOUNT LT 0)
            Y.ERR.MSG = "EB-CHECK.BALANCE.AVAILABLE:&":@FM:WCHEQUE
*AF        = FT.DEBIT.AMOUNT
            AF        = FT.CREDIT.AMOUNT        ;* Changed

    END CASE
*
    WRESULT = WSALDO.CHEQUE + WSALDO.EFECTIVO
*
RETURN
*
* ==================
VALIDATE.RTC.STATUS:
* ==================
*
    WRTC.STATUS = ""
*
* Only REDO.TRANSACTION.CHAIN records with STATUS field equal P may be processed
*
    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,WINITIAL.ID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ)
    IF ERR.MSJ THEN
        Y.ERR.MSG = "EB-RTC.RECORD.DOES.NOT.EXIST:&":@FM:WINITIAL.ID
    END ELSE
        WRTC.STATUS =  R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH>
        IF WRTC.STATUS NE "P" THEN
            Y.ERR.MSG = "EB-RTC.STATUS.&.NOT.CORRECT-:&":@FM:WRTC.STATUS:@VM:WINITIAL.ID
        END
    END
*
RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph that control the error in the subroutine
*
    ETEXT  = Y.ERR.MSG
    CALL STORE.END.ERROR
    ETEXT  = ""
*
RETURN

*

* ===================
STORE.USER.VARIABLES:
* ===================
*
    UV.CCY   = CHANGE(WVCCY,@FM," ")       ;* Changed
    UV.CASH  = CHANGE(WVALCASH,@FM," ")    ;* Changed
    UV.CHECK = CHANGE(WVALCHECK,@FM," ")   ;* Changed
*
    CALL System.setVariable("CURRENT.TID.CCY",UV.CCY)         ;* Changed
    CALL System.setVariable("CURRENT.TID.CASH",UV.CASH)       ;* Changed
    CALL System.setVariable("CURRENT.TID.CHECK",UV.CHECK)     ;* Changed
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
    WTRAN.AMOUNT       = ""
*
    WTT.TRANS          = R.NEW(FT.TRANSACTION.TYPE)
    WTT.ID             = System.getVariable("CURRENT.TID.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        WTT.ID = ""
    END
    WTM.PROC.AUTOR     = System.getVariable("CURRENT.PROC.AUTOR")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        WTM.PROC.AUTOR = ""
    END
*
    FN.FT.TXN.TYPE.CONDITION = "F.FT.TXN.TYPE.CONDITION"
    F.FT.TXN.TYPE.CONDITION  = ""

    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""

    FN.REDO.MULTITXN.PARAMETER = "F.REDO.MULTITXN.PARAMETER"
    F.REDO.MULTITXN.PARAMETER  = ""

    FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
    F.REDO.TRANSACTION.CHAIN  = ""

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

*
    WRMP.ID      = "SYSTEM"
    WTEMP.AMOUNT = COMI
*
    WAPP.LST  = "TELLER.ID" : @FM : "FUNDS.TRANSFER"
    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST  = WCAMPO
    WCAMPO    = "L.NEXT.VERSION"
    WCAMPO<2> = "L.ACTUAL.VERSIO"
    WCAMPO<3> = "L.INITIAL.ID"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    WFLD.LST := @FM : WCAMPO
    YPOS = ''
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
    WPOSLI    = YPOS<1,1>
    WPOSCASH  = YPOS<1,2>
    WPOSCHECK = YPOS<1,3>
    WPOSCCY   = YPOS<1,4>
*
    WPOSNV    = YPOS<2,1>
    WPOSACV   = YPOS<2,2>
    WPOS.LI   = YPOS<2,3>
*
    R.NEW(FT.LOCAL.REF)<1,WPOSACV> = APPLICATION:PGM.VERSION
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


    LOOP.CNT  = 1   ;   MAX.LOOPS = 3

    CALL CACHE.READ(FN.REDO.MULTITXN.PARAMETER,WRMP.ID,R.REDO.MULTITXN.PARAMETER,ERR.MSJ)

*
    IF WTM.PROC.AUTOR EQ "A" OR V$FUNCTION EQ "D" OR V$FUNCTION EQ "A" OR COMI EQ "" OR MESSAGE EQ "VAL" THEN
        PROCESS.GOAHEAD = ""
    END
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1

                CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
                IF R.TELLER.ID THEN
                    WINITIAL.ID   = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>
                    WVCCY         = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCCY>)
                    WVALCASH      = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCASH>)
                    WVALCHECK     = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCHECK>)
                    CCY.BALANCE   = WVCCY
                    CASH.BALANCE  = WVALCASH
                    CHECK.BALANCE = WVALCHECK
                    GOSUB STORE.USER.VARIABLES      ;* Changed
                END
                IF WINITIAL.ID EQ "" AND R.NEW(FT.LOCAL.REF)<1,WPOSNV> EQ "" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                Y.CK = 1

            CASE LOOP.CNT EQ 3
                WTRAN.TYPE = R.NEW(FT.TRANSACTION.TYPE)
                CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, WTRAN.TYPE, R.FT.TXN.TYPE.CONDITION, ERR.FTTC)
                IF ERR.FTTC THEN
                    Y.ERR.MSG       = "EB-TRANSACTION.TYPE.&.NOT.FOUND":@FM:WTRAN.TYPE
                    PROCESS.GOAHEAD = ""
*AF              = FT.TRANSACTION.TYPE  ;* Changed
                END

        END CASE
*       Message Error
        IF Y.ERR.MSG THEN
            GOSUB CONTROL.MSG.ERROR
        END
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
