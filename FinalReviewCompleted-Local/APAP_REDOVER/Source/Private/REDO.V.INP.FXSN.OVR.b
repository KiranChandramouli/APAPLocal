* @ValidationCode : MjotOTY2MTQ3OTgwOkNwMTI1MjoxNjgxMjgyNzczOTI5OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:29:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.FXSN.OVR
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Chandra Prakash T
* Program Name  : REDO.V.INP.FXSN.OVR
* ODR NUMBER    : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description   : This Input routine will do a check with the AML table limits and thrown an OVERRIDE only for NON APAP Customer
*                 Also modification on currency rates manually will be raised as an OVERRIDE message
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 08-Jul-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
* 21-Sep-2010      Chandra Prakash T  ODR-2010-09-0014  CR023-Change Request - CURRENCY MARKET and Exchange Rate
* 21-Mar-2011      Sudharsanan S      PACS00034123      Check non apap Customers for AML override msg
* 31-Mar-2011      Sudharsanan S      PACS00052349      Update corresponding Exchange rate based on currency market value specified in REDO.CCY.MKT.FXSN parameter table
* 29-Oct-2011      Pradeep S          PACS00153529      RATES MODIFIED MANUALLY - Override removed for FX
* 22-Dec-2011      Nava L.                              CHECK AML & CHECK USD COINS Overrides - removed for TT
* 29-Jun-2012      Nava L.                              CHECK AML Override - added for TT again. New logic to get APAP and NO APAP CLIENTS.
* 14-MAR-2019      GOPALA KRISHNAN R  PACS00738390      ISSUE FIX
*-----------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,F.READ TO CACHE.READ, IF CONDITION ADDED
*12-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.CURRENCY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.H.FOREX.AML
    $INSERT I_F.REDO.CCY.MKT.FXSN
    $INSERT I_GTS.COMMON
*
    $INSERT I_System
    $INSERT I_REDO.FX.OVR.COMMON
*
    GOSUB OPEN.FILES
    GOSUB GET.LOCAL.REF
    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------------
    FN.REDO.H.FOREX.AML = 'F.REDO.H.FOREX.AML'
    F.REDO.H.FOREX.AML = ''
    CALL OPF(FN.REDO.H.FOREX.AML,F.REDO.H.FOREX.AML)

    FN.REDO.CCY.MKT.FXSN = 'F.REDO.CCY.MKT.FXSN'
    F.REDO.CCY.MKT.FXSN = ''
    CALL OPF(FN.REDO.CCY.MKT.FXSN,F.REDO.CCY.MKT.FXSN)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.USER = 'F.USER'
    F.USER = ''
    CALL OPF(FN.USER,F.USER)

    APAP.STAFF = 0
    FN.CURRENCY = 'F.CURRENCY'

    FN.CUSTOMER.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUSTOMER.L.CU.CIDENT = ''
    CALL OPF(FN.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT)

    FN.CUSTOMER.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUSTOMER.L.CU.RNC = ''
    CALL OPF(FN.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC)

    FN.CUSTOMER.L.CU.PASS.NAT = 'F.CUSTOMER.L.CU.PASS.NAT'
    F.CUSTOMER.L.CU.PASS.NAT = ''
    CALL OPF(FN.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT)




*
RETURN

*----------------------------------------------------------------------------------
GET.LOCAL.REF:
*----------------------------------------------------------------------------------
    APPL.ARR = "FOREX":@FM:"FUNDS.TRANSFER":@FM:"TELLER"
    FIELD.ARR = "L.FX.LEGAL.ID":@FM:"L.FT.LEGAL.ID":@FM:"L.TT.LEGAL.ID"
    FIELD.POS = ""
    CALL MULTI.GET.LOC.REF(APPL.ARR,FIELD.ARR,FIELD.POS)

    L.FX.LEGAL.ID.POS = FIELD.POS<1,1>
    L.FT.LEGAL.ID.POS = FIELD.POS<2,1>
    L.TT.LEGAL.ID.POS = FIELD.POS<3,1>
*
    Y.NO.FXFLG = ''
*
RETURN

