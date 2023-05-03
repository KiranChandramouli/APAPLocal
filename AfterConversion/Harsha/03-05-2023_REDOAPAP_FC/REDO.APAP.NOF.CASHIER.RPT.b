* @ValidationCode : MjoxNjIyODAwMjk6Q3AxMjUyOjE2ODI1MDI2NTk0ODA6SVRTUzotMTotMToxMDIxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Apr 2023 15:20:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1021
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.CASHIER.RPT(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASHIER.RPT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASHIER.RPT is an No-file enquiry routine, this routine is used to
*                    extract data from relevant files so as to display in the TRANSACTIONS BY CASHIER report.
*Linked With       : Enquiry - REDO.TELLER.CASHIER.REPORT

*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Output array for display
*Files  Used       : REDO.H.TELLER.TXN.CODES          As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 08 Mar 2011       Ganesh R                     ODR-2011-04-0007           Initial Creation
* 04 Apr 2015       Ashokkumar.V.P               PACS00311265               fixing the report
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM , SM to @SM, F.READ to CACHE.READ
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.USER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.REDO.H.TELLER.TXN.CODES

    GOSUB INIT
    GOSUB GET.MULTI.LOC.REF
    GOSUB READ.REDO.H.TELLER.TXN.CODES
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)

    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER  = ''
    CALL OPF(FN.TELLER.USER,F.TELLER.USER)

    FN.REDO.H.TELLER.TXN.CODES = 'F.REDO.H.TELLER.TXN.CODES'
    F.REDO.H.TELLER.TXN.CODES  = ''
    CALL OPF(FN.REDO.H.TELLER.TXN.CODES,F.REDO.H.TELLER.TXN.CODES)
    REDO.H.TELLER.TXN.CODES.ID = 'SYSTEM'

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'; F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'; F.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)
RETURN

PROCESS:
********
*Getting the value of Teller ID and forming the select command
    LOCATE 'TELLER.ID' IN D.FIELDS<1> SETTING Y.TEL.1.POS  THEN
        Y.TEL.1 = D.RANGE.AND.VALUE<Y.TEL.1.POS>
    END
    LOCATE 'CURRENCY' IN D.FIELDS<1> SETTING Y.CCY.POS  THEN
        Y.CCY   = D.RANGE.AND.VALUE<Y.CCY.POS>
    END

    TELL.ID.ERR = ''; R.TELLER.ID = ''; YTILL.USER = ''; Y.TELLER.USER = ''
    CALL CACHE.READ(FN.TELLER.ID,Y.TEL.1,R.TELLER.ID,TELL.ID.ERR)
    YTILL.USER = R.TELLER.ID<TT.TID.USER>

    SEL.FT.CMD = ''; SEL.LIST.FT = ''; NO.OF.REC.FT = ''; SEL.ERR.FT = ''
    SEL.CMD = ''; SEL.LIST = ''; NO.REC = ''; RET.ERR = ''; YTOT.SEL.LST = ''
    IF NOT(Y.CCY) THEN
        SEL.CMD = "SSELECT ":FN.TELLER:" WITH TELLER.ID.1 EQ ":Y.TEL.1:" OR TELLER.ID.2 EQ ":Y.TEL.1:" BY CURRENCY.1"
        SEL.FT.CMD = 'SSELECT ':FN.FUNDS.TRANSFER:' WITH INPUTTER LIKE ...':YTILL.USER:'...'
    END ELSE
        SEL.CMD = "SSELECT ":FN.TELLER:" WITH (TELLER.ID.1 EQ ":Y.TEL.1:" OR TELLER.ID.2 EQ ":Y.TEL.1:") AND (CURRENCY.1 EQ ":Y.CCY:" OR CURRENCY.2 EQ ":Y.CCY:") BY CURRENCY.1"
        SEL.FT.CMD = 'SSELECT ':FN.FUNDS.TRANSFER:' WITH INPUTTER LIKE ...':YTILL.USER:'... AND (DEBIT.CURRENCY EQ ':Y.CCY:' OR CREDIT.CURRENCY EQ ':Y.CCY:')'
    END
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,RET.ERR)
    CALL EB.READLIST(SEL.FT.CMD,SEL.LIST.FT,'',NO.OF.REC.FT,SEL.ERR.FT)
    YTOT.SEL.LST = SEL.LIST:@FM:SEL.LIST.FT

    CALL F.READ(FN.TELLER.USER,OPERATOR,R.TELLER.USER,F.TELLER.USER,USER.ERR)
    Y.CUR.TELL.ID = R.TELLER.USER<1>
    Y.TELLER.USER = R.USER<EB.USE.USER.NAME>

    LOOP
        REMOVE TT.ID FROM YTOT.SEL.LST SETTING TT.POS
    WHILE TT.ID:TT.POS
        IF TT.ID[1,2] EQ 'TT' THEN
            GOSUB PROCESS1
            GOSUB FORM.OUT.ARRAY.TT
        END
        IF TT.ID[1,2] EQ 'FT' THEN
            GOSUB PROCESS.FT
            GOSUB FORM.OUT.ARRAY.FT
        END
    REPEAT
