SUBROUTINE REDO.B.ACCT.DET(ACCOUNT.ID)
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00361294          Ashokkumar.V.P                  14/11/2014           Changes based on mapping.
* PACS00361294          Ashokkumar.V.P                  14/11/2014           Changes tO OPEN.ACTUAL.BAL and Removed zero balance
* PACS00361294          Ashokkumar.V.P                  20/05/2015           Added new fields to display in the report
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.DATES
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.GROUP.CREDIT.INT
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.GROUP.DATE
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.REDO.AZACC.DESC
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.ACCT.DET.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON

    GOSUB PROCESS.PARA
RETURN

PROCESS.PARA:
*------------
    R.ACCOUNT = ''; ACC.ERR = ''; R.CUSTOMER = ''; CUS.ERR = ''; Y.L.CU.TIPO.CL = ''; CUS.INDUST = ''
    C$SPARE(451) = ''; C$SPARE(452) = ''; C$SPARE(453) = ''; C$SPARE(454) = ''; C$SPARE(455) = ''; C$SPARE(468) = ''
    C$SPARE(456) = ''; C$SPARE(457) = ''; C$SPARE(458) = ''; C$SPARE(459) = ''; C$SPARE(460) = ''; C$SPARE(469) = ''
    C$SPARE(461) = ''; C$SPARE(462) = ''; C$SPARE(463) = ''; C$SPARE(464) = ''; C$SPARE(467) = ''
    Y.ALT.ACCT.TYPE = ''; Y.ALT.ACCT.ID = ''; Y.PREV.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>
    Y.CURRENCY = R.ACCOUNT<AC.CURRENCY>
    Y.ALT.ACCT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>
    LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
        Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
    END
    IF NOT(Y.PREV.ACCOUNT) THEN
        Y.PREV.ACCOUNT = ACCOUNT.ID
    END
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.L.CU.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
    CUS.INDUST = R.CUSTOMER<EB.CUS.LOCAL.REF,L.APAP.INDUSTRY.POS>

    GOSUB FETCH.1.TO.3.FLDS
    GOSUB FETCH.4.TO.6.FLDS
    GOSUB FETCH.7.TO.10.FLDS
    GOSUB FETCH.11.TO.12.FLDS
    GOSUB FETCH.22.TO.23.FLDS
    IF Y.TOTAL.INT OR YOPEN.BAL THEN
        GOSUB MAP.RCL.RECORD
    END
RETURN

FETCH.1.TO.3.FLDS:
*-----------------
    X.TODAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.COURT.DT = X.TODAY[7,2]:'/':X.TODAY[5,2]:'/':X.TODAY[1,4]
    C$SPARE(451) = Y.COURT.DT
    C$SPARE(453) = Y.PREV.ACCOUNT

    LOCATE 'AT.SEL.CODES' IN PARAM.FIELD.NAME SETTING AT.POS THEN
        AT.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,AT.POS>
        AT.INT = AT.LIST<1,1,1>
        AT.CR = AT.LIST<1,1,2>
        AT.DB = AT.LIST<1,1,3>
    END
    R.EB.CONTRACT.BALANCES = ''; EB.CONTRACT.BALANCES.ERR = ''
    CALL F.READ(FN.EB.CONTRACT.BALANCES,ACCOUNT.ID,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,EB.CONTRACT.BALANCES.ERR)
    R.REDO.AZACC.DESC = ''; REDO.ERR = ''
    CALL F.READ(FN.REDO.AZACC.DESC,ACCOUNT.ID,R.REDO.AZACC.DESC,F.REDO.AZACC.DESC,AZACC.DESC.ERR)
    IF R.REDO.AZACC.DESC NE '' THEN
        Y.ASSET.TYPE = R.REDO.AZACC.DESC<AZACC.ASSET.TYPE>
        Y.DESC = R.REDO.AZACC.DESC<AZACC.DESC>
        GOSUB DEF.AZ.ACC.VAL
    END ELSE
        GOSUB DEF.DESC.CRF.DC
        GOSUB DEF.DESC.CRF.5000
    END

    C$SPARE(453) = Y.AZACC.DESC
    C$SPARE(462) = Y.AZACC.INT.DESC

    Y.CATEG = ''
    LOCATE 'CA.SEL.CODES' IN PARAM.FIELD.NAME SETTING CA.POS THEN
        CA.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,CA.POS>
        CA.LIST = CHANGE(CA.LIST,@SM,@FM)
        LOCATE Y.CATEGORY IN CA.LIST SETTING CAT.POS THEN
            Y.CATEG = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT><1,CA.POS,CAT.POS>
        END
    END
    C$SPARE(455) = Y.CATEG
