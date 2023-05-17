*
*-----------------------------------------------------------------------------
* <Rating>-164</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RIEN3.EXTRACT(REC.ID)
*----------------------------------------------------------------------------
* Company Name   : APAP
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN3.EXTRACT
* Date           : 3-May-2013
*----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the MM.
*----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
*
*----------------------------------------------------------------------------

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_BATCH.FILES
  $INSERT I_TSA.COMMON
  $INSERT I_F.CUSTOMER
  $INSERT I_F.MM.MONEY.MARKET
  $INSERT I_F.LIMIT
  $INSERT I_F.FOREX
  $INSERT I_F.ACCOUNT
  $INSERT I_F.SEC.TRADE
  $INSERT I_F.SC.PARAMETER
  $INSERT I_F.SECURITY.MASTER
  $INSERT I_F.DR.REG.RIEN3.CONCAT
  $INSERT I_F.CUSTOMER.ACCOUNT
*
$INSERT I_DR.REG.RIEN3.EXTRACT.COMMON
$INSERT I_F.DR.REG.RIEN3.PARAM
$INSERT I_F.EB.CONTRACT.BALANCES
*
  GOSUB PROCESS
*
  RETURN
*----------------------------------------------------------------------------
PROCESS:
*------*
* PACS00309188 - start
*
  GOSUB INITIALIZE
  FIELD3 = R.DR.REG.RIEN3.PARAM<RIEN3.PARAM.PATRIMONIO.TECNICO>
  CALL F.READ(FN.DR.REG.RIEN3.CONCAT,REC.ID,R.DR.REG.RIEN3.CONCAT,F.DR.REG.RIEN3.CONCAT,DR.REG.RIEN3.CONCAT.ERR)
  IF R.DR.REG.RIEN3.CONCAT THEN
    CUS.ID = FIELD(REC.ID,'*',2)
    GOSUB GET.CUS.ENTITY
    CNT.TXN = DCOUNT(R.DR.REG.RIEN3.CONCAT,FM)
    TXN.VAL = R.DR.REG.RIEN3.CONCAT
    ID.CTR1 = 1
    LOOP
    WHILE ID.CTR1 LE CNT.TXN
      TXN.AMT += FIELD(TXN.VAL<ID.CTR1>,'|',2)
      TXN.APP.ID = FIELD(TXN.VAL<ID.CTR1>,'|',1)
      TRX.APP.CODE = TXN.APP.ID[1,2]
      BEGIN CASE
      CASE TRX.APP.CODE EQ 'FX'
        FX.ACCOMP += FIELD(TXN.VAL<ID.CTR1>,'|',2)
        GOSUB FOREX.PROCESS
      CASE TRX.APP.CODE EQ 'MM'
        GOSUB PROCESS.MM
      CASE TRX.APP.CODE EQ 'SC'
        GOSUB SEC.TRADE.PROCESS
      END CASE

      ID.CTR1 += 1
    REPEAT

    GOSUB ACCOUNT.PROCESS
    GOSUB WRITE.RECORD
*
  END
* PACS00309188 - end
  RETURN
*----------------------------------------------------------------------------
WRITE.RECORD:
***********
*
  FIELD2 = TXN.AMT + ACC.AMT
  ACCOMPL = FIELD3 * 0.10
  FX.ACCOMP = FX.ACCOMP * 0.10
  FIELD4 = ACCOMPL + FX.ACCOMP + SC.TRADE.ACCOMP
  FIELD5 = LIM.INT.AMT.MM + LIM.INT.AMT.FX + LIM.INT.AMT.SC + LIM.INT.AMT.AC
  IF FIELD5 THEN
    FIELD5 = FIELD5
    MONTO.LIMIT = (FIELD2 / FIELD5) * 100
    FIELD6 = MONTO.LIMIT:"%"
  END ELSE
    FIELD5 = ''
    FIELD6 = ''
  END
  RETURN.MSG = FIELD1:"|":FIELD2:"|":FIELD3:"|":FIELD4:"|":FIELD5:"|":FIELD6
*
  GOSUB UPDATE.WORKFILE
*
  RETURN
*----------------------------------------------------------------------------
INITIALIZE:
***********

  RETURN.MSG = ''
  R.DR.REG.RIEN3.CONCAT = ''
  DR.REG.RIEN3.CONCAT.ERR = ''
  FIELD3 = ''
  FIELD2 = ''
  FIELD4 = ''
  FIELD5 = ''
  FIELD6 = ''
  ACC.AMT = ''
  ACCOMPL = ''
  GOSUB INITIALIZE2
