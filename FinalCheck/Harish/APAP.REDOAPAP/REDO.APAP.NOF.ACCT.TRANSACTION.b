* @ValidationCode : MjoyMDIyNDI5MzY0OkNwMTI1MjoxNjgxMzgyNTI3NDY5OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:12:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.ACCT.TRANSACTION(Y.DATA)
*--------------------------------------------------------------------------
* Program Description
* Subroutine Type : ENQUIRY ROUTINE
* Attached to : REDO.APAP.NOF.ENQ.ACCT.TRAN.RPT
* Attached as : NOFILE ROUTINE
* Primary Purpose : To return data to the enquiry

* Incoming:
* ---------
*
* Outgoing:
* ---------
* Y.DATA - data returned to the enquiry
*--------------------------------------------------------------------------
* Modification History :
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development BY : Madhu Chetan - Contractor@TAM
* DATE : Dec 01, 2010
*
* Date Who Reference Description
* ------ ------ ------------- -------------
* 29-Mar-2015 V.P.Ashokkumar PACS00313350 Changed the override and fixed issues.
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM , VM to @VM ,++ to +=
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.EB.SYSTEM.ID
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.COMPANY
    $INSERT I_F.MNEMONIC.COMPANY
    $INSERT I_F.STMT.GEN.CONDITION
    $INSERT I_F.LOCAL.TABLE
    $INSERT I_F.ACCOUNT.PARAMETER
    $INSERT I_F.USER
    $INSERT I_F.LATAM.CARD.CUSTOMER
    $INSERT I_F.TRANSACTION

*--------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
    IF Y.DATA THEN
        Y.DATA<1>:= Y.SEL.DISP:"*"
        Y.DATA<1>:= Y.DATA.DATE:"*"
    END
RETURN

***************
INITIALISE:
***************
    FN.ACCT.ENT.TODAY = 'F.ACCT.ENT.TODAY'
    F.ACCT.ENT.TODAY = ''
    CALL OPF(FN.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY)

    FN.ACCOUNT.PARAMETER = 'F.ACCOUNT.PARAMETER'
    F.ACCOUNT.PARAMETER = ''
    CALL OPF(FN.ACCOUNT.PARAMETER,F.ACCOUNT.PARAMETER)

    FN.COMPANY = "F.COMPANY"
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.MNEMONIC.COMPANY = "F.MNEMONIC.COMPANY"
    F.MNEMONIC.COMPANY = ''
    CALL OPF(FN.MNEMONIC.COMPANY,F.MNEMONIC.COMPANY)

    FN.LOCAL.TABLE = "F.LOCAL.TABLE"
    F.LOCAL.TABLE = ''
    CALL OPF(FN.LOCAL.TABLE,F.LOCAL.TABLE)

    FN.STMT.ENTRY = "F.STMT.ENTRY"
    F.STMT.ENTRY = ''

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ''

    FN.TELLER = "F.TELLER"
    F.TELLER = ''

    FN.TELLER$HIS = "F.TELLER$HIS"
    F.TELLER$HIS = ''

    FN.EB.SYSTEM.ID = "F.EB.SYSTEM.ID"
    F.EB.SYSTEM.ID = ''

    FN.CARD.ISSUE.ACCOUNT = "F.CARD.ISSUE.ACCOUNT"
    F.CARD.ISSUE.ACCOUNT = ''

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''

    FN.FUNDS.TRANSFER$HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER$HIS = ''

    FN.FT.TXN.TYPE.CONDITION = "F.FT.TXN.TYPE.CONDITION"
    F.FT.TXN.TYPE.CONDITION = ''

    FN.STMT.GEN.CONDITION = "F.STMT.GEN.CONDITION"
    F.STMT.GEN.CONDIITON = ''

    FN.USER = 'F.USER'
    F.USER = ''

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''

    FN.LATAM.CARD.CUSTOMER = 'F.LATAM.CARD.CUSTOMER'
    F.LATAM.CARD.CUSTOMER = ''
    CALL OPF(FN.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER)

    FTTC.LR.POSN = ''
    CALL GET.LOC.REF("FT.TXN.TYPE.CONDITION","L.FTTC.CHANNELS",FTTC.LR.POSN)
    L.FTTC.CHANNELS.POS = FTTC.LR.POSN

    CALL OPF(FN.STMT.GEN.CONDITION,F.STMT.GEN.CONDITION)
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)
    CALL OPF(FN.FUNDS.TRANSFER$HIS,F.FUNDS.TRANSFER$HIS)
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.TELLER,F.TELLER)
    CALL OPF(FN.TELLER$HIS,F.TELLER$HIS)
    CALL OPF(FN.EB.SYSTEM.ID,F.EB.SYSTEM.ID)
    CALL OPF(FN.CARD.ISSUE.ACCOUNT,F.CARD.ISSUE.ACCOUNT)
    CALL OPF(FN.USER,F.USER)
    CALL CACHE.READ(FN.ACCOUNT.PARAMETER,'SYSTEM',R.ACCOUNT.PARAMETER,Y.ACC.PAR.ERR)
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

