*-----------------------------------------------------------------------------
* <Rating>-63</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.PRINT.LOST.AUTHORISE
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REG.STOCK
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a template routine
*
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 6 SEP 2010    KAVITHA                 PACS00024249             Initial Creation
* 8 AUG 2011    KAVITHA                 PACS00093181             FIX FOR PACS00093181
*PACS00024249-S

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CARD.PRINT.LOST
$INSERT I_F.REDO.CARD.REG.STOCK
$INSERT I_F.REDO.CARD.SERIES.PARAM
$INSERT I_F.REDO.CARD.REQUEST
$INSERT I_F.REDO.BRANCH.REQ.STOCK
$INSERT I_F.LATAM.CARD.ORDER


  CALL REDO.CARD.PRINT.LOST.UPDATE

  GOSUB OPEN.FILE
  GOSUB PROCESS

  RETURN
*-----------------
OPEN.FILE:

  FN.LCO = 'F.LATAM.CARD.ORDER'
  F.LCO = ''
  CALL OPF(FN.LCO,F.LCO)

  R.LCO = ''

  FN.REDO.CARD.REQ = 'F.REDO.CARD.REQUEST'
  F.REDO.CARD.REQ = ''
  CALL OPF(FN.REDO.CARD.REQ,F.REDO.CARD.REQ)

  FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
  F.REDO.CARD.SERIES.PARAM = ''
  CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)

  FN.BRANCH.REQ.STOCK = 'F.REDO.BRANCH.REQ.STOCK'
  F.BRANCH.REQ.STOCK = ''
  CALL OPF(FN.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK)

  LOC.RET.FLAG = ''

  FN.REDO.CARD.REG.STOCK = 'F.REDO.CARD.REG.STOCK'
  F.REDO.CARD.REG.STOCK = ''
  CALL OPF(FN.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK)

  CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)

  CARD.TYPE.PARAM = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.TYPE>
  CARD.SERIES.PARAM = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.SERIES>
  Y.ID.NEW=ID.NEW
  RETURN

*------------------
PROCESS:

  CALL F.READ(FN.REDO.CARD.REQ,Y.ID.NEW,R.REDO.CARD.REQ,F.REDO.CARD.REQ,ERR)
  AGENCY = R.REDO.CARD.REQ<REDO.CARD.REQ.AGENCY>


  OLD.TYPE=R.NEW(REDO.PRN.LST.OLD.CRD.TYPE)

  CRD.TYPE = R.NEW(REDO.PRN.LST.CRD.TYPE)

  CNT.TYPE= DCOUNT(CRD.TYPE,VM)

  FOR LOOP.TYPE=1 TO CNT.TYPE

    LOST.CNTR = ''

    LOCATE CRD.TYPE<LOOP.TYPE> IN OLD.TYPE SETTING POS.OLD THEN

      R.NEW(REDO.PRN.LST.OLD.CRD.TYPE)<1,POS.OLD>=CRD.TYPE<LOOP.TYPE>
      R.NEW(REDO.PRN.LST.OLD.CRD.LOST)<1,POS.OLD,-1>=R.NEW(REDO.PRN.LST.CRD.NUMBER.LOST)<1,LOOP.TYPE>
      R.NEW(REDO.PRN.LST.OLD.REASON)<1,POS.OLD,-1>=R.NEW(REDO.PRN.LST.REASON)<1,LOOP.TYPE>
    END ELSE
      R.NEW(REDO.PRN.LST.OLD.CRD.TYPE)<1,-1>=CRD.TYPE<LOOP.TYPE>
      R.NEW(REDO.PRN.LST.OLD.CRD.LOST)<1,-1,1>=R.NEW(REDO.PRN.LST.CRD.NUMBER.LOST)<1,LOOP.TYPE>
      R.NEW(REDO.PRN.LST.OLD.REASON)<1,-1,1>=R.NEW(REDO.PRN.LST.REASON)<1,LOOP.TYPE>

    END

    GOSUB UPDATE.BRANCH.STK

  NEXT

  R.NEW(REDO.PRN.LST.CRD.TYPE)=''
  R.NEW(REDO.PRN.LST.CRD.NUMBER.LOST)=''
  R.NEW(REDO.PRN.LST.REASON)=''

