*-----------------------------------------------------------------------------
* <Rating>-64</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOFILE.AI.DROP.DOWN.ENQ.LN.SRC(FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name : REDO.NOFILE.AI.DROP.DOWN.ENQ
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry REDO.SAV.ACCOUNT.LIST
* Linked with : Enquiry REDO.SAV.ACCOUNT.LIST  as BUILD routine
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*01/11/11       PACS00146410            PRABHU N                MODIFICAION
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.CATEGORY
$INSERT I_F.RELATION.CUSTOMER
$INSERT I_F.AI.REDO.ARCIB.PARAMETER
$INSERT I_F.AI.REDO.ARCIB.ALIAS.TABLE
$INSERT I_F.FT.TXN.TYPE.CONDITION
$INSERT I_F.FT.COMMISSION.TYPE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER
$INSERT I_F.REDO.APAP.STO.DUPLICATE

  GOSUB INITIALISE
  GOSUB FORM.ACCT.ARRAY

  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
  FN.RELATION.CUSTOMER = 'F.RELATION.CUSTOMER'
  F.RELATION.CUSTOMER  = ''
  CALL OPF(FN.RELATION.CUSTOMER,F.RELATION.CUSTOMER)

  F.CUSTOMER.ACCOUNT = ''
  FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'

  CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
  FN.ACC = 'F.ACCOUNT'
  F.ACC = ''
  CALL OPF(FN.ACC,F.ACC)


  FN.AZ = 'F.AZ.ACCOUNT'
  F.AZ = ''
  CALL OPF(FN.AZ,F.AZ)

  FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
  F.JOINT.CONTRACTS.XREF  = ''
  CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

  Y.VAR.EXT.CUSTOMER = ''
  Y.VAR.EXT.ACCOUNTS=''
  FN.CATEGORY = "F.CATEGORY"
  F.CATEGORY = ''
  FN.AI.REDO.ARC.PARAM='F.AI.REDO.ARCIB.PARAMETER'
  FN.AI.REDO.ACCT.RESTRICT.PARAMETER = 'F.AI.REDO.ACCT.RESTRICT.PARAMETER'
  CALL OPF(FN.CATEGORY,F.CATEGORY)

  Y.FIELD.COUNT = ''
  ACCT.REC = ''
  LOAN.FLG = ''
  DEP.FLG = ''
  AZ.REC = ''
  R.ACC = ''
  FIN.ARR = ''
  LREF.APP='ACCOUNT'
  LREF.FIELDS='L.AC.STATUS1':VM:'L.AC.AV.BAL':VM:'L.AC.NOTIFY.1':VM:'L.AC.STATUS2'
  LREF.POS = ''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
  ACCT.STATUS.POS=LREF.POS<1,1>
  ACCT.OUT.BAL.POS=LREF.POS<1,2>
  NOTIFY.POS = LREF.POS<1,3>
  Y.ACCT.STATUS2.POS=LREF.POS<1,4>

  CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
  
  LOCATE "CREDIT.AMT" IN D.FIELDS SETTING CR.AMT.POS THEN
    Y.CR.AMOUNT = D.RANGE.AND.VALUE<CR.AMT.POS>
  END

*---PACS00126008-----------------------------------
  FN.FTTC='F.FT.TXN.TYPE.CONDITION'
  F.FTTC =''
  CALL OPF(FN.FTTC,F.FTTC)
  Y.BILL.DUE.LIST=System.getVariable('CURRENT.BILL.AMT')
  
  FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
  F.FT.COMMISSION.TYPE =''
  CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
*---PACSS00126008-END--------------------------------
  RETURN
******************
FORM.ACCT.ARRAY:
*****************

  CALL CACHE.READ(FN.AI.REDO.ARC.PARAM,'SYSTEM',R.AI.REDO.ARC.PARAM,PARAM.ERR)
  CALL CACHE.READ(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,'SYSTEM',R.AI.REDO.ACCT.RESTRICT.PARAMETER,RES.ERR)
  LIST.ACCT.TYPE=R.AI.REDO.ARC.PARAM<AI.PARAM.ACCOUNT.TYPE>
  Y.RESTRICT.ACCT.TYPE = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.RESTRICT.ACCT.TYPE>
  CHANGE VM TO FM IN Y.RESTRICT.ACCT.TYPE

  CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.ID,ACCT.REC,F.CUSTOMER.ACCOUNT,CUST.ERR)
  GOSUB MINOR.CUST.PARA
  GOSUB GET.MIN.ACCT.BAL.REQ
  LOOP
    REMOVE ACCT.ID FROM ACCT.REC SETTING ACCT.POS
  WHILE ACCT.ID:ACCT.POS

    ACC.ERR= ''
    CHECK.CATEG=''
    SAV.FLG=''
    CURR.FLG=''
    Y.FLAG = ''
    CUR.ACCT.STATUS1 = ''
    AC.NOFITY.STATUS = ''
    Y.POSTING.RESTRICT = ''
    Y.LAST.BILL.AMT = ''
    CUR.ACCT.STATUS2 = ''
    ACCT.BAL = ''
    CALL F.READ(FN.ACC,ACCT.ID,R.ACC,F.ACC,ACC.ERR)
    AC.NOFITY.STATUS = R.ACC<AC.LOCAL.REF><1,NOTIFY.POS>
    CUR.ACCT.STATUS1 =R.ACC<AC.LOCAL.REF><1,ACCT.STATUS.POS>
    ACCT.BAL      = R.ACC<AC.LOCAL.REF><1,ACCT.OUT.BAL.POS>
    CUR.ACCT.STATUS2 = R.ACC<AC.LOCAL.REF><1,Y.ACCT.STATUS2.POS>
    CHECK.CATEG = R.ACC<AC.CATEGORY>
    CUR.ACCT.CUSTOMER = R.ACC<AC.CUSTOMER>
    Y.POSTING.RESTRICT= R.ACC<AC.POSTING.RESTRICT>

    CHANGE SM TO FM IN CUR.ACCT.STATUS2
    CHANGE SM TO FM IN AC.NOFITY.STATUS

    LOCATE 'DEBIT' IN Y.RESTRICT.ACCT.TYPE SETTING RES.ACCT.POS THEN
      GOSUB STATUS.RESTRICTION.PARA
      GOSUB NOTIFY.RESTRICTION.PARA
      GOSUB POSTING.RESTRICTION.PARA
      GOSUB RELATION.PARA
    END

    GOSUB ACCT.CATEG.PARA
    GOSUB CONTINUE.CONDITION

  REPEAT

  RETURN
