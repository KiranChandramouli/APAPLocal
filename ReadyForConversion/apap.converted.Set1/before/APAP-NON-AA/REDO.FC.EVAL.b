* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03

*-----------------------------------------------------------------------------
* <Rating>-85</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.EVAL(ID.CUST.LIM, ID.NAME.LIM, OUT.RESULT)
*-----------------------------------------------------------------------------
*  Description: Main Routine, allows to
*              1. Evaluate customer to determinate the Risk Limits to applied
*              2. Get 1 or 0 that represent if the Customer  belong to ID.NAME.LIM
*-----------------------------------------------------------------------------
* PARAMETERS:
* INPUT:
*       ID.CUST.LIM -> Customer Id. to process, related with REDO.CCRG.RL.CUSTOMER
*       ID.NAME.LIM -> Limit Code
* OUTPUT:
*       OUT.RESULT ->  1 or 0 that represent if the Customer  belong to ID.NAME.LIM
*
*
*-----------------------------------------------------------------------------
* Modification History:
*                      2011-04-07 : mgudino@temenos.com
*                                   First version
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_F.CUSTOMER
*
$INSERT I_REDO.CCRG.B.EVA.COMMON
$INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
$INSERT I_F.REDO.CCRG.CUSTOMER
*
*-----------------------------------------------------------------------------
* Perform the transaction/contract processing in this routine. All files & standard
  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN

* ========
PROCESS:
* ========
*
*  Principal process to:
  Y.PRGRAPH.NAME = 'PROCESS'
*Evaluate Customer and get data
  GOSUB GET.RL.CUSTOMER
  GOSUB EVALUATE.CUSTOMER

  RETURN

* =================
GET.RL.CUSTOMER:
* =================
*
*  Paragraph to get data from REDO.CCRG.CUSTOMER for P.IN.PRO.ID

*
  Y.PRGRAPH.NAME = 'GET.RL.CUSTOMER'
*Read data in Application REDO.CCRG.CUSTOMER

  CALL F.READ(FN.REDO.CCRG.CUSTOMER,ID.CUST.LIM,R.REDO.CCRG.CUSTOMER,F.REDO.CCRG.CUSTOMER,Y.ERR)
  IF NOT(R.REDO.CCRG.CUSTOMER) THEN
    OUT.RESULT = Y.ERR
    RETURN
  END ELSE

    Y.CUSTOMER.ID   = R.REDO.CCRG.CUSTOMER<REDO.CCRG.CUS.CUSTOMER.ID>
    R.EXT.QUEUE<-1> = Y.CUSTOMER.ID

*Get data for customer from Customer Application

    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.ERR)
    IF NOT(R.CUSTOMER) THEN
      OUT.RESULT = Y.ERR
      RETURN
    END
*Set Relation Code
    R.REL.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
*Set Risk Group
    R.RISK.GRP1 = R.CUSTOMER<EB.CUS.LOCAL.REF,GRP.RISK.POS>
    R.RISK.GRP = CHANGE(R.RISK.GRP1, SM, VM)
  END
*
  RETURN
*
* ===================
EVALUATE.CUSTOMER:
* ===================
*
* Process to evaluate the customer vs. limits
  Y.PRGRAPH.NAME = 'EVALUATE.CUSTOMER'
*
  R.RL.CUSTOMER = ''
  R.RL.REL.CUS = ''
  GOSUB PROCESS.LIMIT
*
  RETURN
*
* ===============
PROCESS.LIMIT:
* ===============
*
*Evaluate the limits for customer to determinate the risk limits
*
  Y.PRGRAPH.NAME = 'PROCESS.LIMIT'
*
  Y.CONT.LIMI.APP = 0

  CALL F.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,ID.NAME.LIM,R.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM,Y.ERR)
  IF Y.ERR THEN
    CALL OCOMO('error: ': Y.ERR)
    OUT.RESULT = 0
    RETURN
  END

* Consider conditions for each Risk.limit
  GOSUB PROCESS.LIMITS.INI
  OUT.RESULT = Y.RETURN
*
  RETURN
