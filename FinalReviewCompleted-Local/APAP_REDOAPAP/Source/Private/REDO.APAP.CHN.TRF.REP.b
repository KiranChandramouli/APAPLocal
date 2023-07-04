* @ValidationCode : MjotMTA5MjU1MDk4MDpDcDEyNTI6MTY4MDYwNDkwOTIyODpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:11:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CHN.TRF.REP(Y.OUT.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CHN.TRF.REP
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.APAP.SEL.CRIT.DISPLAY is the Nofile Routine for the Enquiry REDO.APAP.NOF.CHN.TRF.REP
*
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who               ODR Reference             Description
*   ------         ------              -------------           -------------------
* 09 Mar 2011    Krishna Murthy T.S    ODR-2011-03-0083         Initial Creation
* Date                   who                   Reference              
* 04-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM AND SM TO @SM AND F.READ TO CACHE.READ AND Y.YEAR =Y.YEAR - 1 TO Y.YEAR -= 1 AND REMOVED F.FT.TXN.TYPE.CONDITION
* 04-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CATEGORY
    $INSERT I_F.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_F.DEPT.ACCT.OFFICER

    GOSUB OPEN.PARA
    GOSUB CHECK.SELECTION
    IF NOT(ENQ.ERROR) THEN
        GOSUB BUILD.SELECT.STMT
        IF SEL.LIST.FT THEN
            GOSUB GET.LOCAL.REF.POSN
            GOSUB PROCESS
        END
    END

RETURN

CHECK.SELECTION:
*===============
* Selection field Validations

    Y.TRAN.CHANNEL = '' ; Y.TRAN.TYPE = '' ; Y.FROM.DATE = '' ; Y.TO.DATE = ''
    Y.OUT.ARRAY = '' ; SEL.FLD.DISP = "$*" ; Y.DATE = '' ; Y.SEL.FLAG = ''
    Y.TRAN.CODE = '' ; Y.TRAN.PROD = '' ; Y.AGENCY = '' ; Y.TRAN.MONTH = ''
    Y.MTH.NAME = '' ; Y.TP.OF.ID = '' ; Y.CLIENT.DOC = ''; Y.CATEG.DESC = ''

    Y.TRAN.CHANNEL = ''
    LOCATE "TRAN.CHANNEL" IN D.FIELDS<1> SETTING Y.TCHAN.POS THEN
        Y.TRAN.CHANNEL = D.RANGE.AND.VALUE<Y.TCHAN.POS>
        IF SEL.FLD.DISP EQ "$*" THEN
            SEL.FLD.DISP := "Canal Txn : ":Y.TRAN.CHANNEL
        END ELSE
            SEL.FLD.DISP := ", Canal Txn : ":Y.TRAN.CHANNEL
        END
    END

    Y.TRAN.TYPE = ''
    LOCATE "TRAN.TYPE" IN D.FIELDS<1> SETTING Y.TTYPE.POS THEN
        Y.TRAN.TYPE = D.RANGE.AND.VALUE<Y.TTYPE.POS>
        IF SEL.FLD.DISP EQ "$*" THEN
            SEL.FLD.DISP:= "Tipo Txn : ":Y.TRAN.TYPE
        END ELSE
            SEL.FLD.DISP:= ", Tipo Txn : ":Y.TRAN.TYPE
        END
    END

    Y.FROM.DATE = '' ; Y.TO.DATE = '' ; Y.TRAN.CHA.DATE = ''
    Y.FMT.FROM.DATE = '' ; Y.FMT.TO.DATE = ''
    LOCATE 'TRAN.CHA.DATE' IN D.FIELDS<1> SETTING Y.TCD.POS THEN
        Y.TRAN.CHA.DATE = D.RANGE.AND.VALUE<Y.TCD.POS>
        Y.FROM.DATE = FIELD(Y.TRAN.CHA.DATE,@SM,1)
        Y.TO.DATE = FIELD(Y.TRAN.CHA.DATE,@SM,2)
        GOSUB VALIDATE.DATE.SEL
        Y.FROM.DATE1=ICONV(Y.FROM.DATE,"DJ")
        Y.FROM.DATE1=OCONV(Y.FROM.DATE1,"D4E")
        Y.TO.DATE1=ICONV(Y.TO.DATE,"DJ")
        Y.TO.DATE1=OCONV(Y.TO.DATE1,"D4E")
        Y.FMT.FROM.DATE = Y.FROM.DATE[7,2]:"/":Y.FROM.DATE[5,2]:"/":Y.FROM.DATE[1,4]
        Y.FMT.TO.DATE = Y.TO.DATE[7,2]:"/":Y.TO.DATE[5,2]:"/":Y.TO.DATE[1,4]
        IF SEL.FLD.DISP EQ "$*" THEN
            SEL.FLD.DISP := "Fecha Txn : ":Y.FROM.DATE1:" - ":Y.TO.DATE1
        END ELSE
            SEL.FLD.DISP := ", Fecha Txn : ":Y.FROM.DATE1:" - ":Y.TO.DATE1
        END
    END
    LOCATE "TRAN.CODE" IN D.FIELDS<1> SETTING Y.TCODE.POS THEN
        Y.TRAN.CODE = D.RANGE.AND.VALUE<Y.TCODE.POS>
        IF SEL.FLD.DISP EQ "$*" THEN
            SEL.FLD.DISP := "Descripcion Txn : ":Y.TRAN.CODE
        END ELSE
            SEL.FLD.DISP := ", Descripcion Txn : ":Y.TRAN.CODE
        END
    END
    LOCATE "TRAN.PROD" IN D.FIELDS<1> SETTING Y.TPROD.POS THEN
        Y.TRAN.PROD = D.RANGE.AND.VALUE<Y.TPROD.POS>
        IF SEL.FLD.DISP EQ "$*" THEN
            SEL.FLD.DISP := "Producto Txn : ":Y.TRAN.PROD
        END ELSE
            SEL.FLD.DISP := ", Producto Txn : ":Y.TRAN.PROD

            Y.SEL.FLAG = 'Y'
        END
    END
    LOCATE "AGENCY" IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
        Y.AGENCY = D.RANGE.AND.VALUE<Y.AGENCY.POS>
        IF SEL.FLD.DISP EQ "$*" THEN
            SEL.FLD.DISP := "Agencia : ":Y.AGENCY
        END ELSE
            SEL.FLD.DISP := ", Agencia : ":Y.AGENCY
        END
    END
    LOCATE "TRAN.MONTH" IN D.FIELDS<1> SETTING Y.TMTH.POS THEN
        Y.TRAN.MONTH = D.RANGE.AND.VALUE<Y.TMTH.POS>
        IF TRIM(Y.TRAN.MONTH) GE 1 AND TRIM(Y.TRAN.MONTH) LE 12 THEN
            IF SEL.FLD.DISP EQ "$*" THEN
                SEL.FLD.DISP := "Mes Txn : ":Y.TRAN.MONTH
            END ELSE
                SEL.FLD.DISP := ", Mes Txn : ":Y.TRAN.MONTH
            END
        END ELSE
            ENQ.ERROR = "EB-INVALID.MONTH"
            RETURN
        END
    END

    K.CHN.TYPE = ''  ; CT.CHN.TYPE = ''
    K.TRN.TYPE = ''  ; CT.TRN.TYPE = '' ; K.AGENCY = ''
    K.TRNCODE.TYPE = ''  ; CT.TRNCODE.TYPE = '' ; CT.AGENCY = ''
    K.TRNPROD.TYPE = ''  ; CT.TRNPROD.TYPE = ''

RETURN

VALIDATE.DATE.SEL:
*=================
* Transaction channel date field validations
    IF Y.TRAN.CHA.DATE THEN
        IF NOT(NUM(Y.FROM.DATE)) AND NOT(NUM(Y.TO.DATE)) AND LEN(Y.FROM.DATE) NE 8 AND LEN(Y.TO.DATE) NE 8 THEN
            ENQ.ERROR = "EB-DATE.NOT.VALID"
            RETURN
        END
        IF Y.FROM.DATE AND NOT(Y.TO.DATE) THEN
            ENQ.ERROR = "EB-TO.DATE.MAND"
            RETURN
        END
        IF NOT(Y.FROM.DATE) AND Y.TO.DATE THEN
            ENQ.ERROR = "EB-FROM.DATE.MAND"
            RETURN
        END
        IF Y.FROM.DATE GT Y.TO.DATE THEN
            ENQ.ERROR = "EB-TO.DATE.SHOULD.GT.FROM.DATE"
            RETURN
        END
    END

RETURN

BUILD.SELECT.STMT:
*=================
*Selection Criteria for the Report
    SEL.CMD.FT = "SELECT ":FN.FUNDS.TRANSFER$HIS
    SEL.CMD.FT.LIVE = "SELECT ":FN.FUNDS.TRANSFER
    IF Y.TRAN.MONTH THEN
        Y.YEAR = TODAY[1,4]
        IF Y.TRAN.MONTH LT TODAY[5,2] THEN
            IF TODAY[5,2] EQ '12' THEN
                Y.YEAR -= 1  ;*R22 AUTO CONVERSTION Y.YEAR =Y.YEAR - 1 TO Y.YEAR -= 1
            END
        END
        Y.TRAN.MTH = TRIM(Y.TRAN.MONTH)
        IF LEN(Y.TRAN.MTH) EQ 1 THEN
            Y.TRAN.MTH = Y.YEAR[1,4]:'0':Y.TRAN.MTH
        END ELSE
            Y.TRAN.MTH = Y.YEAR[1,4]:Y.TRAN.MTH
        END
        SEL.CMD.FT:= " WITH DEBIT.VALUE.DATE LIKE ":Y.TRAN.MTH:"..."
        SEL.CMD.FT.LIVE:= " WITH DEBIT.VALUE.DATE LIKE ":Y.TRAN.MTH:"..."
    END
    IF Y.TRAN.CHA.DATE THEN
        IF Y.TRAN.MONTH THEN
            SEL.CMD.FT:= " AND (DEBIT.VALUE.DATE GE ":Y.FROM.DATE:")"
            SEL.CMD.FT.LIVE:= " AND (DEBIT.VALUE.DATE GE ":Y.FROM.DATE:")"
        END ELSE
            SEL.CMD.FT:= " WITH (DEBIT.VALUE.DATE GE ":Y.FROM.DATE:")"
            SEL.CMD.FT.LIVE:= " WITH (DEBIT.VALUE.DATE GE ":Y.FROM.DATE:")"
        END
        SEL.CMD.FT:= " AND (DEBIT.VALUE.DATE LE ":Y.TO.DATE:")"
        SEL.CMD.FT.LIVE:= " AND (DEBIT.VALUE.DATE LE ":Y.TO.DATE:")"
    END
    CALL EB.READLIST(SEL.CMD.FT,SEL.LIST.FT,'',NO.OF.REC.FT,SEL.ERR.FT)
    CALL EB.READLIST(SEL.CMD.FT.LIVE,SEL.LIST.FT.LIVE,'',NO.OF.REC.FT.LIVE,SEL.ERR.FT)

RETURN

OPEN.PARA:
*=========
* Opening all the necesseary tables & Initialising the varibles
    FN.FUNDS.TRANSFER$HIS = "F.FUNDS.TRANSFER$HIS" ; F.FUNDS.TRANSFER$HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER$HIS,F.FUNDS.TRANSFER$HIS)

    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER" ; F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FT.TXN.TYPE.CONDITION = "F.FT.TXN.TYPE.CONDITION" ; F.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    FN.TRANSACTION = 'F.TRANSACTION' ; F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.DEPT.ACCT.OFFICER = "F.DEPT.ACCT.OFFICER" ; F.DEPT.ACCT.OFFICER = ''
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)

    FN.ACCOUNT = "F.ACCOUNT" ; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = "F.CUSTOMER" ; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CATEGORY = "F.CATEGORY" ; F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    FN.EB.EXTERNAL.USER = "F.EB.EXTERNAL.USER" ; F.EB.EXTERNAL.USER = ''
    CALL OPF(FN.EB.EXTERNAL.USER,F.EB.EXTERNAL.USER)

