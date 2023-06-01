* @ValidationCode : MjoxNjQ1NjE0NzM0OkNwMTI1MjoxNjgzMDE4MTAyOTc4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 14:31:42
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
SUBROUTINE REDO.VAL.MTS.CATEG.UPD
******************************************************************************
* =============================================================================
*TSR-337930   Rajasoundarya S    11-Aug-2022    Facing this error : MONTO ML EB-SALDO CADENA EN CHEQUE
*=======================================================================
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011/Apr/06
*
** 18-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 18-04-2023 Skanda R22 Manual Conversion - No changes
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.VERSION
    $INSERT I_F.TELLER
    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER.ID
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.TRANSACTION
*
    $INSERT I_F.REDO.MULTITXN.PARAMETER
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $USING APAP.TAM
    $USING APAP.REDOVER
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
        WTR.ID = ''
        GOSUB ANALISE.NORMAL.TRANSACTIONS
    END
*
    GOSUB CALC.AMOUNT.SIGN    ;* PACS00280731 - S/E
*
    GOSUB READ.TRANSACTION
*
    IF WSIGNO EQ "DEBIT" THEN
        WTRAN.AMOUNT = WTRAN.AMOUNT * -1
    END
    IF V$FUNCTION EQ "D" THEN
        WTRAN.AMOUNT = WTRAN.AMOUNT * -1
    END

    IF WMONEDA EQ "" THEN
        WMONEDA = LCCY
    END
    WTM.AMOUNT = WTRAN.AMOUNT
    R.NEW(TT.TE.LOCAL.REF)<1,WPOSAMT> = WTRAN.AMOUNT
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
        R.NEW(TT.TE.LOCAL.REF)<1,WPOS.LI> = WINITIAL.ID
        CALL System.setVariable("CURRENT.WTM.MONEDA",WMONEDA)
        CALL System.setVariable("CURRENT.WTM.TYPE",WTM.TYPE)
        CALL System.setVariable("CURRENT.WTM.AMOUNT",WTM.AMOUNT)
        CALL System.setVariable("CURRENT.WTM.TRID",WTR.ID)
        CALL System.setVariable("CURRENT.WTM.RESULT",WTM.RESULT)
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
    LOCATE WCATEG1 IN R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,1> SETTING YPOS THEN
        W.ENTREGA       = "1"
        WMONEDA         = R.NEW(TT.TE.CURRENCY.1)
        FLAG.SIDE       = "1"
        WTR.ID          = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
        CALL System.setVariable("CURRENT.SIDE","1")
        CALL System.setVariable("CURRENT.CATEGORI",WCATEG1)
        CALL System.setVariable("CURRENT.CATEGNEW",WCATEG1)
    END ELSE
        LOCATE WCATEG2 IN R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,1> SETTING YPOS THEN
            W.ENTREGA       = "1"
            WMONEDA         = R.NEW(TT.TE.CURRENCY.2)
            FLAG.SIDE       = "2"
            WTR.ID          = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
            CALL System.setVariable("CURRENT.SIDE","2")
            CALL System.setVariable("CURRENT.CATEGORI",WCATEG2)
            CALL System.setVariable("CURRENT.CATEGNEW",WCATEG2)
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
*
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
* =================
CHANGE.ACCT.TRANS1:
* =================
*
    LOCATE WCATEG1 IN R.REDO.MULTITXN.PARAMETER<RMP.ACTUAL.CATEG,1> SETTING YPOS THEN
        WCATEGN         = R.REDO.MULTITXN.PARAMETER<RMP.NEW.CATEG,YPOS>
        WMONEDA         = R.NEW(TT.TE.CURRENCY.1)
        WTR.ID          = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
        IF WTT.CHANGED NE "YES" AND R.NEW(TT.TE.ACCOUNT.1) THEN
            R.NEW(TT.TE.ACCOUNT.1) = CHANGE(R.NEW(TT.TE.ACCOUNT.1),WCATEG1,WCATEGN)
            WTT.ID      = R.NEW(TT.TE.TELLER.ID.1)
            WCO.ID      = R.COMPANY(EB.COM.SUB.DIVISION.CODE)
            R.NEW(TT.TE.ACCOUNT.1) = R.NEW(TT.TE.ACCOUNT.1)[1,8] : WTT.ID : WCO.ID
            WCATEG1     = WCATEGN
            WTT.CHANGED = "YES"
            CALL System.setVariable("CURRENT.CHANGED","YES")
        END
        CALL System.setVariable("CURRENT.SIDE","1")
        CALL System.setVariable("CURRENT.CATEGORI",WCATEG1)
        CALL System.setVariable("CURRENT.CATEGNEW",WCATEGN)
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
        WTR.ID          = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
        IF WTT.CHANGED NE "YES" AND R.NEW(TT.TE.ACCOUNT.2) THEN
            R.NEW(TT.TE.ACCOUNT.2) = CHANGE(R.NEW(TT.TE.ACCOUNT.2),WCATEG2,WCATEGN)
            WTT.ID      = R.NEW(TT.TE.TELLER.ID.2)
            WCO.ID      = R.COMPANY(EB.COM.SUB.DIVISION.CODE)
            R.NEW(TT.TE.ACCOUNT.2) = R.NEW(TT.TE.ACCOUNT.2)[1,8] : WTT.ID : WCO.ID
            WCATEG2     = WCATEGN
            WTT.CHANGED = "YES"
            CALL System.setVariable("CURRENT.CHANGED","YES")
        END
        CALL System.setVariable("CURRENT.SIDE","2")
        CALL System.setVariable("CURRENT.CATEGORI",WCATEG2)
        CALL System.setVariable("CURRENT.CATEGNEW",WCATEGN)
    END
