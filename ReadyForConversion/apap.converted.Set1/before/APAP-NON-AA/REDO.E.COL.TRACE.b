*-----------------------------------------------------------------------------
* <Rating>-221</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.COL.TRACE(SUMMARY.LIST)
*-----------------------------------------------------------------------------
* <doc>
*
* This routine have to genere the totaled data for the enquiry E.REDO.COL.TRACE
* This data is separete in 3 steps filters by tyoe of process:
* 1 case for the tables FIRST CASE TMPCLIENTES OR TMPDIRECCIONESCLIENTE OR TMPDIRECCIONESCLIENTE
* 2 case  SECOND CASE AA.PRODUCT -> CREDIT
* 3 case THIRD CASE MOVEMENT -> CREDIT
* author: mgudino@temenos.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 29/10/2010 - C.1 Collector
*
* 12/10/2011 - C.1 Locking Problem when READU is used. Then the enquiry must read from F.REDO.COL.TRACE instead of F.REDO.COL.TRACE.SUM
*              hpasquel@temenos.com
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.INTERFACE.PARAM
$INSERT I_F.REDO.COL.TRACE

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN
*--------------------------------------
INIT:
*--------------------------------------

*REDO.INTERFACE.PARAM

  FN.REDO.COL.TRACE = 'F.REDO.COL.TRACE'          ;* PP1
  F.REDO.COL.TRACE  = ''      ;* PP1

  FN.AA.PRODUCT.GROUP = 'F.AA.PRODUCT.GROUP'
  F.AA.PRODUCT.GROUP = ''

  Y.SELECT.CMD = ""
  Y.MSG.ERROR = ""
  REDO.COL.TRACE.SUM.LIST = ''
  LIST.NAME = ''
  SELECTED = ''
  SYSTEM.RETURN.CODE = ''

  Y.TOT.SUM.OK = 0
  Y.TOT.SUM.ERR = 0
  Y.TOT.SUM = 0

  Y.SEP = "*"

  Y.PROCESS.DATE = ''

  RETURN
*--------------------------------------
OPENFILES:

  CALL OPF(FN.REDO.COL.TRACE, F.REDO.COL.TRACE)   ;* PP1
  CALL OPF(FN.AA.PRODUCT.GROUP,F.AA.PRODUCT.GROUP)

  RETURN
*--------------------------------------
PROCESS:
* GET FIELDS, INSERT BY THE CUSTOMER

  Y.DETAILS = ""

  Y.TOTAL.PROCESS = 0
  Y.TOTAL.ERROR = 0

  LOCATE "TYPE.PROCESS" IN D.FIELDS<1> SETTING CUS.POS THEN
    Y.PROCESS = UPCASE(D.RANGE.AND.VALUE<CUS.POS>)
    D.RANGE.AND.VALUE<CUS.POS> = Y.PROCESS
  END

  LOCATE "PROCESS.DATE" IN D.FIELDS<1> SETTING CUS.POS THEN
    Y.PROCESS.DATE = D.RANGE.AND.VALUE<CUS.POS>
  END
  GOSUB CHECK.PROCESS.DATE

* CHECK PARAMETERS
  IF NOT(Y.PROCESS MATCHES "DELIVERY" : VM : "EXTRACT") THEN
    Y.TEXT = "ST-REDO.COL.E.INVALID.PROCESS.TYPE" : VM : "PROCESS.TYPE & NOT VALID MUST BE DELIVERY OR EXTRACT"
    Y.TEXT<2> = Y.PROCESS
    CALL TXT(Y.TEXT)
    ENQ.ERROR<1> = Y.TEXT
    RETURN
  END


* TMPCLIENTES OR TMPDIRECCIONESCLIENTE OR TMPDIRECCIONESCLIENTE
  Y.TABLES.LIST.CLIENTS.LIST = "TMPCLIENTES":FM:"TMPDIRECCIONESCLIENTE":FM:"TMPTELEFONOSCLIENTE"
  Y.DETAIL.ID = ""
  Y.POSITION = 1
  Y.SUMMARY.NEED = 0
  Y.SUM.TOTAL.PROCESS = 0
  Y.SUM.TOTAL.ERROR   = 0
  LOOP
    REMOVE Y.TABLE.ID FROM  Y.TABLES.LIST.CLIENTS.LIST SETTING Y.MARK
  WHILE Y.TABLE.ID : Y.MARK
    Y.REDOCOL.TRACE.L.ID = Y.PROCESS.DATE : "." : Y.PROCESS : "." : Y.TABLE.ID : "." : Y.DETAIL.ID
    GOSUB READ.TRACE
  REPEAT

  GOSUB INSERT.BLANK.RECORD

