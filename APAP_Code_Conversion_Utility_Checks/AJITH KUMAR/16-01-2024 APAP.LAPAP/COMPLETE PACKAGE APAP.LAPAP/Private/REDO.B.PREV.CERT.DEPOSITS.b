* @ValidationCode : MjoxMDM2NDkzNDYzOkNwMTI1MjoxNjg2Njc0MjcyMTEzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:07:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.PREV.CERT.DEPOSITS(AZ.ACC.ID)
* -------------------------------------------------------------------------------------------------
* Description           : This is the Batch Routine used to PROCESS information of the Last month
*                         opened renewed and cancelled deposit details.
*
* Developed By          : Amaravathi Krithika B
* Development Reference : CA01
* Attached To           : NA
* Attached As           : NA
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : AZ.ACC.ID
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA

*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
*--------------------------------------------------------------------------------------------------
* Include files
* CA01                   Amaravathi Krithika            20140716              As Per the CR request
*                        Ghayathri                      20230518              R22 Manual Conversion - Call routine modified, insrt $USING APAP.REDOCHNLS
*                        Ghayathri                      07-06-2023            R22 Manual Conversion - L.TYPE.INT.PAY.POS and LCOMP.LOCALIDAD.POS Added in I_REDO.B.PREV.CERT.DEPOSITS.COMMON file
*                        Conversion Tool                24-05-2023            R22 Auto Conversion - Removed T24.BP
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.PREV.CERT.DEPOSITS.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.COLLATERAL
    $INSERT I_F.REDO.AZACC.DESC
    $INSERT I_F.EB.LOOKUP
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.DATES
    $USING APAP.REDOCHNLS
*

    GOSUB INIT
    GOSUB PROCESS
RETURN
INIT:
*---
    Y.CATEG = '';    Y.FLAG = '';   Y.AC.INVEST = '';    Y.INST.CODE = ''
    Y.CUST.TYPE = '';    Y.OPEN.DATE = '';    Y.MAT.DATE = '';    Y.CO.CODE = ''
    Y.VER.CODE = '';   Y.REPLACE = '';    Y.CCY = '';    Y.INIT.RATE = ''
    Y.ALL.IN.ONE.PRDT = '';    Y.ASSET.TYPE = '';    Y.COLL.CNT = ''
    Y.COL.NUM = '';    Y.COL.NUM.AMT = '';   Y.PLE.AMT = '';   Y.VAL.DATE = ''
    Y.TERM = '';    Y.MAT.DATE = '';    Y.TYPE.SCHU = '';    Y.SCHDU = ''
    Y.FREQ = '';    Y.CNT.EB.CON = '';    Y.TYP.SYS.DATE = '';    Y.DCNT.SYS.DATE = ''
    Y.INIT.REINVEST = '';    Y.WORL.BAL.INT.AC = '';   Y.INIT.AMT = ''
    Y.SYS.DA.VAL = '';    Y.SYS.VAL= '';    Y.OPEN.BAL = '';   Y.CREDT.MVMT = ''
    Y.DEBIT.MVMT = '';   Y.ACC.IN = '';    Y.FIN.ACC.IN = '';   Y.LOCAL.VAL = ''
    Y.SUB.CODE = '';    Y.REINVEST.INDI = '';   Y.AC.PAY.MODE = '';   Y.TYP.PAY = ''
    Y.MAP.ID = '';    Y.RCL.APPL = '';    Y.RCL.AZ.ID = '';    R.RETURN.MSG = ''
    C$SPARE(451)='';    C$SPARE(452)='';    C$SPARE(453)='';    C$SPARE(454)=''
    C$SPARE(455)='';    C$SPARE(456)='';    C$SPARE(457)='';    C$SPARE(458)=''
    C$SPARE(459)='';    C$SPARE(460)='';    C$SPARE(461)='';    C$SPARE(462)=''
    C$SPARE(463)='';    C$SPARE(464)='';    C$SPARE(465)='';    C$SPARE(466)=''
    C$SPARE(467)='';    C$SPARE(468)='';    C$SPARE(469)='';    C$SPARE(470)=''
    C$SPARE(471)='';    C$SPARE(472)='';    C$SPARE(473)='';    C$SPARE(474)=''
    C$SPARE(475)=''; YAC.ONLINE.ACTBAL = ''
