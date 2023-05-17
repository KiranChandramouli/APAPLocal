*-----------------------------------------------------------------------------
* <Rating>-66</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CLEARING.INWARD.RECORD
*-----------------------------------------------------------------------------
* Description:
* This routine is a validate routine for REDO.CLEARING.INWARD template and it default the
* charge amount from FT.CHARGE.TYPE or FT.COMMISSION.TYPE application
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Arulpraksam p
* PROGRAM NAME : REDO.CLEARING.INWARD.VALIDATE
*---------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO               REFERENCE           DESCRIPTION
* 04.10.2010       Arulpraksam P     ODR-2010-09-0148    INITIAL CREATION
* 30 8 2011        KAVITHA           PACS00112979        PACS00112979  FIX
*---------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FT.CHARGE.TYPE
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT
$INSERT I_F.FT.COMMISSION.TYPE
$INSERT I_F.REDO.APAP.CLEARING.INWARD
$INSERT I_F.REDO.APAP.CLEAR.PARAM
$INSERT I_System


  GOSUB INIT
  GOSUB PROCESS

  RETURN

*---------------------------------------------------------------------------------------------------
*****
INIT:
*****

  FN.FT.CHARGE.TYPE = 'F.FT.CHARGE.TYPE'
  F.FT.CHARGE.TYPE  = ''
  CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)

  FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
  F.FT.COMMISSION.TYPE  = ''
  CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
  F.REDO.APAP.CLEAR.PARAM  = ''
  CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)

  RETURN

*--------------------------------------------------------------------------------------------------------
********
PROCESS:
********


*GOSUB FIND.MULTI.LOCAL.REF
  Y.ACCOUNT = R.NEW(CLEAR.CHQ.ACCOUNT.NO)
  Y.TRANS.DATE = R.NEW(CLEAR.CHQ.TRANS.DATE)
  Y.IMAGE.REFERENCE = R.NEW(CLEAR.CHQ.IMAGE.REFERENCE)
  CALL System.setVariable("CURRENT.TRANS.DATE",Y.TRANS.DATE)
  CALL System.setVariable("CURRENT.IMAGE.REFERENCE",Y.IMAGE.REFERENCE)
  CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCOUNTE.ERR)
  IF R.ACCOUNT THEN
    Y.CUSTOMER.NO = R.ACCOUNT<AC.CUSTOMER>
    Y.CURRENCY    = R.ACCOUNT<AC.CURRENCY>
    ACCT.OFFICER  = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    Y.CO.CODE     = R.ACCOUNT<AC.CO.CODE>
  END
  R.NEW(CLEAR.CHQ.COMP.CODE)    = Y.CO.CODE
  R.NEW(CLEAR.CHQ.ACCT.OFFICER) = ACCT.OFFICER

*CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.NO,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
*IF R.CUSTOMER THEN
*Y.SEGMENTO    = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.SEGMENTO.POS>
*END

*CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,REDO.APAP.CLEAR.PARAM.ERR)
*Y.CUSTOMER.TYPE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CUSTOMER.TYPE>
*CHANGE VM TO FM IN Y.CUSTOMER.TYPE

*LOCATE Y.SEGMENTO IN Y.CUSTOMER.TYPE SETTING Y.SEG.POS THEN
*Y.FT.REF.CHG = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.FT.REF.CHG,Y.SEG.POS>
*END

*GOSUB GET.GROUP.DETAILS


*PACS00112979 -S
*GOSUB VALIDATE.CHARGE.TYPE
*PACS00112979 -E

  RETURN

*--------------------------------------------------------------------------------------------------------
******************
GET.GROUP.DETAILS:
******************


*CUSTOMER.ID = Y.CUSTOMER.NO
*DEAL.AMOUNT =  R.NEW(CLEAR.CHQ.AMOUNT)
*DEAL.CURRENCY = Y.CURRENCY
*CCY.MKT = '1'
*CROSS.RATE = ""
*CROSS.CURRENCY = DEAL.CURRENCY
*DRAWDOWN.CURRENCY = CROSS.CURRENCY
*T.DATA = ""
*TOTAL.FOREIGN.AMT = ""
*TOTAL.LOCAL.AMT = ""
*TOTAL.AMT = ""
*T.DATA<1,1> = Y.FT.REF.CHG

*CALL CALCULATE.CHARGE(CUSTOMER.ID, DEAL.AMOUNT, DEAL.CURRENCY, CCY.MKT, CROSS.RATE,CROSS.CURRENCY, DRAWDOWN.CURRENCY, T.DATA, '', TOTAL.LOCAL.AMT, TOTAL.FOREIGN.AMT)
*VAR.TOT.CHG.AMT = T.DATA<4,1>

*R.NEW(CLEAR.CHQ.CHG.AMOUNT) = VAR.TOT.CHG.AMT
*R.NEW(CLEAR.CHQ.CHARGE.TYPE) = Y.FT.REF.CHG

  RETURN

*-------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************

  APPL.ARRAY = 'CUSTOMER'
  FLD.ARRAY = 'L.CU.SEGMENTO'

  FLD.POS = ''

  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  L.CU.SEGMENTO.POS = FLD.POS<1,1>

  RETURN
*-----------------------------------------------------------------------------------------------------
VALIDATE.CHARGE.TYPE:


  GET.FT.REF.CHG = R.NEW(CLEAR.CHQ.CHARGE.TYPE)
  R.FT.TXN.TYPE.CONDITION = ''
  R.FT.CHARGE.TYPE = ''

  IF GET.FT.REF.CHG THEN
    CALL F.READ(FN.FT.COMMISSION.TYPE,GET.FT.REF.CHG,R.FT.TXN.TYPE.CONDITION,F.FT.COMMISSION.TYPE,FT.ERR)
    IF NOT(R.FT.TXN.TYPE.CONDITION) THEN
      CALL F.READ(FN.FT.CHARGE.TYPE,GET.FT.REF.CHG,R.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE,CHG.ERR)
    END

  END

  RETURN
*--------------
END