RETURN

***************
PROCESS:
***************
    GOSUB GET.SEL.DETAILS
    IF NOT(ENQ.ERROR) AND Y.ACCT THEN
        GOSUB PROCESS.SEL.RECORDS
    END

RETURN

GET.SEL.DETAILS:
*===============
    GOSUB GET.DATE.SELECTION
    GOSUB GET.CHANNEL.SELECTION
    Y.CDN = ''
    LOCATE "CASH.DESK.NUMBER" IN D.FIELDS<1> SETTING CDN.POS THEN
        Y.CDN = D.RANGE.AND.VALUE<CDN.POS>
        Y.SEL.DISP:= ", NUMERO CAJERO: ":Y.CDN
    END
    Y.TRAN.TYPE = ''
    LOCATE "TRANSACTION.TYPE" IN D.FIELDS<1> SETTING TRANSACTION.TYPE.POS THEN
        Y.TRAN.TYPE = D.RANGE.AND.VALUE<TRANSACTION.TYPE.POS>
        Y.SEL.DISP:= ", TIPO DE TRANSACION: ":Y.TRAN.TYPE
    END
    Y.OVERRIDES = ''

    LOCATE "OVERRIDES" IN D.FIELDS<1> SETTING OVERRIDES.POS THEN
        Y.OVERRIDES = D.RANGE.AND.VALUE<OVERRIDES.POS>
        Y.SEL.DISP:= ", OVERRIDES: ":Y.OVERRIDES
    END
    Y.ACCT = ''
    LOCATE "ACCOUNT.NUMBER" IN D.FIELDS<1> SETTING ACCT.POS THEN
        Y.ACCT = D.RANGE.AND.VALUE<ACCT.POS>
        Y.SEL.DISP:= ", NUMERO DE CUENTA: ":Y.ACCT
    END

RETURN

GET.DATE.SELECTION:
*==================
    Y.TRAN.DATE = '' ; Y.SEL.DISP = "*"


    LOCATE "TRANSACTION.DATE" IN D.FIELDS<1> SETTING TRANSACTION.DATE.POS THEN
        Y.TRAN.DATE = D.RANGE.AND.VALUE<TRANSACTION.DATE.POS>
        Y.TRAN.OPERN = D.LOGICAL.OPERANDS<TRANSACTION.DATE.POS>
    END
    IF INDEX(Y.TRAN.DATE, @SM, 1) THEN
        Y.FROM.DATE = FIELD(Y.TRAN.DATE, @SM, 1)
        Y.TO.DATE = FIELD(Y.TRAN.DATE, @SM, 2)

        IF NOT(NUM(Y.FROM.DATE)) THEN
            ENQ.ERROR = "EB-DATE.NOT.VALID"
            RETURN
        END

        IF NOT(NUM(Y.TO.DATE)) THEN
            ENQ.ERROR = "EB-DATE.NOT.VALID"
            RETURN
        END

        IF Y.FROM.DATE GT Y.TO.DATE THEN
            ENQ.ERROR = "EB-DATE.NOT.VALID"
            RETURN
        END

        CALL EB.DATE.FORMAT.DISPLAY(Y.FROM.DATE, Y.FROM.DATE.FMT, '', '')
        CALL EB.DATE.FORMAT.DISPLAY(Y.TO.DATE, Y.TO.DATE.FMT, '', '')

* Y.FROM.DATE1 = ICONV(Y.FROM.DATE,"D4")
* Y.FROM.DATE1 = OCONV(Y.FROM.DATE1,"D4")