*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

    NON.APAP.CUSTOMER = 0
    LCY.TXN.AMOUNT = 0

    R.REDO.CCY.MKT.FXSN = ""
    REDO.CCY.MKT.FXSN.ERR = ""
    CALL CACHE.READ(FN.REDO.CCY.MKT.FXSN,"SYSTEM",R.REDO.CCY.MKT.FXSN,REDO.CCY.MKT.FXSN.ERR)
    CCY.MKT.CODES = R.REDO.CCY.MKT.FXSN<REDO.CMKT.CCY.MKT.CODE>

    BUY.FLAG = 0
    SELL.FLAG = 0

    BEGIN CASE
        CASE APPLICATION EQ 'FOREX'
            GOSUB PROCESS.FOREX
        CASE APPLICATION EQ 'FUNDS.TRANSFER'
            GOSUB PROCESS.FUNDS.TRANSFER
        CASE APPLICATION EQ 'TELLER'
            GOSUB PROCESS.TELLER
    END CASE

RETURN
*----------------------------------------------------------------------------------
PROCESS.FOREX:
*----------------------------------------------------------------------------------
    IF R.NEW(FX.CURRENCY.BOUGHT) NE LCCY THEN
        FCY.TXN.CCY = R.NEW(FX.CURRENCY.BOUGHT)
        FCY.TXN.AMOUNT = R.NEW(FX.AMOUNT.BOUGHT)
        BUY.FLAG = 1
    END ELSE
        FCY.TXN.CCY = R.NEW(FX.CURRENCY.SOLD)
        FCY.TXN.AMOUNT = R.NEW(FX.AMOUNT.SOLD)
        SELL.FLAG = 1
    END
    FX.LEGAL.ID.VAL = ""
    FX.LEGAL.ID.VAL = R.NEW(FX.LOCAL.REF)<1,L.FX.LEGAL.ID.POS>
    CHANGE "." TO @FM IN FX.LEGAL.ID.VAL
    ID.PROOF.TYPE = FX.LEGAL.ID.VAL<1>
    ID.PROOF.NUM = FX.LEGAL.ID.VAL<2>
    TXN.CURR.MKT = R.NEW(FX.CURRENCY.MARKET)
    GOSUB CHECK.NON.APAP.CUS
*GOSUB CHECK.FX.TXN.RATE.CHANGE ;* PACS00153529 - S/E

    IF NON.APAP.CUSTOMER EQ 1 THEN
        GOSUB CHECK.AML.OVERRIDES
    END

RETURN
*----------------------------------------------------------------------------------
PROCESS.FUNDS.TRANSFER:
*----------------------------------------------------------------------------------
    TXN.AMT.DEBITED = R.NEW(FT.AMOUNT.DEBITED)
    TXN.AMT.CREDITED = R.NEW(FT.AMOUNT.CREDITED)
    IF TXN.AMT.DEBITED[1,3] NE LCCY THEN
        FCY.TXN.CCY = TXN.AMT.DEBITED[1,3]
        FCY.TXN.AMOUNT = TXN.AMT.DEBITED[4,99]
    END ELSE
        FCY.TXN.CCY = TXN.AMT.CREDITED[1,3]
        FCY.TXN.AMOUNT = TXN.AMT.CREDITED[4,99]
    END

    FT.LEGAL.ID.VAL = ""
    FT.LEGAL.ID.VAL = R.NEW(FT.LOCAL.REF)<1,L.FT.LEGAL.ID.POS>
    CHANGE "." TO @FM IN FT.LEGAL.ID.VAL
    ID.PROOF.TYPE = FT.LEGAL.ID.VAL<1>
    ID.PROOF.NUM = FT.LEGAL.ID.VAL<2>
    GOSUB CHECK.NON.APAP.CUS
    GOSUB GET.APPLIED.CCY.MKT
    GOSUB CHECK.FT.TXN.RATE.CHANGE
    IF NON.APAP.CUSTOMER EQ 1 THEN
        GOSUB CHECK.AML.OVERRIDES
    END
RETURN
*----------------------------------------------------------------------------------
PROCESS.TELLER:
*----------------------------------------------------------------------------------

* VNL - 2012APR17 - S
*    IF R.NEW(TT.TE.DR.CR.MARKER) EQ "CREDIT" THEN
*        TXN.FLG = "SELL"
*    END ELSE
*        TXN.FLG = "BUY"
*    END
*
    FX.TXN.TYPE = ''