* TMPCREDITO
*--------------------------------------------------------------
  Y.SEL.CMD = ""
  Y.SEL.CMD := "SELECT " : FN.AA.PRODUCT.GROUP
  Y.SEL.CMD :=  " WITH PRODUCT.LINE EQ 'LENDING'"
  Y.PD.LIST = ""
  Y.TABLE.ID = "TMPCREDITO"
  CALL EB.READLIST(Y.SEL.CMD,Y.PD.LIST,'',SELECTED.TOTAL,SYSTEM.RETURN.CODE)

  GOSUB INSERT.HEADER
  LOOP
    REMOVE Y.DETAIL.ID FROM  Y.PD.LIST SETTING Y.MARK
  WHILE Y.DETAIL.ID : Y.MARK
    Y.REDOCOL.TRACE.L.ID = Y.PROCESS.DATE : "." : Y.PROCESS : "." : Y.TABLE.ID : "." : Y.DETAIL.ID
    GOSUB READ.TRACE
  REPEAT
  GOSUB INSERT.SUMMARY
  GOSUB INSERT.BLANK.RECORD

*TMPMOVIMIENTO
*--------------------------------------------------------------
  Y.TABLES.LIST.CLIENTS.LIST = "PAYOFF.TXN":FM:"PAY.TXN":FM:"PARTIALPAY.TXN"
  Y.DETAIL.ID = ""
  Y.TABLE.ID = "TMPMOVIMIENTOS"
  GOSUB INSERT.HEADER
  LOOP
    REMOVE Y.DETAIL.ID FROM  Y.TABLES.LIST.CLIENTS.LIST SETTING Y.MARK
  WHILE Y.DETAIL.ID : Y.MARK
    Y.REDOCOL.TRACE.L.ID = Y.PROCESS.DATE : "." : Y.PROCESS : "." : Y.TABLE.ID : "." : Y.DETAIL.ID
    GOSUB READ.TRACE
  REPEAT

  GOSUB INSERT.SUMMARY
  GOSUB INSERT.BLANK.RECORD

* FINAL SUMMARY
*--------------------------------------------------------------
  Y.TABLE.ID  = ""
  Y.DETAIL.ID = "TOTAL"
  Y.NUM.PROCESS = Y.TOTAL.PROCESS
  Y.NUM.ERROR   = Y.TOTAL.ERROR
  Y.NUM.PRO.ERR = Y.TOTAL.PROCESS + Y.TOTAL.ERROR
  GOSUB CREATE.ROW

  LOOP
    REMOVE Y.LINE FROM SUMMARY.LIST SETTING Y.MARK
  WHILE Y.MARK : Y.LINE
    Y.LINE = CHANGE(Y.LINE,Y.SEP,"    ")
    CALL OCOMO(Y.LINE)
  REPEAT

*--------------------------------------
  RETURN

*-------------------------------------------------------------------------
* Get info from TRACE for Y.REDOCOL.TRACE.L.ID, the values returned are Y.NUM.PROCESS, Y.NUM.ERROR, Y.TOTAL.PROCESS
READ.TRACE:
*-------------------------------------------------------------------------
  Y.NUM.PROCESS = 0
  Y.NUM.ERROR   = 0
  Y.MSGE        = ""

*     REDO.COL.TRACE.SUM.ID = Y.REDOCOL.TRACE.L.ID : ".10"
*     CALL F.READ(FN.REDO.COL.TRACE.SUM,REDO.COL.TRACE.SUM.ID,R.REDO.COL.TRACE.SUM,F.REDO.COL.TRACE.SUM.SUM,YERR)
*     IF  R.REDO.COL.TRACE.SUM NE "" THEN
*         Y.NUM.PROCESS = R.REDO.COL.TRACE.SUM<1>
*     END
  Y.SEL.CMD = ''
  Y.SEL.CMD := 'SELECT ' : FN.REDO.COL.TRACE
  Y.SEL.CMD := ' WITH PROCESS.DATE EQ "' : Y.PROCESS.DATE : '"'
  Y.SEL.CMD := ' AND TYPE.PROCESS EQ "' : Y.PROCESS : '"'
  Y.SEL.CMD := ' AND STATUS EQ 10'
  Y.SEL.CMD := " AND TABLE EQ '" : Y.TABLE.ID  : "'"
  Y.SEL.CMD := " AND DETAILS EQ '" : Y.DETAIL.ID : "'"
  CALL EB.READLIST(Y.SEL.CMD,Y.PG.LIST,'',SELECTED.TOTAL,SYSTEM.RETURN.CODE)
  IF Y.PG.LIST NE '' THEN
    Y.NUM.PROCESS = SELECTED.TOTAL
  END

