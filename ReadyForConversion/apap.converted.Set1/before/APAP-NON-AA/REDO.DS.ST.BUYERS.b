*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.ST.BUYERS(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Arulprakasam P
* PROGRAM NAME: REDO.DS.ST.BUYERS
* ODR NO      : ODR-2010-07-0082
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Product selected for LETTER

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SEC.TRADE
$INSERT I_F.CUSTOMER

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN

INIT:
*****
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''

  RETURN

OPENFILES:
**********
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  RETURN

PROCESS:
********

  NAME.1 = ''
  CUST.TRANS.CODE = R.NEW(SC.SBS.CUST.TRANS.CODE)
  CHANGE VM TO '*' IN CUST.TRANS.CODE
  Y.COUNT.TRANS = DCOUNT(CUST.TRANS.CODE,'*')
  INIT = 1
*LOOP
*WHILE INIT LE Y.COUNT.TRANS
  Y.FIRST.TRANS = FIELD(CUST.TRANS.CODE,'*',INIT)
  IF Y.FIRST.TRANS EQ 'SEL' THEN
    CUSTOMER.NO = R.NEW(SC.SBS.BROKER.NO)<1,INIT>
    CALL F.READ(FN.CUSTOMER,CUSTOMER.NO,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
    Y.INT.CNT=DCOUNT(SHORT.NAME,VM)

    IF Y.INT.CNT GT 1 THEN
      SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME,LNGG>
    END
    IF  SHORT.NAME EQ '' THEN
      SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME,2>
    END

    NAME.1<-1> := SHORT.NAME
  END
  IF Y.FIRST.TRANS EQ 'BUY' THEN
    NAME.1 = ''
    NAME.1 = "APAP"
  END
  INIT ++
*REPEAT
  CHANGE FM TO ',' IN NAME.1
  Y.RET = NAME.1
  RETURN
END
