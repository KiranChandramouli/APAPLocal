SUBROUTINE S.REDO.CUS.TXN.APP.EVAL(P.IN.APPLICATION, P.IN.ID.NEW, P.IN.REC.STATUS, P.OUT.RESULT, P.OUT.MODULE)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
*!** Simple SUBROUTINE template
* @author:    vpanchi@temenos.com
* @stereotype subroutine: Routine
* @package:   REDO.CCRG
*REM Just for compile
*-----------------------------------------------------------------------------
*  Subroutine customer transaction application evaluator
*  This routine must be colocated in the field EVALUATOR.RTN of REDO.CUS.TXN.PARAM application
*  It must evaluate data of AA.ARRANGEMENT.ACTIVITY, MM.MONEY.MARKET, FOREX, SECURITY.MASTER applications.
*  Once evaluated this routine, return the customer asociated  to the contract in procces*
*  Input Param:
*  ------------
*     P.IN.APPLICATION: Associated application ID
*     P.IN.ID.NEW: Process identifier of the contract
*     P.IN.REC.STATUS: Record Status (INAU, RNAU, etc)
*  Output Param:
*  ------------
*     P.OUT.RESULT:
*        1. Customer code associated with the contract process
*        2. Contract Id (optional)
*        3. Related Product
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
*
    $INSERT I_F.LIMIT
*
    $INSERT I_F.MM.MONEY.MARKET
*
    $INSERT I_F.FOREX
*
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SEC.ACC.MASTER
    $INSERT I_F.SECURITY.TRANSFER
    $INSERT I_F.POSITION.TRANSFER
*
    $INSERT I_F.COMPANY
*
    $INSERT I_F.REDO.CUS.TXN.PARAM
    $INSERT I_REDO.CCRG.CONSTANT.COMMON
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN


*---------------------------------------
INITIALISE:
*---------------------------------------
    PROCESS.GOAHEAD            = 1
    Y.ERR                      = ''
    R.AA.ARRANGEMENT.ACTIVITY  = ''
    R.LIMIT                    = ''
    R.MM.MONEY.MARKET          = ''
    R.SECURITY.MASTER          = ''
    R.FOREX                    = ''
    Y.INAU.STATUS              = 'INAU'
    Y.DELIM.CHAR               = ''
    Y.SEC.CODE                 = ''

RETURN


*---------------------------------------
PROCESS:
*---------------------------------------
*
* Process asociated
*
    BEGIN CASE
        CASE P.IN.APPLICATION EQ "AA.ARRANGEMENT.ACTIVITY"
            GOSUB AA.ARRANGEMENT.ACTIVITY
        CASE P.IN.APPLICATION EQ "MM.MONEY.MARKET"
            GOSUB MM.MONEY.MARKET
        CASE P.IN.APPLICATION EQ "FOREX"
            GOSUB FOREX
        CASE P.IN.APPLICATION EQ "SEC.TRADE"
            GOSUB SEC.TRADE
        CASE P.IN.APPLICATION EQ "SECURITY.TRANSFER"
            GOSUB SECURITY.TRANSFER
        CASE P.IN.APPLICATION EQ "POSITION.TRANSFER"
            GOSUB POSITION.TRANSFER
        CASE P.IN.APPLICATION EQ "LIMIT"
            GOSUB LIMIT
    END CASE

RETURN



*---------------------------------------
AA.ARRANGEMENT.ACTIVITY:
*---------------------------------------
*
* Process asociated with AA
*
* Open files AA
    P.OUT.MODULE = 'AA'
    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY  = ''
    IF P.IN.REC.STATUS EQ Y.INAU.STATUS THEN
        FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY$NAU'
    END
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

* Read the AA
    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,P.IN.ID.NEW,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,Y.ERR)

    IF R.AA.ARRANGEMENT.ACTIVITY THEN
        IF R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.MASTER.AAA> NE P.IN.ID.NEW THEN
            RETURN
        END

        IF R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ACTIVITY> NE 'LENDING-NEW-ARRANGEMENT' THEN
            RETURN
        END

* Assign the CUSTOMER ID
        P.OUT.RESULT<1> = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.CUSTOMER>
* Assign the ARRANGEMENT ID
        P.OUT.RESULT<2> = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ARRANGEMENT>
* Assign Mnemonic Module
        P.OUT.RESULT<3> = 'AA'
    END

RETURN