*     REDO.COL.TRACE.SUM.ID = Y.REDOCOL.TRACE.L.ID : ".20"
*     CALL F.READ(FN.REDO.COL.TRACE.SUM,REDO.COL.TRACE.SUM.ID,R.REDO.COL.TRACE.SUM,F.REDO.COL.TRACE.SUM.SUM,YERR)
*     IF  R.REDO.COL.TRACE.SUM NE "" THEN
*         Y.NUM.ERROR = R.REDO.COL.TRACE.SUM<1>
*         Y.MSGE = R.REDO.COL.TRACE.SUM<4>
*     END
  Y.PG.LIST = ''
  Y.SEL.CMD = ''
  Y.SEL.CMD := 'SELECT ' : FN.REDO.COL.TRACE
  Y.SEL.CMD := ' WITH PROCESS.DATE EQ "' : Y.PROCESS.DATE : '"'
  Y.SEL.CMD := ' AND TYPE.PROCESS EQ "' : Y.PROCESS : '"'
  Y.SEL.CMD := ' AND STATUS EQ 20'
  Y.SEL.CMD := " AND TABLE EQ '" : Y.TABLE.ID  : "'"
  Y.SEL.CMD := " AND DETAILS EQ '" : Y.DETAIL.ID : "'"
  CALL EB.READLIST(Y.SEL.CMD,Y.PG.LIST,'',SELECTED.TOTAL,SYSTEM.RETURN.CODE)
  IF Y.PG.LIST NE '' THEN
    Y.NUM.ERROR = SELECTED.TOTAL
    CALL F.READ(FN.REDO.COL.TRACE, Y.PG.LIST<1>, R.REDO.COL.TRACE, F.REDO.COL.TRACE,YERR)
    Y.MSGE = R.REDO.COL.TRACE<REDO.COL.TRC.MESSAGE>
  END
* >>



  Y.NUM.PRO.ERR = Y.NUM.PROCESS + Y.NUM.ERROR

  IF Y.NUM.PRO.ERR GT 0 THEN
    GOSUB CREATE.ROW
    Y.POSITION ++
    Y.TOTAL.PROCESS += Y.NUM.PROCESS
    Y.TOTAL.ERROR += Y.NUM.ERROR
    Y.SUM.TOTAL.PROCESS += Y.NUM.PROCESS
    Y.SUM.TOTAL.ERROR   += Y.NUM.ERROR
  END

  RETURN
*-------------------------------------------------------------------------
* Create a new row to insert in the QUERY result
CREATE.ROW:
*-------------------------------------------------------------------------
  Y.ROW = ""
  Y.ROW<1> = Y.POSITION
  IF NOT(Y.SUMMARY.NEED) THEN
    Y.ROW<2> = Y.TABLE.ID
  END ELSE
    Y.ROW<2> = ""
  END
  Y.ROW<3> = Y.DETAIL.ID
  IF Y.DETAIL.ID EQ "PAYOFF.TXN" THEN
    Y.ROW<3> = "Pago y/o Cancelacion"
  END
  IF Y.DETAIL.ID EQ "PARTIALPAY.TXN" THEN
    Y.ROW<3> = "Abono"
  END

  Y.ROW<4> = Y.NUM.PROCESS
  Y.ROW<5> = Y.NUM.ERROR
  Y.ROW<6> = Y.NUM.PRO.ERR
  Y.ROW<7> = Y.MSGE
  Y.ROW = CHANGE(Y.ROW,FM,Y.SEP)
  SUMMARY.LIST<-1> = Y.ROW
  RETURN

*-------------------------------------------------------------------------
* Insert summary, count the total processed
INSERT.HEADER:
*-------------------------------------------------------------------------
  SUMMARY.LIST<-1> = Y.POSITION : Y.SEP : Y.TABLE.ID : Y.SEP : Y.SEP : Y.SEP : Y.SEP
  Y.POSITION++
  Y.SUMMARY.NEED = 1
  Y.SUM.TOTAL.PROCESS = 0
  Y.SUM.TOTAL.ERROR   = 0

  RETURN
*-------------------------------------------------------------------------
* Insert summary, count the total processed
INSERT.SUMMARY:
*-------------------------------------------------------------------------
  Y.SUMMARY.NEED = 0
  Y.TABLE.ID = "Total"
  Y.DETAIL.ID = ""
  Y.NUM.PROCESS = Y.SUM.TOTAL.PROCESS
  Y.NUM.ERROR   = Y.SUM.TOTAL.ERROR
  Y.NUM.PRO.ERR = Y.SUM.TOTAL.PROCESS + Y.SUM.TOTAL.ERROR
  GOSUB CREATE.ROW
  Y.POSITION++
  RETURN

*-------------------------------------------------------------------------
INSERT.BLANK.RECORD:
*-------------------------------------------------------------------------
  SUMMARY.LIST<-1> = Y.POSITION : Y.SEP : Y.SEP : Y.SEP : Y.SEP : Y.SEP
  Y.POSITION++
  RETURN

*-------------------------------------------------------------------------
CHECK.PROCESS.DATE:
*-------------------------------------------------------------------------
  IF NOT(Y.PROCESS.DATE) THEN
    Y.PROCESS.DATE = TODAY
  END

  Y.COMI = COMI
  COMI = Y.PROCESS.DATE
  ETEXT = ""
  CALL IN2D("10","D")
  IF ETEXT NE "" THEN
    ENQ.ERROR<1> = ETEXT
    RETURN
  END

  Y.PROCESS.DATE = COMI
  D.RANGE.AND.VALUE<CUS.POS> = COMI
  ENQ.SELECTION<CUS.POS> = COMI
  COMI = Y.COMI
  RETURN
*------------------------------------------------------------------------
END