RETURN

PROCESS:
*-------
    IF CONTROL.LIST<1,1> EQ "ACBAL.HIST" THEN
        Y.AZ.ACC.ID = AZ.ACC.ID
        AZ.ACC.ID = FIELD(Y.AZ.ACC.ID,'-',1,1)
        CALL EB.READ.HISTORY.REC(F.AZ.ACC.HIS,AZ.ACC.ID,R.AZ.ACC.HIS,AZ.HIS.ERR)
        Y.PRE.CLS.IND = R.AZ.ACC.HIS<AZ.PRE.CLOSURE.IND>
        IF Y.PRE.CLS.IND EQ 'Y' THEN
            R.AZ.ACC = ''
            R.AZ.ACC = R.AZ.ACC.HIS
            Y.FLAG   = '1'
            AZ.ACC.ID = FIELD(AZ.ACC.ID,";",1,1)
            CALL EB.READ.HISTORY.REC(F.AC.HIS,AZ.ACC.ID,R.AC.HIS,AC.HIS.ERR)
            R.ACC.APP = R.AC.HIS
        END ELSE
            RETURN
        END
    END ELSE
        CALL F.READ(FN.AZ.ACC,AZ.ACC.ID,R.AZ.ACC,F.AZ.ACC,AZ.ACC.ERR)
        CALL F.READ(FN.ACC.APP,AZ.ACC.ID,R.ACC.APP,F.ACC.APP,ACC.ERR)
        YAC.ONLINE.ACTBAL = R.ACC.APP<AC.ONLINE.ACTUAL.BAL>
        IF YAC.ONLINE.ACTBAL EQ '' OR YAC.ONLINE.ACTBAL EQ 0 THEN
            RETURN
        END
    END
    IF NOT(R.AZ.ACC) THEN
        GOSUB RAISE.ERR.C.22
    END
    Y.CATEG = R.AZ.ACC<AZ.CATEGORY>
    LOCATE Y.CATEG IN Y.DATA.VAL.CATEG<1,1> SETTING Y.DATA.POS.CATEG THEN
        GOSUB GET.MAPP.DETAILS
        GOSUB FORM.ARRAY
    END
RETURN
GET.MAPP.DETAILS:
*---------------
*
    GOSUB GET.AZ.DETAILS
    GOSUB ASSIGN.VALUE
    GOSUB TYPE.INST.MAPP
    GOSUB GET.ACCO.ACC
    GOSUB PLEDGE.AMT.MAPP
    GOSUB TERM.MONTH
    GOSUB MTHD.OF.PAY.INC
    GOSUB INTERST.AMT
    GOSUB GET.BRAN.CODE
    GOSUB GET.LOCALITY
    GOSUB GET.TYP.OF.PAYMENT
    GOSUB GET.RENEW.DATE
    GOSUB GET.DATE.CANCEL
    GOSUB GET.STATUS
    GOSUB GET.LNK.TYPE
RETURN
GET.AZ.DETAILS:
*-------------
    IF Y.FLAG EQ '1' THEN
        AZ.ACC.ID = FIELD(AZ.ACC.ID,";",1,1)
    END
    IF R.AZ.ACC THEN
        Y.AC.INVEST = R.AZ.ACC<AZ.LOCAL.REF, L.TYPE.INT.PAY.POS>;*R22 Manual Conversion L.TYPE.INT.PAY.POS Added in I_REDO.B.PREV.CERT.DEPOSITS.COMMON file
    END
    Y.INST.CODE = AZ.ACC.ID
    Y.CUS.NO    = R.AZ.ACC<AZ.CUSTOMER>
    CALL F.READ(FN.CUS.APP,Y.CUS.NO,R.CUS.APP,F.CUS.APP,CUS.APP.ERR)
    Y.PRDT = ''; Y.REL.CODE = ''
