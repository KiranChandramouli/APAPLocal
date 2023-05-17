*-----------------------------------------------------------------------------
* <Rating>62</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.NOFILE.AZ.SL.REPORT.NO(Y.OUT.ARRAY)

*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOFILE.AZ.SL.REPORT.NO
*--------------------------------------------------------------------------------------------------------
*Description       : This is a NO-FILE enquiry routine, the routine based on the selection criteria selects
*                    the records from REDO.H.DEPOSIT.RECEIPTS and AZ.ACCOUNT and displays the processed records
*Linked With       : Enquiry REDO.APAP.NOF.SERIES.REPORT.NO
*In  Parameter     : N/A
*Out Parameter     : Y.OUT.ARRAY
*Files  Used       : AZ.ACCOUNT                 As              I               Mode
*                    ACCOUNT                    As              I               Mode
*                    CUSTOMER                   As              I               Mode
*                    RELATION                   As              I               Mode
*                    REDO.H.DEPOSIT.RECEIPTS    As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 13 August 2010       Shiva Prasad Y      ODR-2010-03-0158 103         Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.RELATION
$INSERT I_F.REDO.H.DEPOSIT.RECEIPTS
$INSERT I_F.REDO.L.SERIES.CHANGE.DETS

*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

  GOSUB OPEN.PARA

  GOSUB PROCESS.PARA