* Y.TO.DATE1 = ICONV(Y.TO.DATE,"D4")
* Y.TO.DATE1 = OCONV(Y.TO.DATE1,"D4")

        Y.SEL.DISP:= "FECHA DE TRANSACCION: ":Y.FROM.DATE.FMT:" A ":Y.TO.DATE.FMT

*Y.SEL.DISP:= "FECHA DE TRANSACCION: "

*Y.DATA.DATE = Y.FROM.DATE:"#":Y.TO.DATE
    END ELSE
        IF NOT(NUM(Y.TRAN.DATE)) THEN
            ENQ.ERROR = "EB-DATE.NOT.VALID"
            RETURN
        END

        CALL EB.DATE.FORMAT.DISPLAY(Y.TRAN.DATE, Y.TRAN.DATE.FMT, '', '')

*Y.TRAN.DATE1 = ICONV(Y.TRAN.DATE,"D4")
*Y.TRAN.DATE1 = OCONV(Y.TRAN.DATE1,"D4")
        Y.SEL.DISP:= "FECHA DE TRANSACCION: ":Y.TRAN.DATE.FMT
* Y.SEL.DISP:= "FECHA DE TRANSACCION: "
        Y.DATA.DATE = Y.TRAN.DATE
    END


RETURN

GET.CHANNEL.SELECTION:
*==================
    Y.AGENCY = '' ; Y.CHANNEL = '' ; Y.CHA.AGEN = ''
    Y.CA.FLAG = ''
* LOCATE "CHANNEL.AGENCY" IN D.FIELDS<1> SETTING AGENCY.POS THEN
* Y.CHA.AGEN = D.RANGE.AND.VALUE<AGENCY.POS>
* IF LEN(Y.CHA.AGEN) EQ 9 THEN
** CALL CACHE.READ(FN.COMPANY,Y.CHA.AGEN,R.COMP.REC,SEL.ERR1)
* IF NOT(R.COMP.REC) THEN
* ENQ.ERROR = "EB-INVALID.AGENCY.OR.CHANNEL.CODE"
* RETURN
* END
* Y.AGENCY = Y.CHA.AGEN
* Y.CA.FLAG = 'A'
* END ELSE
* CALL CACHE.READ(FN.MNEMONIC.COMPANY,Y.CHA.AGEN,R.MNE.COMP.REC,SEL.ERR2)
* IF R.MNE.COMP.REC THEN
* Y.AGENCY = R.MNE.COMP.REC
* Y.CA.FLAG = 'A'
* END ELSE
* CALL CACHE.READ(FN.LOCAL.TABLE,'578',R.LT.REC,SEL.ERR3)
* Y.CHN.LIST = R.LT.REC<EB.LTA.VETTING.TABLE>
* Y.CHN.LIST = CHANGE(Y.CHN.LIST,VM,FM)
* LOCATE Y.CHA.AGEN IN Y.CHN.LIST<1> SETTING LT.POS THEN
* Y.CHANNEL = Y.CHA.AGEN
* Y.CA.FLAG = 'C'
* END ELSE
* ENQ.ERROR = "EB-INVALID.AGENCY.OR.CHANNEL.CODE"
* RETURN
* END
* END
* END
* Y.SEL.DISP:= ", CANAL/AGENCIA:":Y.CHA.AGEN
* END

* LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
* IF LEN(Y.CHA.AGEN) EQ 9 ELSE
* CALL CACHE.READ(FN.MNEMONIC.COMPANY,Y.CHA.AGEN,R.MNE.COMP.REC,SEL.ERR2)
* IF R.MNE.COMP.REC THEN
* Y.AGENCY = R.MNE.COMP.REC
* Y.CA.FLAG = 'A'
* END
*END
* Y.SEL.DISP:= ", CANAL/AGENCIA:":Y.CHA.AGEN
*END
    LOCATE 'CHANNEL' IN D.FIELDS<1> SETTING Y.CHANNEL.POS THEN
        Y.CHANNEL = D.RANGE.AND.VALUE<Y.CHANNEL.POS>
        Y.SEL.DISP:= ", CANAL/AGENCIA:":Y.CHANNEL
        Y.CA.FLAG = 'C'
    END

RETURN

