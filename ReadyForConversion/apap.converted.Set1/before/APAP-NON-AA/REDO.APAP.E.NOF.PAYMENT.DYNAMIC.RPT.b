*-----------------------------------------------------------------------------
* <Rating>-247</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.E.NOF.PAYMENT.DYNAMIC.RPT(Y.OUT.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : T.Jeeva, Temenos Application Management
*Program   Name    : REDO.APAP.E.NOF.PAYMENT.DYNAMIC.RPT
*ODR Reference     : ODR-2010-03-0183
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.APAP.E.NOF.PAYMENT.DYNAMIC.RPT is a no-file enquiry routine for the enquiry
*               REDO.APAP.ENQ.PAYMENT.DYNAMIC.RPT & REDO.APAP.ER.PAYMENT.DYNAMIC.RPT,
*               the routine based on the selection criteria selects the records from respective files
*               and displays the processed records
*In Parameter : N/A
*Out Parameter: Y.OUT.ARRAY
*LINKED WITH  : STANDARD.SELECTION>NOFILE.PAYMENT.DYNAMIC.RPT
*   DATE           WHO                REFERENCE           DESCRIPTION
* 28-APR-2011      H GANESH           CR009              Change the Vetting value of local field
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.ACCOUNT
$INSERT I_F.AA.ACCOUNT.DETAILS
$INSERT I_F.AA.ACCOUNT
$INSERT I_F.AA.CUSTOMER
$INSERT I_F.AA.OVERDUE
$INSERT I_F.AA.PAYMENT.SCHEDULE
*--------------------------------------------------------------------------------------------------------

  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN
*--------------------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------------------

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT  = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
  F.AA.ACCOUNT.DETAILS  = ''
  CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

  FN.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS = "F.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS"
  F.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS  = ""
  CALL OPF(FN.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,F.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS)

  FN.AAA = "F.AA.ARRANGEMENT.ACTIVITY"
  F.AAA  = ""
  CALL OPF(FN.AAA,F.AAA)

  Y.OUT.ARRAY          = ''
  AA.PRIM.IDS          = ''
  Y.DOM.AA.IDS         = ''
  Y.DOM.FIELD          = ''
  Y.DUE.DATE.FIELD     = ''
  Y.CAMP.FIELD         = ''
  Y.AFF.FIELD          = ''
  Y.LOAN.STATUS.FIELD  = ''
  Y.AGING.STATUS.FIELD = ''

  LOC.REF.APPLICATION   = "AA.PRD.DES.CUSTOMER":FM:"ACCOUNT":FM:"AA.PRD.DES.OVERDUE":FM:"AA.PRD.DES.PAYMENT.SCHEDULE"
  LOC.REF.FIELDS        = 'L.AA.AFF.COM':VM:'L.AA.CAMP.TY':FM:'L.OD.STATUS':FM:'L.LOAN.STATUS.1':FM:'L.AA.PAY.METHD'
  LOC.REF.POS           = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.AA.AFF.COM      = LOC.REF.POS<1,1>
  POS.L.AA.CAMP.TY      = LOC.REF.POS<1,2>
  POS.L.OD.STATUS       = LOC.REF.POS<2,1>
  POS.L.LOAN.STATUS.1   = LOC.REF.POS<3,1>
  POS.L.AA.PAY.METHD    = LOC.REF.POS<4,1>

  RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------

  VALUE.BK    = D.RANGE.AND.VALUE
  OPERAND.BK  = D.LOGICAL.OPERANDS
  FIELDS.BK   = D.FIELDS

  D.RANGE.AND.VALUE  = ''
  D.LOGICAL.OPERANDS = ''
  D.FIELDS           = ''

  GOSUB PRIMARY.SELECTION
  IF AA.PRIM.IDS THEN
    GOSUB GET.SELECTION.VALUES
    GOSUB DO.DOM.DATE.SELECTION
  END ELSE
    ENQ.ERROR = 'No records selected after the primary selection'
    GOSUB END1
  END
  IF Y.DOM.AA.IDS THEN
    GOSUB DO.CUSTOMER.SELECTION
  END ELSE
    ENQ.ERROR = 'No records selected after the DOM selection'
    GOSUB END1
  END
  IF Y.CUS.AA.IDS THEN
    GOSUB DO.OVERDUE.SELECTION
  END ELSE
    ENQ.ERROR = 'No records selected after the CUSTOMER selection'
    GOSUB END1
  END

  IF  Y.AGE.AA.IDS THEN

    D.RANGE.AND.VALUE  = VALUE.BK
    D.LOGICAL.OPERANDS = OPERAND.BK
    D.FIELDS           = FIELDS.BK

    CALL REDO.APAP.E.NOF.PAYMENT.DYNAMIC.RPT.GET(Y.AGE.AA.IDS,Y.OUT.ARRAY)

  END ELSE
    ENQ.ERROR = 'No records selected after the AGING selection'
    GOSUB END1
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
PRIMARY.SELECTION:
*--------------------------------------------------------------------------------------------------------

  Y.PRIM.SEL.FIELDS = 'CO.CODE':FM:'PRODUCT':FM:'PRODUCT.GROUP'
  Y.PRIM.SEL.CNT    = DCOUNT(Y.PRIM.SEL.FIELDS,FM)
  Y.VAR1 = 1
  LOOP
  WHILE Y.VAR1 LE Y.PRIM.SEL.CNT
    LOCATE Y.PRIM.SEL.FIELDS<Y.VAR1> IN FIELDS.BK<1> SETTING POS1 THEN
      D.RANGE.AND.VALUE<-1>  = VALUE.BK<POS1>
      D.LOGICAL.OPERANDS<-1> = OPERAND.BK<POS1>
      D.FIELDS<-1>           = FIELDS.BK<POS1>
    END
    Y.VAR1++
  REPEAT

  LOCATE 'ARR.STATUS' IN FIELDS.BK<1> SETTING POS1 THEN
    D.RANGE.AND.VALUE<-1>  = VALUE.BK<POS1>
    D.LOGICAL.OPERANDS<-1> = OPERAND.BK<POS1>
    D.FIELDS<-1>           = FIELDS.BK<POS1>
  END ELSE
    D.RANGE.AND.VALUE<-1>  = 'CURRENT':SM:'EXPIRED'
    D.LOGICAL.OPERANDS<-1> =  1
    D.FIELDS<-1>           = 'ARR.STATUS'
  END
  D.RANGE.AND.VALUE<-1>      = 'LENDING'
  D.LOGICAL.OPERANDS<-1>     = 1
  D.FIELDS<-1>               = 'PRODUCT.LINE'

  CALL REDO.E.FORM.SEL.STMT(FN.AA.ARRANGEMENT, '', '', SEL.AA.PRIM.CMD)
  CALL EB.READLIST(SEL.AA.PRIM.CMD,AA.PRIM.IDS,'',NO.OF.REC,SEL.ERR)

  GOSUB CHECK.DIRECT.DEBIT    ;* This report should select only the loans with has direct debit payment mode.
  RETURN
*-------------------------------------------------------------------------------
CHECK.DIRECT.DEBIT:
*-------------------------------------------------------------------------------
* This can be changed to refer the table - REDO.DIRECT.DEBIT.ACCOUNTS.

  Y.DD.AA.PRIM.IDS=AA.PRIM.IDS
  AA.PRIM.IDS = ''
  Y.DD.CNT = DCOUNT(Y.DD.AA.PRIM.IDS,FM)
  Y.DD.VAR = 1
  LOOP
  WHILE Y.DD.VAR LE Y.DD.CNT
    Y.AA.ID = Y.DD.AA.PRIM.IDS<Y.DD.VAR>
    R.PAYSCH.CONDITION = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,"","PAYMENT.SCHEDULE","",R.PAYSCH.CONDITION,"")
    Y.PAY.METHOD = R.PAYSCH.CONDITION<AA.PS.LOCAL.REF,POS.L.AA.PAY.METHD>
    IF Y.PAY.METHOD EQ 'Direct Debit' THEN
      AA.PRIM.IDS<-1> = Y.AA.ID
    END
    Y.DD.VAR++
  REPEAT

  RETURN