*    GOSUB SORT.OUT.ARRAY
  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.RELATION = 'F.RELATION'
  F.RELATION = ''
  CALL OPF(FN.RELATION,F.RELATION)

  FN.REDO.H.DEPOSIT.RECEIPTS = 'F.REDO.H.DEPOSIT.RECEIPTS'
  F.REDO.H.DEPOSIT.RECEIPTS = ''
  CALL OPF(FN.REDO.H.DEPOSIT.RECEIPTS,F.REDO.H.DEPOSIT.RECEIPTS)

  FN.REDO.L.SERIES.CHANGE.DETS = 'F.REDO.L.SERIES.CHANGE.DETS'
  F.REDO.L.SERIES.CHANGE.DETS = ''
  CALL OPF(FN.REDO.L.SERIES.CHANGE.DETS, F.REDO.L.SERIES.CHANGE.DETS)

  FN.REDO.T.CANC.DEP.RECEIPTS = 'F.REDO.T.CANC.DEP.RECEIPTS'
  F.REDO.T.CANC.DEP.RECEIPTS = ''
  CALL OPF(FN.REDO.T.CANC.DEP.RECEIPTS, F.REDO.T.CANC.DEP.RECEIPTS)

  FN.AZ.ACCOUNT$HIS = 'F.AZ.ACCOUNT$HIS'
  F.AZ.ACCOUNT$HIS = ''
  CALL OPF(FN.AZ.ACCOUNT$HIS, F.AZ.ACCOUNT$HIS)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
  GOSUB SELECT.PROCESS

  IF R.SEL.LIST THEN
    GOSUB PROCESS
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
******************
SELECT.PROCESS:
******************


  LOCATE 'SERIES.CANCEL.DATE' IN D.FIELDS<1> SETTING Y.CANCEL.POS THEN
    Y.CANCEL.DATE = D.RANGE.AND.VALUE<Y.CANCEL.POS>
    Y.SEL.CAN.DATE = D.RANGE.AND.VALUE<Y.CANCEL.POS>

    IF INDEX(Y.CANCEL.DATE, SM, 1) THEN
      Y.CANCEL.ST.DATE = FIELD(Y.CANCEL.DATE, SM, 1)
      Y.CANCEL.END.DATE = FIELD(Y.CANCEL.DATE, SM, 2)
    END

    Y.CANCEL.OPERATOR = D.LOGICAL.OPERANDS<Y.CANCEL.POS>
    IF Y.CANCEL.OPERATOR EQ 1 THEN

      R.CANCEL.ID.LIST = ''
      CALL F.READ(FN.REDO.T.CANC.DEP.RECEIPTS, Y.CANCEL.DATE, R.CANCEL.ID.LIST, F.REDO.T.CANC.DEP.RECEIPTS, Y.READ.ERR)

    END
    IF Y.CANCEL.OPERATOR EQ 2 THEN

      Y.CANC.SEL.CMD = 'SELECT ':FN.REDO.T.CANC.DEP.RECEIPTS:' WITH @ID BETWEEN ':Y.CANCEL.ST.DATE:' AND ':Y.CANCEL.END.DATE
      CALL EB.READLIST(Y.CANC.SEL.CMD, R.CANCEL.ID.LIST, '', '', Y.SEL.ERR)

    END

  END

  LOCATE 'SERIES.ALLOC.DATE' IN D.FIELDS<1> SETTING Y.ASSIGN.POS THEN
    Y.ASSIGN.DATE = D.RANGE.AND.VALUE<Y.ASSIGN.POS>

    IF INDEX(Y.ASSIGN.DATE , SM, 1) THEN
      Y.ASSIGN.ST.DATE = FIELD(Y.ASSIGN.DATE, SM , 1)
      Y.ASSIGN.END.DATE = FIELD(Y.ASSIGN.DATE, SM, 2)
    END

  END

  LOCATE 'INSTRUMENT.TYPE' IN D.FIELDS<1> SETTING Y.INSTRUMENT.POS THEN
    Y.CATEGORY = D.RANGE.AND.VALUE<Y.INSTRUMENT.POS>
  END

  Y.SEL.STR = 'SELECT ':FN.REDO.L.SERIES.CHANGE.DETS

  IF Y.ASSIGN.ST.DATE THEN
    Y.SEL.STR := ' WITH DATE GE ':Y.ASSIGN.ST.DATE:' AND DATE LE ':Y.ASSIGN.END.DATE
  END
  IF Y.ASSIGN.DATE AND NOT(Y.ASSIGN.ST.DATE) THEN
    Y.SEL.STR := ' WITH DATE EQ ':Y.ASSIGN.DATE
  END

  IF NOT(D.RANGE.AND.VALUE) THEN
    Y.SEL.STR = 'SELECT ':FN.REDO.L.SERIES.CHANGE.DETS:' WITH @ID UNLIKE AZ...'
  END

  CALL EB.READLIST(Y.SEL.STR, R.SEL.LIST, '', NO.OF.REC, Y.SEL.ERR)

  IF R.CANCEL.ID.LIST THEN
    R.SEL.LIST := FM:R.CANCEL.ID.LIST
  END


  RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*-------

  LOOP
    Y.DATE= ''
    Y.AGENCY = ''
    Y.INVST.NO = ''
    Y.INVST.TYPE = ''
    Y.CCY = ''
    Y.INVST.NAMES = ''
    Y.BEN = ''
    Y.CLIENT.CODE = ''
    Y.INVST.AMT = ''
    Y.ALLOC.SERAIL.NO = ''
    Y.PREVIOUS.SR.NO = ''
    Y.CANCEL.DATE = ''
    Y.INPUT= ''
    Y.AUTH = ''
    Y.SKIP.FLAG = ''

    REMOVE Y.SERIES.DET.ID FROM R.SEL.LIST SETTING Y.SERIES.DET.POS
  WHILE Y.SERIES.DET.ID:Y.SERIES.DET.POS

    Y.READ.ERR = ''
    R.SERIES.DETS = ''
    CALL F.READ(FN.REDO.L.SERIES.CHANGE.DETS, Y.SERIES.DET.ID, R.SERIES.DETS, F.REDO.L.SERIES.CHANGE.DETS, Y.READ.ERR)

    Y.DATE = FIELD(Y.SERIES.DET.ID, '.', 1)
    Y.DEP.RECEIPT.ID = FIELD(Y.SERIES.DET.ID, '.',2,1)

    Y.READ.ERR = ''
    R.DEPOSIT.RECEIPT = ''
    CALL F.READ(FN.REDO.H.DEPOSITS.RECEIPTS, Y.DEP.RECEIPT.ID, R.DEPOSIT.RECEIPTS, F.REDO.H.DEPOSIT.RECEIPTS, Y.READ.ERR)

    Y.AZ.ID = R.DEPOSIT.RECEIPTS<REDO.DEP.ACCOUNT>

    Y.READ.ERR = ''
    R.AZ.RECORD = ''
    CALL F.READ(FN.AZ.ACCOUNT, Y.AZ.ID, R.AZ.ACCOUNT, F.AZ.ACCOUNT, Y.READ.ERR)

    IF NOT(R.AZ.ACCOUNT) THEN
      Y.READ.ERR = ''
      Y.HIST.ID = Y.AZ.ID:';1'