*PACS00052349 - S
    IF R.NEW(TT.TE.CURRENCY.1) NE LCCY THEN
        IF R.NEW(TT.TE.DR.CR.MARKER) EQ 'CREDIT' THEN
            TXN.FLG = "SELL"  ;* SELL type transaction
        END ELSE
            TXN.FLG = "BUY"   ;* BUY type transaction
        END
    END
*PACS00052349 - E
*
    IF R.NEW(TT.TE.CURRENCY.2) NE LCCY THEN
        IF R.NEW(TT.TE.DR.CR.MARKER) EQ 'DEBIT' THEN
            TXN.FLG = "SELL"  ;* SELL type transaction
        END ELSE
            TXN.FLG = "BUY"   ;* BUY type transaction
        END
    END
* VNL - 2012APR17 - E
*
    IF R.NEW(TT.TE.CURRENCY.1) NE LCCY THEN
        FCY.TXN.CCY = R.NEW(TT.TE.CURRENCY.1)
        FCY.TXN.AMOUNT =  R.NEW(TT.TE.AMOUNT.FCY.1)
    END ELSE
        FCY.TXN.CCY= R.NEW(TT.TE.CURRENCY.2)
        FCY.TXN.AMOUNT =  R.NEW(TT.TE.AMOUNT.FCY.2)
    END
*
*GROUP 7 VNL 2011DEC22 - S
*GROUP 7 VNL 2012JUN29 - S
    TT.LEGAL.ID.VAL = ""
    TT.LEGAL.ID.VAL = R.NEW(TT.TE.LOCAL.REF)<1,L.TT.LEGAL.ID.POS>
    CHANGE "." TO @FM IN TT.LEGAL.ID.VAL
    TXN.CURR.MKT = R.NEW(TT.TE.CURR.MARKET.1)
    ID.PROOF.TYPE = TT.LEGAL.ID.VAL<1>
    ID.PROOF.NUM = TT.LEGAL.ID.VAL<2>
*
* GOSUB TYPE.PROOF.CHECK.TT      ;*PACS00738390
    GOSUB CHECK.NON.APAP.CUS.TT
*
    IF NON.APAP.CUSTOMER EQ 1 THEN
        GOSUB CHECK.AML.OVERRIDES
    END
*
*GROUP 7 VNL 2012JUN29 - E
*    GOSUB CHECK.USD.COINS.OVERRIDES
*
*GROUP 7 VNL 2011DEC22 - E
    TXN.CURR.MKT = R.NEW(TT.TE.CURR.MARKET.1)
    GOSUB CHECK.TT.TXN.RATE.CHANGE
*
RETURN

*----------------------------------------------------------------------------------
CHECK.AML.OVERRIDES:
*----------------------------------------------------------------------------------

    R.REDO.H.FOREX.AML = ""
    REDO.H.FOREX.AML.ERR = ""
    CALL CACHE.READ(FN.REDO.H.FOREX.AML,"SYSTEM",R.REDO.H.FOREX.AML,REDO.H.FOREX.AML.ERR)

    IF R.REDO.H.FOREX.AML EQ "" THEN
        ETEXT = "EB-REDO.H.FOREX.AML.REC.MISSING"
        CALL STORE.END.ERROR
        RETURN
    END

    AML.CCY = R.REDO.H.FOREX.AML<FX.AML.AML.CCY>

    IF (FCY.TXN.CCY EQ AML.CCY) AND (FCY.TXN.AMOUNT GT R.REDO.H.FOREX.AML<FX.AML.AMT.LIMIT.FCY>) THEN
        IF V$FUNCTION EQ 'I' THEN
            CURR.NO=DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) + 1
            TEXT = "FXSN.TXN.AMT.EXCEED.AML"
            CALL STORE.OVERRIDE(CURR.NO)
            Y.FX.OVERRIDE.DET<-1> = "FXSN.TXN.AMT.EXCEED.AML"
            RETURN
        END
    END

    IF FCY.TXN.CCY NE AML.CCY THEN
        CCY.MARKET = TXN.CURR.MKT
        SELL.AMT = ""
        DIFF.AMT = ''
        LCCY.AMT = ''
        RET.ERR = ''
        EX.RATE = ''
        CALL EXCHRATE(CCY.MARKET,FCY.TXN.CCY,FCY.TXN.AMOUNT,AML.CCY,SELL.AMT,'',EX.RATE,DIFF.AMT,LCCY.AMT,RET.ERR)

        IF SELL.AMT GT R.REDO.H.FOREX.AML<FX.AML.AMT.LIMIT.FCY> THEN
            IF V$FUNCTION EQ 'I' THEN
                CURR.NO=DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) + 1
                TEXT = "FXSN.TXN.AMT.EXCEED.AML"
                CALL STORE.OVERRIDE(CURR.NO)
                Y.FX.OVERRIDE.DET<-1> = "FXSN.TXN.AMT.EXCEED.AML"
                RETURN
            END
        END
    END