*----------------*
MINOR.CUST.PARA:
*----------------*

  CALL F.READ(FN.JOINT.CONTRACTS.XREF,CUSTOMER.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,JNT.XREF.ERR)
  ACCT.REC<-1> = R.JOINT.CONTRACTS.XREF

  RETURN
************************
CONTINUE.CONDITION:
************************

  Y.LAST.BILL.AMT =System.getVariable('CURRENT.ARR.AMT')
  Y.LOOP.CONTINUE=''
*    IF NUM(Y.LAST.BILL.AMT) THEN
*        DEAL.AMOUNT=Y.LAST.BILL.AMT
*        GOSUB GET.MIN.ACCT.BAL.REQ
*        IF ACCT.BAL LT Y.REQ.MIN.AMT OR Y.FLAG THEN
*            Y.LOOP.CONTINUE=1
*        END
*    END

*    IF NUM(Y.BILL.DUE.LIST) THEN
*        IF ACCT.BAL LT Y.BILL.DUE.LIST OR Y.FLAG THEN
*           Y.LOOP.CONTINUE=1
*        END
*    END



  IF Y.FLAG THEN
    Y.LOOP.CONTINUE=1
  END

  CHANGE ',' TO '' IN Y.CR.AMOUNT

  IF NUM(Y.CR.AMOUNT) THEN
    IF ACCT.BAL LT Y.CR.AMOUNT THEN
      Y.LOOP.CONTINUE=1
    END
  END

*    Y.DEBIT.ACCT.AMT = System.getVariable('CURRENT.ARC.AMT')
*
*    IF NUM(Y.DEBIT.ACCT.AMT) THEN
*        DEAL.AMOUNT=Y.DEBIT.ACCT.AMT
*        GOSUB GET.MIN.ACCT.BAL.REQ
*        IF ACCT.BAL LT Y.REQ.MIN.AMT OR Y.FLAG THEN
*            Y.LOOP.CONTINUE=1
*        END
*    END


  IF NOT(Y.LOOP.CONTINUE) THEN

    GOSUB LOCATE.CURR.ACC
    GOSUB LOCATE.SAV.ACC
    GOSUB CHECK.STATUS.SUB

  END

  RETURN
