* @ValidationCode : MjoxMDE0MTk3MDg2OkNwMTI1MjoxNjg0ODU2ODcxMzQwOklUU1M6LTE6LTE6NDEwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 4100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
SUBROUTINE DR.REG.IF02B.EXTRACT.RUN
*-----------------------------------------------------------------------------
* This is a requirement report. The entity require this report with a letter with an unique reference.
* Must be enter a Customer ID or ID card identity as criteria selection like it is working in the version REDO.CREATE.ARRANGEMENT
*-----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 30-Jul-2014     V.P.Ashokkumar      PACS00305219 - Fixed to retrive all forex, MM details for CustomeR

*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   F.READ change to CACHE.READ , VM to @VM , FM to@FM
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------





*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.TRANSACTION
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.LMM.ACTION.CODES
    $INSERT I_F.FOREX
    $INSERT I_F.DR.REG.IF02B.EXTRACT
    $INSERT I_F.RE.CONSOL.SPEC.ENTRY
    $INSERT I_F.RE.TXN.CODE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $USING APAP.LAPAP

*
    OUTPUT.ARR = ''
    GOSUB INIT.PARA
    GOSUB GET.LR.POSN
    IF PROCESS.GO.AHEAD THEN
        GOSUB PROCESS.PARA
    END
*
RETURN
*------------------------------------------------------------------------------------
PROCESS.PARA:
*------------------------------------------------------------------------------------
*
    ID.CARD.IDENTITY = R.NEW(IF02B.ID.CARD.NUMBER)
    CUSTOMER.NO = R.NEW(IF02B.CUSTOMER.NUMBER)
*
    IF ID.CARD.IDENTITY AND CUSTOMER.NO THEN
        E = 'Both Customer ID and ID Card ID should not be entered'
        CALL STORE.END.ERROR
    END
*
    IF ID.CARD.IDENTITY AND CUSTOMER.NO EQ '' THEN
        CALL F.READ(FN.CUSTOMER.L.CU.RNC,ID.CARD.IDENTITY,R.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC,CUSTOMER.L.CU.RNC.ERR)
        IF R.CUSTOMER.L.CU.RNC THEN
            CUSTOMER.NO = FIELD(R.CUSTOMER.L.CU.RNC,'*',2)
        END ELSE
            CALL F.READ(FN.CUSTOMER.L.CU.CIDENT,ID.CARD.IDENTITY,R.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT,CUSTOMER.L.CU.CIDENT.ERR)
            CUSTOMER.NO = FIELD(R.CUSTOMER.L.CU.CIDENT,'*',2)
        END
    END
*
    R.CUSTOMER = ''
    CUSTOMER.ERR = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.NO,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    IF R.CUSTOMER THEN
        GOSUB RUN.CUSTOMER
    END
*
RETURN
*------------------------------------------------------------------------------------
INIT.VARS:
*--------*
*
    SEQ.NUMB = ''
    CIRCULAR.YEAR = ''
    CUST.TYPE = ''
    CUST.ID = ''
    ACC.NUMBER = ''
    MVMT.DESC = ''
    AMOUNT = ''
    MVMT.DATE = ''
    MVMT.TYPE = ''
