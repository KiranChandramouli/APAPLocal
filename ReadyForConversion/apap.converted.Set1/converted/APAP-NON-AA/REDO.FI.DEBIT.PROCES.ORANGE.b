SUBROUTINE REDO.FI.DEBIT.PROCES.ORANGE(R.PARAMS, OUT.RESP,OUT.ERR)
******************************************************************************
*
*
*     Routine to exec a FT transaccion, from Client Account to Internal Account
*     Copy file from one directory to another
*
*
* =============================================================================
*
*    First Release : R09
*    Developed for : APAP
*    Developed by  : AVELASCO
*    Date          : 2012/Feb/01
*=======================================================================
* Modifications:
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.FI.CONTROL
    $INSERT I_F.COMPANY
    $INSERT I_F.AC.ENTRY.PARAM
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT


    $INSERT I_RAPID.APP.DEV.COMMON
    $INSERT I_RAPID.APP.DEV.EQUATE
* Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
* Tus End

*
*************************************************************************
*

    GOSUB INITIALISE

    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.FT
    END

*
    IF WERROR.MSG THEN
        PROCESS.GOAHEAD = 0
        OUT.ERR         = WERROR.MSG
    END ELSE

        CALL F.READ(FN.FUNDS.TRANSFER,OUT.RESP,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
        IF NOT(R.FUNDS.TRANSFER) THEN
            OUT.ERR = 'TRANSACTION FAILED'
            CALL F.READ(FN.FUNDS.TRANSFER.NAU,OUT.RESP,R.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU,FT.NAU.ERR)
            IF R.FUNDS.TRANSFER.NAU<FT.RECORD.STATUS> EQ 'INAO' THEN
                OUT.ERR = 'MOVED TO INAO STATUS'
            END
        END
    END

*
RETURN
*
* ==============
PROCESS.FT:
* ---------
*
    COMM.INTERNAL.ACCT = W.CUENTA.CREDITO

    GOSUB ANALYZE.ACC.INFO


    GOSUB ACCT.STATUS.CHECK
    GOSUB MOVE.FUNDS


RETURN

* ================
ACCT.STATUS.CHECK:
* ================

    IF R.PARAMS<12> EQ 'ORANGE' AND NOT(WERROR.MSG) THEN
        IN.ACCT.TYPE = 'CREDIT'
        IN.ACCT.ID   = COMM.CUST.ACCT
        CALL REDO.NOMINA.ACCT.STATUS.CHECK(IN.ACCT.ID,IN.ACCT.TYPE,OUT.ACCT.STATUS)
        WERROR.MSG = OUT.ACCT.STATUS
    END
    IF R.PARAMS<12> EQ 'ORANGEC' AND NOT(WERROR.MSG) THEN
        IN.ACCT.TYPE = 'DEBIT'
        IN.ACCT.ID   =  W.CUENTA.CREDITO
        CALL REDO.NOMINA.ACCT.STATUS.CHECK(IN.ACCT.ID,IN.ACCT.TYPE,OUT.ACCT.STATUS)
        WERROR.MSG = OUT.ACCT.STATUS
    END
RETURN

* ====================
ANALYZE.ACC.INFO:
* ====================
*   Analyze Customer Debit Account
*
    COMM.CUST.ACCT =  R.PARAMS<6>
*
    GOSUB VALID.DEBIT.ACCT
*
*
RETURN
*

* ====================
VALID.DEBIT.ACCT:
* ====================
*
*   Get Currency and balance from account
*
    CALL CACHE.READ(FN.ACCOUNT,COMM.CUST.ACCT,R.ACCOUNT, YER.CTA)
* Tus Start
    R.ECB = ''
    ECB.ERR = ''
    CALL EB.READ.HVT('EB.CONTRACT.BALANCES',COMM.CUST.ACCT,R.ECB,ECB.ERR)       ;* Tus End
    IF YER.CTA THEN
        WERROR.MSG = "AC-AC.REC.MISS":@FM:COMM.CUST.ACCT
    END ELSE
        COMM.CURRENCY = R.ACCOUNT<AC.CURRENCY>
        Y.CUSTOMER    = R.ACCOUNT<AC.CUSTOMER>
        IF Y.CUSTOMER THEN
            YWORK.BALANCE = R.ACCOUNT<Y.POS.LF.ACC,Y.POS.AV.BAL>
            IF F.TOT.AMOUNT GT YWORK.BALANCE THEN
                WERROR.MSG = "EB-Not.enough.BALANCE.in.&.account":@FM:COMM.CUST.ACCT
            END
        END ELSE
*      YWORK.BALANCE  = R.ACCOUNT<AC.WORKING.BALANCE>
*     Tus Start
            YWORK.BALANCE  = R.ECB<ECB.WORKING.BALANCE>
*     Tus End
            IF F.TOT.AMOUNT GT YWORK.BALANCE THEN
                WERROR.MSG = "EB-Not.enough.BALANCE.in.&.account":@FM:COMM.CUST.ACCT
            END

        END
    END
*
RETURN
*

* ===============
MOVE.FUNDS:
* ===============
*
    R.FUNDS.TRANSFER                      = ""
    ADDNL.INFO                            = ""
*
    R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE> = R.PARAMS<13>

    Y.ACC.VALUE = R.PARAMS<6>
    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>   =   Y.ACC.VALUE

    IF COMM.CURRENCY EQ '' THEN
        COMM.CURRENCY = R.COMPANY(EB.COM.LOCAL.CURRENCY)
    END
* Debit will always use a internal account to debit

    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>    = W.CUENTA.CREDITO

    COMM.CURRENCY =R.PARAMS<8>
    R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>   = COMM.CURRENCY

    F.DEBIT.AMOUNT = R.PARAMS<7>
    R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>    = F.DEBIT.AMOUNT

    W.DEBIT.THEIR.REF = R.PARAMS<9>
*    R.FUNDS.TRANSFER<FT.PAYMENT.DETAILS>  = W.DEBIT.THEIR.REF
    R.FUNDS.TRANSFER<FT.LOCAL.REF,Y.L.COMMENTS.POS> = W.DEBIT.THEIR.REF
    R.FUNDS.TRANSFER<FT.ORDERING.BANK>    = 'ORANGE'

*
    COMM.VERSION = R.PARAMS<12>
    IF WERROR.MSG THEN
        COMM.VERSION = 'ORANGERR'
    END ELSE
        COMM.VERSION = R.PARAMS<12>
    END

    ADDNL.INFO<1,1> = COMM.VERSION
    ADDNL.INFO<1,2> = "I"
*
    ADDNL.INFO<2,1>  = "PROCESS"
    ADDNL.INFO<2,2>  = COMM.USER : "/" : COMM.PW
    ADDNL.INFO<2,3>  = ID.COMPANY
    ADDNL.INFO<2,4>  = ""     ;*    Transaction ID
    ADDNL.INFO<2,5>  =  1
    ADDNL.INFO<2,6>  = "0"    ;*   Authorization Number
*
    Y.OFS.STR = DYN.TO.OFS(R.FUNDS.TRANSFER,'FUNDS.TRANSFER',ADDNL.INFO)
    YWORK.CH  = COMM.USER : "//"
    YWORK.NEW = COMM.USER : "/" : COMM.PW : "/"
    CHANGE YWORK.CH TO YWORK.NEW IN Y.OFS.STR
*
    OFS.RESP   = ""
    TXN.COMMIT = ""
    YERROR.POS = 0
    OFS.SOURCE.ID = "TAM.OFS.SRC"
    OFS.MSG.ER = ""

*


    CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE.ID, Y.OFS.STR, OFS.RESP, TXN.COMMIT)

    M.VALIDA = FIELD(OFS.RESP,"/",1)
    OUT.ERR = ""
    OUT.ERR<1> = OFS.RESP
    OUT.RESP<1> = M.VALIDA
    YERROR.POS = INDEX(OFS.RESP,"-1",1)

    IF YERROR.POS GT 0 THEN
        GOSUB FORMAT.MSG.ERR
    END

