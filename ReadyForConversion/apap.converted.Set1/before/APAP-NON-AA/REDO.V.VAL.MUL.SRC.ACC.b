*-----------------------------------------------------------------------------
* <Rating>-62</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.MUL.SRC.ACC
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.MUL.SRC.ACC
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is the input routine to validate the credit and debit accounts
*
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2010-08-0031   Initial Creation
*-------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AC.LOCKED.EVENTS
$INSERT I_F.ACCOUNT
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_F.STANDING.ORDER
$INSERT I_System
$INSERT I_F.FT.BULK.SUP.PAY
  IF VAL.TEXT EQ '' THEN
    RETURN
  END
  GOSUB INIT
  RETURN
*---
INIT:
*---

  FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
  F.AC.LOCKED.EVENTS=''
  CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
  F.CUSTOMER.ACCOUNT=''
  CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

  LREF.APP = 'AC.LOCKED.EVENTS':FM:'ACCOUNT'
  LREF.FIELDS = 'L.AC.GAR.AMT':FM:'L.AC.STATUS1':FM:'L.AC.AV.BAL'
  LREF.POS=''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
  L.AC.LOCK.POS=LREF.POS<1,1>
  L.AC.STATUS.POS=LREF.POS<2,1>
  L.AC.BAL.POS = LREF.POS<3,1>
  VAR.GAR.AMT = ''
  Y.END.DATE.VAL = ''
  Y.FROM.DATE.VAL1 = ''
  Y.FROM.DATE.INIT = ''
  Y.VAR.ACC.NO=COMI
  CALL F.READ(FN.ACCOUNT,Y.VAR.ACC.NO,R.ACCOUNT,F.ACCOUNT,ERR)
  GOSUB CHECK.BALANCE
  RETURN
*-------------
CHECK.BALANCE:
*-------------

  VAR.ONLINE.BAL=R.ACCOUNT<AC.LOCAL.REF,L.AC.BAL.POS>
  Y.CALC.CREDIT.AMOUNT = ''
  Y.CREDIT.AMOUNT= R.NEW(FT.BUL76.CR.AMOUNT)
  CHANGE VM TO FM IN Y.CREDIT.AMOUNT
  Y.CREDI.AMT.CNT = DCOUNT(Y.CREDIT.AMOUNT,FM)
  IF Y.CREDI.AMT.CNT GT 1 THEN
    Y.CR.AMT.INIT = 1
    LOOP
      REMOVE Y.CREDIT.INIT.AMT FROM Y.CREDIT.AMOUNT SETTING Y.CREDIT.AMT.POS
    WHILE Y.CR.AMT.INIT LE Y.CREDI.AMT.CNT
      IF Y.CALC.CREDIT.AMOUNT EQ '' THEN
        Y.CALC.CREDIT.AMOUNT = Y.CREDIT.INIT.AMT
      END ELSE
        Y.CALC.CREDIT.AMOUNT=Y.CALC.CREDIT.AMOUNT+Y.CREDIT.INIT.AMT
      END
      Y.CR.AMT.INIT++
    REPEAT
  END ELSE
    Y.CALC.CREDIT.AMOUNT = Y.CREDIT.AMOUNT
  END
  Y.REQ.AMOUNT=Y.CALC.CREDIT.AMOUNT
  IF VAR.ONLINE.BAL LE Y.REQ.AMOUNT THEN
    ETEXT = 'EB-AMT.NOT.AVAIL'
    CALL STORE.END.ERROR
  END
  GOSUB CHECK.STATUS
  GOSUB CHECK.USER
  RETURN
*--------------
CHECK.STATUS:
*--------------
  IF R.ACCOUNT<AC.LOCAL.REF><1,L.AC.STATUS.POS> NE 'ACTIVE' AND R.ACCOUNT<AC.ARRANGEMENT.ID> EQ '' THEN
    ETEXT = 'EB-INACT.ACCOUNT'
    CALL STORE.END.ERROR
  END
  RETURN
*-----------
CHECK.USER:
*-----------
  Y.CUSTOMER =System.getVariable('EXT.SMS.CUSTOMERS')
  CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUSTOMER,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,ERR)
  LOCATE Y.VAR.ACC.NO IN R.CUSTOMER.ACCOUNT SETTING POS ELSE
    ETEXT ='EB-NOT.USER.ACCT'
    CALL STORE.END.ERROR
  END
  RETURN
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------