PROCESS.SEL.RECORDS:
*==================

    K.TRAN.TYPE = '' ; K.AGENCY = '' ; K.CHANNEL = '' ; K.CDN = '' ; K.OVERRIDE = ''
    R.STMT.REC = ''
    Y.SE.ID.LIST = ''
    R.ACT.REC = ''
    Y.TRANSACTION.DATE = Y.TRAN.DATE
    Y.CAT.VALUE = ''
    Y.CONT.FLAG = ''
    R.ACCT.ENT.TODAY = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACT.REC,F.ACCOUNT,Y.AC.ERR)
    Y.CAT.ACCOUNT = R.ACT.REC<AC.CATEGORY>
    Y.DEPOSIT.ACCOUNT = R.ACT.REC<AC.ALL.IN.ONE.PRODUCT>
    Y.PARA.CATG.STR = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.STR>
    Y.PARA.CATG.END = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.END>
    Y.COUNT = DCOUNT(Y.PARA.CATG.STR,@VM)
    Y.CNT =1

    LOOP
    WHILE Y.CNT LE Y.COUNT
        IF Y.CAT.ACCOUNT GE Y.PARA.CATG.STR<1,Y.CNT> AND Y.CAT.ACCOUNT LE Y.PARA.CATG.END<1,Y.CNT> THEN
            Y.CONT.FLAG.ST = '1'
        END
        Y.CNT += 1
    REPEAT
    IF Y.CAT.ACCOUNT GE 6011 AND Y.CAT.ACCOUNT LE 6020 THEN
        Y.CONT.FLAG.ST = ''
    END
    IF Y.CONT.FLAG.ST THEN
        GOSUB GET.STMT.ID
        GOSUB PROCESS.ID.ALL
        Y.CONT.FLAG.ST = ''
    END
RETURN

GET.STMT.ID:
*===========

    ENQ.SELECTION<2,1> = 'ACCOUNT'
    ENQ.SELECTION<2,2> = 'BOOKING.DATE'
    ENQ.SELECTION<3,1> = '1'
    ENQ.SELECTION<3,2> =Y.TRAN.OPERN
    ENQ.SELECTION<4,1> = Y.ACCT
    ENQ.SELECTION<4,2> = Y.TRANSACTION.DATE
    Y.ID.LIST = ''

    D.FIELDS = 'ACCOUNT':@FM:'BOOKING.DATE'
    D.RANGE.AND.VALUE = Y.ACCT:@FM:Y.TRANSACTION.DATE
    D.LOGICAL.OPERANDS = '1':@FM:Y.TRAN.OPERN
    CALL E.STMT.ENQ.BY.CONCAT(Y.SE.ID.LIST)
    Y.STMT.IDS.LIST<-1> = Y.SE.ID.LIST

RETURN

*==========================
PROCESS.ID.ALL:
*==========================
    Y.LOOP.CNT = 1
    LOOP
        REMOVE Y.RES.LIST FROM Y.SE.ID.LIST SETTING Y.RES.POS
    WHILE Y.RES.LIST:Y.RES.POS
        DR.AMT = 0 ; CR.AMT = 0 ; Y.TRAN.AMOUNT = 0
        IF Y.LOOP.CNT EQ 1 THEN
            Y.PRE.BAL = FIELD(Y.RES.LIST, "*", 3)
        END ELSE
            Y.PRE.BAL = Y.NEXT.BAL
        END
        Y.SE.ID = FIELD(Y.RES.LIST,'*',2)
        IF Y.SE.ID THEN
            GOSUB PROCESS.SE.IDS
        END
        Y.LOOP.CNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
RETURN

PROCESS.SE.IDS:
*=============

    GOSUB GET.STMT.DETAILS
    GOSUB GET.ACCT.DETAILS
    GOSUB READ.CARD.ISSUE.ACCOUNT
    GOSUB READ.EB.SYSTEM.ID
    GOSUB GET.FINAL.BALANCE

    Y.FILE.NUM = '' ; Y.CASH.NUM = ''
    IF Y.TXN.REF[1,2] EQ 'TT' THEN
        GOSUB GET.TELLER.DETAILS
    END