RETURN

PROCESS1:
*********
*Reading the Teller Table and getting the Appropiate Values
    Y.FLAG = ''; Y.CUS.FLAG = ''
    CALL F.READ(FN.TELLER,TT.ID,R.TELLER,F.TELLER,TELL.ERR)
    IF NOT(R.TELLER) THEN
        RETURN
    END
    Y.TELLER.ID        = Y.TEL.1
    VAR.TELLER.ID.1    = R.TELLER<TT.TE.TELLER.ID.1>
    VAR.TELLER.ID.2    = R.TELLER<TT.TE.TELLER.ID.2>
    Y.TELLER.REF       = TT.ID
    Y.TELLER.TYPE      = R.TELLER<TT.TE.TRANSACTION.CODE>
    GOSUB GET.TELLER.TYPE
    GOSUB PROCESS.2
RETURN

PROCESS.2:
**********
    Y.GET.LANG         = R.USER<EB.USE.LANGUAGE>
    Y.TELLER.OVERRIDE  = R.TELLER<TT.TE.OVERRIDE,1>
    Y.DR.CR.MARKER     = R.TELLER<TT.TE.DR.CR.MARKER>
*    Y.TELLER.OVERRIDE  = R.TELLER<TT.TID.OVERRIDE>
    GOSUB GET.OVERRIDE.AUTH
    Y.INPUTTER         = R.TELLER<TT.TE.INPUTTER>
    Y.INPUTTER         = FIELD(Y.INPUTTER,'_',2)
    Y.AUTHORISER       = R.TELLER<TT.TE.AUTHORISER>
    Y.AUTHORISER       = FIELD(Y.AUTHORISER,'_',2)
    Y.GET.CURRENCY.1   = R.TELLER<TT.TE.CURRENCY.1>
    Y.GET.CURRENCY.2   = R.TELLER<TT.TE.CURRENCY.2>
    GOSUB PROCESS.3
RETURN