*---------------------------------------
LIMIT:
*---------------------------------------
*
* Process asociated WITH LIMIT
*
* Open files LIMIT
    P.OUT.MODULE = 'LI'
    FN.LIMIT = 'F.LIMIT'
    F.LIMIT  = ''
    IF P.IN.REC.STATUS EQ Y.INAU.STATUS THEN
        FN.LIMIT = 'F.LIMIT$NAU'
    END
    CALL OPF(FN.LIMIT,F.LIMIT)

* Read the limit
    CALL F.READ(FN.LIMIT,P.IN.ID.NEW,R.LIMIT,F.LIMIT,Y.ERR)

    IF R.LIMIT THEN
* Assign liability number, Customer Id, a name it is issued the Limit
* It is no necesary the same to the Customer Id owner of the arrangement
        P.OUT.RESULT<1> = R.LIMIT<LI.LIABILITY.NUMBER>
* Limit ID
        P.OUT.RESULT<2> = P.IN.ID.NEW
* Mnemonic Module
        P.OUT.RESULT<3> = 'LI'
    END
RETURN



*---------------------------------------
MM.MONEY.MARKET:
*---------------------------------------
*
* Process asociated with MM
*
* Open files MM
    P.OUT.MODULE = 'MM'
    FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET'
    F.MM.MONEY.MARKET  = ''

    IF P.IN.REC.STATUS EQ Y.INAU.STATUS THEN
        FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET$NAU'
    END
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)

    CALL F.READ(FN.MM.MONEY.MARKET,P.IN.ID.NEW,R.MM.MONEY.MARKET,F.MM.MONEY.MARKET,Y.ERR)
    IF R.MM.MONEY.MARKET THEN
* Customer Id
        P.OUT.RESULT<1> = R.MM.MONEY.MARKET<MM.CUSTOMER.ID>
* Contract Numer
        P.OUT.RESULT<2> = P.IN.ID.NEW
* Mnemonic Module
        P.OUT.RESULT<3> = 'MM'
    END

RETURN



*---------------------------------------
FOREX:
*---------------------------------------
*
* Process asociated with FOREX
*
* Open files FX
    P.OUT.MODULE = 'FX'
    FN.FOREX = 'F.FOREX'
    F.FOREX = ''

    IF P.IN.REC.STATUS EQ Y.INAU.STATUS THEN
        FN.FOREX = 'F.FOREX$NAU'
    END
    CALL OPF(FN.FOREX,F.FOREX)

    CALL F.READ(FN.FOREX,P.IN.ID.NEW,R.FOREX,F.FOREX,Y.ERR)
    IF R.FOREX THEN
* Assign counterparty
        P.OUT.RESULT<1> = R.FOREX<FX.COUNTERPARTY>
* Assign Contract ID
        P.OUT.RESULT<2> = P.IN.ID.NEW
* Mnemonic Module
        P.OUT.RESULT<3> = 'FX'
    END

RETURN



*---------------------------------------
SEC.TRADE:
*---------------------------------------
*
* Process asociated with SECURITY
*
* Open Files
    P.OUT.MODULE='SC':'VM'
    GOSUB OPEN.FILE.SC

* Get Portfolio
    R.SEC.TRADE = ''
    YERR        = ''
    CALL F.READ(FN.SEC.TRADE,P.IN.ID.NEW,R.SEC.TRADE,F.SEC.TRADE,YERR)

    Y.PORTFOLIO     = R.SEC.TRADE<SC.SBS.CUST.SEC.ACC>
    Y.SECURITY.CODE = R.SEC.TRADE<SC.SBS.SECURITY.CODE>

* Validate Portfolio
    GOSUB VALIDATE.PORTFOLIO

RETURN




*---------------------------------------
SECURITY.TRANSFER:
*---------------------------------------
*
* Process asociated with SECURITY
*
* Open Files
    P.OUT.MODULE='SC':'VM'
    GOSUB OPEN.FILE.SC

* Get Record SECURITY.TRANSFER
    R.SECURITY.TRANSFER = ''
    YERR = ''
    CALL F.READ(FN.SECURITY.TRANSFER,P.IN.ID.NEW,R.SECURITY.TRANSFER,F.SECURITY.TRANSFER,YERR)

    Y.PORTFOLIO     = R.SECURITY.TRANSFER<SC.STR.SECURITY.ACC>
    Y.SECURITY.CODE = R.SECURITY.TRANSFER<SC.STR.SECURITY.NO>

* Validate Portfolio
    GOSUB VALIDATE.PORTFOLIO

RETURN




*---------------------------------------
POSITION.TRANSFER:
*---------------------------------------
*
* Process asociated with SECURITY
*
    P.OUT.MODULE='SC':'VM'
* Open Files
    GOSUB OPEN.FILE.SC