*
* ===================
PROCESS.LIMITS.INI:
* ===================
*
*Some limits dont have conditions
*
  R.COND.DEF<2>   = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.OPERATOR>
  R.COND.DEF<3>   = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MIN.VALUE>
  R.COND.DEF<4>   = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MAX.VALUE>
  R.COND.DEF<5>   = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.BOOL.OPER>
  R.COND.DEF<1>   = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.FIELD.NO>
  P.VALUES<1>     = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.FIELD.NO>

  Y.NO.FIELDS = DCOUNT(R.COND.DEF<1>,VM)
  CALL OCOMO('Y.NO.FIELDS': Y.NO.FIELDS :' R.COND.DEF<1>:':R.COND.DEF<1>)
  P.VALUES<2> = ''
  FOR J = 1 TO Y.NO.FIELDS
    P.APPLICATION = 'CUSTOMER'
    P.FIELD.NAME  = R.COND.DEF<1,J>
    IF P.FIELD.NAME EQ 'RELATION.CODE' THEN
      IF NOT(R.CUSTOMER<EB.CUS.RELATION.CODE>) THEN
        R.CUSTOMER<EB.CUS.RELATION.CODE> = "''"
      END
    END
    IF P.FIELD.NAME EQ 'L.CU.GRP.RIESGO' THEN
      P.FIELD.NO = L.CU.GRP.RIESGO.POS
      IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,P.FIELD.NO>) THEN
        R.CUSTOMER<EB.CUS.LOCAL.REF,P.FIELD.NO> = "''"
      END
    END
    IF P.FIELD.NAME EQ 'L.CU.GRP.RIESGO' THEN
      IF J = 1 THEN
        P.VALUES<2> = R.CUSTOMER<EB.CUS.LOCAL.REF,P.FIELD.NO>
      END ELSE
        P.VALUES<2> := VM:R.CUSTOMER<EB.CUS.LOCAL.REF,P.FIELD.NO>
      END
    END ELSE
      IF J = 1 THEN
        P.VALUES<2>  = CHANGE(R.CUSTOMER<EB.CUS.RELATION.CODE>,VM,SM)
      END ELSE
        P.VALUES<2>  := VM:CHANGE(R.CUSTOMER<EB.CUS.RELATION.CODE>,VM,SM)
      END
    END
  NEXT J

  CALL OCOMO('ANTES EVALUATOR':R.COND.DEF:' P.VALUES:':P.VALUES)
*      CRT 'R.COND.DEF->':R.COND.DEF
*      CRT 'P.VALUES ->':P.VALUES
  CALL S.REDO.CONDITION.EVALUATOR(R.COND.DEF,P.VALUES,Y.RETURN)
  CALL OCOMO('ANTES EVALUATOR':R.COND.DEF:' P.VALUES:':P.VALUES:' Y.RETURN')

  IF Y.RETURN EQ '1' THEN
    OUT.RESULT = Y.RETURN
  END
  RETURN

* ===========
INITIALISE:
* ===========
*
*  Paragraph to initialise variables
  Y.PRGRAPH.NAME = 'INITIALISE'
  OUT.RESULT = 0
  PROCESS.GOAHEAD             = 1
  R.EXT.QUEUE                 = ''
  Y.CUSTOMER.ID               = ''
  Y.TEXT                      = ''

  Y.APPL = 'CUSTOMER'
  Y.FIELDS = 'L.CU.GRP.RIESGO'
  Y.POS.FIELD = ''
  CALL MULTI.GET.LOC.REF(Y.APPL,Y.FIELDS,Y.POS.FIELD)
  L.CU.GRP.RIESGO.POS = Y.POS.FIELD<1,1>
*
  RETURN
*
* =========
OPEN.FILES:
* =========

  FN.REDO.CCRG.RISK.LIMIT.PARAM = 'F.REDO.CCRG.RISK.LIMIT.PARAM'
  F.REDO.CCRG.RISK.LIMIT.PARM  = ''
  CALL OPF(FN.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARM)

  FN.REDO.CCRG.CUSTOMER = 'F.REDO.CCRG.CUSTOMER'
  F.REDO.CCRG.CUSTOMER  = ''
  CALL OPF(FN.REDO.CCRG.CUSTOMER,F.REDO.CCRG.CUSTOMER)

  FN.CUSTOMER = "F.CUSTOMER"
  F.CUSTOMER = ""
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  RETURN
END