*PACS00093181 -S
  GOSUB LOST.ACTIVE.CARD
*PACS00093181 -E

  RETURN
*----------------------
UPDATE.BRANCH.STK:


  LOST.CNTR = DCOUNT(R.NEW(REDO.PRN.LST.CRD.NUMBER.LOST)<1,LOOP.TYPE>,SM)

  CHANGE VM TO FM IN CARD.TYPE.PARAM
  CHANGE VM TO FM IN CARD.SERIES.PARAM
  CHANGE VM TO FM IN CRD.TYPE

  LOCATE CRD.TYPE<LOOP.TYPE> IN CARD.TYPE.PARAM SETTING PAR.POS THEN
    CARD.TYPE.FETCH = CARD.SERIES.PARAM<PAR.POS>
  END

  CALL F.READU(FN.REDO.CARD.REG.STOCK,CARD.TYPE.FETCH,R.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK,STOCK.ERR,"")
  CARD.AVAIL.BAL = R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.BAL>

  CONCAT.FILE.ID = TODAY:"-":CARD.TYPE.FETCH
  CALL F.READU(FN.BRANCH.REQ.STOCK,CONCAT.FILE.ID,R.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK,STK.ENT.ERR,'P')

  IF R.BRANCH.REQ.STOCK THEN
    LOOP.REST.CNT = ''
    REQ.POS = ''

    LOC.RET.FLAG = "Y"
    FETCH.REQ.ID = R.BRANCH.REQ.STOCK<BRAN.STK.REQUEST.ID>
    CHANGE VM TO FM IN FETCH.REQ.ID
    TOT.RET.CNTR = DCOUNT(R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK>,VM)
    IF TOT.RET.CNTR LT 1 THEN
      TOT.RET.CNTR = DCOUNT(R.BRANCH.REQ.STOCK<BRAN.STK.VIRGIN.LOAD>,VM)
    END

    LOOP.REST.CNT = TOT.RET.CNTR

    LOCATE Y.ID.NEW IN FETCH.REQ.ID SETTING REQ.POS THEN
      GET.LOST.AVAIL = R.BRANCH.REQ.STOCK<BRAN.STK.LOST,REQ.POS>
      IF GET.LOST.AVAIL THEN
        GET.LOST.AVAIL += LOST.CNTR
      END ELSE
        GET.LOST.AVAIL = LOST.CNTR
      END

      R.BRANCH.REQ.STOCK<BRAN.STK.LOST,REQ.POS> = GET.LOST.AVAIL
      GET.CURRENT.QTY =  R.BRANCH.REQ.STOCK<BRAN.STK.CURRENT.QTY,REQ.POS>
      FINAL.AVAIL.QTY = GET.CURRENT.QTY - LOST.CNTR
      R.BRANCH.REQ.STOCK<BRAN.STK.CURRENT.QTY,REQ.POS> = FINAL.AVAIL.QTY
      GOSUB UPDATE.REST.MV
    END ELSE
      GOSUB UPDATE.NEW.REC
    END
  END ELSE
    GOSUB UPDATE.NEW.REC
  END


  CARD.AVAIL.BAL = CARD.AVAIL.BAL - LOST.CNTR
  R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.BAL> = CARD.AVAIL.BAL

  CALL F.WRITE(FN.REDO.CARD.REG.STOCK,CARD.TYPE.FETCH,R.REDO.CARD.REG.STOCK)


  CALL F.WRITE(FN.BRANCH.REQ.STOCK,CONCAT.FILE.ID,R.BRANCH.REQ.STOCK)
*    CALL JOURNAL.UPDATE("")

  RETURN
*------------
UPDATE.NEW.REC:

  IF LOC.RET.FLAG = 'Y' THEN
    TOT.RET.CNTR += 1
  END ELSE
    TOT.RET.CNTR = 1
  END

  R.BRANCH.REQ.STOCK<BRAN.STK.CARD.TYPE> = CRD.TYPE<LOOP.TYPE>
  R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK,TOT.RET.CNTR> = CARD.AVAIL.BAL
  R.BRANCH.REQ.STOCK<BRAN.STK.REQUEST.ID,TOT.RET.CNTR> = Y.ID.NEW
  R.BRANCH.REQ.STOCK<BRAN.STK.LOST,TOT.RET.CNTR> =  LOST.CNTR
  R.BRANCH.REQ.STOCK<BRAN.STK.AGENCY,TOT.RET.CNTR> = AGENCY
  R.BRANCH.REQ.STOCK<BRAN.STK.CURRENT.QTY,TOT.RET.CNTR> = CARD.AVAIL.BAL - LOST.CNTR
  R.BRANCH.REQ.STOCK<BRAN.STK.TXN.DATE> = TODAY

  RETURN