************************
STATUS.RESTRICTION.PARA:
************************
  IF CUR.ACCT.STATUS1 THEN
    CUR.ACCT.STATUS = CUR.ACCT.STATUS1
  END ELSE
    Y.FLAG = 1
    RETURN
  END
  IF CUR.ACCT.STATUS2 THEN
    CUR.ACCT.STATUS = CUR.ACCT.STATUS2
  END
  IF CUR.ACCT.STATUS1 AND CUR.ACCT.STATUS2 THEN
    CUR.ACCT.STATUS = CUR.ACCT.STATUS1:FM:CUR.ACCT.STATUS2
  END

  Y.CNT.STATUS = DCOUNT(CUR.ACCT.STATUS,FM)
  IF Y.CNT.STATUS GE 1 THEN
    Y.INT.STATUS.CNT = 1
    LOOP
    WHILE Y.INT.STATUS.CNT LE Y.CNT.STATUS
      Y.STATUS2 = CUR.ACCT.STATUS<Y.INT.STATUS.CNT>
      Y.RESTRICT.STATUS = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.ACCT.STATUS,RES.ACCT.POS>
      CHANGE SM TO FM IN Y.RESTRICT.STATUS
      LOCATE Y.STATUS2 IN Y.RESTRICT.STATUS SETTING RES.STATUS.POS THEN
        Y.FLAG = 1
        RETURN
      END
      Y.INT.STATUS.CNT++
    REPEAT
  END



  RETURN
************************
NOTIFY.RESTRICTION.PARA:
************************

  Y.CNT.NOTIFY = DCOUNT(AC.NOFITY.STATUS,FM)
  IF Y.CNT.NOTIFY GE 1 THEN
    Y.INT.NOTIFY.CNT = 1
    LOOP
    WHILE Y.INT.NOTIFY.CNT LE Y.CNT.NOTIFY
      Y.NOTIFY = AC.NOFITY.STATUS<Y.INT.NOTIFY.CNT>
      Y.RESTRICT.NOTIFY = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.ACCT.NOTIFY.1,RES.ACCT.POS>
      CHANGE SM TO FM IN Y.RESTRICT.NOTIFY
      LOCATE Y.NOTIFY IN Y.RESTRICT.NOTIFY SETTING RES.NOTIFY.POS THEN
        Y.FLAG = 1
        RETURN
      END
      Y.INT.NOTIFY.CNT++
    REPEAT
  END

  RETURN
*************************
POSTING.RESTRICTION.PARA:
*************************
  Y.RESTRICT.ACCT.POSTING = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.POSTING.RESTRICT,RES.ACCT.POS>
  CHANGE SM TO FM IN Y.RESTRICT.ACCT.POSTING
  IF Y.POSTING.RESTRICT THEN
    LOCATE Y.POSTING.RESTRICT IN Y.RESTRICT.ACCT.POSTING SETTING POSTING.POS THEN
      Y.FLAG = 1
    END
  END

  RETURN
*----------------*
RELATION.PARA:
*----------------*

  Y.RELATION.CODE = R.ACC<AC.RELATION.CODE>
  Y.REL.PARAM = R.AI.REDO.ARC.PARAM<AI.PARAM.RELATION.CODE>
  CHANGE VM TO FM IN Y.REL.PARAM
  IF CUR.ACCT.CUSTOMER NE CUSTOMER.ID THEN
    IF Y.REL.PARAM THEN
      Y.CNT.REL.CODE  = DCOUNT(Y.RELATION.CODE,VM)
      Y.CNT.REL = 1
      LOOP
      WHILE Y.CNT.REL LE Y.CNT.REL.CODE
        Y.REL.CODE = Y.RELATION.CODE<1,Y.CNT.REL>
        LOCATE Y.REL.CODE IN Y.REL.PARAM SETTING Y.REL.POS THEN
          RETURN
        END ELSE
          Y.FLAG = 1
        END
        Y.CNT.REL++
      REPEAT
    END ELSE
      Y.FLAG = 1
    END
  END

  RETURN