PROCESS.3:
**********
    Y.TELLER.DATE      = R.TELLER<TT.TE.VALUE.DATE.1>
    Y.COMM.CHG.AMT     = R.TELLER<TT.TE.CHRG.AMT.LOCAL>
    Y.COMM.CHG.CODE    = R.TELLER<TT.TE.CHARGE.CODE>
    IF NOT(Y.COMM.CHG.AMT) THEN
        Y.COMM.CHG.AMT     = R.TELLER<TT.TE.CHRG.AMT.FCCY>
    END

    IF Y.GET.CURRENCY.1 EQ LCCY AND Y.GET.CURRENCY.2 EQ LCCY THEN
        IF Y.DR.CR.MARKER EQ 'DEBIT' THEN
            Y.DR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
            Y.CR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.LOCAL.2>
            Y.DR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.1>
            Y.CR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.2>
            Y.CURRENCY.1   = R.TELLER<TT.TE.CURRENCY.1>
            Y.CURRENCY.2   = R.TELLER<TT.TE.CURRENCY.2>
        END ELSE
            Y.CR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
            Y.DR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.LOCAL.2>
            Y.CR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.2>
            Y.DR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.1>
            Y.CURRENCY.1   = R.TELLER<TT.TE.CURRENCY.2>
            Y.CURRENCY.2   = R.TELLER<TT.TE.CURRENCY.1>
        END
    END
    IF Y.GET.CURRENCY.1 NE LCCY AND Y.GET.CURRENCY.2 NE LCCY THEN
        IF Y.DR.CR.MARKER EQ 'DEBIT' THEN
            Y.DR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.FCY.1>
            Y.CR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.FCY.2>
            Y.DR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.1>
            Y.CR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.2>
            Y.CURRENCY.1   = R.TELLER<TT.TE.CURRENCY.1>
            Y.CURRENCY.2   = R.TELLER<TT.TE.CURRENCY.2>
        END ELSE
            Y.CR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.FCY.1>
            Y.DR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.FCY.2>
            Y.DR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.2>
            Y.CR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.1>
            Y.CURRENCY.1   = R.TELLER<TT.TE.CURRENCY.2>
            Y.CURRENCY.2   = R.TELLER<TT.TE.CURRENCY.1>
        END
    END
    IF Y.GET.CURRENCY.1 EQ LCCY AND Y.GET.CURRENCY.2 NE LCCY THEN
        IF Y.DR.CR.MARKER EQ 'DEBIT' THEN
            Y.DR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
            Y.CR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.FCY.2>
            Y.DR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.1>
            Y.CR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.2>
            Y.CURRENCY.1   = R.TELLER<TT.TE.CURRENCY.1>
            Y.CURRENCY.2   = R.TELLER<TT.TE.CURRENCY.2>
        END ELSE
            Y.CR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
            Y.DR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.FCY.2>
            Y.DR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.2>
            Y.CR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.1>
            Y.CURRENCY.1   = R.TELLER<TT.TE.CURRENCY.2>
            Y.CURRENCY.2   = R.TELLER<TT.TE.CURRENCY.1>
        END
    END
    IF Y.GET.CURRENCY.1 NE LCCY AND Y.GET.CURRENCY.2 EQ LCCY THEN
        IF Y.DR.CR.MARKER EQ 'DEBIT' THEN
            Y.DR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.FCY.1>
            Y.CR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.LOCAL.2>
            Y.DR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.1>
            Y.CR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.2>
            Y.CURRENCY.1   = R.TELLER<TT.TE.CURRENCY.1>
            Y.CURRENCY.2   = R.TELLER<TT.TE.CURRENCY.2>
        END ELSE
            Y.CR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.FCY.1>
            Y.DR.AMOUNT    = R.TELLER<TT.TE.AMOUNT.LOCAL.2>
            Y.DR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.1>
            Y.CR.ACCOUNT   = R.TELLER<TT.TE.ACCOUNT.2>
            Y.CURRENCY.1   = R.TELLER<TT.TE.CURRENCY.2>
            Y.CURRENCY.2   = R.TELLER<TT.TE.CURRENCY.1>
        END
    END
RETURN

FORM.OUT.ARRAY.TT:
******************
*Form Final Array
    Y.OUT.ARRAY<-1> = Y.TELLER.ID:'$':Y.TELLER.USER:'$':Y.TELLER.DATE:'$':Y.TELLER.REF:'$':Y.TELLER.TYPE:'$':Y.TELLER.DESC:'$':Y.DR.ACCOUNT:'$':Y.CR.ACCOUNT:'$':Y.CURRENCY.1:'$':Y.CURRENCY.2:'$':Y.DR.AMOUNT:'$':Y.CR.AMOUNT:'$':Y.COMM.CHG.CODE:'$':Y.COMM.CHG.AMT:'$':YOVERRIDE:'$':Y.INPUTTER:'$':Y.AUTHORISER:'$':Y.CUR.TELL.ID
RETURN

PROCESS.FT:
***********
    Y.FT.DATE = ''; Y.FT.TYPE = ''; Y.FT.DESC = ''; Y.DR.ACCOUNT = ''; Y.CR.ACCOUNT = ''; Y.CURRENCY.1 = '';
    Y.CURRENCY.2 = ''; Y.DR.AMOUNT = ''; Y.CR.AMOUNT = ''; Y.COMM.CHG.CODE = ''; Y.COMM.CHG.AMT = '';
    Y.FT.OVERRIDE = ''; Y.INPUTTER = ''; Y.AUTHORISER = ''

    ERR.FT = ''; R.FUNDS.TRANSFER = ''
    CALL F.READ(FN.FUNDS.TRANSFER,TT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,ERR.FT)
    IF NOT(R.FUNDS.TRANSFER) THEN
        RETURN
    END
    Y.FT.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
    ERR.FTTC = ''; R.FT.TXN.TYPE.CONDITION = ''
    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION,Y.FT.TYPE,R.FT.TXN.TYPE.CONDITION,ERR.FTTC)
    Y.FT.DESC = R.FT.TXN.TYPE.CONDITION<FT6.DESCRIPTION>

    Y.DR.ACCOUNT = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
    Y.CR.ACCOUNT = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>
    Y.CURRENCY.1 = R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>
    IF NOT(Y.CURRENCY.1) THEN
        Y.CURRENCY.1 = LCCY
    END
    Y.CURRENCY.2 = R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>
    IF NOT(Y.CURRENCY.2) THEN
        Y.CURRENCY.2 = LCCY
    END
    Y.DR.AMOUNT = R.FUNDS.TRANSFER<FT.AMOUNT.DEBITED>[4,99]
    Y.CR.AMOUNT = R.FUNDS.TRANSFER<FT.AMOUNT.CREDITED>[4,99]
    Y.FT.DATE = R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>
    Y.COMM.CHG.CODE = R.FUNDS.TRANSFER<FT.CHARGE.CODE>
    Y.COMM.CHG.AMT = R.FUNDS.TRANSFER<FT.TOTAL.CHARGE.AMOUNT>[4,99]
    Y.FT.OVERRIDE = R.FUNDS.TRANSFER<FT.OVERRIDE,1>
    GOSUB GET.OVERRIDE.AUTH
    Y.AUTHORISER = R.FUNDS.TRANSFER<FT.AUTHORISER>
    Y.AUTHORISER       = FIELD(Y.AUTHORISER,'_',2)
    Y.INPUTTER = R.FUNDS.TRANSFER<FT.INPUTTER>
    Y.INPUTTER         = FIELD(Y.INPUTTER,'_',2)
