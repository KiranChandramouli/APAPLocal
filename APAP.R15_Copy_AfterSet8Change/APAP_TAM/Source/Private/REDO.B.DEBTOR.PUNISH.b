* @ValidationCode : MjoxNTUyMDM0MTc5OkNwMTI1MjoxNjkwMTc2MDQ5NjY5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 10:50:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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
* 01/12/2017  Ashokkumar            CN007886--> Added the product LINEAS.DE.CREDITO.TC to the report.
* 15/01/2018  Ashokkumar            CN008154 -> Added new field to display Currency and amended the Tipo de Operacion field.
* 21-JULY-2023      Harsha                R22 Auto Conversion  - VM to @VM , FM to @FM and SM to @SM 
* 21-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts and Added APAP.TAM
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_REDO.B.DEBTOR.PUNISH.COMMON		;* Added the two varible L.CU.DEBTOR.POSN and L.LOAN.COND.POS in Insert file
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.REDO.APAP.CREDIT.CARD.DET


    GOSUB INITIALIZE
    GOSUB MAIN.PROCESS
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

MAIN.PROCESS:
*************
    CALL AA.GET.ARRANGEMENT(Y.AA.ARR.ID,R.AA.ARRANGEMENT,AA.ERR)
    IF R.AA.ARRANGEMENT EQ '' THEN
        GOSUB RAISE.ERR.C.22
    END
    Y.PRODUCT.LINE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.LINE>
    Y.PRODUCT.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.AA.ARR.STATUS = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
    Y.PRODUCT = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>

    IF Y.PRODUCT.LINE EQ "LENDING" AND (Y.AA.ARR.STATUS EQ "CURRENT" OR Y.AA.ARR.STATUS EQ "EXPIRED") ELSE
        RETURN
    END
    BEGIN CASE
        CASE CONTROL.LIST<1,1> EQ "SELECT.MRKWOF"
            IF (Y.PRODUCT.GROUP EQ "HIPOTECARIO" OR Y.PRODUCT.GROUP EQ "CONSUMO" OR Y.PRODUCT.GROUP EQ "COMERCIAL" OR Y.PRODUCT.GROUP EQ "LINEAS.DE.CREDITO") THEN
                GOSUB PROCESS
            END
        CASE CONTROL.LIST<1,1> EQ "SELECT.AA"
            GOSUB PROCESS
    END CASE
RETURN

*-----------------------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------------------
*Read AA.ARRANGEMENT and get the values of STATUS, PRODUCT.GROUP, PRODUCT.LINE & CUSTOMER
*-----------------------------------------------------------------------------------------------------------------