*----------------*
ACCT.CATEG.PARA:
*----------------*
  Y.RES.ACCT.CATEG = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.ACCT.CATEGORY>
  CHANGE VM TO FM IN Y.RES.ACCT.CATEG
  LOCATE CHECK.CATEG IN Y.RES.ACCT.CATEG SETTING RES.ACCT.POS THEN
    Y.FLAG = 1
  END
  RETURN
******************
CHECK.STATUS.SUB:
******************
  IF ACCT.BAL GT '0' THEN

    GOSUB CHECK.LOAN.ACC
    GOSUB CHECK.AZ.ACC

    IF  (SAV.FLG EQ '1') OR (CURR.FLG EQ '1') THEN
      FIN.ARR<-1> = ACCT.ID:"@":CUSTOMER.ID
    END
  END
  RETURN

******************
CHECK.LOAN.ACC:
******************

  ARR.ID = R.ACC<AC.ARRANGEMENT.ID>
  IF ARR.ID NE '' THEN

    LOAN.FLG = 1
  END

  RETURN

*******************
CHECK.AZ.ACC:
******************

  CALL F.READ(FN.AZ,ACCT.ID,AZ.REC,F.AZ,AZ.ERR)

  IF AZ.REC THEN
    DEP.FLG = 1

  END
  RETURN
*******************
LOCATE.SAV.ACC:
*****************
  CHANGE VM TO FM IN LIST.ACCT.TYPE
  Y.CNT.CATEG.TYPE  = DCOUNT(LIST.ACCT.TYPE,FM)
  Y.CNT.CAT = 1
  LOOP
  WHILE  Y.CNT.CAT LE Y.CNT.CATEG.TYPE
    Y.CATEG.ID = LIST.ACCT.TYPE<Y.CNT.CAT>
    IF 'SAVINGS' EQ Y.CATEG.ID THEN
      SAV.STR.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,Y.CNT.CAT>
      SAV.END.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,Y.CNT.CAT>
      IF CHECK.CATEG GE SAV.STR.RGE AND CHECK.CATEG LE SAV.END.RGE THEN
        SAV.FLG = 1
        RETURN
      END
    END
    Y.CNT.CAT++
  REPEAT

  RETURN

***************
LOCATE.CURR.ACC:
***************
  CHANGE VM TO FM IN LIST.ACCT.TYPE
  LOCATE 'CURRENT' IN LIST.ACCT.TYPE SETTING SAV.ACCT.POS THEN
    SAV.STR.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.START,SAV.ACCT.POS>
    SAV.END.RGE=R.AI.REDO.ARC.PARAM<AI.PARAM.CATEG.END,SAV.ACCT.POS>
    IF CHECK.CATEG GE SAV.STR.RGE AND CHECK.CATEG LE SAV.END.RGE THEN

      CURR.FLG=1
    END
  END

  RETURN
********************
GET.MIN.ACCT.BAL.REQ:
********************
  Y.FTTC.ID=R.NEW(FT.TRANSACTION.TYPE)
  CALL F.READ(FN.FTTC,Y.FTTC.ID,R.FTTC,F.FTTC,ERR)
  Y.COMMISSION.TYPE.LIST =R.FTTC<FT6.COMM.TYPES>
  CUSTOMER               =''
*    CHANGE '#' TO FM IN Y.BILL.DUE.LIST
*    Y.TOT.BILL      =DCOUNT(Y.BILL.DUE.LIST,FM)
*    Y.ONE.BILL.VALUE=Y.BILL.DUE.LIST<Y.TOT.BILL>
*    DEAL.AMOUNT     =Y.ONE.BILL.VALUE
  DEAL.CURRENCY   =R.NEW(FT.CREDIT.CURRENCY)
  T.DATA<1>       =Y.COMMISSION.TYPE.LIST
  T.DATA<2>       ='COM'
  TOTAL.CHARGE.LOCAL=''
  IF Y.COMMISSION.TYPE.LIST  THEN
    CALL CALCULATE.CHARGE(CUSTOMER, DEAL.AMOUNT, DEAL.CURRENCY, CURRENCY.MARKET, CROSS.RATE, CROSS.CURRENCY, DRAWDOWN.CURRENCY, T.DATA, CUST.CONDITION, TOTAL.CHARGE.LOCAL, TOTAL.CHARGE.FOREIGN)
  END
  Y.REQ.MIN.AMT =DEAL.AMOUNT + TOTAL.CHARGE.LOCAL
  RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
