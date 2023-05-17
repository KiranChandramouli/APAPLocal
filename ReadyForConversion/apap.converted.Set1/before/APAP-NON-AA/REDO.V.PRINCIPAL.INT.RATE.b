*-----------------------------------------------------------------------------
* <Rating>-102</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.PRINCIPAL.INT.RATE
****************************************************************
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.V.PRINCIPAL.INT.RATE
*-----------------------------------------------------------------------------
*Fix for PACS00319190**This rouitne is used to update the interest rate value if principal amount , maturity and value date has changed
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.AZ.CUSTOMER
$INSERT I_F.AZ.PRODUCT.PARAMETER
$INSERT I_F.PERIODIC.INTEREST
$INSERT I_GTS.COMMON
*
  BEGIN CASE

  CASE OFS$HOT.FIELD EQ 'Tab.PRINCIPAL' OR OFS$HOT.FIELD EQ 'PRINCIPAL'
    Y.PRINCIPAL = COMI
    Y.MAT.DATE = R.NEW(AZ.MATURITY.DATE)
    Y.VAL.DATE =  R.NEW(AZ.VALUE.DATE)

  CASE OFS$HOT.FIELD EQ 'Tab.ORIG.LCY.AMT' OR OFS$HOT.FIELD EQ 'ORIG.LCY.AMT'
    Y.PRINCIPAL = R.NEW(AZ.PRINCIPAL)
    Y.MAT.DATE = R.NEW(AZ.MATURITY.DATE)
    Y.VAL.DATE =  R.NEW(AZ.VALUE.DATE)

  CASE OFS$HOT.FIELD EQ 'Tab.MATURITY.DATE' OR OFS$HOT.FIELD EQ 'MATURITY.DATE'
    Y.PRINCIPAL = R.NEW(AZ.PRINCIPAL)
    Y.MAT.DATE = COMI
    Y.VAL.DATE =  R.NEW(AZ.VALUE.DATE)

  CASE OFS$HOT.FIELD EQ 'Tab.VALUE.DATE' OR OFS$HOT.FIELD EQ 'VALUE.DATE'
    Y.PRINCIPAL = R.NEW(AZ.PRINCIPAL)
    Y.MAT.DATE = R.NEW(AZ.MATURITY.DATE)
    Y.VAL.DATE =  COMI

  CASE 1
    GOSUB PGM.END

  END CASE

  GOSUB CHECK.CONDITION
  GOSUB PGM.END

  RETURN
*--------------------
CHECK.CONDITION:
*--------------------
  VAR.CURR.NO = R.OLD(AZ.CURR.NO)
  VAR.PRINCIPAL = Y.PRINCIPAL
  VAR.MATURITY.DATE = Y.MAT.DATE
  VAR.START.DATE =  Y.VAL.DATE
  IF NOT(VAR.CURR.NO) AND (VAR.PRINCIPAL NE '') AND (VAR.MATURITY.DATE NE '') AND (VAR.START.DATE NE '') THEN ;***** Interest Rate has to be applied on deposit opening alone
    GOSUB INIT
    GOSUB PROCESS
  END ELSE
    RETURN
  END
  RETURN
*
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
*
  Y.JOINT.NUM=''

  FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
  F.AZ.ACCOUNT=''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  FN.AZ.CUSTOMER='F.AZ.CUSTOMER'
  F.AZ.CUSTOMER=''
  CALL OPF(FN.AZ.CUSTOMER,F.AZ.CUSTOMER)

  FN.PERIODIC.INTEREST='F.PERIODIC.INTEREST'
  F.PERIODIC.INTEREST=''
  CALL OPF(FN.PERIODIC.INTEREST,F.PERIODIC.INTEREST)

  FN.AZ.PRODUCT.PARAMETER='F.AZ.PRODUCT.PARAMETER'
  F.AZ.PRODUCT.PARAMETER=''
  CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF'
  F.JOINT.CONTRACTS.XREF=''
  CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

  LREF.APP='AZ.ACCOUNT'
  LREF.FIELD='L.AZ.BAL.CONSOL':VM:'ORIG.DEP.AMT'
  LREF.POS=''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
  POS.L.AZ.BAL.CONSOL=LREF.POS<1,1>
  POS.ORIG.DEP.AMT=LREF.POS<1,2>

  RETURN
*
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
**************************
* New Deposit Account
**************************
*

  Y.CONSAL.COND=''
  Y.AZ.ACC.ID = ID.NEW
  Y.CUR=R.NEW(AZ.CURRENCY)
  VAR1.INT.RATE = R.NEW(AZ.INTEREST.RATE)
  Y.AZ.PRODUCT.PARAMETER.ID=R.NEW(AZ.ALL.IN.ONE.PRODUCT)
  R.AZ.PRODUCT.PARAMETER=''
  CALL CACHE.READ(FN.AZ.PRODUCT.PARAMETER,Y.AZ.PRODUCT.PARAMETER.ID,R.AZ.PRODUCT.PARAMETER,PARA.ERR)
  Y.PERIODIC.KEY = R.AZ.PRODUCT.PARAMETER<AZ.APP.PERIODIC.RATE.KEY>
  IF Y.PERIODIC.KEY EQ '' THEN
    RETURN
  END

  VAR.CONS.BAL =  R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.BAL.CONSOL>

  IF VAR.CONS.BAL EQ 'Y' THEN
    Y.CONS.BAL = Y.PRINCIPAL
    GOSUB CHECK.CUSTOMER
    GOSUB CALC.CONSOL.BAL
  END ELSE
    Y.CONS.BAL = Y.PRINCIPAL
  END

  GOSUB PI.TABLE

  RETURN