*
    IF Y.TXN.REF[1,2] EQ 'FT' THEN
        Y.TXN.REF.HIS.FT = Y.TXN.REF:";1"
        GOSUB READ.FT.AND.FTTC
    END

    Y.TRANSACTION.DATE = R.STMT.REC<AC.STE.VALUE.DATE>

    IF Y.TXN.REF[1,2] EQ 'FT' THEN
*AND Y.CA.FLAG EQ 'C' THEN
        Y.COMPANY.CODE = K.AGENCY
        Y.CHNL = K.CHANNEL
    END ELSE
*Y.CHNL = R.STMT.REC<AC.STE.COMPANY.CODE>
        Y.COMPANY.CODE = K.AGENCY
    END

    K.TRAN.TYPE = Y.STMT.SYS
    K.CDN = Y.CASH.NUM
    K.OVERRIDE = Y.OVERRIDE
    Y.CMP.VAL = FIELD(K.OVERRIDE,'}',1)

    GOSUB GET.OVERRIDE.AUTH
    GOSUB APPEND.DATA

RETURN

GET.FINAL.BALANCE:
*=================
*
    IF Y.CCY EQ "DOP" THEN
        Y.TRAN.AMOUNT = Y.AMT.LCY
    END ELSE
        Y.TRAN.AMOUNT = Y.AMT.FCY
    END

    IF Y.TRAN.AMOUNT LT 0 THEN
        DR.AMT = Y.TRAN.AMOUNT
        DR.AMT = TRIM(DR.AMT,"-")
    END ELSE
        CR.AMT = Y.TRAN.AMOUNT
        CR.AMT = TRIM(CR.AMT,"-")
    END

    Y.FINAL.BAL = Y.PRE.BAL + Y.TRAN.AMOUNT
    Y.NEXT.BAL = Y.FINAL.BAL

RETURN

GET.OVERRIDE.AUTH:
*================
    R.USER.REC = ''

* IF Y.OVERRIDE THEN

    Y.AUTH.OVER1 = Y.OVERRIDE
    Y.CHK.VALUE = FIELD(Y.AUTH.OVER1,'}',1)
    TOT.OVERRIDE = DCOUNT(Y.AUTH.OVER1,@VM)
    FOR OVE.COUNT = 1 TO TOT.OVERRIDE
        Y.OVE1 = ''
        Y.OVE1 = Y.AUTH.OVER1<1,OVE.COUNT>
        CHANGE '}' TO @VM IN Y.OVE1
        CHANGE '{' TO @FM IN Y.OVE1
        CALL TXT(Y.OVE1)
* Y.OVE2<1,-1> = Y.OVE1
        Y.OVE2 = Y.OVE1
        Y.OVERRIDE = Y.OVE2
    NEXT OVE.COUNT

RETURN

APPEND.DATA:
*===========
    IF NOT(Y.OVERRIDE) THEN
        Y.OVERRIDE = Y.TXN.OVERRIDE
    END

    GOSUB CHECK.SEL.CRITERIA
    IF NOT(Y.FLAG) THEN
        Y.DATA1 = Y.TRANSACTION.DATE:'*':Y.ACCT:'*':Y.PRE.ACCT.NUM:'*':Y.DEB.CRD.NUM:"*"
        Y.DATA1:= Y.ACCT.NAME:'*':Y.SYS.ID:'*':Y.TRAN.CODE:'*':Y.CCY:'*':Y.PRE.BAL:'*':DR.AMT:'*'
        Y.DATA1:= CR.AMT:'*':Y.FINAL.BAL:'*':Y.FILE.NUM:'*':Y.TXN.REF:'*':Y.OVERRIDE:'*'
        Y.DATA1:= Y.CASH.NUM:'*':Y.CHNL:'*':Y.INP:'*':Y.AUTH:'*':Y.AUTH:'*':Y.COMPANY.CODE
        Y.DATA<-1> = Y.DATA1

    END
    Y.OVERRIDE = ''
RETURN

READ.EB.SYSTEM.ID:
*================
    R.SID.REC = ''


*CALL CACHE.READ(FN.EB.SYSTEM.ID,Y.STMT.SYS,R.SID.REC,SID.ERR)
*Y.SYS.ID = R.SID.REC<SID.DESCRIPTION>
    Y.STMT.SYS = R.STMT.REC<AC.STE.TRANSACTION.CODE>
    Y.SYS.ID = Y.STMT.SYS
    CALL CACHE.READ(FN.TRANSACTION,Y.STMT.SYS,R.TRANSACTION,TRAN.ERR)
    Y.TRAN.NARR = R.TRANSACTION<AC.TRA.NARRATIVE>
    Y.SYS.ID = Y.TRAN.NARR<1,2>