RETURN

FORM.OUT.ARRAY.FT:
******************
    Y.OUT.ARRAY<-1> = Y.TEL.1:'$':Y.TELLER.USER:'$':Y.FT.DATE:'$':TT.ID:'$':Y.FT.TYPE:'$':Y.FT.DESC:'$':Y.DR.ACCOUNT:'$':Y.CR.ACCOUNT:'$':Y.CURRENCY.1:'$':Y.CURRENCY.2:'$':Y.DR.AMOUNT:'$':Y.CR.AMOUNT:'$':Y.COMM.CHG.CODE:'$':Y.COMM.CHG.AMT:'$':YOVERRIDE:'$':Y.INPUTTER:'$':Y.AUTHORISER:'$':Y.CUR.TELL.ID
RETURN

GET.TELLER.TYPE:
****************
*Reading the Transaction Table and getting the Description
    TRANS.ERR = ''; R.TRANSACTION = ''; Y.TELLER.DESC = ''
    CALL CACHE.READ(FN.TRANSACTION, Y.TELLER.TYPE, R.TRANSACTION, TRANS.ERR) ;*R22 AUTO CODE CONVERSION
    Y.TELLER.DESC = R.TRANSACTION<TT.TR.DESC,Y.GET.LANG>
    IF NOT(Y.TELLER.DESC) THEN
        Y.TELLER.DESC = R.TRANSACTION<TT.TR.DESC>
    END
RETURN

GET.MULTI.LOC.REF:
******************
*Getting the Local reference Position
    LOC.APPLICATION = 'TELLER'
    LOC.FIELDS      = 'L.TT.CR.ACCT.NO'
    LOC.POS         = ''
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    Y.CCARD.ACCT.NO = LOC.POS<1,1>
RETURN

READ.REDO.H.TELLER.TXN.CODES:
*****************************
    R.REDO.H.TELLER.TXN.CODES  = ''; REDO.H.TELLER.TXN.CODES.ER = ''; Y.TXN.CODE = ''
    CALL CACHE.READ(FN.REDO.H.TELLER.TXN.CODES,REDO.H.TELLER.TXN.CODES.ID,R.REDO.H.TELLER.TXN.CODES,REDO.H.TELLER.TXN.CODES.ER)
    Y.TXN.CODE = R.REDO.H.TELLER.TXN.CODES<TT.TXN.TXN.CODE>
    CHANGE @SM TO @FM IN Y.TXN.CODE
    CHANGE @VM TO @FM IN Y.TXN.CODE
RETURN

GET.OVERRIDE.AUTH:
*================
    R.USER.REC = ''; YOVERRIDE = ''
    IF Y.FT.OVERRIDE THEN
        CHANGE @VM TO @FM IN Y.FT.OVERRIDE
        OVER.CNT = DCOUNT(Y.FT.OVERRIDE,@FM)
        YOVERRIDE = Y.FT.OVERRIDE<OVER.CNT>
        YOVERRIDE = FIELDS(YOVERRIDE,'}',2,99)
        CHANGE '{' TO ' ' IN YOVERRIDE
        CHANGE '}' TO ' ' IN YOVERRIDE
        CHANGE '& ' TO '' IN YOVERRIDE
        CHANGE '~' TO '' IN YOVERRIDE
        CHANGE '\' TO '' IN YOVERRIDE
        CHANGE @SM TO '*' IN YOVERRIDE
    END
RETURN
END