RETURN

GET.TRAN.CATEG.DESC:
*===================

    IF Y.TRAN.PROD THEN
        Y.TRAN.PROD.ID = Y.TRAN.PROD
    END ELSE
        Y.TRAN.PROD.ID = R.AC.REC<AC.CATEGORY>
    END
    CALL CACHE.READ(FN.CATEGORY,Y.TRAN.PROD.ID,R.CAT.REC,Y.CAT.ERR)
    Y.CATEG.DESC = R.CAT.REC<EB.CAT.DESCRIPTION>

RETURN

GET.CLIENT.AND.TYPE.OF.ID:
*========================
    Y.L.CU.CIDENT = R.CU.REC<EB.CUS.LOCAL.REF,L.CU.CIDENT>
    Y.LEGAL.ID = R.CU.REC<EB.CUS.LEGAL.ID>
    Y.L.CU.RNC = R.CU.REC<EB.CUS.LOCAL.REF,L.CU.RNC>
    Y.L.CU.ACTANAC = R.CU.REC<EB.CUS.LOCAL.REF,L.CU.ACTANAC>
    Y.L.CU.NOUNICO = R.CU.REC<EB.CUS.LOCAL.REF,L.CU.NOUNICO>

    IF Y.L.CU.CIDENT THEN
        Y.TP.OF.ID = "CEDULA"
        Y.CLIENT.DOC = Y.L.CU.CIDENT
    END ELSE
        IF Y.LEGAL.ID THEN
            Y.TP.OF.ID = "PASSAPORTE"
            Y.CLIENT.DOC = Y.LEGAL.ID
        END ELSE
            IF Y.L.CU.RNC THEN
                Y.TP.OF.ID = "RNC"
                Y.CLIENT.DOC = Y.L.CU.RNC
            END ELSE
                IF Y.L.CU.ACTANAC THEN
                    Y.TP.OF.ID = "ACTA NACIMIENTO"
                    Y.CLIENT.DOC = Y.L.CU.ACTANAC
                END ELSE
                    IF Y.L.CU.NOUNICO THEN
                        Y.TP.OF.ID = "NUMERO UNICO"
                        Y.CLIENT.DOC = Y.L.CU.NOUNICO
                    END
                END
            END
        END
    END