*-------------------------------------------------------------------------------
GET.SELECTION.VALUES:
*-------------------------------------------------------------------------------

  LOCATE 'DOM.DATE' IN FIELDS.BK<1> SETTING POS1 THEN
    Y.FIELD    = FIELDS.BK<POS1>
    Y.VALUE    = VALUE.BK<POS1>
    Y.OPERATOR = OPERAND.BK<POS1>
    GOSUB DO.SELECTION.VALIDATION
    Y.DOM.FIELD    = Y.FIELD
    Y.DOM.VALUE    = Y.VALUE
    Y.DOM.OPERATOR = Y.OPERATOR
  END
  LOCATE 'DUE.DATE' IN FIELDS.BK<1> SETTING POS1 THEN
    Y.FIELD    = FIELDS.BK<POS1>
    Y.VALUE    = VALUE.BK<POS1>
    Y.OPERATOR = OPERAND.BK<POS1>
    GOSUB DO.SELECTION.VALIDATION
    Y.DUE.DATE.FIELD    = Y.FIELD
    Y.DUE.DATE.VALUE    = Y.VALUE
    Y.DUE.DATE.OPERATOR = Y.OPERATOR
  END
  LOCATE 'DELAYED.BILLS.CNT' IN FIELDS.BK SETTING POS1 THEN
    Y.FIELD    = FIELDS.BK<POS1>
    Y.VALUE    = VALUE.BK<POS1>
    Y.OPERATOR = OPERAND.BK<POS1>
    GOSUB VAL.DELAYED.BILL.CNT
    Y.DELAY.BILL.FIELD    = Y.FIELD
    Y.DELAY.BILL.VALUE    = Y.VALUE
    Y.DELAY.BILL.OPERATOR = Y.OPERATOR
  END


  RETURN