*            CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT$HIS, Y.HIST.ID, R.AZ.ACCOUNT, Y.READ.ERR)
      CALL F.READ(FN.AZ.ACCOUNT$HIS, Y.HIST.ID, R.AZ.ACCOUNT, F.AZ.ACCOUNT$HIS, Y.READ.ERR)
    END

    IF Y.CATEGORY THEN
      IF  R.AZ.ACCOUNT<AZ.CATEGORY> EQ Y.CATEGORY THEN
        GOSUB GET.AZ.DETAILS
      END ELSE
        Y.SKIP.FLAG = 1
        CONTINUE
      END
    END  ELSE
      GOSUB GET.AZ.DETAILS
    END

*        IF Y.CANCEL.FLAG THEN
*            Y.INVST.NO = ''
*            Y.BEN = ''
*            Y.INVST.NAMES = ''
*        END

    IF NOT(Y.SKIP.FLAG) THEN
      Y.OUT.ARRAY<-1> = Y.DATE:'*': Y.AGENCY:'*': Y.INVST.NO:'*': Y.INVST.TYPE:'*': Y.CCY:'*':Y.INVST.NAMES:'*':Y.BEN:'*': Y.CLIENT.CODE:'*': Y.INVST.AMT:'*': Y.ALLOC.SERAIL.NO:'*': Y.PREVIOUS.SR.NO:'*': Y.CANCEL.DATE:'*': Y.INPUT:'*': Y.AUTH
    END

  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------------------
GET.AZ.DETAILS:
***************

  Y.AGENCY     = R.AZ.ACCOUNT<AZ.CO.CODE>
  Y.INVST.NO   = Y.AZ.ID
  Y.INVST.TYPE = R.AZ.ACCOUNT<AZ.ALL.IN.ONE.PRODUCT>
  Y.CCY        = R.AZ.ACCOUNT<AZ.CURRENCY>

  GOSUB FIND.MULTI.LOCAL.REF
  GOSUB GET.INVST.NAMES

  Y.BEN         = R.AZ.ACCOUNT<AZ.NOMINATED.ACCOUNT>
  Y.INVST.AMT   = R.AZ.ACCOUNT<AZ.PRINCIPAL>

  GOSUB GET.ALLOC.SERIAL.NO

  Y.PREVIOUS.SR.NO = ''

  GOSUB GET.SERIES.CANCEL.DATE

  Y.INPUT = R.DEPOSIT.RECEIPTS<REDO.DEP.INPUTTER>
  Y.AUTH = R.DEPOSIT.RECEIPTS<REDO.DEP.AUTHORISER>

  RETURN
*--------------------------------------------------------------------------------------------------------
****************
GET.INVST.NAMES:
****************
  Y.CLIENT.CODE = R.AZ.ACCOUNT<AZ.CUSTOMER>

  ACCOUNT.ID = Y.AZ.ID
  GOSUB READ.ACCOUNT

  CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
  GOSUB READ.CUSTOMER

  IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'PERSONA FISICA' OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'CLIENTE MENOR' THEN
    Y.CUS.NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
  END

  IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
    Y.CUS.NAMES = R.CUSTOMER<EB.CUS.NAME.1,1>:' ':R.CUSTOMER<EB.CUS.NAME.2,1>
  END

  IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
    Y.CUS.NAMES = R.CUSTOMER<EB.CUS.SHORT.NAME>
  END

  Y.RELATION.COUNT = DCOUNT(R.ACCOUNT<AC.RELATION.CODE>,VM)
  Y.COUNT = 1

  LOOP
  WHILE Y.COUNT LE Y.RELATION.COUNT
    RELATION.ID = R.ACCOUNT<AC.RELATION.CODE,Y.COUNT>
    IF RELATION.ID LT 500 AND RELATION.ID GT 529 THEN
      CONTINUE
    END
    GOSUB READ.RELATION
    Y.REL.DESC  = R.RELATION<EB.REL.DESCRIPTION>
    CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,Y.COUNT>
    GOSUB READ.CUSTOMER

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'PERSONA FISICA' OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'CLIENTE MENOR' THEN
      Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
      Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:' ':R.CUSTOMER<EB.CUS.NAME.2,1>
    END

    IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
      Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
    END

*        Y.CUS.NAMES := VM:Y.REL.DESC:'-': Y.CUS.NAME
    Y.CUS.NAMES := VM:Y.CUS.NAME
    Y.CLIENT.CODE := VM:CUSTOMER.ID

    Y.COUNT += 1
  REPEAT

  Y.CUS.NAMES = CHANGE(Y.CUS.NAMES, VM, '; ')
  Y.CLIENT.CODE = CHANGE(Y.CLIENT.CODE, VM, '; ')
  Y.INVST.NAMES = Y.CUS.NAMES


  RETURN