RETURN

READ.CARD.ISSUE.ACCOUNT:
*======================

    GOSUB READ.LATAM.CARD.CUSTOMER

    Y.ACCT.DETS = R.LATAM.CARD.CUSTOMER<APAP.DC.ACCOUNT.NO>
    Y.CARD.NOS = R.LATAM.CARD.CUSTOMER<APAP.DC.CARD.NO>

    Y.CUR.ID = Y.ACCT
    Y.ACC.COUNT = DCOUNT(Y.ACCT.DETS,@VM)
    Y.ACC.START = 1
    Y.CARD.IDS = ''
    LOOP
    WHILE Y.ACC.START LE Y.ACC.COUNT
        Y.CHK.ACCT = Y.ACCT.DETS<1,Y.ACC.START>
        IF Y.CHK.ACCT NE Y.CUR.ID THEN
            Y.ACC.START += 1
            CONTINUE
        END
        Y.CARD.IDS<-1> = Y.CARD.NOS<1,Y.ACC.START>[6,99]
        Y.ACC.START += 1
    REPEAT

    CHANGE @FM TO @VM IN Y.CARD.IDS
    Y.DEB.CRD.NUM = Y.CARD.IDS

*Y.DEBIT.CARD.NUM.VAL = Y.CARD.IDS

*Y.DEB.CRD.NUM = R.CIA.REC
*Y.DEB.CRD.NUM = CHANGE(Y.DEB.CRD.NUM,FM,VM)

*CALL CACHE.READ(FN.CARD.ISSUE.ACCOUNT,Y.ACCT,R.CIA.REC,Y.CIA.ERR)
*Y.DEB.CRD.NUM = R.CIA.REC
*Y.DEB.CRD.NUM = CHANGE(Y.DEB.CRD.NUM,FM,VM)
RETURN

