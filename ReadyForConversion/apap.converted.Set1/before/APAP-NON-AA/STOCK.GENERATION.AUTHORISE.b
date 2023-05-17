*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE STOCK.GENERATION.AUTHORISE
*------------------------------------------------------------------------------
*DESCRIPTION
* AUTHORISE ROUTINE TO UPDATE CERTIFIED.CHEQUE.STOCK RECORD
*------------------------------------------------------------------------------
*APPLICATION : STOCK.GENERATION
*------------------------------------------------------------------------------
*
* Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : STOCK.GENERATION.AUTHORISE
*----------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STOCK.GENERATION
$INSERT I_F.CERTIFIED.CHEQUE.STOCK
  GOSUB INIT
  GOSUB PROCESS
  RETURN
***********
INIT:
***********
  FN.CERTIFIED.CHEQUE.STOCK='F.CERTIFIED.CHEQUE.STOCK'
  F.CERTIFIED.CHEQUE.STOCK=''
  CALL OPF(FN.CERTIFIED.CHEQUE.STOCK,F.CERTIFIED.CHEQUE.STOCK)
  Y.CHEQUE.STOCK.ID=''
  RETURN
*--------------------------------------------------------------------------
************
PROCESS:
************
*Upload the certified cheques in the table
  Y.TYPE.BENEF = R.NEW(STO.GEN.TYPE.BENEF)
  Y.YEAR = FMT(R.NEW(STO.GEN.YEAR),'R%2')
  Y.START.SEQ.NO = FMT(R.NEW(STO.GEN.START.SEQ.NO),'R%6')
  Y.NO.OF.INST = R.NEW(STO.GEN.NO.OF.INST)
  Y.RECORD.STATUS=R.NEW(STO.GEN.RECORD.STATUS)
  IF Y.RECORD.STATUS EQ 'INAU' AND V$FUNCTION EQ 'A' THEN
    NO.OF.INST=1
    LOOP
    WHILE NO.OF.INST LE Y.NO.OF.INST
      Y.CHEQUE.STOCK.ID<-1>=Y.TYPE.BENEF:Y.YEAR:Y.START.SEQ.NO
      Y.CHEQUE.STK.ID=Y.CHEQUE.STOCK.ID<NO.OF.INST>
      CALL F.READ(FN.CERTIFIED.CHEQUE.STOCK,Y.CHEQUE.STK.ID,R.CERT.CHEQ.STK,F.CERTIFIED.CHEQUE.STOCK,CERT.CHEQ.ERR)
      R.CERT.CHEQ.STK<CERT.STO.STATUS> = 'AVAILABLE'
      CALL F.WRITE(FN.CERTIFIED.CHEQUE.STOCK,Y.CHEQUE.STK.ID,R.CERT.CHEQ.STK)
      Y.START.SEQ.NO++
      NO.OF.INST++
    REPEAT
  END
  IF Y.RECORD.STATUS EQ 'RNAU' AND V$FUNCTION EQ 'A' THEN
    GOSUB CHEQ.DEL
  END
  RETURN
*--------------------------------------------------------------
**********
CHEQ.DEL:
***********
  NO.OF.INST=1
  LOOP
  WHILE NO.OF.INST LE Y.NO.OF.INST
    Y.CHEQUE.STOCK.ID<-1>=Y.TYPE.BENEF:Y.YEAR:Y.START.SEQ.NO
    Y.CHEQUE.STK.ID=Y.CHEQUE.STOCK.ID<NO.OF.INST>
    CALL F.READ(FN.CERTIFIED.CHEQUE.STOCK,Y.CHEQUE.STK.ID,R.CERT.CHEQ.STK,F.CERTIFIED.CHEQUE.STOCK,CERT.CHEQ.ERR)
    CALL F.DELETE(FN.CERTIFIED.CHEQUE.STOCK,Y.CHEQUE.STK.ID)
    Y.START.SEQ.NO++
    NO.OF.INST++
  REPEAT
  RETURN
*-------------------------------------------------------------
END