*-------------------------
UPDATE.REST.MV:

  REST.MV.CNTR = REQ.POS + 1
  LOOP
  WHILE REST.MV.CNTR LE LOOP.REST.CNT

    REST.QTY.REQUEST = ''
    REST.LOST.VALUE = ''
    REST.DAMAGE.VAL = ''
    REST.RETURN.VALUE = ''
    REST.DELIVERED =  ''
    REST.CURRENT.QTY = ''

    R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK,REST.MV.CNTR> = FINAL.AVAIL.QTY
    REST.QTY.REQUEST = R.BRANCH.REQ.STOCK<BRAN.STK.QTY.REQUEST,REST.MV.CNTR>
    REST.LOST.VALUE = R.BRANCH.REQ.STOCK<BRAN.STK.LOST,REST.MV.CNTR>
    REST.DAMAGE.VAL = R.BRANCH.REQ.STOCK<BRAN.STK.DAMAGE,REST.MV.CNTR>
    REST.RETURN.VALUE = R.BRANCH.REQ.STOCK<BRAN.STK.RETURN,REST.MV.CNTR>
    REST.DELIVERED = R.BRANCH.REQ.STOCK<BRAN.STK.DELIVERED,REST.MV.CNTR>
    REST.CURRENT.QTY = FINAL.AVAIL.QTY + REST.QTY.REQUEST - REST.LOST.VALUE - REST.DAMAGE.VAL - REST.RETURN.VALUE - REST.DELIVERED
    R.BRANCH.REQ.STOCK<BRAN.STK.CURRENT.QTY,REST.MV.CNTR> = REST.CURRENT.QTY
    FINAL.AVAIL.QTY = REST.CURRENT.QTY

    REST.MV.CNTR += 1
  REPEAT

  RETURN
*-------------------------
*PACS00024249-E
LOST.ACTIVE.CARD:


  CALL F.READ(FN.REDO.CARD.REQ,Y.ID.NEW,R.REDO.CARD.REQUEST,F.REDO.CARD.REQ,REQ.ERR)
  IF R.REDO.CARD.REQUEST THEN
    RENEWAL.FLAG = R.REDO.CARD.REQUEST<REDO.CARD.REQ.RENEWAL.FLAG>
  END
  IF RENEWAL.FLAG EQ "YES" THEN

    VAULT.QUANTITY =   R.REDO.CARD.REQUEST<REDO.CARD.REQ.VAULT.QTY,1>
    LATAM.CARD.ID = FIELD(VAULT.QUANTITY,":",2)
    LATAM.CARD.ID = TRIM(LATAM.CARD.ID)

* CALL F.READ(FN.LCO,LATAM.CARD.ID,R.LCO,F.LCO,LCO.ERR)

* IF R.LCO THEN
    R.LCO<CARD.IS.CARD.STATUS> = "52"
    R.LCO<CARD.IS.RENEW.CARD.LOST> = "YES"
    R.LCO<CARD.IS.RENEW.STATUS> = "LOST"
*       END

    OFS.SOURCE.ID = 'REDO.OFS.LATAM.UPD'
    APPLICATION.NAME = 'LATAM.CARD.ORDER'
    TRANS.FUNC.VAL = 'I'
    TRANS.OPER.VAL = 'PROCESS'
    APPLICATION.NAME.VERSION = 'LATAM.CARD.ORDER,ADDITIONAL'
    NO.AUT = ''
    OFS.MSG.ID = ''
    APPLICATION.ID = LATAM.CARD.ID
    OFS.POST.MSG = ''
    OFS.ERR = ''

    CALL OFS.BUILD.RECORD(APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT,APPLICATION.ID,R.LCO,OFS.REQ.MSG)
    CALL OFS.POST.MESSAGE(OFS.REQ.MSG,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

  END


  RETURN
*------------
END