*    CALL REDO.S.REP.CUSTOMER.EXTRACT(Y.CUS.NO,Y.PRDT,Y.REL.CODE,OUT.ARR)
*
*Read the required Az Account details
*
    OUT.ARR = ''
*   CALL DR.REG.GET.CUST.TYPE(R.CUS.APP,OUT.ARR)
    APAP.LAPAP.drRegGetCustType(R.CUS.APP,OUT.ARR) ;* R22 Manua Conversion
    
*    Y.OPEN.DATE = R.AZ.ACC<AZ.CREATE.DATE>
    Y.AC.HIS=AZ.ACC.ID:";1"
    CALL F.READ(FN.AC.HIS,Y.AC.HIS,R.AC.HIST,F.AC.HIS,AC.HIS.ERR)
    Y.OPEN.DATE=R.AC.HIST<AC.OPENING.DATE>
    IF Y.OPEN.DATE THEN
        Y.OPEN.DATE.DIS = Y.OPEN.DATE[7,2]:"/":Y.OPEN.DATE[5,2]:"/":Y.OPEN.DATE[1,4]
    END ELSE
        Y.OPEN.DATE.DIS = ''
    END

    Y.AZ.HIS.ONE.ID=AZ.ACC.ID:";1"
    CALL F.READ(FN.AZ.ACC.HIS,Y.AZ.HIS.ONE.ID,R.AZ.HIS.ONE,F.AZ.ACC.HIS,Y.ERR)
    R.AZ.HIS.LAST = ''
    Y.AZ.LAST.HIS.ID = AZ.ACC.ID;
    CALL F.READ.HISTORY(FN.AZ.ACC.HIS, Y.AZ.LAST.HIS.ID, R.AZ.HIS.LAST, F.AZ.ACC.HIS, YERR )
    Y.MAT.DATE = R.AZ.ACC<AZ.MATURITY.DATE>
    Y.ROLLOVER.TERM=R.AZ.HIS.ONE<AZ.ROLLOVER.TERM>
    IF NOT(Y.ROLLOVER.TERM) THEN
        Y.ROLLOVER.TERM=R.AZ.ACC<AZ.ROLLOVER.TERM>
    END
    Y.ALT.ACCT.ID = ''
    Y.ALT.ACCT.ID=R.ACC.APP<AC.ALT.ACCT.ID,1>
    IF Y.ALT.ACCT.ID THEN
        IF Y.OPEN.DATE AND Y.ROLLOVER.TERM THEN
            Y.CA.ST.DT=Y.OPEN.DATE
            Y.DIFF    =Y.ROLLOVER.TERM
            CALL CALENDAR.DAY(Y.CA.ST.DT,'+',Y.DIFF)
            Y.MAT.DATE=Y.DIFF
        END ELSE
            Y.MAT.DATE = R.AZ.ACC<AZ.MATURITY.DATE>
        END
    END
    IF NOT(Y.MAT.DATE) THEN
*FOR THIS ONE WE'LL USE THE VALUE FROM THE LAST HIS.
        Y.MAT.DATE= "99990807"          ;*R.AZ.HIS.LAST<AZ.MATURITY.DATE> ;*R.AZ.HIS.ONE<AZ.MATURITY.DATE>
    END
    Y.MAT.DATE= R.AZ.HIS.LAST<AZ.MATURITY.DATE>
    IF Y.MAT.DATE THEN
        Y.MAT.DATE.DIS = Y.MAT.DATE[7,2]:"/":Y.MAT.DATE[5,2]:"/":Y.MAT.DATE[1,4]
    END ELSE
        Y.MAT.DATE.DIS = ''
    END
    Y.CO.CODE =  R.AZ.ACC<AZ.CO.CODE>
    Y.VER.CODE = R.AZ.ACC<AZ.LOCAL.REF,Y.VER.CODE.POS>
    Y.REPLACE = 'N'
    Y.CCY = R.AZ.ACC<AZ.CURRENCY>
    Y.INIT.RATE = R.AZ.ACC<AZ.INTEREST.RATE>
RETURN