RETURN

GET.EB.EXTERNAL.USER.DTLS:
*==========================
    Y.INPUTTER = R.FT.REC<FT.INPUTTER>
    Y.EB.EXT.NAME = FIELD(Y.INPUTTER,'_',2,1)
RETURN

GET.DAO.NAME:
*============
    CALL CACHE.READ(FN.DEPT.ACCT.OFFICER,Y.CU.AF,R.DAO.REC,Y.DAO.ERR)
    Y.DAO.NAME = R.DAO.REC<EB.DAO.NAME>

RETURN

GET.TRAN.CODE.DTLS:
*==================
    IF Y.TRAN.CODE THEN
        Y.TRAN.ID = Y.TRAN.CODE
    END ELSE
        Y.TRAN.ID = R.FTTC.REC<FT6.TXN.CODE.CR>
    END

    CALL CACHE.READ(FN.TRANSACTION,Y.TRAN.ID,R.TRN.REC,Y.TRN.ERR)
    Y.TRN.DESC = R.TRN.REC<AC.TRA.NARRATIVE,2>
    IF Y.TRN.DESC EQ '' THEN
        Y.TRN.DESC = R.TRN.REC<AC.TRA.NARRATIVE,1>
    END
RETURN

GET.LOCAL.REF.POSN:
*==================
*Getting the Local reference field Positions
    FTTC.LR.FIELDS = "L.FTTC.CHANNELS":@VM:"L.FTTC.PAY.TYPE"
    CU.LR.FIELDS   = "L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.ACTANAC":@VM:"L.CU.NOUNICO":@VM:"L.CU.TIPO.CL"

    Y.LOC.FLDS   = FTTC.LR.FIELDS:@FM:CU.LR.FIELDS
    Y.APPLNS     = "FT.TXN.TYPE.CONDITION":@FM:"CUSTOMER"
    Y.LOC.POSNS  = ''
    FTTC.LR.POSN = ''
    CALL MULTI.GET.LOC.REF(Y.APPLNS,Y.LOC.FLDS,Y.LOC.POSNS)

    L.FTTC.CHANNELS = Y.LOC.POSNS<1,1>
    L.FTTC.PAY.TYPE = Y.LOC.POSNS<1,2>
    L.CU.CIDENT     = Y.LOC.POSNS<2,1>
    L.CU.RNC        = Y.LOC.POSNS<2,2>
    L.CU.ACTANAC    = Y.LOC.POSNS<2,3>
    L.CU.NOUNICO    = Y.LOC.POSNS<2,4>
    L.CU.TIPO.CL    = Y.LOC.POSNS<2,5>
