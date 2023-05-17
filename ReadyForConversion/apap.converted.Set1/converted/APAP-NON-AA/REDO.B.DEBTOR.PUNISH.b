SUBROUTINE REDO.B.DEBTOR.PUNISH(Y.AA.ARR.ID)
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine is used to write the final report array to REDO.REPORT.TEMP
*
* Developed By          : Nowful Rahman M
*
* Development Reference : 202_DE05
*
* Attached To           : BNK/REDO.B.DEBTOR.PUNISH
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : Y.AA.ARR.ID
* Argument#2 : NA
* Argument#3 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*   Date       Author              Modification Description
*
* 29/10/2014  Ashokkumar.V.P        PACS00400717 - New mapping changes
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.B.DEBTOR.PUNISH.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON

    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------------------------------------------
*Intialize the variables
*-----------------------------------------------------------------------------------------------------------------
    Y.PROD.GRP = ''
    Y.CUS.NO = ''
    Y.ACCT.NO = ''
    Y.CUS.REL.CODE = ''
    Y.LOAN.STATUS = ''
    Y.PRIN.INT.AMT = ''
    Y.TYPE.VINCULATION = ''
    Y.CR.TYPE = ''
    Y.REL.REQ = ''
    Y.PRODUCT.GROUP = ""
    Y.AA.ARR.STATUS = ""
    Y.PRODUCT.LINE = ""
    Y.AC.PROP.CLASS = "ACCOUNT"
    Y.AC.PROPERTY = ""
    Y.CUST.IDEN = ""
    Y.CUST.TYPE = ""
    Y.CUST.NAME = ""
    Y.CUST.GN.NAME = ""
    Y.OUT.ARR = ""