ASSIGN.VALUE:
*------------
*    Y.ALT.ACCT.TYPE = ''; Y.PREV.ACCOUNT = ''
*    Y.ALT.ACCT.TYPE=R.ACC.APP<AC.ALT.ACCT.TYPE>
*    LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
*        Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
*    END
*    YACCT.GRP.ID = AZ.ACC.ID
*    IF Y.PREV.ACCOUNT THEN
*        YACCT.GRP.ID = Y.PREV.ACCOUNT
*    END

    ERR.REDO.APAP.CUST.SWIFT.CONCAT = ''; R.REDO.APAP.CUST.SWIFT.CONCAT = ''
    CALL F.READ(FN.REDO.APAP.CUST.SWIFT.CONCAT,Y.CUS.NO,R.REDO.APAP.CUST.SWIFT.CONCAT,F.REDO.APAP.CUST.SWIFT.CONCAT,ERR.REDO.APAP.CUST.SWIFT.CONCAT)
    IF R.REDO.APAP.CUST.SWIFT.CONCAT THEN
        YCUST.DETAIL = R.REDO.APAP.CUST.SWIFT.CONCAT<1>
    END ELSE
        YCUST.DETAIL = Y.CUS.NO
    END

    C$SPARE(451) = AZ.ACC.ID
    C$SPARE(454) = R.AZ.ACC<AZ.LOCAL.REF,Y.ORIG.DEP.AMT>
    C$SPARE(456) = Y.INIT.RATE
    C$SPARE(459)  = YCUST.DETAIL
    C$SPARE(460) = OUT.ARR<1>
    C$SPARE(467) = Y.OPEN.DATE.DIS
    C$SPARE(468) = Y.MAT.DATE.DIS
    C$SPARE(473) = Y.VER.CODE
*    C$SPARE(474) = Y.REPLACE
    C$SPARE(475) = Y.CCY
RETURN

TYPE.INST.MAPP:
*-------------
    Y.ALL.IN.ONE.PRDT = R.AZ.ACC<AZ.ALL.IN.ONE.PRODUCT>
    Y.REGUL.CODE = ''
    LOCATE Y.ALL.IN.ONE.PRDT IN Y.ALL.IN.PRDT.NAME<1,1> SETTING Y.DATA.ALL.POS THEN
        Y.REGUL.CODE = R.EB.LOOKUP.APP.PRDT<EB.LU.DATA.VALUE,Y.DATA.ALL.POS>
    END
    C$SPARE(452) = Y.REGUL.CODE
RETURN
GET.ACCO.ACC:
*------------
*Read the REDO.AZACC.DESC application and get the DESC value
    Y.ACCT.DET=''; Y.LINE.DET = ''
    Y.ACCT.DET="CREDIT"
    GOSUB READ.ECB
    GOSUB DEF.DESC.CRF.DC
    C$SPARE(453)  = Y.LINE.DET
    GOSUB GET.LINE.DESC.IL
RETURN
*---------------
GET.LINE.DESC.IL:
*---------------
    Y.ACCT.DET=''; Y.LINE.DET = ''
    Y.ACCT.DET="50000"
    GOSUB DEF.DESC.CRF.DC
    C$SPARE(462)  = Y.LINE.DET
RETURN

READ.ECB:
*********
    R.EB.CON.BAL = ''; EB.CON.BAL.ERR = ''; Y.IN.CONSOL.KEY = ''
    CALL F.READ(FN.EB.CON.BAL,AZ.ACC.ID,R.EB.CON.BAL,F.EB.CON.BAL,EB.CON.BAL.ERR)
RETURN

DEF.DESC.CRF.DC:
****************
    IF R.EB.CON.BAL THEN
        Y.CONSOL.KEY = R.EB.CON.BAL<ECB.CONSOL.KEY>
        Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
        Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':Y.ACCT.DET
        Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''
        CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
        Y.LINE = Y.RPRTS:'.':Y.LINES
        R.LINE = ''; REP.ERR = ''
        CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
        Y.LINE.DET = R.LINE<RE.SRL.DESC,1>
    END
RETURN