*-------------------------------------------------------------------------------
DO.SELECTION.VALIDATION:
*-------------------------------------------------------------------------------

  IF Y.OPERATOR EQ 1 THEN
    IF DCOUNT(Y.VALUE,SM) GT 1 THEN
      ENQ.ERROR = "Only one value allowed for this operand - ":Y.FIELD
      GOSUB END1
    END
  END
  IF Y.OPERATOR EQ 2 THEN
    IF DCOUNT(Y.VALUE,SM) NE 2 THEN
      ENQ.ERROR = "Two values needs to be entered for this operand - ":Y.FIELD
      GOSUB END1
    END
  END

  RETURN
*--------------------------------------------------------------
VAL.DELAYED.BILL.CNT:
*--------------------------------------------------------------
  IF NOT (ISDIGIT(Y.VALUE)) THEN
    ENQ.ERROR = "ERROR EL CRITERIO PARA Cant. Cuotas Atraso DEBE SER NUMERICO"
    GOSUB END1
  END
  IF Y.OPERATOR EQ '3' OR Y.OPERATOR EQ '8' AND Y.VALUE LE 0 THEN
    ENQ.ERROR="ERROR EN EL CRITERIO DE FILTRO PARA CANT. CUOTAS ATRASO "
    GOSUB END1
  END
  IF Y.VALUE LT 1 THEN
    ENQ.ERROR="ERROR EL CRITERIO PARA Cant. Cuotas Atraso DEBE SER NUMERICO POSITIVO"
    GOSUB END1
  END
  RETURN
*--------------------------------------------------------------------------------
DO.DOM.DATE.SELECTION:
*--------------------------------------------------------------------------------

  BEGIN CASE
  CASE Y.DOM.FIELD EQ '' AND Y.DUE.DATE.FIELD EQ ''
    Y.DOM.AA.IDS = AA.PRIM.IDS
    RETURN
  CASE Y.DOM.FIELD EQ '' AND Y.DUE.DATE.FIELD NE ''
    GOSUB DO.DUE.DATE.SELECTION
  CASE Y.DOM.FIELD NE '' AND Y.DUE.DATE.FIELD EQ ''
    GOSUB DO.DOM.SELECTION
  CASE Y.DOM.FIELD NE '' AND Y.DUE.DATE.FIELD NE ''
    GOSUB DO.DOM.DUE.DATE.SELECTION
  END CASE
  RETURN
*----------------------------------------------------------------
DO.DUE.DATE.SELECTION:
*----------------------------------------------------------------
  Y.DOM.VAR = 1
  LOOP
  WHILE Y.DOM.VAR LE NO.OF.REC
    Y.DUE.FLAG = ''
    Y.AA.ID = AA.PRIM.IDS<Y.DOM.VAR>
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACC.ERR)
    GOSUB CHECK.DUE
    IF Y.DUE.FLAG EQ 'YES' THEN
      Y.DOM.AA.IDS<-1> = Y.AA.ID
    END

    Y.DOM.VAR++
  REPEAT
  RETURN
*----------------------------------------------------------------
DO.DOM.SELECTION:
*----------------------------------------------------------------

  Y.DOM.VAR = 1
  LOOP
  WHILE Y.DOM.VAR LE NO.OF.REC
    Y.DOM.FLAG = ''
    Y.AA.ID = AA.PRIM.IDS<Y.DOM.VAR>

*CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACC.ERR)
    GOSUB CHECK.DOM
    IF Y.DOM.FLAG EQ 'YES' THEN
      Y.DOM.AA.IDS<-1> = Y.AA.ID
    END

    Y.DOM.VAR++
  REPEAT
  RETURN
*----------------------------------------------------------------
DO.DOM.DUE.DATE.SELECTION:
*----------------------------------------------------------------

  Y.DOM.VAR = 1
  LOOP
  WHILE Y.DOM.VAR LE NO.OF.REC
    Y.DOM.FLAG = ''
    Y.DUE.FLAG = ''
    Y.AA.ID = AA.PRIM.IDS<Y.DOM.VAR>
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACC.ERR)
    GOSUB CHECK.DOM
    GOSUB CHECK.DUE
    IF Y.DOM.FLAG EQ 'YES' AND Y.DUE.FLAG EQ 'YES' THEN
      Y.DOM.AA.IDS<-1> = Y.AA.ID
    END

    Y.DOM.VAR++
  REPEAT

  RETURN
*--------------------------------------------------------------------------------
CHECK.DOM:
*--------------------------------------------------------------------------------
*Y.VALUE.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.VALUE.DATE>

  CALL F.READ(FN.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,Y.AA.ID,R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,F.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,CNCT.ERR)
  IF R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS THEN
    Y.DOM.CNT = DCOUNT(R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS<1>,VM)

    LOOP
    WHILE Y.DOM.CNT GE 1
      Y.AAAA.ID = R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS<1,Y.DOM.CNT>
      CALL F.READ(FN.AAA,Y.AAAA.ID,R.AAAA,F.AAA,AAA.ERR)
      IF R.AAAA THEN
              Y.VALUE.DATE = R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS<2,Y.DOM.CNT>
        Y.DOM.CNT = 0         ;* Break
      END
      Y.DOM.CNT--
    REPEAT
  END ELSE
    RETURN
  END
  IF Y.DOM.OPERATOR EQ 1 THEN ;* In case of EQ operand
    IF Y.VALUE.DATE EQ Y.DOM.VALUE THEN
      Y.DOM.FLAG = 'YES'
    END
  END
  IF Y.DOM.OPERATOR EQ 2 THEN ;* In case of RG operand
    IF Y.VALUE.DATE GE Y.DOM.VALUE<1,1,1> AND Y.VALUE.DATE LE Y.DOM.VALUE<1,1,2> THEN
      Y.DOM.FLAG = 'YES'
    END
  END

  RETURN
*--------------------------------------------------------------------------------
CHECK.DUE:
*--------------------------------------------------------------------------------

  Y.DUE.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE>
  CHANGE SM TO FM IN Y.DUE.DATE
  CHANGE VM TO FM IN Y.DUE.DATE

  IF Y.DUE.DATE.OPERATOR EQ 1 THEN      ;* In case of EQ operand
    LOCATE Y.DUE.DATE.VALUE IN Y.DUE.DATE SETTING POS.DUE THEN
      Y.DUE.FLAG = 'YES'
    END
  END
  IF Y.DUE.DATE.OPERATOR EQ 2 THEN      ;* In case of RG operand
    Y.FIRST.DUE.DATE = Y.DUE.DATE<1>
    Y.LAST.DUE.DATE  = Y.DUE.DATE<DCOUNT(Y.DUE.DATE,FM)>
    IF (Y.FIRST.DUE.DATE GE Y.DUE.DATE.VALUE<1,1,1> AND Y.FIRST.DUE.DATE LE Y.DUE.DATE.VALUE<1,1,2>) OR (Y.LAST.DUE.DATE GE Y.DUE.DATE.VALUE<1,1,1> AND Y.LAST.DUE.DATE LE Y.DUE.DATE.VALUE<1,1,2>) THEN
* Either first or late due date of the loan should fall on the range
      Y.DUE.FLAG = 'YES'
    END
  END
  RETURN
