*---------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-243</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.TAXPAYER.SERVICES(Y.NCF.ID)
*---------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about Sales of Goods and / or Services made by the taxpayer during the fiscal period ended

* Developed By          : Thilak Kumar K
*
* Development Reference : RegN9
*
* Attached To           : Batch - BNK/APAP.B.TAXPAYER.SERVICES
*
* Attached As           : Online Batch Routine to COB
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : Y.NCF.ID -@ID of REDO.NCF.ISSUED application
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00350484          Ashokkumar.V.P                  18/12/2014           Corrected the field values
* PACS00463470          Ashokkumar.V.P                  23/06/2015           Mapping change to display for RNC and Cedula
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT TAM.BP I_REDO.B.TAXPAYER.SERVICES.COMMON
    $INSERT TAM.BP I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_F.REDO.NCF.ISSUED
*
    GOSUB PROCESS
    RETURN

PROCESS:
*-------
    Y.NCF='';Y.MODIFIED.NCF='';Y.ID.TYPE='';Y.ID.NUMBER='';Y.CUSTOMER='';Y.DATE='';Y.CHRG='';Y.TAX='';Y.CNT.CNF=''
    Y.NCF.ACT.FLAG='';Y.MNCF.ACT.FLAG='';Y.ACCOUNT.1='';Y.ACCOUNT.2='';Y.ACCOUNT1.LOC='';Y.ACCOUNT2.LOC=''
    Y.DEBIT.ACCT.NO='';Y.CREDIT.ACCT.NO='';Y.DEBIT.AMT='';Y.CREDIT.AMT='';Y.ITBIS.BILLED='';Y.ITBIS.VAL=''
    Y.CHRG.AMT='';Y.TAX.AMT='';Y.TXN.ID='';Y.ACCOUNT='';Y.TOT.AMT='0';Y.AMOUNT='';Y.ITBIS.VALUE=''
    Y.RNC.LEGAL.ID = ''; Y.IDEN.TYPE = ''; Y.BILL.NUM = ''; Y.BILL.NUM.MOD = ''; Y.DATE =''; Y.FLAG = ''
    Y.ITBIS.VAL = ''; Y.BILL.AMOUNT = ''; TXN.LEN = ''; Y.RNC.LEGAL.ID.1 = ''
*
*    Y.NCF.ID = '4052004.20130614.FT1312208767'
    CALL F.READ(FN.REDO.NCF.ISSUED,Y.NCF.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,Y.NCF.ERR)
    IF R.REDO.NCF.ISSUED NE '' THEN
        Y.TXN.ID  = R.REDO.NCF.ISSUED<ST.IS.TXN.ID>
        TXN.LEN = DCOUNT(Y.TXN.ID,'.')
        IF TXN.LEN GT 1 THEN
            RETURN
        END
        GOSUB GET.NCF.ISSUED
        GOSUB GET.CHRG.AMT
        GOSUB GET.TAX.DETAILS
        GOSUB READ.TRANSACTION
        GOSUB DEBIT.FLG.DTLS
        GOSUB FORM.BODY
    END
    RETURN
*---------------
READ.TRANSACTION:
*----------------
    Y.DEBIT.1='';Y.CREDIT.1=''
    BEGIN CASE
    CASE Y.TXN.ID[1,2] EQ 'TT'
        GOSUB READ.TT
    CASE Y.TXN.ID[1,2] EQ 'FT'
        GOSUB READ.FT
    END CASE
    RETURN
*--------------
GET.NCF.ISSUED:
*--------------
    Y.NCF = R.REDO.NCF.ISSUED<ST.IS.NCF>
    Y.MODIFIED.NCF  = R.REDO.NCF.ISSUED<ST.IS.MODIFIED.NCF>
    Y.ID.TYPE       = R.REDO.NCF.ISSUED<ST.IS.ID.TYPE>
    Y.ID.NUMBER     = R.REDO.NCF.ISSUED<ST.IS.ID.NUMBER>
    Y.CUSTOMER      = R.REDO.NCF.ISSUED<ST.IS.CUSTOMER>
    Y.DATE          = R.REDO.NCF.ISSUED<ST.IS.DATE>
    Y.CHRG          = R.REDO.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>
    Y.TAX           = R.REDO.NCF.ISSUED<ST.IS.TAX.AMOUNT>
    RETURN
