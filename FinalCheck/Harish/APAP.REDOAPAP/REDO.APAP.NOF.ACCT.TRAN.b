* @ValidationCode : MjotMjUyMzE5MzQzOkNwMTI1MjoxNjgxMzgxMzkxNzQyOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 15:53:11
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
SUBROUTINE REDO.APAP.NOF.ACCT.TRAN(Y.DATA)
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
* 05/May/2012 : Shekar : Performance
* select only customer accounts
* do not cache read FT$HIS, TT$HIS, SE, CARD.ISSUE.ACCOUNT
* do not cache read company to check if they are valid id
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   SM to @SM , FM to @FM ,VM to @VM,F.READ to CACHE.READ,I to .VAR
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*--------------------------------------------------------------------------
* Modification Details:
*=====================
* Date Who Reference Description
* ------ ----- ------------- -------------
* 25-Mar-2015 V.P.Ashokkumar PACS00313350 Corrected the field Override, FILENUMBER
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
*TUS Start
    $INSERT I_F.EB.CONTRACT.BALANCES
*TUS End
*--------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS
    IF Y.DATA THEN

        Y.DATA<1>:= Y.SEL.DISP:"*"
    END
RETURN

***************
INITIALISE:
***************
    FN.ACCT.ENT.TODAY = 'F.ACCT.ENT.TODAY'
    F.ACCT.ENT.TODAY = ''
    CALL OPF(FN.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY)


    FN.ACCT.ENT.LWORK.DAY = 'F.ACCT.ENT.LWORK.DAY'
    F.ACCT.ENT.LWORK.DAY = ''
    CALL OPF(FN.ACCT.ENT.LWORK.DAY,F.ACCT.ENT.LWORK.DAY)

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

RETURN
***************
OPEN.FILES:
***************

    FTTC.LR.POSN = ''
    CALL GET.LOC.REF("FT.TXN.TYPE.CONDITION","L.FTTC.CHANNELS",FTTC.LR.POSN)
    L.FTTC.CHANNELS = FTTC.LR.POSN

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
    CALL CACHE.READ(FN.LOCAL.TABLE, '578', R.LT.REC, SEL.ERR3) ;*R22 AUTO CODE CONVERSION

*Shek -s
* do not cache read company record just to check if it is a valid company id
* build list of company ids and check the array
    SEL.COMP = 'SELECT F.COMPANY'
    CALL EB.READLIST(SEL.COMP, COMP.ID.LIST, '', '', '')
*Shek -e
RETURN

***************
PROCESS:
***************
    GOSUB GET.SEL.DETAILS
    IF NOT(ENQ.ERROR) AND ACCT.LIST THEN
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

    SEL.STMT = 'SELECT ':FN.ACCT.ENT.LWORK.DAY: " WITH @ID LIKE '0N'" ;* select only customer accounts. shek
    CALL EB.READLIST(SEL.STMT,ACCT.LIST,'',NO.OF.REC,Y.ACCT.ERR)
RETURN

GET.DATE.SELECTION:
*==================
    Y.TRAN.DATE = '' ; Y.SEL.DISP = "*"

    LOCATE "TRANSACTION.DATE" IN D.FIELDS<1> SETTING TRANSACTION.DATE.POS THEN
        Y.TRAN.DATE = D.RANGE.AND.VALUE<TRANSACTION.DATE.POS>
    END
    IF NOT(NUM(Y.TRAN.DATE)) THEN
        ENQ.ERROR = "EB-DATE.NOT.VALID"
        RETURN
    END
    Y.TRAN.DATE1 = ICONV(Y.TRAN.DATE,"D4")
    Y.TRAN.DATE1 = OCONV(Y.TRAN.DATE1,"D4")
    Y.SEL.DISP:= "FECHA: ":Y.TRAN.DATE1
RETURN

GET.CHANNEL.SELECTION:
*==================
    Y.AGENCY = '' ; Y.CHANNEL = '' ; Y.CHA.AGEN = ''
    Y.CA.FLAG = ''
    LOCATE "CHANNEL.AGENCY" IN D.FIELDS<1> SETTING AGENCY.POS THEN
        Y.CHA.AGEN = D.RANGE.AND.VALUE<AGENCY.POS>
        IF LEN(Y.CHA.AGEN) EQ 9 THEN