PLEDGE.AMT.MAPP:
*---------------
*Read the CUSTOMER.COLLATERAL application and get the COLLATERAL right id  using the collateral right
*application get the COLLATERAL id get the value of COL.NUM value and match with AA id .
    Y.PLE.AMT = ''
    CALL F.READ(FN.CUS.COLL,Y.CUS.NO,R.CUS.COLL,F.CUS.COLL,CUS.COLL.ERR)
    IF R.CUS.COLL THEN
        Y.DCNT.COLL = DCOUNT(R.CUS.COLL,@FM)
        Y.COLL.CNT = '1'
        LOOP
        WHILE Y.COLL.CNT LE Y.DCNT.COLL
            GOSUB GET.COLL.RGHT.VAL
            Y.COLL.CNT += 1
        REPEAT
    END

    GOSUB GET.LOCKED.AMOUNT
RETURN

GET.LOCKED.AMOUNT:
******************
    Y.LOCK.AMT = 0
    IF NOT(R.ACC.APP<AC.FROM.DATE>) THEN
        Y.LOCK.AMT = 0
        RETURN
    END

    Y.DATE.COUNT = DCOUNT(R.ACC.APP<AC.FROM.DATE>,@VM)
    Y.DATE.START = 1
    LOOP
    WHILE Y.DATE.START LE Y.DATE.COUNT
        IF R.ACC.APP<AC.FROM.DATE,Y.DATE.START> LE TODAY THEN
            Y.LOCK.AMT = R.ACC.APP<AC.LOCKED.AMOUNT,Y.DATE.START>
        END
        Y.DATE.START += 1
    REPEAT
RETURN

GET.COLL.RGHT.VAL:
*----------------
    Y.COLL.RGHT = R.CUS.COLL<Y.COLL.CNT>
    CALL F.READ(FN.COLL.RGHT,Y.COLL.RGHT,R.COLL.RGHT,F.COLL.RGHT,COLL.RGHT.ERR)
    Y.DCNT.COLL.ID = DCOUNT(R.COLL.RGHT,@FM)
    Y.COLL.STA = '1'
    LOOP
    WHILE Y.COLL.STA LE Y.DCNT.COLL.ID
        Y.COLL.ID = R.COLL.RGHT<Y.COLL.STA>
        IF Y.COLL.ID THEN
            CALL F.READ(FN.COLL.APP,Y.COLL.ID,R.COLL.APP,F.COLL.APP,COLL.ERR)
            IF R.COLL.APP THEN
                Y.COL.NUM = R.COLL.APP<COLL.LOCAL.REF,Y.COL.POS>
                GOSUB GET.COLL.INFO
            END
        END
        Y.COLL.STA += 1
    REPEAT
RETURN
GET.COLL.INFO:
*-----------
    Y.COL.NUM.AMT = ''
    IF Y.COL.NUM EQ AZ.ACC.ID THEN
        Y.COL.NUM.AMT = R.COLL.APP<COLL.LOCAL.REF,Y.COL.AVA.POS>
    END
    IF Y.PLE.AMT THEN
        Y.PLE.AMT += Y.COL.NUM.AMT
    END ELSE
        Y.PLE.AMT = Y.COL.NUM.AMT
    END
RETURN
TERM.MONTH:
*----------
    Y.VAL.DATE = R.AZ.ACC<AZ.VALUE.DATE>
    Y.TERM     = 'C'
    IF Y.OPEN.DATE AND Y.MAT.DATE THEN
        Y.ST.TE.DATE=Y.OPEN.DATE
        Y.ED.TE.DATE=Y.MAT.DATE
        CALL CDD('',Y.ST.TE.DATE,Y.ED.TE.DATE,Y.TERM)
        Y.TERM =Y.TERM/30
        Y.TERM = FMT(Y.TERM,0)
        C$SPARE(457) = Y.TERM
    END
RETURN
MTHD.OF.PAY.INC:
*--------------
    Y.MTHD.PAY = ''
    Y.TYPE.SCHU = R.AZ.ACC<AZ.TYPE.OF.SCHDLE>
    Y.SCHDU = R.AZ.ACC<AZ.SCHEDULES>
    IF Y.AC.INVEST EQ 'Reinvested' THEN
        Y.MTHD.PAY = 'R'
    END ELSE
        IF Y.SCHDU EQ 'N' THEN
            Y.MTHD.PAY = 'V'
        END ELSE
            GOSUB GET.SCHU.VAL
        END
    END
    C$SPARE(458)  = Y.MTHD.PAY