*-----------
GET.CHRG.AMT:
*-----------
    IF Y.CHRG EQ '' THEN
        RETURN
    END
    IF NUM(Y.CHRG[1,2]) THEN
        Y.CHRG.AMT = Y.CHRG
    END ELSE
        Y.CHRG.AMT = FIELD(Y.CHRG,' ',2,1)
    END
    RETURN
*--------------
GET.TAX.DETAILS:
*--------------
    IF Y.TAX EQ '' THEN
        RETURN
    END
    IF NUM(Y.TAX[1,2]) THEN
        Y.TAX.AMT = Y.TAX
    END ELSE
        Y.TAX.AMT = FIELD(Y.TAX,' ',2,1)
    END
    Y.ACCOUNT = R.REDO.NCF.ISSUED<ST.IS.ACCOUNT>
    RETURN
*-------------
DEBIT.FLG.DTLS:
*-------------
    IF Y.DEBIT.1 THEN
        Y.NCF.ACT.FLAG  = 'DB'
    END ELSE
        IF Y.CREDIT.1 THEN
            Y.NCF.ACT.FLAG  = 'CR'
        END
    END
    RETURN
*-------
READ.TT:
*-------
    R.TELLER = ''; Y.TL.ERR = ''; TELLER.HERR = ''
    CALL F.READ(FN.TELLER,Y.TXN.ID,R.TELLER,F.TELLER,Y.TL.ERR)
    IF NOT(R.TELLER) THEN
        TXN.ID.HST = Y.TXN.ID
        CALL EB.READ.HISTORY.REC(F.TELLER.HIS,TXN.ID.HST,R.TELLER,TELLER.HERR)
    END
    Y.ACCOUNT.1   = R.TELLER<TT.TE.ACCOUNT.1>
    Y.ACCOUNT.2   = R.TELLER<TT.TE.ACCOUNT.2>
    Y.ITBIS.BILLED   = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
    Y.CREDIT.AMT     = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
    IF Y.ACCOUNT EQ Y.ACCOUNT.1 THEN
        Y.DEBIT.1 = 'DB':Y.ACCOUNT
    END ELSE
        IF Y.ACCOUNT EQ Y.ACCOUNT.2 THEN
            Y.CREDIT.1 = 'CR':Y.ACCOUNT
        END
    END
    RETURN
*------
READ.FT:
*-------
    R.FUNDS.TRANSFER = ''; Y.FT.ERR = ''; FUNDS.TRANSFER.HERR = ''; Y.DEBIT.ACCT.NO = ''
    Y.CREDIT.ACCT.NO = ''; Y.CREDIT.AMT = ''; Y.ITBIS.BILLED = ''; Y.DEBIT.1 = ''; Y.CREDIT.1 = ''
    CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,Y.FT.ERR)
    IF NOT(R.FUNDS.TRANSFER) THEN
        FT.ID.HST = Y.TXN.ID
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,FT.ID.HST,R.FUNDS.TRANSFER,FUNDS.TRANSFER.HERR)
    END
    Y.DEBIT.ACCT.NO  = R.FUNDS.TRANSFER<FT.IN.DEBIT.ACCT.NO>
*        Y.DEBIT.AMT     = R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
    Y.CREDIT.ACCT.NO = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
    Y.CREDIT.AMT     = R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>
    Y.ITBIS.BILLED   = R.FUNDS.TRANSFER<FT.LOCAL.REF,Y.ITBIS.POS>

    IF Y.ACCOUNT EQ Y.DEBIT.ACCT.NO THEN
        Y.DEBIT.1 = 'DB':Y.ACCOUNT
    END ELSE
        IF Y.ACCOUNT EQ Y.CREDIT.ACCT.NO THEN
            Y.CREDIT.1 = 'CR':Y.ACCOUNT
        END
    END
    RETURN