*--------------------------------------------------------------------------------------------------------
********************
GET.ALLOC.SERIAL.NO:
********************
  Y.ALLOC.SERAIL.NO = R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.RECEIPT.NO.POS>

  IF Y.ALLOC.SERAIL.NO EQ '' THEN
    Y.ALLOC.SERAIL.NO = R.DEPOSIT.RECEIPTS<REDO.DEP.SERIAL.NO>
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
***********************
GET.SERIES.CANCEL.DATE:
***********************

  Y.CANCEL.FLAG = 0
*    LOCATE 'Cancelada' IN R.SERIES.DETS<AZ.CH.DETS.STATUS, 1> SETTING Y.ASIGN.POS THEN
*        Y.CANCEL.FLAG = 1
*        Y.CANCEL.DATE = FIELD(Y.SERIES.DET.ID, '.', 1)
*    END
*    LOCATE 'Destruida' IN R.SERIES.DETS<AZ.CH.DETS.STATUS, 1> SETTING Y.ASIGN.POS THEN
*        Y.CANCEL.FLAG = 1
*        Y.CANCEL.DATE = FIELD(Y.SERIES.DET.ID, '.', 1)
*    END

  Y.STATUS = R.DEPOSIT.RECEIPTS<REDO.DEP.STATUS>

  IF Y.STATUS EQ 'Cancelada' THEN
    Y.CANCEL.FLAG = 1
    Y.CANCEL.DATE = R.DEPOSIT.RECEIPTS<REDO.DEP.DATE.UPDATED>
  END
  IF Y.STATUS EQ 'Destruida' THEN
    Y.CANCEL.FLAG = 1
    Y.CANCEL.DATE = R.DEPOSIT.RECEIPTS<REDO.DEP.DATE.UPDATED>
  END

  IF Y.SEL.CAN.DATE AND Y.CANCEL.DATE THEN
    IF Y.CANCEL.DATE EQ Y.SEL.CAN.DATE THEN
    END ELSE
      Y.SKIP.FLAG = 1
    END
  END
  IF Y.SEL.CAN.DATE AND NOT(Y.CANCEL.DATE) THEN
    Y.SKIP.FLAG = 1
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
****************
READ.AZ.ACCOUNT:
****************
* In this para of the code, file AZ.ACCOUNT is read
  R.AZ.ACCOUNT  = ''
  AZ.ACCOUNT.ER = ''
  CALL F.READ(FN.AZ.ACCOUNT, Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
  R.ACCOUNT  = ''
  ACCOUNT.ER = ''
  CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
**************
READ.CUSTOMER:
**************
* In this para of the code, file CUSTOMER is read
  R.CUSTOMER  = ''
  CUSTOMER.ER = ''
  CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
**************
READ.RELATION:
**************
* In this para of the code, file RELATION is read
  R.RELATION  = ''
  RELATION.ER = ''
  CALL F.READ(FN.RELATION,RELATION.ID,R.RELATION,F.RELATION,RELATION.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
*****************************
READ.REDO.H.DEPOSIT.RECEIPTS:
*****************************
* In this para of the code, file REDO.H.DEPOSIT.RECEIPTS is read
  R.REDO.H.DEPOSIT.RECEIPTS  = ''
  REDO.H.DEPOSIT.RECEIPTS.ER = ''
  CALL F.READ(FN.REDO.H.DEPOSIT.RECEIPTS,REDO.H.DEPOSIT.RECEIPTS.ID,R.REDO.H.DEPOSIT.RECEIPTS,F.REDO.H.DEPOSIT.RECEIPTS,REDO.H.DEPOSIT.RECEIPTS.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
  APPL.ARRAY = 'AZ.ACCOUNT':FM:'CUSTOMER'
  FLD.ARRAY  = 'L.AZ.RECEIPT.NO':FM:'L.CU.TIPO.CL'
  FLD.POS    = ''

  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

  LOC.L.AZ.RECEIPT.NO.POS = FLD.POS<1,1>
  LOC.L.CU.TIPO.CL.POS    = FLD.POS<2,1>

  RETURN
*--------------------------------------------------------------------------------------------------------
END