*--------------------------------------------------------------------------------
DO.CUSTOMER.SELECTION:
*--------------------------------------------------------------------------------
  Y.CUS.AA.IDS  = ''
  LOCATE 'CAMP.TYPE' IN FIELDS.BK<1> SETTING POS1 THEN
    Y.CAMP.FIELD   = FIELDS.BK<POS1>
    Y.CAMP.OPERAND = OPERAND.BK<POS1>
    Y.CAMP.VALUE   = VALUE.BK<POS1>
  END
  LOCATE 'AFF.COMP' IN FIELDS.BK<1> SETTING POS1 THEN
    Y.AFF.FIELD   = FIELDS.BK<POS1>
    Y.AFF.OPERAND = OPERAND.BK<POS1>
    Y.AFF.VALUE   = VALUE.BK<POS1>
  END
  BEGIN CASE
  CASE Y.CAMP.FIELD EQ '' AND Y.AFF.FIELD EQ ''
    Y.CUS.AA.IDS = Y.DOM.AA.IDS
  CASE Y.CAMP.FIELD EQ '' AND Y.AFF.FIELD NE ''
    GOSUB CHECK.AFF.COMP.ALONE
  CASE Y.CAMP.FIELD NE '' AND Y.AFF.FIELD EQ ''
    GOSUB CHECK.CAMP.TYPE.ALONE
  CASE Y.CAMP.FIELD NE '' AND Y.AFF.FIELD NE ''
    GOSUB CHECK.CAMP.AFF.TOGETHER
  END CASE

  RETURN
*-----------------------------------------------------
CHECK.AFF.COMP.ALONE:
*-----------------------------------------------------

  Y.DOM.AA.CNT = DCOUNT(Y.DOM.AA.IDS,FM)
  Y.CUS.VAR = 1
  LOOP
  WHILE Y.CUS.VAR LE Y.DOM.AA.CNT
    Y.AA.ID = Y.DOM.AA.IDS<Y.CUS.VAR>
    GOSUB GET.CUSTOMER.CONDITION
    IF Y.CUS.AFF.COMP EQ Y.AFF.VALUE THEN
      Y.CUS.AA.IDS<-1> = Y.AA.ID
    END
    Y.CUS.VAR++
  REPEAT

  RETURN
*-----------------------------------------------------
CHECK.CAMP.TYPE.ALONE:
*-----------------------------------------------------

  Y.DOM.AA.CNT = DCOUNT(Y.DOM.AA.IDS,FM)
  Y.CUS.VAR = 1
  LOOP
  WHILE Y.CUS.VAR LE Y.DOM.AA.CNT
    Y.AA.ID = Y.DOM.AA.IDS<Y.CUS.VAR>
    GOSUB GET.CUSTOMER.CONDITION
    IF Y.CUS.CAMP.TYPE EQ Y.CAMP.VALUE THEN
      Y.CUS.AA.IDS<-1> = Y.AA.ID
    END
    Y.CUS.VAR++
  REPEAT
  RETURN
*-----------------------------------------------------
CHECK.CAMP.AFF.TOGETHER:
*-----------------------------------------------------

  Y.DOM.AA.CNT = DCOUNT(Y.DOM.AA.IDS,FM)
  Y.CUS.VAR = 1
  LOOP
  WHILE Y.CUS.VAR LE Y.DOM.AA.CNT
    Y.AA.ID = Y.DOM.AA.IDS<Y.CUS.VAR>
    GOSUB GET.CUSTOMER.CONDITION
    IF Y.CUS.CAMP.TYPE EQ Y.CAMP.VALUE AND Y.CUS.AFF.COMP EQ Y.AFF.VALUE THEN
      Y.CUS.AA.IDS<-1> = Y.AA.ID
    END
    Y.CUS.VAR++
  REPEAT
  RETURN
*-----------------------------------------------------
GET.CUSTOMER.CONDITION:
*-----------------------------------------------------
  EFF.DATE        = ''
  PROP.CLASS      = 'CUSTOMER'
  PROPERTY        = ''
  R.CONDITION.CUS = ''
  ERR.MSG = ''
  CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CUS,ERR.MSG)
  Y.CUS.AFF.COMP  = R.CONDITION.CUS<AA.CUS.LOCAL.REF,POS.L.AA.AFF.COM>
  Y.CUS.CAMP.TYPE = R.CONDITION.CUS<AA.CUS.LOCAL.REF,POS.L.AA.CAMP.TY>
  RETURN