READ.CUST:
**********
    R.CUSTOMER = ''; Y.CUS.ERR = ''; Y.CUST.HIST = ''; Y.CUS.ERRH = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    IF NOT(R.CUSTOMER) THEN
        Y.CUST.HIST = Y.CUSTOMER
        CALL EB.READ.HISTORY.REC(F.CUSTOMER.HST,Y.CUST.HIST,R.CUSTOMER,Y.CUS.ERRH)
    END
    RETURN

*---------
FORM.BODY:
*---------
    GOSUB READ.CUST
    IF NOT(R.CUSTOMER) THEN
        GOSUB GET.CUST.DET
        GOSUB READ.CUST
    END
    IF NOT(R.CUSTOMER) THEN
        RETURN
    END

    IF Y.ID.TYPE EQ 'CEDULA' THEN
        Y.IDEN.TYPE = '2'
    END

    IF Y.ID.TYPE EQ 'RNC' THEN
        Y.IDEN.TYPE = '1'
    END

    BEGIN CASE
    CASE Y.ID.TYPE AND Y.ID.NUMBER
        Y.RNC.LEGAL.ID = Y.ID.NUMBER
    CASE NOT(Y.ID.TYPE)
        GOSUB GET.CUS.DTLS
        GOSUB GET.CUS.CHK.FLDS
*    CASE NOT(Y.ID.TYPE) AND (Y.CUSTOMER EQ "APAP" OR Y.CUSTOMER EQ '')
*        Y.RNC.LEGAL.ID = Y.RCL.APAP.ID
*        Y.IDEN.TYPE = '1'
*    CASE NOT(Y.ID.TYPE) AND Y.CUSTOMER AND NOT(R.CUSTOMER)
*        Y.RNC.LEGAL.ID = Y.CUSTOMER
*        Y.IDEN.TYPE = '3'
    END CASE
    GOSUB GET.CNT.NCF.CHK
    RETURN

GET.CUST.DET:
*************
    ERR.CUSTOMER.L.CU.CIDENT = ''; R.CUSTOMER.L.CU.CIDENT = ''
    CALL F.READ(FN.CUSTOMER.L.CU.CIDENT,Y.ID.NUMBER,R.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT,ERR.CUSTOMER.L.CU.CIDENT)
    IF R.CUSTOMER.L.CU.CIDENT THEN
        Y.CUSTOMER = R.CUSTOMER.L.CU.CIDENT
        GOSUB READ.CUST
        RETURN
    END
    ERR.CUSTOMER.L.CU.RNC = ''; R.CUSTOMER.L.CU.RNC = ''
    CALL F.READ(FN.CUSTOMER.L.CU.RNC,Y.ID.NUMBER,R.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC,ERR.CUSTOMER.L.CU.RNC)
    IF R.CUSTOMER.L.CU.RNC THEN
        Y.CUSTOMER = R.CUSTOMER.L.CU.RNC
        GOSUB READ.CUST
        RETURN
    END
    ERR.CUSTOMER.L.CU.PASS.NAT = ''; R.CUSTOMER.L.CU.PASS.NAT = ''
    CALL F.READ(FN.CUSTOMER.L.CU.PASS.NAT,Y.ID.NUMBER,R.CUSTOMER.L.CU.PASS.NAT,F.CUSTOMER.L.CU.PASS.NAT,ERR.CUSTOMER.L.CU.PASS.NAT)
    IF R.CUSTOMER.L.CU.PASS.NAT THEN
        Y.CUSTOMER = R.CUSTOMER.L.CU.PASS.NAT
        GOSUB READ.CUST
        RETURN
    END
    RETURN

*--------------
GET.CNT.NCF.CHK:
*--------------
    Y.CNT.NCF = DCOUNT(Y.NCF,VM)
    IF Y.CNT.NCF GE '1' THEN
        Y.COUNT = '1'
        GOSUB GET.NCF.AMOUNT.AND.UPDATATION
    END
    RETURN