*
RETURN
*
*----------------------------------------------------------------------------------
CHECK.NON.APAP.CUS:
*----------------------------------------------------------------------------------
    BEGIN CASE
        CASE ID.PROOF.TYPE EQ "CIDENT"
            SELECT.COMMAND = "SELECT ":FN.CUSTOMER:" WITH L.CU.CIDENT EQ ":ID.PROOF.NUM
        CASE ID.PROOF.TYPE EQ "RNC"
            SELECT.COMMAND = "SELECT ":FN.CUSTOMER:" WITH L.CU.RNC EQ ":ID.PROOF.NUM
        CASE ID.PROOF.TYPE EQ "PASSPORT"
            SELECT.COMMAND = "SELECT ":FN.CUSTOMER:" WITH LEGAL.ID EQ ":ID.PROOF.NUM
    END CASE

    SELECT.ID = ""
    SELECT.NR = ''
    SELECT.ERR = ''
    CALL EB.READLIST(SELECT.COMMAND,SELECT.ID,'',SELECT.NR,SELECT.ERR)
    CUSTOMER.NO = SELECT.ID<1>
    R.CUSTOMER.REC = ""
    CUSTOMER.ERR = ""
    CALL F.READ(FN.CUSTOMER,CUSTOMER.NO,R.CUSTOMER.REC,F.CUSTOMER,CUSTOMER.ERR)
*PACS00034123 - S
    IF R.CUSTOMER.REC THEN
* CUS.FAX = R.CUSTOMER.REC<EB.CUS.FAX.1>
* R.USER.REC = ""
* USER.ERR = ""
* CALL F.READ(FN.USER,CUS.FAX,R.USER.REC,F.USER,USER.ERR)
*IF R.USER.REC THEN
*   APAP.STAFF = 1
*END
        NON.APAP.CUSTOMER = 0
    END ELSE
        NON.APAP.CUSTOMER = 1
    END
*PACS00034123 - E
RETURN
*
*----------------------------------------------------------------------------------
CHECK.USD.COINS.OVERRIDES:
*----------------------------------------------------------------------------------

*   LCY.TXN.AMOUNT = R.NEW(TT.TE.AMOUNT.LOCAL.1)

    IF R.NEW(TT.TE.CURRENCY.1) EQ "USD" THEN
        TELLER.DENOMS = R.NEW(TT.TE.DENOMINATION)
        TELLER.UNITS = R.NEW(TT.TE.UNIT)

        CHANGE @VM TO @FM IN TELLER.DENOMS
        CHANGE @VM TO @FM IN TELLER.UNITS

        TELLER.DENOMS.TOTAL = DCOUNT(TELLER.DENOMS,@FM)

        LOOP
            REMOVE TT.DENOM FROM TELLER.DENOMS SETTING TT.DENOM.POS
            REMOVE TT.UNIT FROM TELLER.UNITS SETTING TT.UNIT.POS
        WHILE TT.DENOM NE ""
            IF TT.DENOM[4,3] LT 1 AND TT.UNIT GT 0 THEN
                IF V$FUNCTION EQ 'I' THEN
                    CURR.NO=DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) + 1
                    TEXT = "FXSN.USD.COINS.DEP"
                    CALL STORE.OVERRIDE(CURR.NO)
                    Y.FX.OVERRIDE.DET<-1> = "FXSN.USD.COINS.DEP"
                END
            END
        REPEAT

    END