*
RETURN
*------------------------------------------------------------------------------------
RUN.CUSTOMER:
*-----------*
*
    CUSTOMER.TYPE = R.CUSTOMER
    CALL APAP.LAPAP.drReg213if02GetCustType(CUSTOMER.TYPE,TIPO.CL.POS);*R22 AUTO CODE CONVERSION
    CUST.TYPE = CUSTOMER.TYPE
    CUSTOMER.CODE = ''
    BEGIN CASE
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS> NE ''
            CUSTOMER.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
            CUSTOMER.CODE = CUSTOMER.ID[1,3]:'-':CUSTOMER.ID[4,7]:'-':CUSTOMER.ID[11,1]
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS> NE ''
            CUSTOMER.ID =  R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
            CUSTOMER.CODE = CUSTOMER.ID[1,1]:'-':CUSTOMER.ID[2,2]:'-':CUSTOMER.ID[4,5]:'-':CUSTOMER.ID[9,1]
        CASE R.CUSTOMER<EB.CUS.LOCAL.REF,FOREIGN.POS> NE ''
            CUSTOMER.CODE = R.CUSTOMER<EB.CUS.NATIONALITY>:R.CUSTOMER<EB.CUS.LOCAL.REF,FOREIGN.POS>
        CASE 1
            CUSTOMER.CODE =  R.CUSTOMER<EB.CUS.NATIONALITY>:R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    END CASE

    CUST.ID = CUSTOMER.CODE
    TIPO.CL.POS.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS>
*
    GOSUB GET.USER.VALUES
    GOSUB GET.CUSTOMER.DETAILS
    GOSUB WRITE.TO.FILE
RETURN
*------------------------------------------------------------------------------------
GET.USER.VALUES:
****************
    CALL CACHE.READ(FN.DR.REG.IF02B.EXTRACT,'SYSTEM',R.DR.REG.IF02B.EXTRACT,DR.REG.IF02B.EXTRACT.ERR)
    SEQ.NUMB = R.DR.REG.IF02B.EXTRACT<IF02B.COMMUNC.NUMBER>
    CIRCULAR.YEAR = R.DR.REG.IF02B.EXTRACT<IF02B.COMMUNC.YEAR>
RETURN
*------------------------------------------------------------------------------------
WRITE.TO.FILE:
*------------*
*
    OPEN.ERR = ''
    IF R.CUSTOMER THEN
        EXTRACT.FILE.ID = 'IF02B_':CUSTOMER.NO:'.txt' ;* Parameterise
    END ELSE
        EXTRACT.FILE.ID = 'IF02B_NON.T24.CUS.txt'
    END
**FN.CHK.DIR = '../bnk.interface/REG.REPORTS'
    FN.CHK.DIR = R.NEW(IF02B.EXTRACT.PATH)
    OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE THEN
        DELETESEQ FN.CHK.DIR,EXTRACT.FILE.ID THEN
        END ELSE
            NULL          ;* In case if it exisit DELETE, for Safer side
        END
        OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE THEN
        END ELSE        ;* After DELETE file pointer will be closed, hence reopen the file
            CREATE FV.EXTRACT.FILE THEN
            END ELSE
                OPEN.ERR = 1
            END
        END
    END ELSE
        CREATE FV.EXTRACT.FILE THEN
        END ELSE
            OPEN.ERR = 1
        END
    END

    IF OPEN.ERR THEN
        TEXT = "Unable to Create a File -> ":EXTRACT.FILE.ID
        CALL FATAL.ERROR("DR.REG.IF02B.EXTRACT.RUN")
    END
*
    CNT.OUT.ARR = DCOUNT(OUTPUT.ARR,@FM)
    CTR.OUT.ARR = 1
    LOOP
    WHILE CTR.OUT.ARR LE CNT.OUT.ARR
        R.REC = OUTPUT.ARR<CTR.OUT.ARR>
        CHANGE '*' TO '|' IN R.REC
        CRLF = CHARX(013):CHARX(010)
        CHANGE @FM TO CRLF IN R.REC
        WRITESEQ R.REC TO FV.EXTRACT.FILE THEN
        END ELSE
            NULL
        END
        CTR.OUT.ARR += 1
    REPEAT
*
RETURN
*------------------------------------------------------------------------------------
GET.CUSTOMER.DETAILS:
*---------------------*
*
    GOSUB GET.ACCOUNT.DETAILS
    GOSUB GET.MM.DETAILS
    GOSUB GET.FX.DETAILS