*
RETURN
*
*----------------
READ.TRANSACTION:
*----------------
*
    IF WTR.ID EQ "" THEN      ;* PACS00280731 - S
        GOSUB GET.TT.TRANSACTION
    END   ;* PACS00280731 - E
*
    CALL CACHE.READ(FN.TRANSACTION, WTR.ID, R.TRANSACTION, ERR.MSJ) ;* R22 Auto conversion
    IF R.TRANSACTION THEN
        WSIGNO = R.TRANSACTION<AC.TRA.DEBIT.CREDIT.IND>
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
*
            GOSUB CALC.AMOUNT.SIGN      ;* PACS00280731 - S

            IF WINITIAL.ID NE "" AND ID.NEW NE WINITIAL.ID AND WTM.SIGN EQ "DEBIT" THEN   ;* Whenever current txn is the last of the chain balance will be zero for check.
                CHECK.BALANCE<YPOS> = CHECK.BALANCE<YPOS> - WTRAN.AMOUNT
            END
            ELSE
                CHECK.BALANCE<YPOS> = CHECK.BALANCE<YPOS> + WTRAN.AMOUNT
            END     ;* PACS00280731 - E
*
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
    GOSUB STORE.USER.VARIABLES
*
RETURN
*
* ---------------
CALC.AMOUNT.SIGN:
* ---------------
*
    IF WTM.SIGN EQ "DEBIT" THEN
        IF FLAG.SIDE EQ "1" THEN
            WTRAN.AMOUNT = WAMOUNT.DB
        END ELSE
            WTRAN.AMOUNT = WAMOUNT.CR
        END
    END ELSE
        IF FLAG.SIDE EQ "1" THEN
            WTRAN.AMOUNT = WAMOUNT.CR
        END ELSE
            WTRAN.AMOUNT = WAMOUNT.DB
        END
    END
*
RETURN
*
* -----------
BALANCE.CHECK:
* -----------
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
    Y.TRANS.ID      = WINITIAL.ID
    Y.VERSION.NAMES = ''
    Y.VERSION.TYPES = ''
* CALL REDO.GET.NV.VERSION.TYPES(Y.TRANS.ID,Y.VERSION.NAMES,Y.VERSION.TYPES,Y.PROC.TYPE,Y.RECEP.METHOD)
**R22 Manual Convarsion
    APAP.TAM.redoGetNvVersionTypes(Y.TRANS.ID,Y.VERSION.NAMES,Y.VERSION.TYPES,Y.PROC.TYPE,Y.RECEP.METHOD)
    CHANGE @FM TO @VM IN Y.VERSION.TYPES