RETURN

DEF.DESC.CRF.DC:
****************
    Y.REGULATORY.AC.ACC = ''; Y.IN.CONSOL.KEY = ''; YCRF.TYPE = ''
    IF R.EB.CONTRACT.BALANCES THEN
        Y.CONSOL.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
        YCRF.TYPE = R.EB.CONTRACT.BALANCES<ECB.OPEN.ASSET.TYPE>
        Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
        Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':YCRF.TYPE
        Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''
        CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
        Y.LINE = Y.RPRTS:'.':Y.LINES
        CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
        Y.REGULATORY.ACC.NO = R.LINE<RE.SRL.DESC,1>
        Y.AZACC.DESC = Y.REGULATORY.ACC.NO
    END
RETURN

DEF.DESC.CRF.5000:
*****************
    Y.REGULATORY.AC.ACC = ''; Y.IN.CONSOL.KEY = ''
    IF R.EB.CONTRACT.BALANCES THEN
        Y.CONSOL.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
        Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
        Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':AT.INT
        Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''
        CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
        Y.LINE = Y.RPRTS:'.':Y.LINES
        CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
        Y.REGULATORY.ACC.NO = R.LINE<RE.SRL.DESC,1>
        Y.AZACC.INT.DESC = Y.REGULATORY.ACC.NO
    END
RETURN

DEF.AZ.ACC.VAL:
***************
    Y.CR.POS = ''; Y.AZACC.DESC = ''
    LOCATE YCRF.TYPE IN Y.ASSET.TYPE<1,1> SETTING Y.CR.POS THEN
        Y.AZACC.DESC = Y.DESC<1,Y.CR.POS>
    END
    IF NOT(Y.AZACC.DESC) THEN
        GOSUB DEF.DESC.CRF.DC
    END

    Y.AC.INT.POS = ''; Y.AZACC.INT.DESC = ''
    LOCATE AT.INT IN Y.ASSET.TYPE<1,1> SETTING Y.AC.INT.POS THEN
        Y.AZACC.INT.DESC = Y.DESC<1,Y.AC.INT.POS>
    END ELSE
        LOCATE "51000" IN Y.ASSET.TYPE<1,1> SETTING Y.AC.INT1.POS THEN
            Y.AZACC.INT.DESC = Y.DESC<1,Y.AC.INT1.POS>
        END
    END
    IF NOT(Y.AZACC.INT.DESC) THEN
        GOSUB DEF.DESC.CRF.5000
    END
RETURN

FETCH.4.TO.6.FLDS:
*-----------------
    LOCATE 'CUR.SEL.CODES' IN PARAM.FIELD.NAME SETTING CUR.POS THEN
        CUR.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,CUR.POS>
        CUR.LIST = CHANGE(CUR.LIST,@SM,@FM)
        LOCATE Y.CURRENCY IN CUR.LIST SETTING CURRENCY.POS THEN
            Y.CURR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT,CUR.POS,CURRENCY.POS>
        END
    END
    C$SPARE(456) = Y.CURR