*
RETURN
*------------------------------------------------------------------------------------
GET.ACCOUNT.DETAILS:
*------------------*
*
    R.CUSTOMER.ACCOUNT = ''; CUSTOMER.ACCOUNT.ERR = ''
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.NO,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUSTOMER.ACCOUNT.ERR)
    IF R.CUSTOMER.ACCOUNT THEN
        CUSTOMER.ACCOUNT.CNT = DCOUNT(R.CUSTOMER.ACCOUNT,@FM)
        CUSTOMER.ACCOUNT.CTR = 1
        GOSUB ACCT.PROCESS
    END
RETURN

ACCT.PROCESS:
*************
    LOOP
    WHILE CUSTOMER.ACCOUNT.CTR LE CUSTOMER.ACCOUNT.CNT
        ACCOUNT.VAL = R.CUSTOMER.ACCOUNT<CUSTOMER.ACCOUNT.CTR>
        CALL F.READ(FN.ACCOUNT,ACCOUNT.VAL,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
        GOSUB STMT.PRINT.PROCESS
        CUSTOMER.ACCOUNT.CTR += 1
    REPEAT
RETURN

STMT.PRINT.PROCESS:
*******************
    SE.LIST.GRP = ''
    ACC.NUMBER = ACCOUNT.VAL
    GOSUB ALT.ACCT.VALUE
    IF Y.PREV.ACCOUNT THEN
        ACC.NUMBER = Y.PREV.ACCOUNT
    END
    YDAT = "(FIELD(@ID,'-',2))"
    ENT.DATE = EN.DATE[1,6]:'30'
    SEL.PRT = "SELECT ":FN.STMT.PRINT
    SEL.PRT := " WITH @ID LIKE ":ACCOUNT.VAL:"... AND WITH EVAL":DQUOTE(YDAT):" GE ":ST.DATE:" AND EVAL":DQUOTE(YDAT):" LE ":ENT.DATE
    EXECUTE SEL.PRT RTNLIST PRT.LIST
    SEL.PRT1 = 'QSELECT FBNK.STMT.PRINTED'
    EXECUTE SEL.PRT1 PASSLIST PRT.LIST RTNLIST SE.LIST

    IF SE.LIST THEN
        SE.LIST.GRP<-1> = SE.LIST
    END

    SEL.PRT2 = "SELECT ":FN.STMT.PRINT:" WITH @ID EQ ":ACCOUNT.VAL:"-PASSBOOK"
    EXECUTE SEL.PRT2 RTNLIST PRT.LIST2
    SEL.PRT2 = 'QSELECT FBNK.STMT.PRINTED'
    EXECUTE SEL.PRT2 PASSLIST PRT.LIST2 RTNLIST SE.LIST1
    IF SE.LIST1 THEN
        SE.LIST.GRP<-1> = SE.LIST1
    END

    LOOP
        REMOVE SEL.ID FROM SE.LIST.GRP SETTING POSN
    WHILE SEL.ID:POSN

        STMT.ENT.ERR = ''; R.ENT.REC = ''; AMOUNT = ''; AMOUNT = ''
        MVMT.DATE = ''
        CALL F.READ(FN.STMT.ENTRY,SEL.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENT.ERR)
        TXN.CODE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
        MVMT.DATE = R.STMT.ENTRY<AC.STE.BOOKING.DATE>
        YMVMT.DATE = ''
        YMVMT.DATE = MVMT.DATE
        IF MVMT.DATE THEN
            MVMT.DATE = MVMT.DATE[7,2]:'/':MVMT.DATE[5,2]:'/':MVMT.DATE[1,4]
        END
        AMOUNT.LCY = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
        AMOUNT = ABS(AMOUNT.LCY)
        GOSUB READ.TRANSACTION
        IF AMOUNT.LCY GT 0 THEN
            MVMT.TYPE = 'CR'
        END ELSE
            MVMT.TYPE = 'DR'
        END
        IF (YMVMT.DATE GE ST.DATE AND YMVMT.DATE LE EN.DATE) THEN
            GOSUB FMT.FLDS
            OUTPUT.ARR<-1> = SEQ.NUMB:'*':CIRCULAR.YEAR:'*':CUST.TYPE:'*':CUST.ID:'*':ACC.NUMBER:'*':MVMT.DESC:'*':AMOUNT:'*':MVMT.DATE:'*':MVMT.TYPE
        END
    REPEAT
RETURN

ALT.ACCT.VALUE:
***************
    Y.ALT.ACCT.TYPE = ''; Y.ALT.ACCT.ID = ''; Y.PREV.ACCOUNT = ''
    Y.ALT.ACCT.TYPE=R.ACCOUNT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID=R.ACCOUNT<AC.ALT.ACCT.ID>
    LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
        Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
    END
RETURN

GET.MM.DETAILS:
*-------------*
*
    R.LMM.CUSTOMER = '';    LMM.CUSTOMER.ERR = ''
    CALL F.READ(FN.LMM.CUSTOMER,CUSTOMER.NO,R.LMM.CUSTOMER,F.LMM.CUSTOMER,LMM.CUSTOMER.ERR)
    IF R.LMM.CUSTOMER THEN
        LMM.CUSTOMER.CNT = DCOUNT(R.LMM.CUSTOMER,@FM)
        LMM.CUSTOMER.CTR = 1
        GOSUB MM.PROC.LOOP
    END
RETURN
*------------------------------------------------------------------------------------
MM.PROC.LOOP:
*************
    LOOP
    WHILE LMM.CUSTOMER.CTR LE LMM.CUSTOMER.CNT
        MM.ID = R.LMM.CUSTOMER<LMM.CUSTOMER.CTR>
        CALL F.READ(FN.MM.MONEY.MARKET,MM.ID,R.MM.MONEY.MARKET,F.MM.MONEY.MARKET,MM.MONEY.MARKET.ERR)
        GOSUB GET.MM.VAL
        LMM.CUSTOMER.CTR += 1
    REPEAT
RETURN

GET.MM.VAL:
***********
    IF R.MM.MONEY.MARKET THEN
        CALL F.READ(FN.EB.CONTRACT.BALANCE,MM.ID,R.EB.CONTRACT.BAL,F.EB.CONTRACT.BALANCE,ECB.ERR)
        IF R.EB.CONTRACT.BAL THEN
            CONSOL.ID = R.EB.CONTRACT.BAL<ECB.CONSOL.ENT.IDS>
            CONSOL.ID = FIELD(CONSOL.ID,'/',1)
        END
        CALL F.READ(FN.RE.SPEC.ENTRY,CONSOL.ID,R.RE.SPEC.ENTRY,F.RE.SPEC.ENTRY,RE.SPEC.ENTRY.ERR)
        IF NOT(R.RE.SPEC.ENTRY) THEN
            RETURN
        END
        CHECK.DATE = R.RE.SPEC.ENTRY<RE.CSE.BOOKING.DATE>
        IF CHECK.DATE GE ST.DATE AND CHECK.DATE LE EN.DATE THEN
            ACC.NUMBER = MM.ID
            TXN.CODE = R.RE.SPEC.ENTRY<RE.CSE.TRANSACTION.CODE>
            R.RE.TXN.CODE = '' ; RE.TXN.CODE.ERR = ''
            CALL CACHE.READ(FN.RE.TXN.CODE, TXN.CODE, R.RE.TXN.CODE, RE.TXN.CODE.ERR) ;*R22 AUTO CODE CONVERSION
            MVMT.DESC = R.RE.TXN.CODE<RE.TXN.DESCRIPTION>
            AMOUNT.LCY = R.RE.SPEC.ENTRY<RE.CSE.AMOUNT.LCY>
            AMOUNT = ABS(AMOUNT.LCY)
            MVMT.DATE = CHECK.DATE
            IF MVMT.DATE THEN
                MVMT.DATE = MVMT.DATE[7,2]:'/':MVMT.DATE[5,2]:'/':MVMT.DATE[1,4]
            END
            IF AMOUNT.LCY GT 0 THEN
                MVMT.TYPE = 'CR'
            END ELSE
                MVMT.TYPE = 'DR'
            END
            GOSUB FMT.FLDS
            OUTPUT.ARR<-1> = SEQ.NUMB:'*':CIRCULAR.YEAR:'*':CUST.TYPE:'*':CUST.ID:'*':ACC.NUMBER:'*':MVMT.DESC:'*':AMOUNT:'*':MVMT.DATE:'*':MVMT.TYPE
        END
    END
RETURN

GET.FX.DETAILS:
***************
*
    GOSUB INIT.FX
    SEL.CMD1 = "SELECT ":FN.FOREX:" WITH COUNTERPARTY EQ ":CUSTOMER.NO
    CALL EB.READLIST(SEL.CMD1, ID.LIST1, "", ID.CNT1, ERR.SEL1)
    ID.CTR1 = 1
    LOOP
    WHILE ID.CTR1 LE ID.CNT1
        REC.ID = ID.LIST1<ID.CTR1>
        GOSUB PROCESS.FX
        ID.CTR1 += 1
    REPEAT
*
RETURN
*------------------------------------------------------------------------------------
PROCESS.FX:
***********
*
    CALL F.READ(FN.FOREX,REC.ID,R.FOREX,F.FOREX,FOREX.ERR)
    IF R.FOREX THEN
        STMT.NO = R.FOREX<FX.STMT.NO,1>:"0001"
        CALL F.READ(FN.STMT.ENTRY,STMT.NO,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
        IF R.STMT.ENTRY THEN
            CHECK.DATE = R.STMT.ENTRY<AC.STE.BOOKING.DATE>
            GOSUB SUB.PROCESS.FX
        END
    END
RETURN

SUB.PROCESS.FX:
***************
    IF CHECK.DATE GE ST.DATE AND CHECK.DATE LE EN.DATE THEN
        ACC.NUMBER = REC.ID
        TXN.CODE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
        GOSUB READ.TRANSACTION
        AMOUNT.LCY = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
        AMOUNT = ABS(AMOUNT.LCY)
        MVMT.DATE = R.STMT.ENTRY<AC.STE.VALUE.DATE>
        IF MVMT.DATE THEN
            MVMT.DATE = MVMT.DATE[7,2]:'/':MVMT.DATE[5,2]:'/':MVMT.DATE[1,4]
        END
        IF AMOUNT.LCY GT 0 THEN
            MVMT.TYPE = 'CR'
        END ELSE
            MVMT.TYPE = 'DR'
        END
        GOSUB FMT.FLDS
        OUTPUT.ARR<-1> = SEQ.NUMB:'*':CIRCULAR.YEAR:'*':CUST.TYPE:'*':CUST.ID:'*':ACC.NUMBER:'*':MVMT.DESC:'*':AMOUNT:'*':MVMT.DATE:'*':MVMT.TYPE
    END
RETURN

FMT.FLDS:
*-------*
    SEQ.NUMB = FMT(SEQ.NUMB,'R%7')
    CIRCULAR.YEAR = FMT(CIRCULAR.YEAR,'R%4')
    CUST.TYPE = FMT(CUST.TYPE,'L#2')
    CUST.ID = FMT(CUST.ID,'L#17')
    ACC.NUMBER = FMT(ACC.NUMBER,'L#27')
    MVMT.DESC = FMT(MVMT.DESC,'L#40')
    AMOUNT = FMT(AMOUNT,'R2%14')
    MVMT.DATE = FMT(MVMT.DATE,'L#10')
    MVMT.TYPE = FMT(MVMT.TYPE,'L#2')
RETURN

READ.TRANSACTION:
*****************
    R.TRANSACTION = ''; TRANSACTION.ERR = ''
    CALL F.READ(FN.TRANSACTION,TXN.CODE,R.TRANSACTION,F.TRANSACTION,TRANSACTION.ERR)
    IF R.TRANSACTION THEN
        MVMT.DESC = R.TRANSACTION<AC.TRA.STMT.NARR>
    END
RETURN

INIT.FX:
********
*
    SEL.CMD1 = ''
    ID.LIST1 = ''
    ID.CNT1 = ''
    ERR.SEL1 = ''
    REC.ID = ''
    STMT.NO = ''
*
RETURN
*------------------------------------------------------------------------------------
INIT.PARA:
*--------*
*
    PROCESS.GO.AHEAD =  1
*
    ST.DATE = R.NEW(IF02B.START.TIME)
    EN.DATE = R.NEW(IF02B.END.TIME)
    ID.CARD.IDENTITY = ''
    CUSTOMER.NO = ''
*
    FN.DR.REGREP.PARAM = 'F.DR.REGREP.PARAM'
    F.DR.REGREP.PARAM = ''
    CALL OPF(FN.DR.REGREP.PARAM, F.DR.REGREP.PARAM)
*
    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.CUSTOMER.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.CUSTOMER.L.CU.RNC = ''
    CALL OPF(FN.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC)
*
    FN.CUSTOMER.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.CUSTOMER.L.CU.CIDENT = ''
    CALL OPF(FN.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT)
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)
*
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
*
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
    FN.LMM.CUSTOMER = 'F.LMM.CUSTOMER'
    F.LMM.CUSTOMER = ''
    CALL OPF(FN.LMM.CUSTOMER,F.LMM.CUSTOMER)
*
    FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET'
    F.MM.MONEY.MARKET = ''
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)

    FN.DR.REG.IF02B.EXTRACT = 'F.DR.REG.IF02B.EXTRACT'
    F.DR.REG.IF02B.EXTRACT = ''
    CALL OPF(FN.DR.REG.IF02B.EXTRACT,F.DR.REG.IF02B.EXTRACT)