*---------------------------
GET.NCF.AMOUNT.AND.UPDATATION:
*----------------------------
    Y.TOT.AMT = ''
    Y.CREDIT.FLAG = ''
    Y.ORG.CHRG.AMT = Y.CHRG.AMT
    Y.ORG.TAX.AMT = Y.TAX.AMT
    LOOP
        REMOVE Y.NCF.ID FROM Y.NCF SETTING NCF.POS
    WHILE Y.NCF.ID:NCF.POS
        GOSUB GET.ITBIS.VALUE
        IF Y.COUNT EQ '1' THEN
            GOSUB GET.TOT.AMT
        END
        IF Y.CHRG.AMT EQ '' AND Y.TAX.AMT EQ '' AND Y.COUNT EQ 1 THEN
            GOSUB FT.AMOUNT
        END ELSE
            GOSUB UPDATE.RCL.REC.AMT
        END
*    END
*   END
*       GOSUB CHK.CNT.TWO.TAX
        Y.COUNT += 1
    REPEAT
    RETURN
*------------
GET.CUS.DTLS:
*------------
    Y.CUS.NAT      = R.CUSTOMER<EB.CUS.NATIONALITY>
    Y.CUS.CIDENT   = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CIDENT.POS>
    Y.CUS.RNC      = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.RNC.POS>
    Y.CUS.FORE     = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.FORE.POS>
    Y.CUS.LEGAL.ID = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    Y.CUS.STREET   = R.CUSTOMER<EB.CUS.STREET>
    Y.CUS.TWN.CNT  = R.CUSTOMER<EB.CUS.TOWN.COUNTRY>
    RETURN

*---------------
GET.CUS.CHK.FLDS:
*---------------
    BEGIN CASE
    CASE Y.CUS.CIDENT NE ''
        Y.RNC.LEGAL.ID = Y.CUS.CIDENT
        Y.IDEN.TYPE = '2'
    CASE Y.CUS.RNC NE ''
        Y.RNC.LEGAL.ID = Y.CUS.RNC
        Y.IDEN.TYPE = '1'
*    CASE Y.CUS.FORE NE ''
*        Y.RNC.LEGAL.ID = Y.CUS.FORE
*        Y.IDEN.TYPE = '3'
*    CASE 1
*        Y.RNC.LEGAL.ID = Y.CUS.NAT:Y.CUS.LEGAL.ID
*        IF Y.CUS.LEGAL.ID THEN
*            Y.IDEN.TYPE = '3'
*        END
    END CASE
    RETURN

*---------------
GET.ITBIS.VALUE:
*--------------
    IF Y.ITBIS.BILLED NE '' THEN
        IF NUM(Y.ITBIS.BILLED[1,2]) THEN
            Y.ITBIS.VALUE = Y.ITBIS.BILLED
        END ELSE
            Y.ITBIS.VALUE = FIELD(Y.ITBIS.BILLED,' ',2,1)
        END
    END
    Y.BILL.NUM = Y.NCF.ID
    IF Y.MODIFIED.NCF NE '' THEN
        Y.BILL.NUM.MOD = Y.MODIFIED.NCF
    END
    RETURN
*--------------
CHK.CNT.TWO.TAX:
*--------------
    IF Y.COUNT EQ '2' THEN
        IF Y.TAX.AMT NE '' THEN
            Y.BILL.AMOUNT = Y.TAX.AMT
            GOSUB MAP.RCL.REC
        END
        GOSUB FT.AMOUNT
    END
    RETURN
*---------
FT.AMOUNT:
*---------
    IF Y.ITBIS.VALUE NE '' AND Y.AMOUNT NE '' THEN
        Y.ITBIS.VAL   = Y.ITBIS.VALUE
        Y.BILL.AMOUNT = Y.CREDIT.AMT
        GOSUB MAP.RCL.REC
    END
    RETURN