*------------------------------------------------------------------------
CHECK.CUSTOMER:
*-------------------------------------------------------------------------
* Read AZ.CUSTOMER to get other AZ.ACCOUNT
**********************************************
  Y.AZ.CUSTOMER.ID=R.NEW(AZ.CUSTOMER)
  R.AZ.CUSTOMER=''
  CALL F.READ(FN.AZ.CUSTOMER,Y.AZ.CUSTOMER.ID,R.AZ.CUSTOMER,F.AZ.CUSTOMER,AZ.CUS.ERR)
* ------------PACS00032518--------------
  GOSUB GET.JOINT.DEPOSIT
  R.AZ.CUSTOMER=R.AZ.CUSTOMER:FM:Y.JOINT.NUM
  RETURN
*
*-----------------------------------------------------------------------------
GET.JOINT.DEPOSIT:
*-----------------------------------------------------------------------------
* Gets the ID of AZ.ACCOUNT of this customer where he is a joint holder of that account
* This Gosub has been added for the PACS issue ref PACS00032518 - B.163

  CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.AZ.CUSTOMER.ID,R.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF,XREF.ERR)
  NO.OF.JOINT.ACCOUNT=DCOUNT(R.JOINT.CONTRACTS.XREF,FM)
  Y.VAR1=1
  LOOP
  WHILE Y.VAR1 LE NO.OF.JOINT.ACCOUNT
    Y.ACC.NO=R.JOINT.CONTRACTS.XREF<Y.VAR1>
    CALL F.READ(FN.ACCOUNT,Y.ACC.NO,R.ACC,F.ACCOUNT,ACC.ERR)
    Y.JOINT.HOLD=R.ACC<AC.JOINT.HOLDER>
    LOCATE Y.AZ.CUSTOMER.ID IN Y.JOINT.HOLD<1,1> SETTING POS1 THEN
      Y.RELATION.CODE=R.ACC<AC.RELATION.CODE,POS1>
      GOSUB CHECK.JOINT.CUS
    END
    Y.VAR1++
  REPEAT
  RETURN
*------------------------------------------------------------------------------
CHECK.JOINT.CUS:
*------------------------------------------------------------------------------
  IF (Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 509) OR (Y.RELATION.CODE GE 600 AND Y.RELATION.CODE LE 609) THEN
    R.AZ=''
    CALL F.READ(FN.AZ.ACCOUNT,Y.ACC.NO,R.AZ,F.AZ.ACCOUNT,AZ.ERR)
    IF R.AZ NE '' THEN
      Y.JOINT.NUM<-1>=Y.ACC.NO
    END
  END
  RETURN
*-----------------------------------------------------------------------------
CALC.CONSOL.BAL:
*-----------------------------------------------------------------------------
* Here we will calculating for consolidated principal amount when the L.AZ.BAL.CONSOL is not equal to 'N'
* for all the previous initial deposit for that customer under fall the same currency. In the authorization
* level to change the L.AZ.BAL.CONSOL as 'Y' in the previous deposit field
  Y.ACC.CNT=DCOUNT(R.AZ.CUSTOMER,FM)
  Y.VAR2=1
  LOOP
  WHILE Y.VAR2 LE Y.ACC.CNT
    Y.AZ.ID=R.AZ.CUSTOMER<Y.VAR2>
    IF Y.AZ.ID EQ '' OR Y.AZ.ID EQ ID.NEW ELSE
      CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ,F.AZ.ACCOUNT,AZ.ERR)
      IF R.NEW(AZ.CURRENCY) EQ R.AZ<AZ.CURRENCY> THEN
        Y.CONS.BAL+=R.AZ<AZ.LOCAL.REF,POS.ORIG.DEP.AMT>
      END
    END
    Y.VAR2++
  REPEAT
  RETURN
*---------------------------------------------------------------------------------
PI.TABLE:
*-----------------------------------------------------------------------------------
*
  LOAN.DEPOSIT = R.AZ.PRODUCT.PARAMETER<AZ.APP.LOAN.DEPOSIT>
  AMOUNT = Y.CONS.BAL
  CURRENCY= R.NEW(AZ.CURRENCY)
  PI.KEY = Y.PERIODIC.KEY
  PI.METHOD = R.AZ.PRODUCT.PARAMETER<AZ.APP.PI.METHOD>
  BI.KEY = ''
  BI.SPREAD = ''
  BI.OPERAND = ''
  BI.PERCENT = ''
  FIXED.RATE = ''
  START.DATE = Y.VAL.DATE
  END.DATE =   Y.MAT.DATE
  AZ.INT.RATE = ''
  CALL EB.CALC.INTEREST.RATE(LOAN.DEPOSIT,AMOUNT,CURRENCY,PI.KEY,PI.METHOD,BI.KEY,BI.SPREAD,BI.OPERAND,BI.PERCENT,FIXED.RATE,START.DATE,END.DATE,AZ.INT.RATE)
  VAR.INT.RATE = DROUND(AZ.INT.RATE,2)

* Fix for PACS00247796

  IF OFS$HOT.FIELD EQ 'Tab.L.AZ.BAL.CONSOL' THEN

* End of Fix

    R.NEW(AZ.INTEREST.RATE) = VAR.INT.RATE
  END ELSE
*Fix for PACS00307564**IF CONDITION IS COMMENTED.****
*IF NOT(VAR1.INT.RATE) THEN
    R.NEW(AZ.INTEREST.RATE) = VAR.INT.RATE
*END
  END
  RETURN
*-------------------------------------------------------------------------------
PGM.END:
*------------------------------------------------------------------------------------
END