RETURN

COUNT.TRAN.TYPES:
*=================
    IF NOT(Y.TRAN.CHANNEL) THEN
        LOCATE Y.FTTC.CHANNEL IN K.CHN.TYPE<1> BY 'AR' SETTING Y.POS ELSE
            INS Y.FTTC.CHANNEL BEFORE K.CHN.TYPE<Y.POS>
            CT.CHN.TYPE+= 1
        END
    END
    IF NOT(Y.TRAN.TYPE) THEN
        LOCATE Y.FTTC.TYPE IN K.TRN.TYPE<1> BY 'AR' SETTING Y.POS ELSE
            INS Y.FTTC.TYPE BEFORE K.TRN.TYPE<Y.POS>
            CT.TRN.TYPE+= 1
        END
    END
    IF NOT(Y.TRAN.PROD) THEN
        LOCATE R.AC.REC<AC.CATEGORY> IN K.TRNPROD.TYPE<1> BY 'AR' SETTING Y.POS ELSE
            INS Y.TRAN.PROD BEFORE K.TRNPROD.TYPE<Y.POS>
            CT.TRNPROD.TYPE+= 1
        END
    END
    IF NOT(Y.TRAN.CODE) THEN
        LOCATE R.FTTC.REC<FT6.TXN.CODE.CR> IN K.TRNCODE.TYPE<1> BY 'AR' SETTING Y.POS ELSE
            INS R.FTTC.REC<FT6.TXN.CODE.CR> BEFORE K.TRNCODE.TYPE<Y.POS>
            CT.TRNCODE.TYPE+= 1
        END
    END
    IF NOT(Y.AGENCY) THEN
        LOCATE R.CU.REC<EB.CUS.OTHER.OFFICER,1> IN K.AGENCY<1> BY 'AR' SETTING Y.POS ELSE
            INS R.CU.REC<EB.CUS.OTHER.OFFICER,1> BEFORE K.AGENCY<Y.POS>
            CT.AGENCY+= 1
        END
    END