GET.TELLER.DETAILS:
*=================
    Y.TXN.REF = FIELD(Y.TXN.REF,'\',1)
    Y.TXN.REF.HIS = Y.TXN.REF:";1"
    R.TEL.REC = ''
    CALL CACHE.READ(FN.TELLER$HIS,Y.TXN.REF.HIS,R.TEL.REC,Y.TEL.ERR)
    IF NOT(R.TEL.REC) THEN
        CALL F.READ(FN.TELLER,Y.TXN.REF,R.TEL.REC,F.TELLER,Y.TEL.ERR1)
    END
    IF R.TEL.REC<TT.TE.NARRATIVE.1> AND R.TEL.REC<TT.TE.CHEQUE.NUMBER> THEN
        Y.FILE.NUM= R.TEL.REC<TT.TE.NARRATIVE.1>:"-":R.TEL.REC<TT.TE.CHEQUE.NUMBER>
    END ELSE
        Y.FILE.NUM= R.TEL.REC<TT.TE.NARRATIVE.1>:R.TEL.REC<TT.TE.CHEQUE.NUMBER>
    END
    Y.CASH.NUM = R.TEL.REC<TT.TE.TELLER.ID.1>
    Y.TXN.OVERRIDE = R.TEL.REC<TT.TE.OVERRIDE>
RETURN

GET.ACCT.DETAILS:
*===================
    Y.ALT.TYPE = R.ACT.REC<AC.ALT.ACCT.TYPE>
    LOCATE "ALTERNO1" IN Y.ALT.TYPE<1,1> SETTING ALT.ACCT.POS THEN
        Y.PRE.ACCT.NUM = R.ACT.REC<AC.ALT.ACCT.ID,ALT.ACCT.POS>
    END
*Y.PRE.ACCT.NUM = R.ACT.REC<AC.ALT.ACCT.ID>
    Y.ACCT.NAME = R.ACT.REC<AC.CUSTOMER>:"-":Y.ACCT
* Y.PRE.BAL = R.ACT.REC<AC.OPEN.ACTUAL.BAL>
*Y.STMT.SYS = R.STMT.REC<AC.STE.SYSTEM.ID>
    Y.STMT.SYS = R.STMT.REC<AC.STE.TRANSACTION.CODE>
    Y.TXN.OVERRIDE = R.ACT.REC<AC.OVERRIDE>
RETURN

GET.STMT.DETAILS:
*===============
    R.STMT.REC = ''

    CALL CACHE.READ(FN.STMT.ENTRY,Y.SE.ID,R.STMT.REC,STMT.ENTRY.ERR)
    IF R.STMT.REC THEN
        Y.INP = FIELD(R.STMT.REC<AC.STE.INPUTTER>,'_',2)
        Y.AUTH = FIELD(R.STMT.REC<AC.STE.AUTHORISER>,'_',2)
        K.AGENCY = R.STMT.REC<AC.STE.COMPANY.CODE>
        Y.OVERRIDE = R.STMT.REC<AC.STE.OVERRIDE>
        Y.TXN.REF = R.STMT.REC<AC.STE.TRANS.REFERENCE>
        Y.AMT.LCY = R.STMT.REC<AC.STE.AMOUNT.LCY>
        Y.AMT.FCY = R.STMT.REC<AC.STE.AMOUNT.FCY>
        Y.TRAN.CODE = R.STMT.REC<AC.STE.TRANSACTION.CODE>
        Y.CCY = R.STMT.REC<AC.STE.CURRENCY>
    END
RETURN

******************
READ.FT.AND.FTTC:
******************
    Y.TXN.REF = FIELD(Y.TXN.REF,'\',1)
    R.FT.REC = ''; Y.FT.ERR1 = ''
    Y.TXN.REF.HIS = Y.TXN.REF:";1"
    CALL CACHE.READ(FN.FUNDS.TRANSFER$HIS,Y.TXN.REF.HIS,R.FT.REC,Y.FT.ERR1)
    IF NOT(R.FT.REC) THEN
        CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.REF,R.FT.REC,F.FUNDS.TRANSFER,Y.FT.ERR2)
    END

    Y.FTTC.ID = R.FT.REC<FT.TRANSACTION.TYPE>
    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION,Y.FTTC.ID,R.FTTC.REC,Y.FTTC.ERR)
    K.CHANNEL = R.FTTC.REC<FT6.LOCAL.REF,L.FTTC.CHANNELS.POS>
    Y.TXN.OVERRIDE = R.FT.REC<FT.OVERRIDE>
RETURN

********************
CHECK.SEL.CRITERIA:
********************

    Y.FLAG = ''
    IF Y.TRAN.TYPE AND Y.TRAN.TYPE NE K.TRAN.TYPE THEN
        Y.FLAG = 'N'
        RETURN
    END
*IF NOT(Y.FLAG) AND Y.AGENCY AND Y.AGENCY NE K.AGENCY THEN
* Y.FLAG = 'N'
* RETURN
* END
    IF NOT(Y.FLAG) AND NOT(Y.CHANNEL) AND Y.COMPANY.CODE NE K.AGENCY THEN
        Y.FLAG = 'N'
        RETURN
    END

    IF NOT(Y.FLAG) AND Y.CHANNEL AND Y.CHANNEL NE K.CHANNEL THEN
        Y.FLAG = 'N'
        RETURN
    END
    IF NOT(Y.FLAG) AND Y.CDN AND Y.CDN NE K.CDN THEN
        Y.FLAG = 'N'
        RETURN
    END
    IF NOT(Y.FLAG) AND Y.OVERRIDES AND Y.OVERRIDES NE Y.CMP.VAL THEN
        Y.FLAG = 'N'
        RETURN
    END

    IF Y.OVERRIDES THEN
        IF Y.CHK.VALUE NE Y.OVERRIDES THEN
            Y.FLAG = 'N'
            RETURN
        END
    END
RETURN


*---------------------------------------------------------------------------------------------------------------
READ.LATAM.CARD.CUSTOMER:
*************************
    R.LATAM.CARD.CUSTOMER = ''
    LATAM.CARD.CUSTOMER.ER = ''
    LATAM.CARD.CUSTOMER.ID = R.ACT.REC<AC.CUSTOMER>
    CALL F.READ(FN.LATAM.CARD.CUSTOMER,LATAM.CARD.CUSTOMER.ID,R.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER,LATAM.CARD.CUS.ERR)

RETURN


END