*
    YOPEN.BAL = ''
    Y.SYS.DATE = R.EB.CONTRACT.BALANCES<ECB.TYPE.SYSDATE>
    Y.SYS.CNT = DCOUNT(Y.SYS.DATE,@VM)
    Y.TOTAL.INT = ''
    FOR SYS.DT.POS = 1 TO Y.SYS.CNT
        Y.SYS.VAL = Y.SYS.DATE<1,SYS.DT.POS>
        Y.SYS.DT = FIELD(Y.SYS.VAL,'-',1)
        Y.SYS.DTE = FIELD(Y.SYS.VAL,'-',2)
        YTOTAL.INT = 0; Y.OPEN.BAL = '0'; Y.CR.MVMT = '0'; Y.DB.MVMT = '0'
        IF (Y.SYS.DT EQ AT.INT AND Y.SYS.DTE LE Y.TODAY) THEN
            Y.OPEN.BAL = R.EB.CONTRACT.BALANCES<ECB.OPEN.BALANCE><1,SYS.DT.POS,1>
            Y.CR.MVMT =  R.EB.CONTRACT.BALANCES<ECB.CREDIT.MVMT><1,SYS.DT.POS,1>
            Y.DB.MVMT = R.EB.CONTRACT.BALANCES<ECB.DEBIT.MVMT><1,SYS.DT.POS,1>
            YTOTAL.INT = Y.OPEN.BAL + Y.CR.MVMT + Y.DB.MVMT
        END
        Y.TOTAL.INT += YTOTAL.INT
    NEXT SYS.DT.POS
    C$SPARE(457) = Y.TOTAL.INT

    YOPEN.BAL = R.ACCOUNT<AC.OPEN.ACTUAL.BAL>
    C$SPARE(467) = YOPEN.BAL

    Y.OVR.SEGM = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.OVR.SEGM.POS>
    Y.SEGMENTO = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.SEGMENTO.POS>
    IF Y.OVR.SEGM NE '' THEN
        Y.SUB.POP = Y.OVR.SEGM
    END ELSE
        Y.SUB.POP = Y.SEGMENTO
    END
    C$SPARE(458) = Y.SUB.POP
RETURN