RETURN

GET.DR.FT.MTH:
*=============
* Y.MTH = TRIM(R.FT.REC<FT.DEBIT.VALUE.DATE>[5,2])
    BEGIN CASE
        CASE Y.MTH EQ '1'
            Y.MTH.NAME = 'Enero'
        CASE Y.MTH EQ '2'
            Y.MTH.NAME = 'Febrebo'
        CASE Y.MTH EQ '3'
            Y.MTH.NAME = 'Marzo'
        CASE Y.MTH EQ '4'
            Y.MTH.NAME = 'Abrill'
        CASE Y.MTH EQ '5'
            Y.MTH.NAME = 'Mayo'
        CASE Y.MTH EQ '6'
            Y.MTH.NAME = 'Junio'
        CASE Y.MTH EQ '7'
            Y.MTH.NAME = 'Julio'
        CASE Y.MTH EQ '8'
            Y.MTH.NAME = 'Agosto'
        CASE Y.MTH EQ '8'
            Y.MTH.NAME = 'Septiembre'
        CASE Y.MTH EQ '10'
            Y.MTH.NAME = 'Octubre'
        CASE Y.MTH EQ '11'
            Y.MTH.NAME = 'Noviembre'
        CASE Y.MTH EQ '12'
            Y.MTH.NAME = 'Diciembre'
    END CASE