*
RETURN

* =============
FORMAT.MSG.ERR:
* =============
*
*   Formated msg error
*
    OUT.ERR<1> = "ERROR"
    Y.VAR = FIELD(OFS.RESP,'-1/NO,',2)
    Z = INDEX(Y.VAR,",",1) - 1
    IF Z EQ '-1' THEN
        Z = 50
    END

    OUT.ERR<2> ="ERROR"
    IF Y.VAR NE '' THEN
        OUT.ERR<3>=Y.VAR
    END
*
RETURN
*

*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
* Get THE FIRST DOT
                Y.POS = INDEX(WCONTROL.ID, '.', 1)
                Y.POS -= 1
* Get the Company ID

                Y.INTERFACE = R.PARAMS<5>
                Y.POS += 2
* Get the Company ID
                Y.COMPANY.ID = SUBSTRINGS (WCONTROL.ID, Y.POS, 4)

                IF Y.INTERFACE NE 'ORANGE' THEN
                    PROCESS.GOAHEAD = 0
                    E = "EB-NOT.ORANGE"
                    OUT.ERR = E
                    RETURN
                END

            CASE LOOP.CNT EQ 2

                CALL F.READ(FN.REDO.INTERFACE.PARAM, Y.INTERFACE, R.REDO.INTERFACE.PARAM, F.REDO.INTERFACE.PARAM, Y.ERR)
                IF Y.ERR THEN
                    PROCESS.GOAHEAD = 0
                    E = "EB-PARAMETER.MISSING"
                    CALL ERR
                END

            CASE LOOP.CNT EQ 3
                RIP.USER     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.USER.SIGN.ON>
                RIP.PASSWORD = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.USER.PWD>
                COMM.USER = RIP.USER
                COMM.PW   = RIP.PASSWORD
                RIP.PARAM = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
                RIP.VALUE = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