RETURN

*----------------------------------------------------------------------------------
CHECK.FX.TXN.RATE.CHANGE:
*----------------------------------------------------------------------------------

    R.CURRENCY.REC = ""
    CURRENCY.ERR = ""
    CALL CACHE.READ(FN.CURRENCY, FCY.TXN.CCY, R.CURRENCY.REC, CURRENCY.ERR)  ;*R22 AUTO CODE CONVERSION

    CCY.MKTS = R.CURRENCY.REC<EB.CUR.CURRENCY.MARKET>
    LOCATE TXN.CURR.MKT IN CCY.MKTS<1,1> SETTING CURR.MARKET.POS THEN
        IF BUY.FLAG EQ 1 THEN
            EFFECTIVE.RATE = R.CURRENCY.REC<EB.CUR.BUY.RATE,CURR.MARKET.POS>
        END
        IF SELL.FLAG EQ 1 THEN
            EFFECTIVE.RATE = R.CURRENCY.REC<EB.CUR.SELL.RATE,CURR.MARKET.POS>
        END
    END

    BEGIN CASE
        CASE R.NEW(FX.DEAL.TYPE) EQ 'SP' AND (R.NEW(FX.SPOT.RATE) NE EFFECTIVE.RATE)
            IF V$FUNCTION EQ 'I' THEN
                CURR.NO=DCOUNT(R.NEW(FX.OVERRIDE),@VM) + 1
                TEXT = "FXSN.TXN.MODIFIED.RATE"
                CALL STORE.OVERRIDE(CURR.NO)
                Y.FX.OVERRIDE.DET<-1> = "FXSN.TXN.MODIFIED.RATE"
            END
        CASE R.NEW(FX.DEAL.TYPE) EQ 'FW' AND (R.NEW(FX.FORWARD.RATE) NE EFFECTIVE.RATE)
            IF V$FUNCTION EQ 'I' THEN
                CURR.NO=DCOUNT(R.NEW(FX.OVERRIDE),@VM) + 1
                TEXT = "FXSN.TXN.MODIFIED.RATE"
                CALL STORE.OVERRIDE(CURR.NO)
                Y.FX.OVERRIDE.DET<-1> = "FXSN.TXN.MODIFIED.RATE"
            END
    END CASE

RETURN

*----------------------------------------------------------------------------------
CHECK.FT.TXN.RATE.CHANGE:
*----------------------------------------------------------------------------------
    IF R.NEW(FT.DEBIT.CURRENCY) EQ R.NEW(FT.CREDIT.CURRENCY) THEN
        RETURN
    END

    IF R.NEW(FT.DEBIT.CURRENCY) NE LCCY THEN
        TXN.FCY = R.NEW(FT.DEBIT.CURRENCY)
    END ELSE
        TXN.FCY = R.NEW(FT.CREDIT.CURRENCY)
    END

    R.CURRENCY.REC = ""
    CURRENCY.ERR = ""
    CALL CACHE.READ(FN.CURRENCY, TXN.FCY, R.CURRENCY.REC, CURRENCY.ERR)    ;*R22 AUTO CODE CONVERSION
    CCY.MKTS = R.CURRENCY.REC<EB.CUR.CURRENCY.MARKET>
    LOCATE TXN.CURR.MKT IN CCY.MKTS<1,1> SETTING CURR.MARKET.POS THEN
        EFFECTIVE.RATE = R.CURRENCY.REC<EB.CUR.MID.REVAL.RATE,CURR.MARKET.POS>
    END

    IF R.NEW(FT.CUSTOMER.RATE) NE EFFECTIVE.RATE THEN
        IF V$FUNCTION EQ 'I' THEN
            CURR.NO=DCOUNT(R.NEW(FT.OVERRIDE),@VM) + 1
            TEXT = "FXSN.TXN.MODIFIED.RATE"
            CALL STORE.OVERRIDE(CURR.NO)
            Y.FX.OVERRIDE.DET<-1> = "FXSN.TXN.MODIFIED.RATE"
        END
    END

RETURN