RETURN
*-----------------------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------------------
*Read AA.ARRANGEMENT and get the values of STATUS, PRODUCT.GROUP, PRODUCT.LINE & CUSTOMER
*-----------------------------------------------------------------------------------------------------------------
    CALL AA.GET.ARRANGEMENT(Y.AA.ARR.ID,R.AA.ARRANGEMENT,AA.ERR)
    IF R.AA.ARRANGEMENT EQ '' THEN
        GOSUB RAISE.ERR.C.22
    END
    Y.PRODUCT.LINE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.LINE>
    Y.PRODUCT.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.AA.ARR.STATUS = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
    Y.PRODUCT = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    IF Y.PRODUCT.LINE EQ "LENDING" AND (Y.AA.ARR.STATUS EQ "CURRENT" OR Y.AA.ARR.STATUS EQ "EXPIRED") AND (Y.PRODUCT.GROUP EQ "HIPOTECARIO" OR Y.PRODUCT.GROUP EQ "CONSUMO" OR Y.PRODUCT.GROUP EQ "COMERCIAL" OR Y.PRODUCT.GROUP EQ "LINEAS.DE.CREDITO" OR Y.PRODUCT.GROUP EQ "LINEA.CREDITO.TC") THEN
    END ELSE
        RETURN
    END
    CALL AA.GET.PROPERTY.NAME(R.AA.ARRANGEMENT,Y.AC.PROP.CLASS,Y.AC.PROPERTY)
    GOSUB GET.ACCT.ID
    Y.CUS.NO = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    ARRAY.VAL = ''; Y.LOAN.STATUS = ''; Y.CLOSE.LN.FLG = 0
    CALL REDO.RPT.CLSE.WRITE.LOANS(Y.AA.ARR.ID,R.AA.ARRANGEMENT,ARRAY.VAL)
    Y.LOAN.STATUS = ARRAY.VAL<1>
    Y.CLOSE.LN.FLG = ARRAY.VAL<2>
    IF Y.LOAN.STATUS NE "Write-off" THEN
        RETURN
    END
    IF Y.CLOSE.LN.FLG NE 1 THEN
        GOSUB READ.CUSTOMER
        GOSUB READ.AA.ARR.OVERDUE
        GOSUB MAP.FIELD.RCL
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
GET.ACCT.ID:
*-----------------------------------------------------------------------------------------------------------------
*Get the account id
*-----------------------------------------------------------------------------------------------------------------
    Y.ACCT.NO = ""
    Y.LINK.APP = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL>
    Y.LINK.APP.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    LOCATE "ACCOUNT" IN Y.LINK.APP<1,1> SETTING Y.AA.AC.POS THEN
        Y.ACCT.NO = Y.LINK.APP.ID<1,Y.AA.AC.POS>
    END

    Y.PREV.ACCOUNT = ''; R.ACCOUNT = ''; ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    IF NOT(R.ACCOUNT) THEN
        RETURN
    END
    Y.ARRAY.VAL = ''; Y.PREV.ACCOUNT = ''
    YACCT.GRP = R.ACCOUNT:"###":R.AA.ARRANGEMENT
    CALL REDO.RPT.ACCT.ALT.LOANS(YACCT.GRP,Y.PREV.ACCOUNT)
    IF NOT(Y.PREV.ACCOUNT) THEN
        Y.PREV.ACCOUNT = Y.ACCT.NO
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
READ.AA.ARR.OVERDUE:
*-----------------------------------------------------------------------------------------------------------------
* Using Core API AA.GET.ARRANGEMENT.CONDITIONS, read the overdue record
* Get the value of the fields STATUS & L.STATUS.CHG.DT
*-----------------------------------------------------------------------------------------------------------------
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.AA.ARR.ID,Y.PROPERTY.CLASS,Y.PROPERTY,'','',Y.RETURN.CONDITION,Y.RET.ERR)
    R.AA.ARR.OVERDUE = ""
    R.AA.ARR.OVERDUE = RAISE(Y.RETURN.CONDITION)
    IF R.AA.ARR.OVERDUE NE '' THEN
        Y.L.LN.STATUS = R.AA.ARR.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.STATUS.1.POS>
        Y.OD.STATUS.ARR = R.AA.ARR.OVERDUE<AA.OD.OVERDUE.STATUS>
        Y.OD.STATUS.ARR = CHANGE(Y.OD.STATUS.ARR,@VM,@FM)
        Y.OD.STATUS.ARR = "CUR":@FM:"DUE":@FM:Y.OD.STATUS.ARR
        Y.STATUS.CHG.DT = R.AA.ARR.OVERDUE<AA.OD.LOCAL.REF,Y.STATUS.CHG.DT.POS>
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
READ.CUSTOMER:
*-----------------------------------------------------------------------------------------------------------------
*Read Customer and get the value for thr field RELATION.CODE
*-----------------------------------------------------------------------------------------------------------------

    CALL F.READ(FN.CUSTOMER,Y.CUS.NO,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER NE '' THEN
        Y.CUS.REL.CODE.ARR = R.CUSTOMER<EB.CUS.RELATION.CODE>
        GOSUB GET.REL.CODE
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
GET.REL.CODE:
*-----------------------------------------------------------------------------------------------------------------
*Frame Loop and remove relation code from array
*-----------------------------------------------------------------------------------------------------------------

    Y.REL.CNT = DCOUNT(Y.CUS.REL.CODE.ARR,@VM)
    Y.CNT1 = 1
    LOOP
    WHILE Y.CNT1 LE Y.REL.CNT AND Y.TYPE.VINCULATION EQ ''
        Y.CUS.REL.CODE = Y.CUS.REL.CODE.ARR<1,Y.CNT1>
        GOSUB DEF.TYP.VINCULATION
        Y.CNT1 += 1
    REPEAT
    IF NOT(Y.TYPE.VINCULATION) THEN
        Y.TYPE.VINCULATION = 'NI'
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
DEF.TYP.VINCULATION:
*-----------------------------------------------------------------------------------------------------------------
*Defaulting value for type of vinculation based upon relation code
*-----------------------------------------------------------------------------------------------------------------

    LOCATE "RELATION.CODE" IN Y.FIELD.NME.ARR<1,1> SETTING REL.POS THEN
        Y.REL.VAL.ARR = Y.FIELD.VAL.ARR<1,REL.POS>
        Y.REL.DIS.ARR = Y.DISP.TEXT.ARR<1,REL.POS>
    END ELSE
        RETURN
    END
    Y.REL.VAL.ARR = CHANGE(Y.REL.VAL.ARR,@SM,@VM)
    Y.REL.DIS.ARR = CHANGE(Y.REL.DIS.ARR,@SM,@VM)
    LOCATE Y.CUS.REL.CODE IN Y.REL.VAL.ARR<1,1> SETTING POS.REL THEN
        Y.TYPE.VINCULATION = Y.REL.DIS.ARR<1,POS.REL>
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
MAP.FIELD.RCL:
*-----------------------------------------------------------------------------------------------------------------
*Mapping field for RCL
*REDO.S.REP.CUSTOMER.EXTRACT is generic routine
*-----------------------------------------------------------------------------------------------------------------
    CALL REDO.S.REP.CUSTOMER.EXTRACT(Y.CUS.NO,Y.PRODUCT.GROUP,Y.REL.REQ,Y.OUT.ARR)
    Y.CUST.IDEN = Y.OUT.ARR<1>
    Y.CUST.TYPE = Y.OUT.ARR<2>
    Y.CUST.NAME = Y.OUT.ARR<3>
    Y.CUST.GN.NAME = Y.OUT.ARR<4>
*--------------------------------------------------------------
*Identificador del deudor/Emisor(Customer identification number)
*---------------------------------------------------------------
    C$SPARE(451) = Y.CUST.IDEN
*-----------------------------------------
*Tipo de deudor/Emisor(Client type person)
*-----------------------------------------
    C$SPARE(452) = Y.CUST.TYPE
*-------------------------------
*Nombres/razocial(Customer Name)
*-------------------------------
    C$SPARE(453) = Y.CUST.NAME
*------------------------------------
*Apellidos/siglas(Surname / Acronyms)
*------------------------------------
    C$SPARE(454) = Y.CUST.GN.NAME
*-----------------------------------------------------------------------
*Monto de las obligaciones castigadas/Condonadas(Punish amount's credit)
*-----------------------------------------------------------------------
    GOSUB DEF.PRIN.INT.AMT
*-------------------------------
*Codigo del Credito(Loan Number)
*-------------------------------
    C$SPARE(456) = Y.PREV.ACCOUNT
*-------------------------------------------------
*Codigo Cuenta Contable(Accounting account number
*-------------------------------------------------
    GOSUB READ.EB.CONT.BAL
    C$SPARE(457) = Y.REGULATORY.ACC.NO
*----------------------------------
*Fecha del castigo(Punishment Date)
*----------------------------------
    IF Y.STATUS.CHG.DT THEN
        Y.STATUS.CHG.DT = Y.STATUS.CHG.DT[7,2]:"/":Y.STATUS.CHG.DT[5,2]:"/":Y.STATUS.CHG.DT[1,4]
*    Y.PUNISH.DT = ICONV(Y.STATUS.CHG.DT,"D")
*    C$SPARE(458) = OCONV(Y.PUNISH.DT,"D4/")
        C$SPARE(458) = Y.STATUS.CHG.DT
    END
*------------------------------
*Tipo de operacion(Credit Type)
*------------------------------
    GOSUB DEF.CR.TYPE
    C$SPARE(459) = Y.CR.TYPE
*----------------------------------------
*Tipo de Vinculacion(Type of Vinculation)
*----------------------------------------
    C$SPARE(460) = Y.TYPE.VINCULATION
*----------------------------------
*Assigning value to RCL
*----------------------------------
*                   1                  2          3                  4                5                     6            7                      8              9                 10
*    Y.ARR<-1> = Y.CUST.IDEN:"*":Y.CUST.TYPE:"*":Y.CUST.NAME:"*":Y.CUST.GN.NAME:"*":Y.PRIN.INT.AMT:"*":Y.ACCT.NO:"*":Y.REGULATORY.ACC.NO:"*":Y.PUNISH.DT:"*":Y.CR.TYPE:"*":Y.TYPE.VINCULATION
    IF Y.PRIN.INT.AMT LT '0' THEN
        C$SPARE(455) = ABS(Y.PRIN.INT.AMT)
        MAP.FMT = "MAP"
        ID.RCON.L = "REDO.RCL.DE05"
        APP = FN.AA.ARR.OVERDUE
        R.APP = R.AA.ARR.OVERDUE
        ID.APP = R.AA.ARR.OVERDUE<AA.OD.ID.COMP.1>:R.AA.ARR.OVERDUE<AA.OD.ID.COMP.2>:R.AA.ARR.OVERDUE<AA.OD.ID.COMP.3>
        CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
        IF R.RETURN.MSG THEN
            WRK.FILE.ID = Y.AA.ARR.ID
            CALL F.WRITE(FN.DR.REG.DE05.WORKFILE,WRK.FILE.ID,R.RETURN.MSG)
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
DEF.CR.TYPE:
*-----------------------------------------------------------------------------------------------------------------
*Defaulting credit type based upon product group
*-----------------------------------------------------------------------------------------------------------------

    LOCATE "CREDIT.TYPE" IN Y.FIELD.NME.ARR<1,1> SETTING CR.POS THEN
        Y.CR.TYP.VAL.ARR = Y.FIELD.VAL.ARR<1,CR.POS>
        Y.CR.TYP.DIS.ARR = Y.DISP.TEXT.ARR<1,CR.POS>
    END ELSE
        RETURN
    END
    Y.CR.TYP.VAL.ARR = CHANGE(Y.CR.TYP.VAL.ARR,@SM,@VM)
    Y.CR.TYP.DIS.ARR = CHANGE(Y.CR.TYP.DIS.ARR,@SM,@VM)
    LOCATE Y.PRODUCT.GROUP IN Y.CR.TYP.VAL.ARR<1,1> SETTING POS.CR THEN
        Y.CR.TYPE = Y.CR.TYP.DIS.ARR<1,POS.CR>
    END

    IF Y.PRODUCT.GROUP EQ "LINEAS.DE.CREDITO" THEN
        FINDSTR "COM" IN Y.PRODUCT SETTING YFM,YSM,YVM THEN
            Y.CR.TYPE = "C"
        END
        FINDSTR "CONS" IN Y.PRODUCT SETTING YFM,YSM,YVM THEN
            Y.CR.TYPE = "O"
        END
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
DEF.PRIN.INT.AMT:
*-----------------------------------------------------------------------------------------------------------------
*Using core API AA.GET.ECB.BALANCE.AMOUNT get the balance amount
*Sum all the balance amount to get principal amount
*-----------------------------------------------------------------------------------------------------------------
    Y.OD.CNT = DCOUNT(Y.OD.STATUS.ARR,@FM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.OD.CNT
        Y.BAL.TYPE = Y.OD.STATUS.ARR<Y.CNT>:Y.AC.PROPERTY
        CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ACCT.NO,Y.BAL.TYPE,YLST.TODAY,Y.BAL.AMT,BAL.RET.ERROR)
        Y.PRIN.INT.AMT += Y.BAL.AMT
        Y.CNT += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------------------------------------------
READ.EB.CONT.BAL:
*-----------------------------------------------------------------------------------------------------------------
*Read EB.CONTRACT.BALANCES and get the value of field CONSOL.KEY
*Append CURACCOUNT to CONSOL.KEY at the end
*Using core API RE.CALCUL.REP.AL.LINE get the RE.STAT.REP.LINE id
*Read RE.STAT.REP.LINE and get the value of field DESC
*-----------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.EB.CONTRACT.BALANCES,Y.ACCT.NO,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,ECB.ERR)
    IF R.EB.CONTRACT.BALANCES NE '' THEN
        Y.CONSOL.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
        Y.ASSET.TYPE = 'CURACCOUNT'
        Y.CONSOL.PART   = FIELD(Y.CONSOL.KEY,'.',1,16)
        Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':Y.ASSET.TYPE
        Y.VARIABLE = ''
        CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
        Y.LINE = Y.RPRTS:'.':Y.LINES
        CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
        Y.REGULATORY.ACC.NO = R.LINE<RE.SRL.DESC,1>
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling error process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP = "04"
    Y.ERR.MSG = "Record not found"
    REC.CON = "DE05.":Y.AA.ARR.ID:Y.ERR.MSG
    DESC = "DE05.":Y.AA.ARR.ID:Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
RETURN
*------------------------------------------------------------------Final End-------------------------------------------
END