RETURN

CHK.TRN.CHANNEL.TYPE:
*====================
    Y.FLAG = '' ; R.FTTC.REC = ''

    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, Y.FTTC.ID, R.FTTC.REC, Y.FTTC.ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.FT.TXN.TYPE.CONDITION
    Y.FTTC.CHANNEL = R.FTTC.REC<FT6.LOCAL.REF,L.FTTC.CHANNELS>
    Y.FTTC.TYPE = R.FTTC.REC<FT6.LOCAL.REF,L.FTTC.PAY.TYPE>

    GOSUB GET.TRAN.CODE.DTLS
    IF Y.TRAN.CHANNEL AND Y.TRAN.CHANNEL NE Y.FTTC.CHANNEL THEN
        Y.FLAG = 'N'
    END
    IF NOT(Y.FLAG) AND Y.TRAN.TYPE THEN
        IF Y.TRAN.TYPE NE Y.FTTC.TYPE THEN
            Y.FLAG = 'N'
        END
    END
    IF NOT(Y.FLAG) AND Y.TRAN.CODE THEN
        IF Y.TRAN.CODE NE R.FTTC.REC<FT6.TXN.CODE.CR> OR Y.TRAN.CODE NE R.FTTC.REC<FT6.TXN.CODE.DR> THEN
            Y.FLAG = 'N'
        END
    END

RETURN

MATCH.SEL.CRITERIA:
*=================
    GOSUB CHK.TRN.CHANNEL.TYPE
    R.AC.REC = '' ; R.CU.REC = ''
    CALL F.READ(FN.ACCOUNT,Y.DR.ACCT.NO,R.AC.REC,F.ACCOUNT,Y.AC.ERR)
    CALL F.READ(FN.CUSTOMER,R.AC.REC<AC.CUSTOMER>,R.CU.REC,F.CUSTOMER,Y.CU.ERR)
    GOSUB GET.EB.EXTERNAL.USER.DTLS

    IF Y.TRAN.PROD AND Y.TRAN.PROD NE R.AC.REC<AC.CATEGORY> THEN
        Y.FLAG = 'N'
    END

    Y.CU.AF = R.CU.REC<EB.CUS.OTHER.OFFICER,1>
    IF Y.AGENCY AND Y.AGENCY NE Y.CU.AF THEN
        Y.FLAG = 'N'
    END

RETURN

PROCESS:
*=======
    LOOP
        REMOVE Y.FT.ID FROM SEL.LIST.FT SETTING Y.FT.POS
    WHILE Y.FT.ID:Y.FT.POS
        R.FT.REC = ''
        CALL F.READ(FN.FUNDS.TRANSFER$HIS,Y.FT.ID,R.FT.REC,F.FUNDS.TRANSFER$HIS,Y.FT.ERR)
        Y.FTTC.ID = R.FT.REC<FT.TRANSACTION.TYPE>
        Y.DR.ACCT.NO = R.FT.REC<FT.DEBIT.ACCT.NO>
        GOSUB MATCH.SEL.CRITERIA
        IF Y.FLAG NE 'N' THEN
            GOSUB GET.FIELD.VALUES
        END
    REPEAT
    Y.FLAG = ''
    LOOP
        REMOVE Y.FT.ID FROM SEL.LIST.FT.LIVE SETTING Y.FT.POS
    WHILE Y.FT.ID:Y.FT.POS
        R.FT.REC = ''
        CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FT.REC,F.FUNDS.TRANSFER,Y.FT.ERR)
        Y.FTTC.ID = R.FT.REC<FT.TRANSACTION.TYPE>
        Y.DR.ACCT.NO = R.FT.REC<FT.DEBIT.ACCT.NO>
        GOSUB MATCH.SEL.CRITERIA
        IF Y.FLAG NE 'N' THEN
            GOSUB GET.FIELD.VALUES
        END
    REPEAT

    IF Y.OUT.ARRAY THEN
        GOSUB BUILD.HEADER.TOTALS
    END

RETURN