*----------------------------------------------------------------------------------
CHECK.TT.TXN.RATE.CHANGE:
*----------------------------------------------------------------------------------
*
    R.CURRENCY.REC = ""
    CURRENCY.ERR = ""
    CALL CACHE.READ(FN.CURRENCY, FCY.TXN.CCY, R.CURRENCY.REC, CURRENCY.ERR)    ;*R22 AUTO CODE CONVERSION

    CCY.CURR.MKTS = R.CURRENCY.REC<EB.CUR.CURRENCY.MARKET>
    LOCATE TXN.CURR.MKT IN CCY.CURR.MKTS<1,1> SETTING TT.CURR.MKT.POS THEN
        IF TXN.FLG EQ 'BUY' THEN
            EFFECTIVE.RATE = R.CURRENCY.REC<EB.CUR.BUY.RATE,TT.CURR.MKT.POS>
        END ELSE
            EFFECTIVE.RATE = R.CURRENCY.REC<EB.CUR.SELL.RATE,TT.CURR.MKT.POS>
        END
    END
    GOSUB GET.NO.FX.TXN
*PACS00052349 - S
    VAR.DEAL.RATE = R.NEW(TT.TE.DEAL.RATE)
    IF NOT(VAR.DEAL.RATE) AND NOT(Y.NO.FXFLG) THEN
        R.NEW(TT.TE.DEAL.RATE) = EFFECTIVE.RATE
    END ELSE
        IF R.NEW(TT.TE.DEAL.RATE) NE "" AND R.NEW(TT.TE.DEAL.RATE) NE EFFECTIVE.RATE THEN
            IF V$FUNCTION EQ 'I' THEN
                CURR.NO=DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) + 1
                TEXT = "FXSN.TXN.MODIFIED.RATE"
                CALL STORE.OVERRIDE(CURR.NO)
                Y.FX.OVERRIDE.DET<-1> = "FXSN.TXN.MODIFIED.RATE"
            END
        END
    END
* PACS00052349 - E

RETURN
*
*----------------------------------------------------------------------------------
TYPE.PROOF.CHECK.TT:
*----------------------------------------------------------------------------------
*
    Y.WCCA = "NO CLIENTE APAP"
    WCCA   = ""
*
    CALL System.getUserVariables( U.VARNAMES, U.VARVALS )
*
    WWVAR = "CURRENT.VAR.DETAILS" ; YPOS.VAR = ""
    LOCATE WWVAR IN U.VARNAMES SETTING YPOS.VAR THEN
        WCVD = System.getVariable("CURRENT.VAR.DETAILS")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION.START
            WCVD = ""   ;*R22 AUTO CODE CONVERSION
        END   ;*R22 AUTO CODE CONVERSION.END
        WCUS.NUM = FIELD(WCVD,"*",4)
    END
*
    IF NOT(WCUS.NUM) THEN
        WWVAR = "CURRENT.CLIENTE.APAP" ; YPOS.VAR = ""
        LOCATE WWVAR IN U.VARNAMES SETTING YPOS.VAR THEN
            WCCA = System.getVariable("CURRENT.CLIENTE.APAP")
            IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 AUTO CODE CONVERSION.START
                WCCA = ""   ;*R22 AUTO CODE CONVERSION
            END   ;*R22 AUTO CODE CONVERSION.END
        END
    END
*
    IF WCUS.NUM EQ "NA" OR Y.WCCA EQ WCCA THEN
        NON.APAP.CUSTOMER = 1
    END ELSE
        NON.APAP.CUSTOMER = 0
    END
*
RETURN
*
*----------------------------------------------------------------------------------
GET.APPLIED.CCY.MKT:
*----------------------------------------------------------------------------------
    IF APPLICATION EQ "FUNDS.TRANSFER" THEN
        LOCATE "FT.ACCT.TRANSFER" IN CCY.MKT.CODES<1,1> SETTING FT.MKT.POS THEN
            TXN.CURR.MKT = R.REDO.CCY.MKT.FXSN<REDO.CMKT.CCY.MKT,FT.MKT.POS>
        END
    END