*Shek-s
* do not cache read company .. check id.company or the array
*- CALL CACHE.READ(FN.COMPANY,Y.CHA.AGEN,R.COMP.REC,SEL.ERR1)
*- IF NOT(R.COMP.REC) THEN
            GOSUB COMPANY.MATCH
        END ELSE
            GOSUB NOT.COMPANY.MATCH
        END
        Y.SEL.DISP:= ", CANAL/AGENCIA:":Y.CHA.AGEN
    END
RETURN

PROCESS.SEL.RECORDS:
*==================

    FOR I.VAR = 1 TO NO.OF.REC
        K.TRAN.TYPE = '' ; K.AGENCY = '' ; K.CHANNEL = '' ; K.CDN = '' ; K.OVERRIDE = ''
        R.STMT.REC = ''
        Y.SE.ID.LIST = ''
        Y.ACCT = ACCT.LIST<I.VAR> ; R.ACT.REC = ''
        Y.TRANSACTION.DATE = TODAY
        Y.CAT.VALUE = ''
        Y.CONT.FLAG = ''
        R.ACCT.ENT.TODAY = ''
        CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACT.REC,F.ACCOUNT,Y.AC.ERR)
*TUS Start
        CALL EB.READ.HVT ('EB.CONTRACT.BALANCES', Y.ACCT, R.ECB, ECB.ERR)
*TUS End
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
            CALL F.READ(FN.ACCT.ENT.LWORK.DAY,Y.ACCT,R.ACCT.ENT.TODAY,F.ACCT.ENT.LWORK.DAY,Y.ACC.ERR)
            Y.SE.ID.LIST = R.ACCT.ENT.TODAY
            GOSUB PROCESS.ID.ALL
            Y.CONT.FLAG.ST = ''
        END
    NEXT I.VAR ;*R22 AUTO CODE CONVERSION

RETURN
*==========================
PROCESS.ID.ALL:
*==========================
    LOOP
        REMOVE Y.RES.LIST FROM Y.SE.ID.LIST SETTING Y.RES.POS
    WHILE Y.RES.LIST:Y.RES.POS
        DR.AMT = 0 ; CR.AMT = 0 ; Y.TRAN.AMOUNT = 0
        Y.SE.ID = Y.RES.LIST
        IF Y.SE.ID THEN
            GOSUB PROCESS.SE.IDS
        END
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
        GOSUB READ.FT.AND.FTTC
    END

    IF Y.TXN.REF[1,2] EQ 'FT' AND Y.CA.FLAG EQ 'C' THEN
        Y.CHNL = K.CHANNEL
    END ELSE
        Y.CHNL = R.STMT.REC<AC.STE.COMPANY.CODE>
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
    IF Y.CCY EQ LCCY THEN ;* use common variables do not hardcode as DOP
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
RETURN

GET.OVERRIDE.AUTH:
*================
    R.USER.REC = ''; YOVERRIDE = ''
    Y.CHK.VALUE = FIELD(Y.OVERRIDE,'}',1)
    IF Y.OVERRIDE THEN
        Y.OVERRIDE = FIELD(Y.OVERRIDE,@SM,1)
        CHANGE @VM TO @FM IN Y.OVERRIDE
        OVER.CNT = DCOUNT(Y.OVERRIDE,@FM)
        YOVERRIDE = Y.OVERRIDE<OVER.CNT>
        YOVERRIDE = FIELDS(YOVERRIDE,'}',2,99)
        CHANGE '{' TO ' ' IN YOVERRIDE
        CHANGE '}' TO ' ' IN YOVERRIDE
        CHANGE '& ' TO '' IN YOVERRIDE
        CHANGE '~' TO '' IN YOVERRIDE
        CHANGE '\' TO '' IN YOVERRIDE
        CHANGE @SM TO '' IN YOVERRIDE
        Y.OVERRIDE = YOVERRIDE
    END
RETURN

APPEND.DATA:
*===========
    GOSUB CHECK.SEL.CRITERIA
    IF NOT(Y.FLAG) THEN
        Y.DATA1 = Y.TRANSACTION.DATE:'*':Y.ACCT:'*':Y.PRE.ACCT.NUM:'*':Y.DEB.CRD.NUM:"*"
        Y.DATA1:= Y.ACCT.NAME:'*':Y.SYS.ID:'*':Y.TRAN.CODE:'*':Y.CCY:'*':Y.PRE.BAL:'*':DR.AMT:'*'
        Y.DATA1:= CR.AMT:'*':Y.FINAL.BAL:'*':Y.FILE.NUM:'*':Y.TXN.REF:'*':Y.OVERRIDE:'*'
        Y.DATA1:= Y.CASH.NUM:'*':Y.CHNL:'*':Y.INP:'*':Y.AUTH:'*':Y.AUTH
        Y.DATA<-1> = Y.DATA1
    END
    Y.OVERRIDE = ''