BUILD.HEADER.TOTALS:
*===================
    H.LINE = ''
    H.LINE<1> = Y.FMT.FROM.DATE
    H.LINE<2> = Y.FMT.TO.DATE
    IF Y.TRAN.CHANNEL THEN
        H.LINE<3> = 1
    END ELSE
        H.LINE<3> = CT.CHN.TYPE
    END
    IF Y.TRAN.TYPE THEN
        H.LINE<4> = 1
    END ELSE
        H.LINE<4> = CT.TRN.TYPE
    END
    IF Y.TRAN.CODE THEN
        H.LINE<5> = 1
    END ELSE
        H.LINE<5> = CT.TRNCODE.TYPE
    END
    IF Y.TRAN.PROD THEN
        H.LINE<6> = 1
    END ELSE
        H.LINE<6> = CT.TRNPROD.TYPE
    END

    IF Y.TRAN.MONTH THEN
        Y.MTH = Y.TRAN.MONTH
        GOSUB GET.DR.FT.MTH
        H.LINE<7> = Y.MTH.NAME
    END ELSE
        Y.MTH = Y.FROM.DATE[5,2]
        GOSUB GET.DR.FT.MTH
        H.LINE<7> = Y.MTH.NAME:" ":Y.FROM.DATE[1,4]:" a ":
        Y.MTH = Y.TO.DATE[5,2]
        GOSUB GET.DR.FT.MTH
        H.LINE<7> := Y.MTH.NAME:" ":Y.TO.DATE[1,4]
    END

    IF Y.AGENCY THEN
        H.LINE<8> = 1
    END ELSE
        H.LINE<8> = CT.AGENCY
    END
    H.LINE = CHANGE(H.LINE,@FM,"#")
*    Assign the values to the 1st record of the array
    Y.SEL.CNT = DCOUNT(SEL.FLD.DISP,',')
    IF Y.SEL.CNT EQ 7 THEN
        SEL.FLD.DISP = "$*ALL"
    END
    IF SEL.FLD.DISP EQ '$*' THEN
        SEL.FLD.DISP = '$*ALL'
    END
    Y.OUT.ARRAY<1>:= SEL.FLD.DISP:"$*#":H.LINE:"#"

RETURN

GET.FIELD.VALUES:
*===============
    Y.CHN.DT = R.FT.REC<FT.DEBIT.VALUE.DATE>
    GOSUB GET.TRAN.CATEG.DESC
    GOSUB GET.DAO.NAME
    Y.CLIENT.TYPE = R.CU.REC<EB.CUS.LOCAL.REF,L.CU.TIPO.CL>
    Y.MTH = TRIM(R.FT.REC<FT.DEBIT.VALUE.DATE>[5,2])
    GOSUB GET.DR.FT.MTH
    Y.DR.AMT = R.FT.REC<FT.DEBIT.AMOUNT>
    Y.DR.AC = R.FT.REC<FT.DEBIT.ACCT.NO>
    Y.AC.ALT.ID = R.AC.REC<AC.ALT.ACCT.ID>
    Y.FT.DR.CU = R.AC.REC<AC.CUSTOMER>
    GOSUB GET.CLIENT.AND.TYPE.OF.ID
    GOSUB COUNT.TRAN.TYPES
    GOSUB APPEND.DATA

RETURN

APPEND.DATA:
*===========
    Y.OUT.ARRAY1 = ''
    Y.OUT.ARRAY1 = Y.FTTC.CHANNEL:"$*":Y.FTTC.TYPE:"$*":Y.CHN.DT:"$*":Y.TRN.DESC:"$*"
    Y.OUT.ARRAY1:= Y.CATEG.DESC:"$*":Y.DAO.NAME:"$*":Y.CLIENT.TYPE:"$*":Y.MTH.NAME:"$*"
    Y.OUT.ARRAY1:= Y.DR.AMT:"$*":Y.DR.AC:"$*":Y.AC.ALT.ID:"$*":Y.FT.DR.CU:"$*"
    Y.OUT.ARRAY1:= Y.TP.OF.ID:"$*":Y.CLIENT.DOC:"$*":Y.EB.EXT.NAME
    Y.OUT.ARRAY<-1> = Y.OUT.ARRAY1

RETURN

END