RETURN
*
*----------------------------------------------------------------------------------
GET.NO.FX.TXN:
*----------------------------------------------------------------------------------
    IF R.NEW(TT.TE.CURRENCY.1) NE LCCY AND R.NEW(TT.TE.CURRENCY.2) NE LCCY THEN
        Y.NO.FXFLG = '1'
    END
*
RETURN
*
*----------------------------------------------------------------------------------
CHECK.NON.APAP.CUS.TT:
*----------------------------------------------------------------------------------

*    BEGIN CASE
*    CASE ID.PROOF.TYPE EQ "CEDULA"
*        SELECT.COMMAND = "SELECT ":FN.CUSTOMER:" WITH L.CU.CIDENT EQ ":ID.PROOF.NUM
*    CASE ID.PROOF.TYPE EQ "RNC"
*        SELECT.COMMAND = "SELECT ":FN.CUSTOMER:" WITH L.CU.RNC EQ ":ID.PROOF.NUM
*    CASE ID.PROOF.TYPE EQ "PASAPORTE"
*        SELECT.COMMAND = "SELECT ":FN.CUSTOMER:" WITH LEGAL.ID EQ ":ID.PROOF.NUM
*    END CASE

    BEGIN CASE
        CASE ID.PROOF.TYPE EQ "CEDULA"
            SELECT.ID = ""
            SELECT.NR = ''
            SELECT.ERR = ''
            SELECT.COMMAND = "SELECT ":FN.CUSTOMER.L.CU.CIDENT:" WITH @ID LIKE ":"'...":ID.PROOF.NUM:"...'"
            CALL EB.READLIST(SELECT.COMMAND,SELECT.ID,'',SELECT.NR,SELECT.ERR)
            CEDULA.ID = SELECT.ID<1>
            CALL F.READ(FN.CUSTOMER.L.CU.CIDENT,CEDULA.ID,R.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT,ERR.CUSTOMER.L.CU.CIDENT)
            CHANGE '*' TO @FM IN R.CUSTOMER.L.CU.CIDENT
            CUSTOMER.NO = R.CUSTOMER.L.CU.CIDENT<2>
        CASE ID.PROOF.TYPE EQ "RNC"
            SELECT.ID = ""
            SELECT.NR = ''
            SELECT.ERR = ''
            SELECT.COMMAND = "SELECT ":FN.CUSTOMER.L.CU.RNC:" WITH @ID LIKE ":"'...":ID.PROOF.NUM:"...'"
            CALL EB.READLIST(SELECT.COMMAND,SELECT.ID,'',SELECT.NR,SELECT.ERR)
            RNC.ID = SELECT.ID<1>
            CALL F.READ(FN.CUSTOMER.L.CU.RNC,RNC.ID,R.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC,ERR.CUSTOMER.L.CU.RNC)
            CHANGE '*' TO @FM IN R.CUSTOMER.L.CU.RNC
            CUSTOMER.NO = R.CUSTOMER.L.CU.RNC<2>
        CASE ID.PROOF.TYPE EQ "PASAPORTE"
            SELECT.ID = ""
            SELECT.NR = ''
            SELECT.ERR = ''
            SELECT.COMMAND = "SELECT ":FN.CUSTOMER.L.CU.PASS.NAT:" WITH @ID LIKE ":"'...":ID.PROOF.NUM:"...'"
            CALL EB.READLIST(SELECT.COMMAND,SELECT.ID,'',SELECT.NR,SELECT.ERR)
            PASAPORTE.ID = SELECT.ID<1>
            CALL F.READ(FN.CUSTOMER.L.CU.PASS.NAT,PASAPORTE.ID,R.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT,ERR.CUSTOMER.L.CU.PASS.NAT)
            CHANGE '*' TO @FM IN R.CUSTOMER.L.CU.PASS.NAT
            CUSTOMER.NO = R.CUSTOMER.L.CU.PASS.NAT<2>
    END CASE

    R.CUSTOMER.REC = ""
    CUSTOMER.ERR = ""
    CALL F.READ(FN.CUSTOMER,CUSTOMER.NO,R.CUSTOMER.REC,F.CUSTOMER,CUSTOMER.ERR)
    IF R.CUSTOMER.REC THEN
        NON.APAP.CUSTOMER = 0
    END ELSE
        NON.APAP.CUSTOMER = 1
    END

RETURN


END