RETURN
GET.SCHU.VAL:
*-----------
    LOCATE "I" IN Y.TYPE.SCHU<1,1> SETTING Y.TYPE.POS THEN
        Y.FREQ = R.AZ.ACC<AZ.FREQUENCY,Y.TYPE.POS>
        Y.FREQ.VAL = Y.FREQ[9,3]
        IF Y.SCHDU EQ 'N' THEN
            Y.MTHD.PAY = 'V'
            RETURN
        END
        IF Y.FREQ.VAL EQ '' THEN
            Y.MTHD.PAY = 'V'
        END ELSE
            GOSUB CHK.SCHUDULE
        END
    END
RETURN
CHK.SCHUDULE:
*-----------
    LOCATE Y.FREQ.VAL IN Y.MTHD.OF.PAY.NAME<1,1> SETTING Y.MTHD.OF.PAY.POS THEN
        Y.MTHD.PAY = R.EB.LOOKUP.APP.PAY<EB.LU.DATA.VALUE,Y.MTHD.OF.PAY.POS>
    END
RETURN
INTERST.AMT:
*-----------
*Read the EB.CONTRACT.BALANCE application get the field value Y.TYP.SYS.DATE value get the DCOUNT variable
*it gets matches with "50000-" then corresponding OPEN.BAL,CREDIT.MVMT,DEBIT.MVMT caluculated
    Y.INT.REINVEST = '0'
    Y.ACC.IN = '0'
    Y.FIN.ACC.IN = '0'
    Y.WORL.BAL.INT.AC = '0'
    IF R.EB.CON.BAL THEN
        Y.CNT.EB.CON = '1'
        Y.TYP.SYS.DATE = R.EB.CON.BAL<ECB.TYPE.SYSDATE>
        Y.DCNT.SYS.DATE = DCOUNT(Y.TYP.SYS.DATE,@VM)
        LOOP
        WHILE Y.CNT.EB.CON LE Y.DCNT.SYS.DATE
            GOSUB GET.EB.INIT.AMT
            Y.CNT.EB.CON +=1
        REPEAT
        IF Y.AC.INVEST EQ "Reinvested" THEN
            Y.INIT.REINVEST = R.AZ.ACC<AZ.INTEREST.LIQU.ACCT>
            GOSUB GET.WORK.BALANCE
        END
    END
    Y.INIT.AMT = Y.FIN.ACC.IN + Y.WORL.BAL.INT.AC
    C$SPARE(461) = Y.INIT.AMT
RETURN
GET.WORK.BALANCE:
*--------------
    IF Y.INIT.REINVEST THEN
        CALL F.READ(FN.ACC.APP,Y.INIT.REINVEST,R.ACC.APP.AC,F.ACC.APP,ACC.ERR)
        IF R.ACC.APP.AC THEN
            Y.WORL.BAL.INT.AC = R.ACC.APP.AC<AC.WORKING.BALANCE>
        END
    END
RETURN
GET.EB.INIT.AMT:
*--------------
    Y.SYS.DA.VAL = Y.TYP.SYS.DATE<1,Y.CNT.EB.CON>
    Y.SYS.VAL = FIELD(Y.SYS.DA.VAL,"-",1,1)
    Y.OPEN.BAL = ''
    Y.CREDT.MVMT = ''
    Y.DEBIT.MVMT = ''
    Y.ACC.IN = ''
    IF Y.SYS.VAL EQ "50000" THEN
        Y.OPEN.BAL =  R.EB.CON.BAL<ECB.OPEN.BALANCE,Y.CNT.EB.CON>
        Y.CREDT.MVMT = R.EB.CON.BAL<ECB.CREDIT.MVMT,Y.CNT.EB.CON>
        Y.DEBIT.MVMT = R.EB.CON.BAL<ECB.DEBIT.MVMT,Y.CNT.EB.CON>
        Y.ACC.IN = Y.OPEN.BAL + Y.CREDT.MVMT + Y.DEBIT.MVMT
    END
    IF Y.FIN.ACC.IN THEN
        Y.FIN.ACC.IN +=  Y.ACC.IN
    END ELSE
        Y.FIN.ACC.IN = Y.ACC.IN
    END
