*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE STOCK.GENERATION.RECORD
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------
* DESCRIPTION :  This is routine is needed to automatically populate
* the field START.SEQ.NO in the template STOCK.GENERATION
*----------------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*----------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : STOCK.GENERATION.RECORD
*----------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 16.03.2010      SUDHARSANAN S     ODR-2009-10-0319  INITIAL CREATION
* ---------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.DATES
$INSERT I_F.STOCK.GENERATION
$INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
INIT:
  FN.CERTIFIED.CHEQUE.PARAMETER = 'F.CERTIFIED.CHEQUE.PARAMETER'
  F.CERTIFIED.CHEQUE.PARAMETER = ''
  CALL OPF(FN.CERTIFIED.CHEQUE.PARAMETER,F.CERTIFIED.CHEQUE.PARAMETER)
  RETURN
*----------------------------------------------------------------------------
PROCESS:
*Update Account no,type and year in stock.generation table
  CALL CACHE.READ(FN.CERTIFIED.CHEQUE.PARAMETER,ID.COMPANY,R.CERT.CHEQ.PARAM,CHEQ.ERR)
  Y.ID = ID.NEW
  Y.ID1 = Y.ID[1,1]
  IF Y.ID1 EQ 1 THEN
    LOCATE 'GOVT' IN R.CERT.CHEQ.PARAM<CERT.CHEQ.TYPE,1> SETTING POS THEN
      R.NEW(STO.GEN.ACCOUNT.NO) = R.CERT.CHEQ.PARAM<CERT.CHEQ.ACCOUNT.NO,POS>
      R.NEW(STO.GEN.TYPE.BENEF) = R.CERT.CHEQ.PARAM<CERT.CHEQ.START.SERIAL.NO,POS>
    END
  END
  IF Y.ID1 EQ 2 THEN
    LOCATE 'NON.GOVT' IN R.CERT.CHEQ.PARAM<CERT.CHEQ.TYPE,1> SETTING POS THEN
      R.NEW(STO.GEN.ACCOUNT.NO) = R.CERT.CHEQ.PARAM<CERT.CHEQ.ACCOUNT.NO,POS>
      R.NEW(STO.GEN.TYPE.BENEF) = R.CERT.CHEQ.PARAM<CERT.CHEQ.START.SERIAL.NO,POS>
    END
  END
  Y.TODAY.DATE = R.DATES(EB.DAT.TODAY)
  Y.LEFT.TODAY.DATE = LEFT(Y.TODAY.DATE,4)
  Y.YEAR = RIGHT(Y.LEFT.TODAY.DATE,2)
  R.NEW(STO.GEN.YEAR) = Y.YEAR
  RETURN
*--------------------------------------------------------------------------
END