FETCH.7.TO.10.FLDS:
*------------------
    Y.PRODUCT.GROUP = ''; Y.REL.CODE = ''; OUT.ARR = ''
    CALL REDO.S.REP.CUSTOMER.EXTRACT(Y.CUSTOMER,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)
    Y.PERSON.TYPE = OUT.ARR<2>
    C$SPARE(459) = Y.PERSON.TYPE
    Y.CONST.VAL = '001'
    Y.VAL.CONSTANT = FMT(Y.CONST.VAL,'R%3')
    C$SPARE(464) = Y.VAL.CONSTANT
    Y.LNK.TYPE = "REDO.CONSUMO.LOAN*VINCATION"
    CALL F.READ(FN.EB.LOOKUP,Y.LNK.TYPE,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
    Y.LNK.TYP.NAME = R.EB.LOOKUP<EB.LU.DATA.NAME>

    Y.RELATION.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
    Y.REL.CNT = DCOUNT(Y.RELATION.CODE,@VM)
    LOOP
        REMOVE Y.RLN.CODE FROM Y.RELATION.CODE SETTING RLN.POS
    WHILE Y.RLN.CODE:RLN.POS
        LOCATE Y.RLN.CODE IN Y.LNK.TYP.NAME<1,1> SETTING Y.LNK.TYP.POS THEN
            Y.VINC.TYPE = R.EB.LOOKUP< EB.LU.DATA.VALUE,Y.LNK.TYP.POS>
        END
        ELSE
            Y.VINC.TYPE = R.EB.LOOKUP< EB.LU.DATA.VALUE,1>
        END
    REPEAT
    IF Y.RELATION.CODE EQ '' THEN
        Y.VINC.TYPE = R.EB.LOOKUP< EB.LU.DATA.VALUE,1>
    END
    C$SPARE(460) = Y.VINC.TYPE

    Y.OPEN.DATE = R.ACCOUNT<AC.OPENING.DATE>
    Y.OPENING.DT = Y.OPEN.DATE[7,2]:'/':Y.OPEN.DATE[5,2]:'/':Y.OPEN.DATE[1,4]
    C$SPARE(463) = Y.OPENING.DT

    STAT1 = ''; STAT2 = ''; Y.POS.RESTRICT = '';STAT.VAL = ''
    Y.STATUS1.POS = Y.POS<2,1>
    STAT1 = R.ACCOUNT<AC.LOCAL.REF,Y.STATUS1.POS>
    Y.STATUS2.POS = Y.POS<2,2>
    STAT2 = R.ACCOUNT<AC.LOCAL.REF,Y.STATUS2.POS>
    Y.POS.RESTRICT = R.ACCOUNT<AC.POSTING.RESTRICT>
    STAT2.CNT = DCOUNT(STAT2,@SM)

    IF STAT2.CNT GE 2 THEN
        GOSUB GET.STATUS.MULTIVAL
        C$SPARE(461) = STAT.VAL
        RETURN
    END

    BEGIN CASE
        CASE STAT2 EQ 'DECEASED'
            STAT.VAL = 'F'
        CASE STAT2 EQ 'GARNISHMENT'
            STAT.VAL = 'E'
        CASE STAT2 EQ 'GUARANTEE.STATUS'
            STAT.VAL = 'G'
        CASE STAT1 EQ 'ACTIVE' OR STAT1 EQ '6MINACTIVE' OR STAT1 EQ ''
            STAT.VAL = 'A'
        CASE STAT1 EQ 'ABANDONED'
            STAT.VAL = 'B'
        CASE STAT1 EQ '3YINACTIVE'
            STAT.VAL = 'I'
    END CASE

    C$SPARE(461) = STAT.VAL
RETURN

GET.STATUS.MULTIVAL:
********************
    D.POSN = ''; G.POSN = ''
    LOCATE 'DECEASED' IN STAT2<1,1,1> SETTING D.POSN THEN
        STAT.VAL = 'F'
    END ELSE
        LOCATE 'GARNISHMENT' IN STAT2<1,1,1> SETTING G.POSN THEN
            STAT.VAL = 'E'
        END ELSE
            STAT.VAL = 'G'
        END
    END
RETURN

FETCH.11.TO.12.FLDS:
*-------------------
    Y.CUST.CODE = OUT.ARR<1>
    C$SPARE(452) = Y.CUST.CODE

    Y.CUST.NAME = OUT.ARR<3>
    Y.CUST.GN.NAME  = OUT.ARR<4>
    IF Y.L.CU.TIPO.CL EQ "PERSONA JURIDICA" THEN
        Y.COMP.DEBTOR = Y.CUST.NAME
    END ELSE
        Y.COMP.DEBTOR = Y.CUST.NAME:' ':Y.CUST.GN.NAME
    END
    C$SPARE(454) = Y.COMP.DEBTOR
    GOSUB CALC.AC.INT.RATE
RETURN

FETCH.22.TO.23.FLDS:
********************

    CATEGINT.LIST = ''; YDEP.LP = ''
    LOCATE 'TASA.CATEGORY' IN PARAM.FIELD.NAME SETTING TCS.POS THEN
        CATEGINT.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,TCS.POS>
        CATEGI.LIST = CHANGE(CATEGINT.LIST,@SM,@FM)
        LOCATE Y.CATEGORY IN CATEGINT.LIST SETTING CATIN.POS THEN
            C$SPARE(468) = 'V'
        END ELSE
            C$SPARE(468) = 'F'
        END
    END

    IF CUS.INDUST GE '651000' AND CUS.INDUST LE '672204' THEN
        YDEP.LP = 'Y'
    END ELSE
        YDEP.LP = 'M'
    END
    IF CUS.INDUST EQ "651104" THEN
        YDEP.LP = 'M'
    END
    C$SPARE(469) = YDEP.LP
RETURN

MAP.RCL.RECORD:
*--------------
    IF Y.TOTAL.INT EQ 0 AND YOPEN.BAL EQ 0 THEN
        RETURN
    END

    R.RETURN.MSG = ''
    MAP.FMT = 'MAP'
    ID.RCON.L = "REDO.RCL.RN07"
    APP = FN.ACCOUNT
    ID.APP = ACCOUNT.ID
    R.APP = R.ACCOUNT
    CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    IF R.RETURN.MSG THEN
        OUT.ARRAY = R.RETURN.MSG
        GOSUB WRITE.TO.FILE
    END
RETURN

WRITE.TO.FILE:
*--------------
    IF Y.CURRENCY EQ LCCY THEN
        WRITESEQ OUT.ARRAY ON SEQ1.PTR ELSE
            ERR.MSG = "Unable to write to ":FILE.NAME
            INT.CODE = "R07"
            INT.TYPE = "ONLINE"
            MON.TP = "07"
            REC.CON = "R07-":ERR.MSG
            DESC = "R07-":ERR.MSG
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
    END ELSE
        WRITESEQ OUT.ARRAY ON SEQ2.PTR ELSE
            ERR.MSG = "Unable to write to ":FILE.NAME
            INT.CODE = "R07"
            INT.TYPE = "ONLINE"
            MON.TP = "07"
            REC.CON = "R07-":ERR.MSG
            DESC = "R07-":ERR.MSG
            CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        END
    END
RETURN

CALC.AC.INT.RATE:
*****************
    AC.CR.INT = R.ACCOUNT<AC.ACCT.CREDIT.INT,1>
    COND.GRP = R.ACCOUNT<AC.CONDITION.GROUP>
    CR.MAR.OPR = ''; CR.MAR.RATE = ''; CR.INT.RATE = ''; CR.BASIC.RTE = ''
    IF AC.CR.INT THEN
        ACI.ID = ACCOUNT.ID:'-':AC.CR.INT
        CALL F.READ(FN.ACCOUNT.CREDIT.INT,ACI.ID,R.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT,ACCOUNT.CREDIT.INT.ERR)
        CR.MAR.RATE = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.MARGIN.RATE,1>
        CR.MAR.OPR = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.MARGIN.OPER,1>
        CR.INT.RATE = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.INT.RATE,1>
        CR.BASIC.RTE = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.BASIC.RATE,1>
        IF CR.INT.RATE THEN
            GOSUB CR.INT.CASE
        END
        IF NOT(CR.INT.RATE) AND CR.BASIC.RTE THEN
            GD.ID = CR.BASIC.RTE:Y.CURRENCY
            GOSUB READ.GROUP.DTE
            BI.ID = CR.BASIC.RTE:Y.CURRENCY:GRP.CR.DATE
            GOSUB READ.BASIC.INT
            GOSUB BI.INT.CASE
        END
    END ELSE
        GD.ID = COND.GRP:Y.CURRENCY
        GOSUB READ.GROUP.DTE
        GCI.ID = COND.GRP:Y.CURRENCY:GRP.CR.DATE
        R.GROUP.CREDIT.INT = ''; GROUP.CREDIT.INT.ERR = ''
        CALL F.READ(FN.GROUP.CREDIT.INT,GCI.ID,R.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT,GROUP.CREDIT.INT.ERR)
        CR.MAR.OPR = R.GROUP.CREDIT.INT<IC.GCI.CR.MARGIN.OPER,1>
        CR.MAR.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.MARGIN.RATE,1>
        CR.INT.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.INT.RATE,1>
        CR.BAS.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.BASIC.RATE,1>
        IF CR.INT.RATE THEN
            GOSUB CR.INT.CASE
        END ELSE
            BI.ID = CR.BAS.RATE:Y.CURRENCY:GRP.CR.DATE
            GOSUB READ.BASIC.INT
            GOSUB BI.INT.CASE
        END
    END
    C$SPARE(465) = INT.RATE
RETURN

CR.INT.CASE:
************
    BEGIN CASE
        CASE CR.MAR.OPR EQ 'ADD'
            INT.RATE = CR.INT.RATE + CR.MAR.RATE
        CASE CR.MAR.OPR EQ 'SUBTRACT'
            INT.RATE = CR.INT.RATE - CR.MAR.RATE
        CASE 1
            INT.RATE = CR.INT.RATE
    END CASE
RETURN

BI.INT.CASE:
************
    BEGIN CASE
        CASE CR.MAR.OPR EQ 'ADD'
            INT.RATE = BI.INT.RATE + CR.MAR.RATE
        CASE CR.MAR.OPR EQ 'SUBTRACT'
            INT.RATE = BI.INT.RATE - CR.MAR.RATE
        CASE 1
            INT.RATE = BI.INT.RATE
    END CASE
RETURN

READ.GROUP.DTE:
***************
    R.GROUP.DATE = ''; GROUP.DATE.ERR = ''
    CALL F.READ(FN.GROUP.DATE,GD.ID,R.GROUP.DATE,F.GROUP.DATE,GROUP.DATE.ERR)
    GRP.CR.DATE = R.GROUP.DATE<AC.GRD.CREDIT.GROUP.DATE>
RETURN

READ.BASIC.INT:
***************
    R.BASIC.INTEREST = ''; BASIC.INTEREST.ERR = ''
    CALL F.READ(FN.BASIC.INTEREST,BI.ID,R.BASIC.INTEREST,F.BASIC.INTEREST,BASIC.INTEREST.ERR)
    BI.INT.RATE = R.BASIC.INTEREST<EB.BIN.INTEREST.RATE>
RETURN
END