*
        END CASE
        LOOP.CNT +=1
    REPEAT
*
RETURN

* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD        = 1          ;*No problems
    F.TRANSACTION.ID = R.PARAMS<1>
    F.VAL.TRX.ENT = R.PARAMS<2>
    F.TOT.AMOUNT = R.PARAMS<3>
    WCONTROL.ID = R.PARAMS<4>
    W.INDICADOR.PROCESO = R.PARAMS<10>
    W.CUENTA.CREDITO = R.PARAMS<11>

    Y.ACC.VALUE = ''
    WPARAM.POS  = 1
    Y.COMPANY.ID = ""
    Y.INTERFACE = ""

    FN.TELLER = "F.TELLER"
    F.TELLER = ""

    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM = ""

    FN.AC.ENTRY.PARAM = "F.AC.ENTRY.PARAM"
    F.AC.ENTRY.PARAM = ""

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    R.FUNDS.TRANSFER = ''

    FN.FUNDS.TRANSFER.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER.NAU = ''
    R.FUNDS.TRANSFER.NAU = ''

    WERROR.MSG = ""

    Y.POS.LF.ACC           = AC.LOCAL.REF
    Y.POS.CCY.ACC          = AC.CURRENCY
    Y.POS.AV.BAL           = ""

    LREF.POS = ''
    LREF.APP = 'FUNDS.TRANSFER':@FM:'ACCOUNT'
    LREF.FIELD = 'L.COMMENTS':@FM:'L.AC.AV.BAL'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    Y.L.COMMENTS.POS = LREF.POS<1,1>
    Y.POS.AV.BAL = LREF.POS<2,1>

RETURN
*-----------
OPEN.FILES:
* ---------
*
*   Paragraph that open files
*
*   OPEN  TELLER
    CALL OPF(FN.TELLER,F.TELLER)
*
*   OPEN  ACCOUNT
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
*   OPEN  REDO.IN.PARAM
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
*
*   OPEN  AC.ENTRY.PARAM
    CALL OPF(FN.AC.ENTRY.PARAM,F.AC.ENTRY.PARAM)

    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    CALL OPF(FN.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU)
*
RETURN
*

*-------- END -------

END