*
  RETURN
*----------------------------------------------------------------------------
INITIALIZE2:
************
*
  LIM.INT.AMT.MM = ''
  LIM.INT.AMT.SC = ''
  LIM.INT.AMT.FX = ''
  LIM.INT.AMT.AC = ''
  MONTO.LIMIT = ''
  CNT.TXN = ''
  TXN.AMOUNT = ''
  FX.ACCOMP = ''
  TXN.AMT = ''
*
  RETURN
*----------------------------------------------------------------------------
FOREX.PROCESS:
**************
*
  R.FOREX = ''
  CALL F.READ(FN.FOREX,TXN.APP.ID,R.FOREX,F.FOREX,FOREX.ERR)
  IF R.FOREX THEN
*FIELD 5
    LIM.REF = R.FOREX<FX.LIMIT.REFERENCE.NO>
    GOSUB GET.LIMIT.INT.AMT
    IF R.LIMIT THEN
      LIM.INT.AMT.FX += R.LIMIT<LI.INTERNAL.AMOUNT>
    END
  END
*
  RETURN
*----------------------------------------------------------------------------
GET.CUS.ENTITY:
***************
*
  CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
  L.CU.TIPO.CL.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
  BEGIN CASE
  CASE L.CU.TIPO.CL.VAL EQ 'PERSONA FISICA' OR L.CU.TIPO.CL.VAL EQ 'CLIENTE MENOR'
*        CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
    FIELD1 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
  CASE L.CU.TIPO.CL.VAL EQ 'PERSONA JURIDICA'
    FIELD1 = R.CUSTOMER<EB.CUS.NAME.1>:' ':R.CUSTOMER<EB.CUS.NAME.2>
  END CASE
*
  RETURN
*----------------------------------------------------------------------------
PROCESS.MM:
**********
  R.MM.MONEY.MARKET = ''
  MM.MONEY.MARKET.ERR = ''
  CALL F.READ(FN.MM.MONEY.MARKET,TXN.APP.ID,R.MM.MONEY.MARKET,F.MM.MONEY.MARKET,MM.MONEY.MARKET.ERR)
  IF R.MM.MONEY.MARKET THEN
*FIELD 5
    LIM.REF = R.MM.MONEY.MARKET<MM.LIMIT.REFERENCE>
    GOSUB GET.LIMIT.INT.AMT
    IF R.LIMIT THEN
      LIM.INT.AMT.MM += R.LIMIT<LI.INTERNAL.AMOUNT>
    END
  END
*PACS00309188 - end
  RETURN
*----------------------------------------------------------------------------
GET.LIMIT.INT.AMT:
******************
*
  GOSUB LIMIT.AMT.INIT
  LIM.1 = FMT(FIELD(LIM.REF,'.',1),"7'0'R")
  LIM.2 = FIELD(LIM.REF,'.',2)
  LIM.ID = CUS.ID:'.':LIM.1:'.':LIM.2
  CALL F.READ(FN.LIMIT,LIM.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)
  IF R.LIMIT THEN
    LIMIT.PARENT.ID = R.LIMIT<LI.RECORD.PARENT>
    IF LIMIT.PARENT.ID NE '' THEN
      CALL F.READ(FN.LIMIT,LIMIT.PARENT.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)
    END
  END
*
  RETURN
*----------------------------------------------------------------------------
LIMIT.AMT.INIT:
***************
*
  LIM.1 = ''
  R.LIMIT.CHILD = ''
  R.LIMIT = ''
  LIMIT.ERR = ''
  LIMIT.PARENT.ID = ''
*
  RETURN
*----------------------------------------------------------------------------
ACCOUNT.PROCESS:
***************
*
  GOSUB ACC.PROC.INIT
  CATEG.LIST = R.DR.REG.RIEN3.PARAM<RIEN3.PARAM.ACCOUNT.CATEG>
  CALL F.READ(FN.CUSTOMER.ACCOUNT,CUS.ID,R.CUST.ACCOUNT,F.CUSTOMER.ACCOUNT,CUST.ACCOUNT.ERR)
  IF R.CUST.ACCOUNT THEN
    CNT.ACT = DCOUNT(R.CUST.ACCOUNT,FM)
    ACC.LIST = R.CUST.ACCOUNT
    CTR.AC = 1
    LOOP
    WHILE CTR.AC LE CNT.ACT
      ACC.ID = ACC.LIST<CTR.AC>
      CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
      ACC.CATEG = R.ACCOUNT<AC.CATEGORY>
      IF (ACC.CATEG GE CATEG.LIST<1,1> AND ACC.CATEG LE CATEG.LIST<1,2>) OR ACC.CATEG EQ CATEG.LIST<1,3> THEN