RETURN
GET.LOCALITY:
*-----------
    Y.LOCAL.VAL = ''
    Y.LOCAL.VAL =  R.CUS.APP<EB.CUS.LOCAL.REF,Y.LOCAL.POS>
    IF NOT(Y.LOCAL.VAL) THEN
        Y.LOCAL.VAL = R.COMP.APP<EB.COM.LOCAL.REF,LCOMP.LOCALIDAD.POS>;*R22 Manual Conversion LCOMP.LOCALIDAD.POS Added in I_REDO.B.PREV.CERT.DEPOSITS.COMMON file
    END
    C$SPARE(463) = Y.LOCAL.VAL
RETURN
GET.BRAN.CODE:
*-----------
    Y.SUB.CODE = ''
    CALL F.READ(FN.COMP.APP,Y.CO.CODE,R.COMP.APP,F.COMP.APP,COMP.APP.ERR)
    IF R.COMP.APP THEN
        Y.SUB.CODE = R.COMP.APP<EB.COM.SUB.DIVISION.CODE>
    END
    C$SPARE(464) = Y.SUB.CODE
RETURN

GET.TYP.OF.PAYMENT:
*-----------------
    Y.TYP.PAY=''; Y.REINVEST.INDI = ''
    IF Y.AC.INVEST EQ 'Reinvested' THEN
        Y.TYP.PAY = 'CD'
        Y.REINVEST.INDI = 'R'
    END ELSE
        LOCATE Y.AC.INVEST IN Y.TYPE.PAY.NAME<1,1> SETTING Y.LOCAL.CO.POS THEN
            Y.TYP.PAY = R.EB.LOOKUP.APP.TYPE<EB.LU.DATA.VALUE,Y.LOCAL.CO.POS>
        END
    END
    C$SPARE(465) = Y.REINVEST.INDI
    C$SPARE(466) = Y.TYP.PAY
RETURN
GET.RENEW.DATE:
*--------------
    Y.RENE.DATE = ''
    Y.AZ.ACC.HIS.I = AZ.ACC.ID:";1"
    CALL F.READ(FN.AZ.ACC.HIS,Y.AZ.ACC.HIS.I,R.AZ.ACC.HIS.I,F.AZ.ACC.HIS,AC.HIS.ERR)
    AZ.VAL.HIS = R.AZ.ACC.HIS.I<AZ.VALUE.DATE>
    IF AZ.VAL.HIS AND AZ.VAL.HIS NE Y.VAL.DATE THEN
        Y.RENE.DATE = Y.VAL.DATE
    END ELSE
        Y.RENE.DATE = ''
    END
    IF Y.RENE.DATE THEN
        Y.RENE.DATE.DIS = Y.RENE.DATE[7,2]:"/":Y.RENE.DATE[5,2]:"/":Y.RENE.DATE[1,4]
    END ELSE
        Y.RENE.DATE.DIS = ''
    END
    C$SPARE(469) = Y.RENE.DATE.DIS
    IF C$SPARE(469) EQ '' THEN
        C$SPARE(469) = 'N/A'
    END
RETURN
GET.DATE.CANCEL:
*--------------
    IF Y.FLAG EQ '1' THEN
        Y.AZ.DT.CANCEL = FIELD(Y.AZ.ACC.ID,'-',2,1)
        C$SPARE(470)   = Y.AZ.DT.CANCEL[7,2]:"/":Y.AZ.DT.CANCEL[5,2]:"/":Y.AZ.DT.CANCEL[1,4]
    END ELSE
        C$SPARE(470) = ''
    END
    IF C$SPARE(470) EQ '' THEN
        C$SPARE(470) = 'N/A'
    END