* Not working R15
*    CALL AA.GET.PROPERTY.NAME(R.AA.ARRANGEMENT,Y.AC.PROP.CLASS,Y.AC.PROPERTY)
    IF CONTROL.LIST<1,1> EQ "SELECT.AA" THEN
        Y.AC.PROPERTY = 'ACCOUNTTC'
        Y.ASSET.TYPE = 'DUEACCOUNTTC'
    END ELSE
        Y.AC.PROPERTY = 'ACCOUNT'
        Y.ASSET.TYPE = 'CURACCOUNT'
    END

    GOSUB GET.ACCT.ID
    Y.CUS.NO = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    Y.LOAN.STATUS = ''; CLOSE.LN.FLG = 0; YPOST.RESTRICT = ''
    GOSUB GET.LOAN.STATUS

    YPOST.RESTRICT = R.ACCOUNT<AC.POSTING.RESTRICT>
    IF YPOST.RESTRICT EQ '75' OR YPOST.RESTRICT EQ '90' THEN
        RETURN
    END
    IF Y.LOAN.STATUS EQ "Write-off" THEN
        GOSUB READ.CUSTOMER
        GOSUB MAP.FIELD.RCL
    END ELSE
        LOCATE "CASTIGADO" IN YL.LOAN.COND.POSN SETTING LP.PPSN THEN
            GOSUB READ.CUSTOMER
            GOSUB MAP.FIELD.RCL
        END

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
    APAP.TAM.redoRptAcctAltLoans(YACCT.GRP,Y.PREV.ACCOUNT)		;*R22 Manual Conversion - Added APAP.TAM
    IF Y.PRODUCT.GROUP EQ 'LINEAS.DE.CREDITO.TC' THEN
        YTPY.PREV.ACCOUNT = Y.PREV.ACCOUNT
        Y.ALT.ACCT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
        Y.ALT.ACCT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>
        LOCATE 'T.DEBITO.1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
            Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
            Y.PREV.ACCOUNT = TRIM(Y.PREV.ACCOUNT,'0',"L")
            ERR.REDO.APAP.CREDIT.CARD.DET = ''; R.REDO.APAP.CREDIT.CARD.DET = ''
            CALL F.READ(FN.REDO.APAP.CREDIT.CARD.DET,Y.PREV.ACCOUNT,R.REDO.APAP.CREDIT.CARD.DET,F.REDO.APAP.CREDIT.CARD.DET,ERR.REDO.APAP.CREDIT.CARD.DET)
            YCR.LOGO.NO = R.REDO.APAP.CREDIT.CARD.DET<CRDT.CARD.CARD.LOGO>
        END
        IF NOT(Y.PREV.ACCOUNT) THEN
            Y.PREV.ACCOUNT = YTPY.PREV.ACCOUNT
        END
    END
*---------------------------------CI009703-------------------------------------------------------------

    FINDSTR "-" IN Y.PREV.ACCOUNT  SETTING Ap, Vp  THEN
    END ELSE
        IF Y.PREV.ACCOUNT NE '' AND Y.PRODUCT.GROUP NE 'LINEAS.DE.CREDITO.TC' THEN
            Y.LEN = ''
            Y.LEN = LEN(Y.PREV.ACCOUNT)
            Y.PREV.ACCOUNT = Y.PREV.ACCOUNT[1,2]:"-":Y.PREV.ACCOUNT[3,3]:"-":Y.PREV.ACCOUNT[6,Y.LEN]
        END
    END
*------------------------------------------------------------------------------------------------------
    IF NOT(Y.PREV.ACCOUNT) THEN
        Y.PREV.ACCOUNT = Y.ACCT.NO
    END
    GOSUB GET.LN.CODE.5.1
RETURN