*        ACC.AMT += R.ACCOUNT<AC.WORKING.BALANCE> ;*Tus Start
 CALL EB.READ.HVT ('EB.CONTRACT.BALANCES', ACC.ID, R.ECB, ECB.ERR)
 ACC.AMT +=R.ECB<ECB.WORKING.BALANCE>;*Tus End
*FIELD 5
        LIM.REF.CHILD = R.ACCOUNT<AC.LIMIT.REF>
        GOSUB GET.AC.LIMIT
      END
      CTR.AC += 1
    REPEAT
  END
*
  RETURN
*----------------------------------------------------------------------------
GET.AC.LIMIT:
*************
*
  IF LIM.REF.CHILD NE 'NOSTRO' AND LIM.REF.CHILD NE '' THEN
    LIM.1 = FMT(FIELD(LIM.REF.CHILD,'.',1),"7'0'R")
    LIM.2 = FIELD(LIM.REF.CHILD,'.',2)
    LIM.ID = CUS.ID:'.':LIM.1:'.':LIM.2
    CALL F.READ(FN.LIMIT,LIM.ID,R.LIMIT.CHILD,F.LIMIT,LIMIT.ERR)
    IF R.LIMIT.CHILD THEN
      LIM.REF.PARENT = R.LIMIT<LI.RECORD.PARENT>
      IF LIM.REF.PARENT THEN
        CALL F.READ(FN.LIMIT,LIM.REF.PARENT,R.LIMIT.PARENT,F.LIMIT,LIMIT.ERR)
        LIM.INT.AMT.AC += R.LIMIT.PARENT<LI.INTERNAL.AMOUNT>
      END ELSE
        LIM.INT.AMT.AC += R.LIMIT.CHILD<LI.INTERNAL.AMOUNT>
      END
    END
  END
*
  RETURN
*----------------------------------------------------------------------------
ACC.PROC.INIT:
**************
*
  R.CUST.ACCOUNT = ''
  CUST.ACCOUNT.ERR = ''
  R.ACCOUNT = ''
  ACCOUNT.ERR = ''
  ACC.CATEG = ''
  LIM.REF.CHILD = ''
*
  RETURN
*----------------------------------------------------------------------------
SEC.TRADE.PROCESS:
******************
*
  R.SEC.TRADE = ''
  SEC.TRADE.ERR = ''
  CALL F.READ(FN.SEC.TRADE,TXN.APP.ID,R.SEC.TRADE,F.SEC.TRADE,SEC.TRADE.ERR)
  IF R.SEC.TRADE THEN
*FIELD 4
    GOSUB SEC.TRAD.FLD4
*FIELD 5
    GOSUB SEC.TRAD.FLD5
*
  END
*
  RETURN
*----------------------------------------------------------------------------
SEC.TRAD.FLD4:
**************
*
  SEC.CODE = R.SEC.TRADE<SC.SBS.SECURITY.CODE>
  CALL F.READ(FN.SECURITY.MASTER,SEC.CODE,R.SEC.MASTER,F.SECURITY.MASTER,SEC.MASTER.ERR)
  IF R.SEC.MASTER THEN
    COLL.ISSUE.VAL = R.SEC.MASTER<SC.SCM.LOCAL.REF,L.COLL.ISSUE.POS>
    IF COLL.ISSUE.VAL NE '' THEN
      SC.TRADE.ACCOMP += FIELD3 * 0.20
    END ELSE
      SC.TRADE.ACCOMP += FIELD3 * 0.10
    END
  END
*
  RETURN
*----------------------------------------------------------------------------
SEC.TRAD.FLD5:
**************
*
  LIM.REF = R.SEC.TRADE<SC.SBS.CPTY.LIMIT.REF>
  GOSUB GET.LIMIT.INT.AMT
  IF R.LIMIT THEN
    LIM.INT.AMT.SC += R.LIMIT<LI.INTERNAL.AMOUNT>
  END
*
  RETURN
*----------------------------------------------------------------------------
UPDATE.WORKFILE:
***************

  IF RETURN.MSG THEN
    CALL F.WRITE(FN.DR.REG.RIEN3.WORKFILE, CUS.ID, RETURN.MSG)
  END
*
  RETURN
*----------------------------------------------------------------------------
END