*-----------
GET.TOT.AMT:
*-----------
    Y.AMOUNT = ''
    IF Y.ORG.CHRG.AMT EQ '' AND Y.ORG.TAX.AMT EQ '' AND Y.COUNT EQ 1 AND Y.ITBIS.VALUE THEN
        Y.AMOUNT = Y.CREDIT.AMT
    END ELSE
        IF (Y.ORG.CHRG.AMT EQ '' OR Y.ORG.TAX.AMT EQ '') AND Y.CNT.NCF EQ 2 AND Y.ITBIS.VALUE THEN
            Y.AMOUNT = Y.CREDIT.AMT
        END
    END
    IF Y.MNCF.ACT.FLAG NE '' THEN
        IF Y.NCF.ACT.FLAG NE Y.MNCF.ACT.FLAG THEN
            Y.TOT.AMT = Y.AMOUNT+Y.ORG.CHRG.AMT+Y.ORG.TAX.AMT
        END ELSE
            Y.TOT.AMT = Y.AMOUNT+(Y.ORG.CHRG.AMT-Y.ORG.TAX.AMT)
        END
    END ELSE
        Y.TOT.AMT = Y.AMOUNT+Y.ORG.CHRG.AMT+Y.ORG.TAX.AMT
    END
*    IF Y.CNT.NCF EQ '2' AND Y.TAX.AMT EQ '' OR Y.CHRG.AMT EQ '' THEN
*       Y.AMOUNT   = Y.CREDIT.AMT
*      Y.TOT.AMT += Y.AMOUNT
* END
    RETURN
*-----------
MAP.RCL.REC:
*-----------
*
    IF NOT(Y.RNC.LEGAL.ID) THEN
        RETURN
    END
    Y.RNC.LEGAL.ID.1 = TRIM(Y.RNC.LEGAL.ID,'-','A')
    C$SPARE(451) = Y.RNC.LEGAL.ID.1
    C$SPARE(452) = Y.IDEN.TYPE
    C$SPARE(453) = Y.BILL.NUM
    C$SPARE(454) = Y.BILL.NUM.MOD
    C$SPARE(455) = Y.DATE
    C$SPARE(456) = Y.ITBIS.VAL
    C$SPARE(457) = Y.BILL.AMOUNT
    MAP.FMT = "MAP"
    ID.RCON.L = "REDO.RCL.REGN9"
    APP = FN.REDO.NCF.ISSUED
    R.APP = R.REDO.NCF.ISSUED
    R.RETURN.MSG = ''
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    IF NOT(Y.FLAG) THEN
*    IF Y.COUNT EQ '1' THEN
        Y.ARRAY = Y.TOT.AMT:"*":R.RETURN.MSG
        Y.FLAG = 'Y'
    END ELSE
        Y.ARRAY = '0':"*":R.RETURN.MSG
    END
    IF Y.ARRAY THEN
        WRITESEQ Y.ARRAY APPEND TO SEQ.PTR ELSE
            Y.ERR.MSG = "Unable to Write '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
    RETURN
*------------------
UPDATE.RCL.REC.AMT:
*-----------------
! send credit amount if NCF count is more than 1 but charge/tax amount is missing
    IF (Y.ORG.CHRG.AMT EQ '' OR Y.ORG.TAX.AMT EQ '') AND Y.COUNT GT 1 THEN
        IF NOT(Y.CREDIT.FLAG) THEN
*            Y.AMOUNT = Y.CREDIT.AMT
            GOSUB FT.AMOUNT
            Y.CREDIT.FLAG = 'Y'
        END
    END

    IF Y.CHRG.AMT NE '' THEN
        Y.BILL.AMOUNT = Y.CHRG.AMT
        GOSUB MAP.RCL.REC
        Y.CHRG.AMT = ''
    END ELSE
        IF Y.TAX.AMT NE '' THEN
            Y.BILL.AMOUNT = Y.TAX.AMT
            Y.TAX.AMT = ''
            GOSUB MAP.RCL.REC
        END
    END
*END
    RETURN
*--------------
RAISE.ERR.C.22:
*--------------
    MON.TP    = "13"
    REC.CON   = "REGN9-":Y.NCF.ID:Y.ERR.MSG
    DESC      = "REGN9-":Y.NCF.ID:Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    RETURN
END