*-----------------------------------------------------
DO.OVERDUE.SELECTION:
*-----------------------------------------------------
  Y.AGE.AA.IDS = ''
  LOCATE 'LOAN.STATUS' IN FIELDS.BK<1> SETTING POS1 THEN
    Y.LOAN.STATUS.FIELD   = FIELDS.BK<POS1>
    Y.LOAN.STATUS.OPERAND = OPERAND.BK<POS1>
    Y.LOAN.STATUS.VALUE   = VALUE.BK<POS1>
  END
  LOCATE 'AGING.STATUS' IN FIELDS.BK<1> SETTING POS1 THEN
    Y.AGING.STATUS.FIELD   = FIELDS.BK<POS1>
    Y.AGING.STATUS.OPERAND = OPERAND.BK<POS1>
    Y.AGING.STATUS.VALUE   = VALUE.BK<POS1>
  END
  BEGIN CASE
  CASE Y.LOAN.STATUS.FIELD EQ '' AND Y.AGING.STATUS.FIELD EQ ''
    Y.AGE.AA.IDS = Y.CUS.AA.IDS
  CASE Y.LOAN.STATUS.FIELD EQ '' AND Y.AGING.STATUS.FIELD NE ''
    GOSUB CHECK.AGING.STATUS
  CASE Y.LOAN.STATUS.FIELD NE '' AND Y.AGING.STATUS.FIELD EQ ''
    GOSUB CHECK.LOAN.STATUS
  CASE Y.LOAN.STATUS.FIELD NE '' AND Y.AGING.STATUS.FIELD NE ''
    GOSUB CHECK.LOAN.AGING.STATUS
  END CASE
  RETURN
*----------------------------------------------------------
CHECK.AGING.STATUS:
*----------------------------------------------------------
  Y.AGE.VAR = 1
  Y.AGE.AA.CNT = DCOUNT(Y.CUS.AA.IDS,FM)
  LOOP
  WHILE Y.AGE.VAR LE Y.AGE.AA.CNT
    Y.AA.ID = Y.CUS.AA.IDS<Y.AGE.VAR>
    IN.ACC.ID  = ''
    Y.LOAN.ACC = ''
    CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,Y.AA.ID,Y.LOAN.ACC,ERR.TEXT)
    CALL F.READ(FN.ACCOUNT,Y.LOAN.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT<AC.LOCAL.REF,POS.L.OD.STATUS> EQ Y.AGING.STATUS.VALUE THEN
      Y.AGE.AA.IDS<-1> = Y.AA.ID
    END
    Y.AGE.VAR++
  REPEAT
  RETURN
*----------------------------------------------------------
CHECK.LOAN.STATUS:
*----------------------------------------------------------

  Y.AGE.VAR = 1
  Y.AGE.AA.CNT = DCOUNT(Y.CUS.AA.IDS,FM)
  LOOP
  WHILE Y.AGE.VAR LE Y.AGE.AA.CNT
    Y.AA.ID = Y.CUS.AA.IDS<Y.AGE.VAR>
    GOSUB GET.OVERDUE.COND
    IF Y.AA.LOAN.STATUS EQ Y.LOAN.STATUS.VALUE THEN
      Y.AGE.AA.IDS<-1> = Y.AA.ID
    END
    Y.AGE.VAR++
  REPEAT
  RETURN
*----------------------------------------------------------
CHECK.LOAN.AGING.STATUS:
*----------------------------------------------------------

  Y.AGE.VAR = 1
  Y.AGE.AA.CNT = DCOUNT(Y.CUS.AA.IDS,FM)
  LOOP
  WHILE Y.AGE.VAR LE Y.AGE.AA.CNT
    Y.AA.ID = Y.CUS.AA.IDS<Y.AGE.VAR>
    IN.ACC.ID  = ''
    Y.LOAN.ACC = ''
    CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,Y.AA.ID,Y.LOAN.ACC,ERR.TEXT)
    CALL F.READ(FN.ACCOUNT,Y.LOAN.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    GOSUB GET.OVERDUE.COND
    IF R.ACCOUNT<AC.LOCAL.REF,POS.L.OD.STATUS> EQ Y.AGING.STATUS.VALUE AND Y.AA.LOAN.STATUS EQ Y.LOAN.STATUS.VALUE THEN
      Y.AGE.AA.IDS<-1> = Y.AA.ID
    END
    Y.AGE.VAR++
  REPEAT

  RETURN
*----------------------------------------------------------
GET.OVERDUE.COND:
*----------------------------------------------------------
  EFF.DATE        = ''
  PROP.CLASS      = 'OVERDUE'
  PROPERTY        = ''
  R.CONDITION.OVERDUE = ''
  ERR.MSG = ''
  CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
  Y.AA.LOAN.STATUS = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1,1>

  RETURN
*--------------------------------------------------------------------------------
END1:
END