RETURN

READ.EB.SYSTEM.ID:
*================
    R.SID.REC = ''
    CALL CACHE.READ(FN.EB.SYSTEM.ID,Y.STMT.SYS,R.SID.REC,SID.ERR)
    Y.SYS.ID = R.SID.REC<SID.DESCRIPTION>
RETURN

READ.CARD.ISSUE.ACCOUNT:
*======================
    R.CIA.REC = ''
*Shek CALL CACHE.READ(FN.CARD.ISSUE.ACCOUNT,Y.ACCT,R.CIA.REC,Y.CIA.ERR)
* READ R.CIA.REC FROM F.CARD.ISSUE.ACCOUNT, Y.ACCT ELSE ;*Tus Start
    CALL F.READ(FN.CARD.ISSUE.ACCOUNT,Y.ACCT,R.CIA.REC,F.CARD.ISSUE.ACCOUNT,R.CIA.REC.ERR)
    IF R.CIA.REC.ERR THEN ;* Tus End
        R.CIA.REC = ''
    END
    Y.DEB.CRD.NUM = R.CIA.REC
    Y.DEB.CRD.NUM = CHANGE(Y.DEB.CRD.NUM,@FM,@VM)
RETURN

GET.TELLER.DETAILS:
*=================
    R.TEL.REC = ''; Y.TEL.ERRH = ''; Y.TEL.ERR1 = ''
    YCHQ.NO = ''; YNARR.1 = ''; YNARR.2 = ''; Y.CASH.NUM = ''
    Y.TXN.REF = FIELD(Y.TXN.REF,'\',1)
    CALL F.READ(FN.TELLER,Y.TXN.REF,R.TEL.REC,F.TELLER,Y.TEL.ERR1)
    IF NOT(R.TEL.REC) THEN
        Y.TXN.REF.HIS = Y.TXN.REF
        CALL EB.READ.HISTORY.REC(F.TELLER$HIS,Y.TXN.REF.HIS,R.TEL.REC,Y.TEL.ERRH)
    END

    YNARR.1 = R.TEL.REC<TT.TE.NARRATIVE.1>
    YNARR.2 = R.TEL.REC<TT.TE.NARRATIVE.2>
    YCHQ.NO = R.TEL.REC<TT.TE.CHEQUE.NUMBER>
    BEGIN CASE
        CASE YNARR.1 AND YCHQ.NO
            Y.FILE.NUM= YNARR.1:"-":YCHQ.NO
        CASE YNARR.2 AND YCHQ.NO
            Y.FILE.NUM= YNARR.2:"-":YCHQ.NO
        CASE YNARR.1 AND YCHQ.NO EQ ''
            Y.FILE.NUM= YNARR.1
        CASE YNARR.2 AND YCHQ.NO EQ ''
            Y.FILE.NUM= YNARR.2
    END CASE

    YACCT1.TT = R.TEL.REC<TT.TE.ACCOUNT.1>
    YACCT2.TT = R.TEL.REC<TT.TE.ACCOUNT.2>

    IF YACCT1.TT EQ YSTMT.ACCT.NO THEN
        Y.CASH.NUM = R.TEL.REC<TT.TE.TELLER.ID.1>
    END ELSE
        Y.CASH.NUM = R.TEL.REC<TT.TE.TELLER.ID.2>
    END
    Y.OVERRIDE = R.TEL.REC<TT.TE.OVERRIDE,1>
RETURN

GET.ACCT.DETAILS:
*===================
    Y.PRE.ACCT.NUM = R.ACT.REC<AC.ALT.ACCT.ID>
    Y.ACCT.NAME = R.ACT.REC<AC.CUSTOMER>
*TUS Start
*Y.PRE.BAL = R.ACT.REC<AC.OPEN.ACTUAL.BAL>
    Y.PRE.BAL = R.ECB<ECB.OPEN.ACTUAL.BAL>
*TUS End
    Y.STMT.SYS = R.STMT.REC<AC.STE.SYSTEM.ID>
RETURN

GET.STMT.DETAILS:
*===============
    R.STMT.REC = ''; STMT.ERR = ''
*Shek CALL CACHE.READ(FN.STMT.ENTRY,Y.SE.ID,R.STMT.REC,STMT.ENTRY.ERR)
    CALL F.READ(FN.STMT.ENTRY,Y.SE.ID,R.STMT.REC,F.STMT.ENTRY,STMT.ERR)
    IF R.STMT.REC THEN
        Y.INP = FIELD(R.STMT.REC<AC.STE.INPUTTER>,'_',2)
        Y.AUTH = FIELD(R.STMT.REC<AC.STE.AUTHORISER>,'_',2)
        K.AGENCY = R.STMT.REC<AC.STE.COMPANY.CODE>
        Y.TXN.REF = R.STMT.REC<AC.STE.TRANS.REFERENCE>
        Y.AMT.LCY = R.STMT.REC<AC.STE.AMOUNT.LCY>
        Y.AMT.FCY = R.STMT.REC<AC.STE.AMOUNT.FCY>
        Y.TRAN.CODE = R.STMT.REC<AC.STE.TRANSACTION.CODE>
        Y.CCY = R.STMT.REC<AC.STE.CURRENCY>
        YSTMT.ACCT.NO = R.STMT.REC<AC.STE.ACCOUNT.NUMBER>
    END
RETURN

******************
READ.FT.AND.FTTC:
******************
    R.FT.REC = ''; Y.FT.ERR2 = ''; Y.FT.ERR = ''
*Shek CALL CACHE.READ(FN.FUNDS.TRANSFER$HIS,Y.TXN.REF.HIS.FT,R.FT.REC,Y.FT.ERR1)
    CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.REF,R.FT.REC,F.FUNDS.TRANSFER,Y.FT.ERR2)
    IF NOT(R.FT.REC) THEN
        Y.TXN.REF.HIS.FT = Y.TXN.REF
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER$HIS,Y.TXN.REF.HIS.FT,R.FT.REC,Y.FT.ERR)
    END
    Y.OVERRIDE = R.FT.REC<FT.OVERRIDE,1>
    Y.FTTC.ID = R.FT.REC<FT.TRANSACTION.TYPE>
    IF K.CHANNEL THEN
        RETURN
    END
    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION,Y.FTTC.ID,R.FTTC.REC,Y.FTTC.ERR)
    K.CHANNEL = R.FTTC.REC<FT6.LOCAL.REF,L.FTTC.CHANNELS>