*
    FN.LMM.ACTION.CODES = 'F.LMM.ACTION.CODES'
    F.LMM.ACTION.CODES = ''
    CALL OPF(FN.LMM.ACTION.CODES,F.LMM.ACTION.CODES)

    FN.FOREX = 'F.FOREX'
    F.FOREX = ''
    CALL OPF(FN.FOREX,F.FOREX)

    FN.RE.SPEC.ENTRY = 'F.RE.CONSOL.SPEC.ENTRY'
    F.RE.SPEC.ENTRY = ''
    CALL OPF(FN.RE.SPEC.ENTRY,F.RE.SPEC.ENTRY)

    FN.EB.CONTRACT.BALANCE = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCE = ''
    CALL OPF(FN.EB.CONTRACT.BALANCE,F.EB.CONTRACT.BALANCE)

    FN.RE.TXN.CODE = 'F.RE.TXN.CODE'
    F.RE.TXN.CODE = ''
    CALL OPF(FN.RE.TXN.CODE,F.RE.TXN.CODE)

    FN.STMT.PRINT = 'F.STMT.PRINTED'
    F.STMT.PRINT = ''
    CALL OPF(FN.STMT.PRINT,F.STMT.PRINT)

    GOSUB INIT.VARS
*
RETURN
*------------------------------------------------------------------------------------
GET.LR.POSN:
*------------------------------------------------------------------------------------
*
    APPL.NAME = 'CUSTOMER'
    FLD.NAME = 'L.CU.TIPO.CL':@VM:'L.CU.RNC':@VM:'L.CU.CIDENT':@VM:'L.CU.FOREIGN'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,FLD.NAME,FLD.POS)
    TIPO.CL.POS = FLD.POS<1,1>
    CIDENT.POS = FLD.POS<1,3>
    RNC.POS = FLD.POS<1,2>
    FOREIGN.POS = FLD.POS<1,4>
*
RETURN
*---------------------------------------------------------------------------
END
