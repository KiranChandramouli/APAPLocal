*--------------------------------------------------------------------------------------------------------
* <Rating>-62</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.E.NOF.BRANCH.STOCK(TX.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.NOF.BRANCH.STOCK
*--------------------------------------------------------------------------------------------------------
*Description  : This is a no file enquiry routine for the enquiry REDO.CARD.SUPPLY
*Linked With  : Enquiry REDO.CARD.BRANCH.STOCK
*In Parameter : N/A
*Out Parameter: TX.ARRAY
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
* 15th Mar 2011    SWAMINATHAN.S.R        ODR-2010-03-0400        Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.USER
$INSERT I_F.COMPANY
$INSERT I_F.CARD.TYPE
$INSERT I_F.STOCK.REGISTER
$INSERT I_F.REDO.STOCK.QTY.COUNT
$INSERT I_F.REDO.CARD.SERIES.PARAM
$INSERT I_F.REDO.CARD.REQUEST
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********



  GOSUB OPEN.PARA
  GOSUB SEL.PROC

  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********

  FN.REDO.STOCK.QTY.COUNT = 'F.REDO.STOCK.QTY.COUNT'
  F.REDO.STOCK.QTY.COUNT = ''
  CALL OPF(FN.REDO.STOCK.QTY.COUNT,F.REDO.STOCK.QTY.COUNT)

  FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
  F.REDO.CARD.SERIES.PARAM = ''
  CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)

  FN.CARD.TYPE = 'F.CARD.TYPE'
  F.CARD.TYPE = ''
  CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

  FN.COMPANY = 'F.COMPANY'
  F.COMPANY = ''
  CALL OPF(FN.COMPANY,F.COMPANY)

  FN.STOCK.REGISTER = 'F.STOCK.REGISTER'
  F.STOCK.REGISTER = ''
  CALL OPF(FN.STOCK.REGISTER,F.STOCK.REGISTER)

  FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
  F.REDO.CARD.REQUEST = ''
  CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

  Y.LRF.APPL = "CARD.TYPE"
  Y.LRF.FIELDS = 'L.CT.SUMIN.CO'
  FIELD.POS = ''
  CALL MULTI.GET.LOC.REF(Y.LRF.APPL,Y.LRF.FIELDS,FIELD.POS)
  Y.CT.SUMIN.CO.POS = FIELD.POS<1,1>

  Y.CODE = '' ; Y.TYPE = '' ; Y.DAMAGE = '' ; Y.LOST = '' ; Y.QTY.RECD = '' ; Y.ISSUED = '' ; Y.LOOP.YEAR.FLAG = '' ; FLAG.FIRST = ''
  REGION = '' ; PRODUCT.FLAG = '' ; Y.CURRENCT.STOCK = '' ; Y.FINAL.STK = '' ; Y.ENQ.STOCK = '' ; STOCK.QTY = 0
  RETURN
*--------------------------------------------------------------------------------------------------------
SEL.PROC:
***********

  LOCATE "DATE" IN D.FIELDS<1> SETTING Y.DATE.POS  THEN
    Y.DATE.VAL         = D.RANGE.AND.VALUE<Y.DATE.POS>
    Y.DATE.VAL.FROM = D.RANGE.AND.VALUE<Y.DATE.POS,1,1>
    Y.DATE.VAL.TO = D.RANGE.AND.VALUE<Y.DATE.POS,1,2>
    IF NOT(NUM(Y.DATE.VAL.FROM)) OR LEN(Y.DATE.VAL.FROM) NE '8' OR NOT(NUM(Y.DATE.VAL.TO)) OR LEN(Y.DATE.VAL.TO) NE '8' THEN
      ENQ.ERROR = 'EB-REDO.DATE.RANGE'
      RETURN
    END
    IF Y.DATE.VAL.FROM[5,2] GT 12 OR Y.DATE.VAL.TO[5,2] GT 12 OR Y.DATE.VAL.FROM[7,2] GT 31 OR Y.DATE.VAL.TO[7,2] GT 31 OR Y.DATE.VAL.TO GT TODAY OR Y.DATE.VAL.FROM GT TODAY OR Y.DATE.VAL.FROM GT Y.DATE.VAL.TO THEN
      ENQ.ERROR = 'EB-REDO.DATE.RANGE'
      RETURN
    END
  END
*
  Y.SELECT.FROM = Y.DATE.VAL.FROM
  Y.SELECT.FROM = OCONV(ICONV(Y.SELECT.FROM,'D'),'D')
  Y.SELECT.TO = Y.DATE.VAL.TO
  Y.SELECT.TO = OCONV(ICONV(Y.SELECT.TO,'D'),'D')
  Y.SELECT.DATE = Y.SELECT.FROM:' - ':Y.SELECT.TO

  IF Y.DATE.VAL.FROM  NE '' THEN
    YDATE= Y.DATE.VAL.FROM
    CALL AWD(REGION,YDATE,RETURNVAL)
    IF RETURNVAL EQ 'H' THEN
      DATE1=Y.DATE.VAL.FROM
      DAYS1='+1W'
      CALL CDT(REGION,DATE1,DAYS1)
      Y.DATE.VAL.FROM=DATE1
    END
  END
  IF Y.DATE.VAL.TO NE '' THEN
    YDATE= Y.DATE.VAL.TO
    CALL AWD(REGION,YDATE,RETURNVAL)
    IF RETURNVAL EQ 'H' THEN
      DATE1=Y.DATE.VAL.TO
      DAYS1='-1W'
      CALL CDT(REGION,DATE1,DAYS1)
      Y.DATE.VAL.TO=DATE1
    END
  END

  Y.COMP =  ID.COMPANY[7,3]