* Get Record POSITION.TRANSFER
    R.POSITION.TRANSFER = ''
    YERR = ''
    CALL CACHE.READ(FN.POSITION.TRANSFER, POSITION.TRANSFER.ID, R.POSITION.TRANSFER, YERR)

    Y.PORTFOLIO  = R.SECURITY.TRANSFER<SC.PST.SEC.ACCT.TO>
    Y.SEC.CODE   = R.SECURITY.TRANSFER<SC.PST.SECURITY.CODE>
    Y.SEC.CODE   = CHANGE(Y.SEC.CODE,@SM,@FM)


* Only transfer between portfolios
    IF Y.PORTFOLIO THEN
        Y.COUNT.SC      = DCOUNT(Y.SEC.CODE,@FM)
* For every security code
        FOR I.VAR = 1 TO Y.COUNT.SC
            Y.SECURITY.CODE = Y.SEC.CODE<I.VAR>
            Y.DELIM.CHAR    = 'VM'
* Validate Portfolio
            GOSUB VALIDATE.PORTFOLIO
        NEXT I.VAR
    END

RETURN



*---------------------------------------
VALIDATE.PORTFOLIO:
*---------------------------------------

* Validate the Portfolio is Owner or no
    R.SEC.ACC.MASTER  = ''
    YERR = ''
    CALL F.READ(FN.SEC.ACC.MASTER,Y.PORTFOLIO,R.SEC.ACC.MASTER,F.SEC.ACC.MASTER,YERR)
    Y.DEALER.BOOK  =  R.SEC.ACC.MASTER<SC.SAM.DEALER.BOOK>

* Owner Portfolio
    IF Y.DEALER.BOOK THEN
* Get ISSUER from SECURITY.MASTER to the COMPANY in process
        Y.BOND.OR.SHARE = ''
        CALL F.READ(FN.SECURITY.MASTER,Y.SECURITY.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,Y.ERR)

        IF R.SECURITY.MASTER THEN
* Get Issuer
            Y.COM.MNE = R.COMPANY(EB.COM.MNEMONIC)
            LOCATE Y.COM.MNE IN R.SECURITY.MASTER<SC.SCM.CUS.COMPANY,1> SETTING Y.POS THEN
                P.OUT.RESULT<1> := R.SECURITY.MASTER<SC.SCM.ISSUER,Y.POS>:Y.DELIM.CHAR
            END
* Bond an share
            Y.BOND.OR.SHARE = R.SECURITY.MASTER<SC.SCM.BOND.OR.SHARE>
            P.OUT.RESULT<2> := Y.PORTFOLIO : '.' : Y.SECURITY.CODE : '.' : Y.BOND.OR.SHARE:Y.DELIM.CHAR
* Mnemonic Module
            P.OUT.RESULT<3> := 'SC':Y.DELIM.CHAR
        END
    END

RETURN



*---------------------------------------
OPEN.FILE.SC:
*---------------------------------------
*
* Open file process OPEN.FILE.SC
*
* Open File SEC.TRADE
    FN.SEC.TRADE = 'F.SEC.TRADE'
    F.SEC.TRADE  = ''

    IF P.IN.REC.STATUS EQ Y.INAU.STATUS THEN
        FN.SEC.TRADE = 'F.SEC.TRADE$NAU'
    END
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)


* Open file SEC.ACC.MASTER
    FN.SEC.ACC.MASTER = 'F.SEC.ACC.MASTER'
    F.SEC.ACC.MASTER  = ''
    CALL OPF(FN.SEC.ACC.MASTER,F.SEC.ACC.MASTER)


* Open file SECURITY.MASTER, To save data in the  SEC.TRADE application, SECURITY.MASTER application must be authorized.
    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER  = ''
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)


* Open file SECURITY.TRANSFER
    FN.SECURITY.TRANSFER = 'F.SECURITY.TRANSFER'
    F.SECURITY.TRANSFER  = ''
    IF P.IN.REC.STATUS EQ Y.INAU.STATUS THEN
        FN.SECURITY.TRANSFER = 'F.SECURITY.TRANSFER$NAU'
    END
    CALL OPF(FN.SECURITY.TRANSFER,F.SECURITY.TRANSFER)


* Open file POSITION.TRANSFER
    FN.POSITION.TRANSFER = 'F.POSITION.TRANSFER'
    F.POSITION.TRANSFER  = ''
    IF P.IN.REC.STATUS EQ Y.INAU.STATUS THEN
        FN.SECURITY.TRANSFER = 'F.SECURITY.TRANSFER$NAU'
    END
    CALL OPF(FN.POSITION.TRANSFER,F.POSITION.TRANSFER)

RETURN


END