*TSR-337930
    Y.BAL = WEFECTIVO + WSALDO.CHEQUE
    BEGIN CASE
*
*      SI SALDO DE LA MONEDA QUEDA NEGATIVO Y ES SALIDA DE DINERO, GENERAR MENSAJE DE ERROR
*      SI ES SALIDA DE EFECTIVO, PERO HAY SALDO EN CHEQUE EN CUALQUIER MONEDA, GENERAR MENSAJE DE ERROR
*      SI NO TRAE SIGUIENTE TRANSACCION, PERO HAY ALGUN SALDO, GENERAR MENSAJE DE ERROR
*

        CASE Y.ERR.MSG NE ""
            AF = TT.TE.AMOUNT.LOCAL.1

* CASE (WEFECTIVO LT 0 AND WTRAN.AMOUNT LT 0)
*   Y.ERR.MSG = "EB-NOT.ENOUGH.BALANCE:&":FM:WEFECTIVO
*   AF        = TT.TE.AMOUNT.LOCAL.1

*TSR-337930-Start
        CASE NOT(FLAG.CHECK) AND (Y.BAL NE 0) AND (W.ENTREGA EQ "" OR WTRAN.AMOUNT LT 0)
            IF 'AA.PAYMENT' MATCHES Y.VERSION.TYPES ELSE        ;* Other than AA payment we have set this error.
                IF 'AA.COLLECTION'  MATCHES Y.VERSION.TYPES ELSE
                    Y.ERR.MSG = "EB-CHECK.BALANCE.AVAILABLE:&":@FM:Y.BAL
                    AF        = TT.TE.AMOUNT.LOCAL.1
                END
            END

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
*     SOLO SE DEBEN PROCESAR REGISTROS QUE TENGAN EN REDO.TRANSACTION.CHAIN SU ESTADO EN "P"
*     LOS DEMAS ESTADOS INDICAN QUE HAY OTROS PROCESOS EJECUTANDOSE
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
GET.TT.TRANSACTION:
* ----------------
*
    CALL CACHE.READ(FN.TELLER.TRANSACTION, WTT.TRANS, R.TELLER.TRANSACTION, ERR.MSJ) ;* R22 Auto conversion
    IF R.TELLER.TRANSACTION THEN
        IF FLAG.SIDE EQ "1" THEN
            WTR.ID = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
        END
        IF FLAG.SIDE EQ "2" THEN
            WTR.ID = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
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
    IF Y.ERR.MSG THEN
        ETEXT  = Y.ERR.MSG
        CALL STORE.END.ERROR
        ETEXT  = ""
    END
*
RETURN
*
* ===================
STORE.USER.VARIABLES:
* ===================
*
    UV.CCY   = CHANGE(WVCCY,@FM," ")
    UV.CASH  = CHANGE(WVALCASH,@FM," ")
    UV.CHECK = CHANGE(WVALCHECK,@FM," ")
*
    CALL System.setVariable("CURRENT.TID.CCY",UV.CCY)
    CALL System.setVariable("CURRENT.TID.CASH",UV.CASH)
    CALL System.setVariable("CURRENT.TID.CHECK",UV.CHECK)
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
    WCATEG.CHECK       = ""
    WCATEG.CASH        = ""
*
    WTT.TRANS          = R.NEW(TT.TE.TRANSACTION.CODE)
    WTT.ID             = R.NEW(TT.TE.TELLER.ID.1)
    WTM.PROC.AUTOR     = System.getVariable("CURRENT.PROC.AUTOR")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;* R22 Auto conversion
        WTM.PROC.AUTOR = "" ;* R22 Auto conversion
    END ;* R22 Auto conversion

*
    IF WTT.ID EQ "" THEN
        WTT.ID = System.getVariable("CURRENT.TID.ID")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;* R22 Auto conversion
            WTT.ID = "" ;* R22 Auto conversion
        END ;* R22 Auto conversion
    END