*
  GOSUB PROCESS.PARA

  RETURN
*---------------------------------------------------------------------------------------------------------------------------------
PROCESS.PARA:
**************
  SEL.CMD = "SELECT ":FN.REDO.STOCK.QTY.COUNT:" WITH AGENCY EQ ":ID.COMPANY:" BY CARD.TYPE"
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',COUNT.LIST,ERR)
  PREV.PROD.TYPE=''
  LOOP
    REMOVE Y.STOCK.ID FROM SEL.LIST SETTING POS
  WHILE Y.STOCK.ID : POS

    FETCH.DATE = ''
    BRANCH = ''
    BATCH.NO = ''
    PROD.CODE = ''
    PROD.TYPE = ''
    LOST = ''
    DAMAGE = ''
    QTY.RECEIVE = ''
    ISSUED.QTY = ''
* STOCK.QTY = 0

    CALL F.READ(FN.REDO.STOCK.QTY.COUNT,Y.STOCK.ID,R.REDO.STOCK.QTY.COUNT,F.REDO.STOCK.QTY.COUNT,Y.ERR.STOCK.QTY)
    FETCH.DATE = R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.DATE>
    BRANCH = R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.AGENCY>
    CALL F.READ(FN.COMPANY,BRANCH,R.COMPANY1,F.COMPANY,Y.ERR.COM)
    BRANCH.NAME = R.COMPANY1<EB.COM.COMPANY.NAME>
    Y.BRANCH  = BRANCH:" - ":BRANCH.NAME
    GET.PROD.CODE = R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.CARD.TYPE>
    GET.LOST = R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.LOST>
    GET.DAMAGE = R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.DAMAGE>
    GET.QTY.RECEIVE = R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.QTY.RECD>
    GET.ISSUED.QTY = R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.ISSUED>+R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.RETURNED>+R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.DESTROYED>
    GET.STOCK.QTY = R.REDO.STOCK.QTY.COUNT<REDO.STOCK.QTY.COUNT.STOCK.QTY>

    GOSUB PROCESS.RECORD

  REPEAT

  RETURN
*----------------------------------------------------------------------------------
PROCESS.RECORD:

  TOTAL.DATE.CNT = DCOUNT(FETCH.DATE,VM)
  CHANGE VM TO FM IN FETCH.DATE

  CHANGE VM TO FM IN GET.LOST
  CHANGE VM TO FM IN GET.DAMAGE
  CHANGE VM TO FM IN GET.QTY.RECEIVE
  CHANGE VM TO FM IN GET.ISSUED.QTY
  CHANGE VM TO FM IN GET.STOCK.QTY

  LOOP.CNTR = 1
  LOOP
  WHILE LOOP.CNTR LE TOTAL.DATE.CNT
    GET.CURR.DATE = FETCH.DATE<LOOP.CNTR>
    IF GET.CURR.DATE GE Y.DATE.VAL.FROM AND GET.CURR.DATE LE Y.DATE.VAL.TO THEN
      BATCH.NO = FIELD(Y.STOCK.ID,'-',1)
      CALL F.READ(FN.REDO.CARD.REQUEST,BATCH.NO,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,CARD.ERR)
      VAR.AGENCY = R.REDO.CARD.REQUEST<REDO.CARD.REQ.AGENCY>
      CALL F.READ(FN.COMPANY,VAR.AGENCY,R.COMP,F.COMPANY,COMP.ERR)
      VAR.COMPANY = R.COMP<EB.COM.COMPANY.NAME>
      BATCH.NAME  = VAR.AGENCY:" ":VAR.COMPANY
      PROD.CODE = GET.PROD.CODE
      PROD.TYPE = GET.PROD.CODE
      LOST = GET.LOST<LOOP.CNTR>
      DAMAGE = GET.DAMAGE<LOOP.CNTR>
      QTY.RECEIVE = GET.QTY.RECEIVE<LOOP.CNTR>
      ISSUED.QTY = GET.ISSUED.QTY<LOOP.CNTR>
      VAR.QTY = GET.STOCK.QTY<LOOP.CNTR>
      IF PREV.PROD.TYPE NE PROD.TYPE THEN
        STOCK.QTY=0
      END
      IF QTY.RECEIVE GE 1 THEN
        STOCK.QTY = VAR.QTY+STOCK.QTY

      END ELSE
        STOCK.QTY= STOCK.QTY - (LOST + DAMAGE + ISSUED.QTY)
      END
      PREV.PROD.TYPE=PROD.TYPE
      GOSUB FINAL.ARRAY
    END
    LOOP.CNTR += 1
  REPEAT



  RETURN
*------------------------------------------------------------------------------------
FINAL.ARRAY:

  Y.USER = OPERATOR

  TX.ARRAY<-1> = Y.USER:'*':Y.BRANCH:'*':BATCH.NO:'*':PROD.CODE:'*':PROD.TYPE:'*':LOST:'*':DAMAGE

  TX.ARRAY := '*':QTY.RECEIVE:'*':ISSUED.QTY:'*':STOCK.QTY:'*':GET.CURR.DATE:'*':BATCH.NAME

  RETURN
*-------------------------------------------------------------------------------------------------------------
END