RETURN
GET.STATUS:
*---------
    Y.AC.STA.VAL.II = ''
    Y.AC.STA.I = R.ACC.APP<AC.LOCAL.REF,Y.AC.STATUS.I.POS>
    Y.AC.STA.II = R.ACC.APP<AC.LOCAL.REF,Y.AC.STATUS.II.POS>
*20140716 Amaravathi Krithika As Per the CR request
    Y.CLOSE.DEP = ''
    Y.CLOSE.DEP = R.ACC.APP<AC.CLOSURE.DATE>
    IF NOT(Y.CLOSE.DEP) THEN
        LOCATE Y.AC.STA.II IN Y.STA.NAME.II<1,1> SETTING Y.STA.II.POS THEN
            Y.AC.STA.VAL.II = R.EB.LOOKUP.APP.STA.II<EB.LU.DATA.VALUE,Y.STA.II.POS>
        END
        IF NOT(Y.AC.STA.VAL.II) THEN
            LOCATE Y.AC.STA.I IN Y.STA.NAME<1,1> SETTING Y.STA.I.POS THEN
                Y.AC.STA.VAL.II = R.EB.LOOKUP.APP.STA<EB.LU.DATA.VALUE,Y.STA.I.POS>
            END
        END
    END ELSE
        Y.AC.STA.VAL.II = 'C'
    END
*20140716 Amaravathi Krithika As Per the CR request
    C$SPARE(471) = Y.AC.STA.VAL.II

    IF Y.AC.STA.VAL.II EQ 'E' THEN
        C$SPARE(455) = Y.PLE.AMT + Y.LOCK.AMT
    END ELSE
        C$SPARE(455) = Y.PLE.AMT
    END
RETURN
GET.LNK.TYPE:
*-----------
    Y.RLN.VAL = ''
    IF R.CUS.APP THEN
        Y.RLN.CODE.VAL = R.CUS.APP<EB.CUS.RELATION.CODE>
        Y.RL.DCNT = DCOUNT(Y.RLN.CODE.VAL,@VM)
        Y.RL.CNT = '1'
        LOOP
        WHILE Y.RL.CNT LE Y.RL.DCNT
            Y.RLN.CODE = Y.RLN.CODE.VAL<1,Y.RL.CNT>
            LOCATE Y.RLN.CODE IN Y.LNK.TYP.NAME<1,1> SETTING Y.LNK.TYP.POS THEN
                Y.RLN.VAL = R.EB.LOOKUP.APP.LNK<EB.LU.DATA.VALUE,Y.LNK.TYP.POS>
            END
            IF Y.RLN.VAL THEN
                Y.RL.CNT =  Y.RL.DCNT
            END
            Y.RL.CNT += 1
        REPEAT
    END
*20140716 Amaravathi Krithika As Per the CR request
    IF NOT(Y.RLN.VAL) THEN
        Y.RLN.VAL = 'NI'
    END
*20140716 Amaravathi Krithika As Per the CR request
    C$SPARE(472) = Y.RLN.VAL
RETURN
FORM.ARRAY:
*----------
    MAP.FMT = "MAP"
    Y.MAP.ID = "REDO.RCL.CA01"
    Y.RCL.APPL = FN.AZ.ACC
    Y.RCL.AZ.ID = AZ.ACC.ID
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,Y.MAP.ID,Y.RCL.APPL,Y.RCL.AZ.ID,R.AZ.ACC,R.RETURN.MSG,ERR.MSG)
    IF R.RETURN.MSG THEN
        CALL F.WRITE(FN.DR.REG.CA01.WORKFILE,AZ.ACC.ID,R.RETURN.MSG)
    END
RETURN

RAISE.ERR.C.22:
*-------------
    MON.TP = "04"
    Y.ERR.MSG = "Record not found"
    REC.CON = "CA01-":AZ.ACC.ID:Y.ERR.MSG
    DESC = "CA01-":AZ.ACC.ID:Y.ERR.MSG
    INT.CODE = 'REP001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = ''
    INFO.DE = ''
    ID.PROC = ''
    EX.USER = ''
    EX.PC = ''
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 Manual Conversion
RETURN
END