RETURN

********************
CHECK.SEL.CRITERIA:
********************
    Y.FLAG = ''
    IF Y.TRAN.TYPE AND Y.TRAN.TYPE NE K.TRAN.TYPE THEN
        Y.FLAG = 'N'
        RETURN
    END
    IF NOT(Y.FLAG) AND Y.AGENCY AND Y.AGENCY NE K.AGENCY THEN
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

**************
COMPANY.MATCH:
**************
    IF Y.CHA.AGEN EQ ID.COMPANY THEN
        Y.AGENCY = Y.CHA.AGEN
    END ELSE
        LOCATE Y.CHA.AGEN IN COMP.ID.LIST SETTING jPos THEN
            Y.AGENCY = Y.CHA.AGEN
        END ELSE
            ENQ.ERROR = "EB-INVALID.AGENCY.OR.CHANNEL.CODE"
            RETURN
        END

    END
    Y.AGENCY = Y.CHA.AGEN
    Y.CA.FLAG = 'A'
RETURN
******************
NOT.COMPANY.MATCH:
******************
    CALL CACHE.READ(FN.MNEMONIC.COMPANY,Y.CHA.AGEN,R.MNE.COMP.REC,SEL.ERR2)
    IF R.MNE.COMP.REC THEN
        Y.AGENCY = R.MNE.COMP.REC
        Y.CA.FLAG = 'A'
    END ELSE
        Y.CHN.LIST = R.LT.REC<EB.LTA.VETTING.TABLE>
        Y.CHN.LIST = CHANGE(Y.CHN.LIST,@VM,@FM)
        LOCATE Y.CHA.AGEN IN Y.CHN.LIST<1> SETTING LT.POS THEN
            Y.CHANNEL = Y.CHA.AGEN
            Y.CA.FLAG = 'C'
        END ELSE
            ENQ.ERROR = "EB-INVALID.AGENCY.OR.CHANNEL.CODE"
            RETURN
        END
    END
RETURN
END