*---------------
GET.LN.CODE.5.1:
*---------------
**Verificar si tiene id alteno 4
    IF Y.ACCT.NO EQ Y.PREV.ACCOUNT THEN
        ID.ALTENO4 = '' ; Y.ALT.TYPE = ''
        Y.ALT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
        CHANGE @VM TO @FM IN Y.ALT.TYPE
        CHANGE @SM TO @FM IN Y.ALT.TYPE
        LOCATE "ALTERNO2" IN Y.ALT.TYPE<1> SETTING EYPO.POS THEN
            ID.ALTENO4  = R.ACCOUNT<AC.ALT.ACCT.ID,EYPO.POS,1>
            FINDSTR "VI" IN ID.ALTENO4 SETTING Ap, Vp THEN
                Y.PREV.ACCOUNT = ID.ALTENO4[3,LEN(ID.ALTENO4)]
            END
        END
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
READ.CUSTOMER:
*-----------------------------------------------------------------------------------------------------------------
*Read Customer and get the value for thr field RELATION.CODE
*-----------------------------------------------------------------------------------------------------------------
    YL.CU.DEBTOR = ''
    CALL F.READ(FN.CUSTOMER,Y.CUS.NO,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.CUSTOMER NE '' THEN
        Y.CUS.REL.CODE.ARR = R.CUSTOMER<EB.CUS.RELATION.CODE>
        YL.CU.DEBTOR = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.DEBTOR.POSN>
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
        Y.CNT1++
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
    CALL REDO.S.REG.CUSTOMER.EXTRACT(Y.CUS.NO,Y.PRODUCT.GROUP,Y.REL.REQ,Y.OUT.ARR)
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
    END
    Y.CR.TYP.VAL.ARR = CHANGE(Y.CR.TYP.VAL.ARR,@SM,@VM)
    Y.CR.TYP.DIS.ARR = CHANGE(Y.CR.TYP.DIS.ARR,@SM,@VM)
    LOCATE Y.PRODUCT.GROUP IN Y.CR.TYP.VAL.ARR<1,1> SETTING POS.CR THEN
        Y.CR.TYPE = Y.CR.TYP.DIS.ARR<1,POS.CR>
    END

    IF Y.PRODUCT.GROUP EQ "COMERCIAL" THEN
        Y.CR.TYPE = YL.CU.DEBTOR
    END

    IF Y.PRODUCT.GROUP EQ "LINEAS.DE.CREDITO" THEN
        FINDSTR "COM" IN Y.PRODUCT SETTING YFM,YSM,YVM THEN
            Y.CR.TYPE = YL.CU.DEBTOR
        END
        FINDSTR "CONS" IN Y.PRODUCT SETTING YFM,YSM,YVM THEN
            Y.CR.TYPE = "O"
        END
    END

    IF Y.PRODUCT.GROUP EQ "LINEAS.DE.CREDITO.TC" THEN
        IF (YCR.LOGO.NO EQ '24' OR YCR.LOGO.NO EQ '4') THEN
            Y.CR.TYPE = 'O'
        END ELSE
            Y.CR.TYPE = 'T'
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
        Y.PRIN.INT.AMT = Y.PRIN.INT.AMT+Y.BAL.AMT
        Y.CNT++
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
        Y.CONSOL.PART   = FIELD(Y.CONSOL.KEY,'.',1,16)
        Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':Y.ASSET.TYPE
        Y.VARIABLE = ''
        CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
        Y.LINE = Y.RPRTS:'.':Y.LINES
        CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
        Y.REGULATORY.ACC.NO = R.LINE<RE.SRL.DESC,1>
    END
RETURN

GET.LOAN.STATUS:
*--------------*
    ArrangementID = Y.AA.ARR.ID
    idPropertyClass = 'OVERDUE'
    idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''; effectiveDate = ''
    YL.LOAN.COND.POSN = ''; L.LOAN.COND.POSN = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.ARR.OVERDUE = RAISE(returnConditions)
    IF R.AA.ARR.OVERDUE NE '' THEN
        Y.LOAN.STATUS = R.AA.ARR.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.STATUS.1.POS>
        L.LOAN.COND.POSN = R.AA.ARR.OVERDUE<AA.OD.LOCAL.REF,L.LOAN.COND.POS>
        Y.BILL.TYPE = R.AA.ARR.OVERDUE<AA.OD.BILL.TYPE>
        LOCATE 'PAYMENT' IN Y.BILL.TYPE<1,1> SETTING YPOSN THEN
            Y.OD.STATUS.ARR = R.AA.ARR.OVERDUE<AA.OD.OVERDUE.STATUS,YPOSN>
        END
        Y.OD.STATUS.ARR = CHANGE(Y.OD.STATUS.ARR,@SM,@FM)
        Y.OD.STATUS.ARR = "CUR":@FM:"DUE":@FM:Y.OD.STATUS.ARR
        Y.STATUS.CHG.DT = R.AA.ARR.OVERDUE<AA.OD.LOCAL.REF,Y.STATUS.CHG.DT.POS>
        YL.LOAN.COND.POSN = CHANGE(L.LOAN.COND.POSN,@SM,@FM)
    END
RETURN

*-----------------------------------------------------------------------------------------------------------------
RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling error process
*-----------------------------------------------------------------------------------------------------------------
    Y.ERR.MSG = "Record not found"
RETURN
*------------------------------------------------------------------Final End-------------------------------------------
END