*
    FN.TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
    F.TELLER.TRANSACTION  = ""

    FN.TRANSACTION = "F.TRANSACTION"
    F.TRANSACTION  = ""

    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""

    FN.REDO.MULTITXN.PARAMETER = "F.REDO.MULTITXN.PARAMETER"
    F.REDO.MULTITXN.PARAMETER  = ""

    FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
    F.REDO.TRANSACTION.CHAIN  = ""
*
    WRMP.ID      = "SYSTEM"
    WTEMP.AMOUNT = COMI
*
    WAPP.LST  = "TELLER.ID" : @FM : "TELLER"
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
    YPOS = ''
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
    IF MESSAGE NE "VAL" THEN
*CALL REDO.V.CASH.FIELDS2
**R22 Manual Convarsion
        APAP.REDOVER.redoVCashFields2()
    END
*
    WAMOUNT.DB = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.DB>
    WAMOUNT.CR = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.CR>
    WTM.SIGN   = R.NEW(TT.TE.DR.CR.MARKER)
*
    R.NEW(TT.TE.LOCAL.REF)<1,WPOSACV> = APPLICATION:PGM.VERSION
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
*
    IF WTM.PROC.AUTOR EQ "A" OR V$FUNCTION EQ "D" OR V$FUNCTION EQ "A" OR COMI EQ "" OR MESSAGE EQ "VAL" THEN ;* R22 Auto conversion
        PROCESS.GOAHEAD = ""
    END
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
* PACS00263984 - S
                CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
                IF R.TELLER.ID THEN
                    WINITIAL.ID   = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>
                    WVCCY         = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCCY>)
                    WVALCASH      = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCASH>)
                    WVALCHECK     = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCHECK>)
                    CCY.BALANCE   = WVCCY
                    CASH.BALANCE  = WVALCASH
                    CHECK.BALANCE = WVALCHECK
                    GOSUB STORE.USER.VARIABLES
                END
* PACS00263984 - E
                IF WINITIAL.ID EQ "" AND R.NEW(TT.TE.LOCAL.REF)<1,WPOSNV> EQ "" THEN
                    PROCESS.GOAHEAD = ""
                    RETURN
                END
*
*               CALL F.READ(FN.TELLER.ID,WTT.ID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
*               IF R.TELLER.ID THEN
*                  WINITIAL.ID   = R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>
*                  WVCCY         = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCCY>)
*                  WVALCASH      = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCASH>)
*                  WVALCHECK     = RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WPOSCHECK>)
*                  CCY.BALANCE   = WVCCY
*                  CASH.BALANCE  = WVALCASH
*                  CHECK.BALANCE = WVALCHECK
*                  GOSUB STORE.USER.VARIABLES
*               END

            CASE LOOP.CNT EQ 2
                CALL CACHE.READ(FN.TELLER.TRANSACTION, WTT.TRANS, R.TELLER.TRANSACTION, ERR.MSJ) ;* R22 Auto conversion
                IF R.TELLER.TRANSACTION THEN
                    WCATEG1  = R.TELLER.TRANSACTION<TT.TR.CAT.DEPT.CODE.1>
                    WCATEG2  = R.TELLER.TRANSACTION<TT.TR.CAT.DEPT.CODE.2>
                    WTRCODE1 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
                    WTRCODE2 = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
                END

            CASE LOOP.CNT EQ 3

*      CALL F.READ(FN.REDO.MULTITXN.PARAMETER,WRMP.ID,R.REDO.MULTITXN.PARAMETER,F.REDO.MULTITXN.PARAMETER,RMP.ERR) ;*Tus Start
                CALL CACHE.READ(FN.REDO.MULTITXN.PARAMETER,WRMP.ID,R.REDO.MULTITXN.PARAMETER,RMP.ERR)   ;* Tus End
                WCATEG.CHECK = R.REDO.MULTITXN.PARAMETER<RMP.CATEG.CHECK>
                WCATEG.CASH  = R.REDO.MULTITXN.PARAMETER<RMP.CATEG.CASH>
                WTT.CHANGED    = System.getVariable("CURRENT.CHANGED")
                IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;* R22 Auto conversion
                    WTT.CHANGED = "" ;* R22 Auto conversion
                END ;* R22 Auto conversion

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
