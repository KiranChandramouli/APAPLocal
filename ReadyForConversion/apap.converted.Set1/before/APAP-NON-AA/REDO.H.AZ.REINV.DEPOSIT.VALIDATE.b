*-----------------------------------------------------------------------------
* <Rating>-120</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.H.AZ.REINV.DEPOSIT.VALIDATE
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.H.AZ.REINV.DEPOSIT.VALIDATE
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*           This validation routine should be attached to the REDO.H.AZ.REINV.DEPOSIT
* template. This routine checks whether the input details are proper for creating
* primary base account, reinvested interest account and az.account
*---------------------------------------------------------------------------------
* Modification History :
*-----------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 11-06-2010      SUJITHA.S   ODR-2009-10-0332   INITIAL CREATION
* 24-02-2011      H GANESH    PACS00033293       Change made as per issue
* ----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.AZ.REINV.DEPOSIT
$INSERT I_F.AZ.PRODUCT.PARAMETER
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.ACCOUNT
$INSERT I_GTS.COMMON
$INSERT I_F.PERIODIC.INTEREST

  GOSUB INITIALISE
  GOSUB VALIDATE
  GOSUB VALIDATE.AUTHORISATION
  RETURN
*
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
*
  Y.TOT.AMT=''

  Y.CUSTOMER = R.NEW(REDO.AZ.REINV.CUSTOMER)
  Y.PRODUCT = R.NEW(REDO.AZ.REINV.DEPOSIT.PRODUCT)
  Y.CURRENCY = R.NEW(REDO.AZ.REINV.CURRENCY)
  Y.PRINCIPAL = R.NEW(REDO.AZ.REINV.DEPOSIT.AMOUNT)
  Y.DB.ACCT = R.NEW(REDO.AZ.REINV.DEBIT.ACCOUNT)
  Y.AZ.METHOD.PAY = R.NEW(REDO.AZ.REINV.AZ.METHOD.PAY)
  Y.AZ.AMOUNT = R.NEW(REDO.AZ.REINV.AZ.AMOUNT)
  Y.AZ.SOURCE.FUND = R.NEW(REDO.AZ.REINV.AZ.SOURCE.FUND)
  Y.AZ.DEBIT.ACC = R.NEW(REDO.AZ.REINV.AZ.DEBIT.ACC)

  FN.AZPROD='F.AZ.PRODUCT.PARAMETER'
  F.AZPROD=''
  R.AZPROD=''
  CALL OPF(FN.AZPROD,F.AZPROD)



  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  R.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
  F.AZ.ACCOUNT=''
  R.AZ.ACCOUNT=''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  FN.PERIODIC.INTEREST='F.PERIODIC.INTEREST'
  F.PERIODIC.INTEREST=''
  R.PERIODIC.INTEREST=''
  CALL OPF(FN.PERIODIC.INTEREST,F.PERIODIC.INTEREST)

  LOC.REF.APP='AZ.PRODUCT.PARAMETER':FM:'ACCOUNT'
  LOC.REF.FLD='L.AZ.RE.INV.CAT':VM:'L.AZP.TRAN.DAYS':FM:'L.AC.REINVESTED':VM:'L.AC.AV.BAL'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FLD,LOC.REF.POS)
  Y.REINV.CAT.POS=LOC.REF.POS<1,1>
  Y.TRANS.POS=LOC.REF.POS<1,2>
  Y.REINV.FLAG.POS=LOC.REF.POS<2,1>
  Y.L.AC.AV.BAL.POS=LOC.REF.POS<2,2>

  RETURN
*
*-----------------------------------------------------------------------------
VALIDATE:
*-----------------------------------------------------------------------------
*

  IF R.NEW(REDO.AZ.REINV.MATURITY.INSTRN) EQ 'PAYMENT TO NOMINATED ACCOUNT' THEN
    IF R.NEW(REDO.AZ.REINV.NOMINATED.ACCOUNT) EQ '' THEN
      AF=REDO.AZ.REINV.NOMINATED.ACCOUNT
      ETEXT='EB-INPUT.MISSING'
      CALL STORE.END.ERROR
    END

  END

  CALL F.READ(FN.AZPROD,Y.PRODUCT,R.AZPROD,F.AZPROD,Y.ERR)

  Y.PERIODIC.KEY = R.AZPROD<AZ.APP.PERIODIC.RATE.KEY>
  IF Y.PERIODIC.KEY EQ "" THEN
  END ELSE
    GOSUB INT.RATE
  END

  Y.L.AZ.RE.INV.CAT=R.AZPROD<AZ.APP.LOCAL.REF,Y.REINV.CAT.POS>


  IF Y.L.AZ.RE.INV.CAT EQ "" THEN
    AF=REDO.AZ.REINV.DEPOSIT.PRODUCT
    ETEXT="EB-REINV.CATEG"
    CALL STORE.END.ERROR
  END ELSE
    R.NEW(REDO.AZ.REINV.REINVINT.CATEG)=Y.L.AZ.RE.INV.CAT
  END

  IF R.NEW(REDO.AZ.REINV.MATURITY.INSTRN) EQ "AUTOMATIC ROLLOVER" THEN
    Y.L.AZ.ORG.DP.AMT=R.NEW(REDO.AZ.REINV.DEPOSIT.AMOUNT)
  END

  Y.ACCOUNT.ID=R.NEW(REDO.AZ.REINV.NOMINATED.ACCOUNT)

  CALL F.READ(FN.AZ.ACCOUNT,Y.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.AZACC.ERR)
  IF R.AZ.ACCOUNT THEN
    AF=REDO.AZ.REINV.NOMINATED.ACCOUNT
    ETEXT="EB-NOM.ACC"
    CALL STORE.END.ERROR
  END

  CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)

  IF R.ACCOUNT NE '' THEN
    Y.NOMACC.CURRENCY=R.ACCOUNT<AC.CURRENCY>
    IF Y.NOMACC.CURRENCY NE R.NEW(REDO.AZ.REINV.CURRENCY) THEN
      AF=REDO.AZ.REINV.NOMINATED.ACCOUNT
      ETEXT="EB-NOMACC.CURRENCY"
      CALL STORE.END.ERROR
    END
  END
  IF Y.DB.ACCT EQ "" THEN
    GOSUB AZSET
  END ELSE
*---------------------------PACS00033293------------------
    CALL F.READ(FN.ACCOUNT,Y.DB.ACCT,R.DB.ACC,F.ACCOUNT,Y.DB.ERR)
    Y.DB.BALANCE=R.DB.ACC<AC.LOCAL.REF,Y.L.AC.AV.BAL.POS>
    Y.DEP.AMT=R.NEW(REDO.AZ.REINV.DEPOSIT.AMOUNT)
    IF Y.DB.BALANCE LT Y.DEP.AMT THEN
      AF=REDO.AZ.REINV.DEBIT.ACCOUNT
      ETEXT='EB-INSUFFICIENT.FUNDS'
      CALL STORE.END.ERROR

    END
  END
  IF Y.DB.ACCT NE '' AND R.NEW(REDO.AZ.REINV.AZ.METHOD.PAY) THEN
    AF=REDO.AZ.REINV.DEBIT.ACCOUNT
    ETEXT='EB-REDO.REINV.PAY'
    CALL STORE.END.ERROR
    AF=REDO.AZ.REINV.AZ.METHOD.PAY
    ETEXT='EB-REDO.REINV.PAY'
    CALL STORE.END.ERROR

  END

*---------------------------PACS00033293------------------
  GOSUB OFS.VALIDATE

  RETURN
*
*-----------------------------------------------------------------------------
OFS.VALIDATE:
*-----------------------------------------------------------------------------
*
  Y.CUSTOMER=R.NEW(REDO.AZ.REINV.CUSTOMER)
  Y.CATEGORY=R.NEW(REDO.AZ.REINV.REINVINT.CATEG)
  Y.CURRENCY=R.NEW(REDO.AZ.REINV.CURRENCY)
  Y.ACCOUNTNAME=R.NEW(REDO.AZ.REINV.ACCOUNT.NAME)
*Y.MNEMONIC=R.NEW(REDO.AZ.REINV.MNEMONIC)
  Y.MNEMONIC=''
  Y.ACCT.OFF=R.NEW(REDO.AZ.REINV.ACCOUNT.OFFICER)
  Y.JOINT.HOLDER=R.NEW(REDO.AZ.REINV.JOINT.HOLDER)
  Y.JOINT.REL=R.NEW(REDO.AZ.REINV.JOINT.RELCODE)

  R.AC.DETAIL=''

  R.AC.DETAIL<AC.CUSTOMER> = Y.CUSTOMER
  R.AC.DETAIL<AC.CATEGORY> = Y.CATEGORY
  R.AC.DETAIL<AC.CURRENCY> = Y.CURRENCY
  R.AC.DETAIL<AC.SHORT.TITLE> = Y.ACCOUNTNAME
  R.AC.DETAIL<AC.MNEMONIC> = Y.MNEMONIC
  R.AC.DETAIL<AC.ACCOUNT.OFFICER> = Y.ACCT.OFF

  Y.JOINT.DETAILS=DCOUNT(Y.JOINT.HOLDER,VM)
  Y.JOINT.INIT=1
  LOOP
  WHILE Y.JOINT.INIT LE Y.JOINT.DETAILS
    R.AC.DETAIL<AC.JOINT.HOLDER,Y.JOINT.INIT> = R.NEW(REDO.AZ.REINV.JOINT.HOLDER)<1,Y.JOINT.INIT>
    R.AC.DETAIL<AC.RELATION.CODE,Y.JOINT.INIT> = R.NEW(REDO.AZ.REINV.JOINT.RELCODE)<1,Y.JOINT.INIT>
    Y.JOINT.INIT++
  REPEAT

  ACTUAL.APP.NAME = 'ACCOUNT'
  OFS.FUNCTION = 'I'
  PROCESS = 'VALIDATE'
  OFS.VERSION = ''
  GTSMODE = ''
  NO.OF.AUTH = ''
  TRANSACTION.ID = ''
  OFS.RECORD = ''
  VERSION = 'ACCOUNT,RE'
  MSG.ID = ''
  OFS.SRC.ID = 'REINV.DEPOSIT'
  OPTION = ''
  CALL OFS.BUILD.RECORD(ACTUAL.APP.NAME,OFS.FUNCTION,PROCESS,OFS.VERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.AC.DETAIL,OFS.RECORD)
  OFS.MSG.VAL = VERSION:OFS.RECORD

  CALL OFS.GLOBUS.MANAGER(OFS.SRC.ID,OFS.MSG.VAL)

  FIRST = FIELD(OFS.MSG.VAL,',',1)
  SECOND = FIELD(FIRST,'/',3)
  AC.OGM.ID = FIELD(OFS.MSG.VAL,'/',1)

  IF SECOND EQ '-1' THEN
    ERR.MSG = FIELD(OFS.MSG.VAL,'/',4)
    I=2
    LOOP
      Y.CURR.FLD=FIELD(ERR.MSG,',',I)
    WHILE Y.CURR.FLD
      Y.FLD=FIELD(Y.CURR.FLD,'=',1)
      Y.FLD.NAME=FIELD(Y.FLD,':',1)
      Y.ERR=FIELD(Y.CURR.FLD,'=',2)
      GOSUB ACC.ERR
      I++
    REPEAT
  END
  GOSUB REINV.ACC

  RETURN
*
*---------------------------------------------------------------------------
INT.RATE:
*---------------------------------------------------------------------------
*
  ST.DATE=R.NEW(REDO.AZ.REINV.START.DATE)
  ED.DATE =R.NEW(REDO.AZ.REINV.END.DATE)
  NOF.DAYS="C"
  CALL CDD ("1", ST.DATE, ED.DATE, NOF.DAYS)

  PI.ID = Y.PERIODIC.KEY:Y.CURRENCY
  TABLE.AVAIL=''
  R.PERIODIC.INTEREST = ''
  LATEST.DATE=TODAY
  Y.PERIODIC.INT.ID = PI.ID:LATEST.DATE
  LOOP
    CALL F.READ(FN.PERIODIC.INTEREST,Y.PERIODIC.INT.ID,R.PERIODIC.INTEREST,F.PERIODIC.INTEREST,PI.ERR)
    IF R.PERIODIC.INTEREST NE '' THEN
      TABLE.AVAIL='YES'
    END
  WHILE TABLE.AVAIL NE 'YES'
    CALL CDT('',LATEST.DATE,'-1W')
    Y.PERIODIC.INT.ID = PI.ID:LATEST.DATE
  REPEAT
  Y.DAYS.SINCE.SPOT.CNT=DCOUNT(R.PERIODIC.INTEREST<PI.DAYS.SINCE.SPOT>,VM)
  FOR VAR2 = 1 TO Y.DAYS.SINCE.SPOT.CNT
    Y.DAYS.SINCE.SPOT=R.PERIODIC.INTEREST<PI.DAYS.SINCE.SPOT,VAR2>
    Y.REST.PERIOD=R.PERIODIC.INTEREST<PI.REST.PERIOD,VAR2>
    IF NOF.DAYS LE Y.DAYS.SINCE.SPOT OR Y.REST.PERIOD EQ 'R' THEN
      Y.SM.CNT=DCOUNT(R.PERIODIC.INTEREST<PI.AMT,VAR2>,SM)
      GOSUB CHK.PI.AMT
      VAR2 = Y.DAYS.SINCE.SPOT.CNT
    END
  NEXT VAR2
  IF  R.NEW(REDO.AZ.REINV.INTEREST.RATE) EQ  '' THEN
    R.NEW(REDO.AZ.REINV.INTEREST.RATE)=R.PERIODIC.INTEREST<PI.OFFER.RATE,VAR2,Y.SM.CNT++>
  END

  RETURN
*
*----------------------------------------------------------------------------
AZSET:
*----------------------------------------------------------------------------
*
  Y.L.AZP.TRAN.DAYS=R.AZPROD<AZ.APP.LOCAL.REF,Y.TRANS.POS>
  Y.AZSET.COUNT=DCOUNT(R.NEW(REDO.AZ.REINV.AZ.METHOD.PAY),VM)
  Y.INITIALSET=1

  LOOP
  WHILE Y.INITIALSET LE Y.AZSET.COUNT
    IF Y.AZ.METHOD.PAY<1,Y.INITIALSET> EQ "" THEN
      AF=REDO.AZ.REINV.AZ.METHOD.PAY
      AV=Y.INITIALSET
      ETEXT="EB-AZSET"
      CALL STORE.END.ERROR
    END

    IF Y.AZ.AMOUNT<1,Y.INITIALSET> EQ "" THEN
      AF=REDO.AZ.REINV.AZ.AMOUNT
      AV=Y.INITIALSET
      ETEXT="EB-AZSET"
      CALL STORE.END.ERROR
    END

    IF Y.AZ.SOURCE.FUND<1,Y.INITIALSET> EQ "" THEN
      AF=REDO.AZ.REINV.AZ.SOURCE.FUND
      AV=Y.INITIALSET
      ETEXT="EB-AZSET"
      CALL STORE.END.ERROR
    END

    IF Y.AZ.METHOD.PAY<1,Y.INITIALSET> EQ "FROM" AND Y.AZ.DEBIT.ACC<1,Y.INITIALSET> EQ "" THEN
      AF=REDO.AZ.REINV.AZ.DEBIT.ACC
      AV=Y.INITIALSET
      ETEXT="EB-AZSET"
      CALL STORE.END.ERROR
    END

    CALL F.READ(FN.ACCOUNT,Y.AZ.DEBIT.ACC<1,Y.INITIALSET>,R.AZ.DEBIT.ACC,F.ACCOUNT,AZ.DB.ERR)
    IF R.AZ.DEBIT.ACC THEN
      Y.AZ.DB.CURRENCY=R.AZ.DEBIT.ACC<AC.CURRENCY>
      Y.AZ.DB.CATEGORY=R.AZ.DEBIT.ACC<AC.CATEGORY>

      IF Y.AZ.DB.CURRENCY NE R.NEW(REDO.AZ.REINV.CURRENCY) THEN
        AF=REDO.AZ.REINV.AZ.DEBIT.ACC
        AV=Y.INITIALSET
        ETEXT="EB-AZ.DEB.ACC"
        CALL STORE.END.ERROR
      END

    END

    Y.ONE.AMT=R.NEW(REDO.AZ.REINV.AZ.AMOUNT)<1,Y.INITIALSET>
    Y.TOT.AMT+=Y.ONE.AMT
    Y.INITIALSET++

  REPEAT

  IF Y.TOT.AMT NE Y.PRINCIPAL THEN
    AF=REDO.AZ.REINV.DEPOSIT.AMOUNT
    ETEXT="EB-AZ.AMOUNT.TOTAL"
    CALL STORE.END.ERROR
  END

  R.NEW(REDO.AZ.REINV.IN.TRANSIT)=''

  FIND "CHEQUE.DEPOSIT" IN Y.AZ.METHOD.PAY SETTING POS1 THEN
    IF Y.L.AZP.TRAN.DAYS GT 0 THEN
      R.NEW(REDO.AZ.REINV.IN.TRANSIT)='YES'
    END
  END

  RETURN
*
*-----------------------------------------------------------------------------
REINV.ACC:
*-----------------------------------------------------------------------------
*

  Y.CUSTOMER1=R.NEW(REDO.AZ.REINV.CUSTOMER)
  Y.CATEGORY1=R.NEW(REDO.AZ.REINV.PRODUCT.CODE)
  Y.CURRENCY1=R.NEW(REDO.AZ.REINV.CURRENCY)
  Y.SHORT.TITLE='REINVESTED.ACCOUNT-':AC.OGM.ID
*Y.MNEMONIC1='RE-':Y.MNEMONIC
  Y.MNEMONIC1=''
  Y.ACCT.OFF1=R.NEW(REDO.AZ.REINV.ACCOUNT.OFFICER)
  Y.REINV.FLAG='YES'

  R.AC.DETAIL1=''

  VERSION1 = 'ACCOUNT,RE'
  OFS.HEADER1=VERSION1:'/I/VALIDATE///,//,':AC.OGM.ID1
  OFS.BODY1=',CUSTOMER:1:1=':Y.CUSTOMER1:',CATEGORY:1:1=':Y.CATEGORY1:',CURRENCY:1:1=':Y.CURRENCY1:',SHORT.TITLE:1:1=':Y.SHORT.TITLE:',MNEMONIC:1:1=':Y.MNEMONIC1:',ACCOUNT.OFFICER:1:1=':Y.ACCT.OFF1:',INTEREST.LIQU.ACCT:1:1=':AC.OGM.ID:',LOCAL.REF:':Y.REINV.FLAG.POS:':1=':Y.REINV.FLAG
  Y.JNT.INIT=1
  JOINT.MULTI=''
  LOOP
  WHILE Y.JNT.INIT LE Y.JOINT.DETAILS
    JOINT.MULTI:=',JOINT.HOLDER:':Y.JNT.INIT:':1=':Y.JOINT.HOLDER<1,Y.JNT.INIT>:',RELATION.CODE:':Y.JNT.INIT:':1=':Y.JOINT.REL<1,Y.JNT.INIT>
    Y.JNT.INIT++
  REPEAT

  OFS.MSG.VAL1=OFS.HEADER1:OFS.BODY1:JOINT.MULTI
  OFS.SRC.ID1 = 'REINV.DEPOSIT'
  CALL OFS.GLOBUS.MANAGER(OFS.SRC.ID1,OFS.MSG.VAL1)

  FIRST1 = FIELD(OFS.MSG.VAL1,',',1)
  SECOND1 = FIELD(FIRST1,'/',3)
  AC.OGM.ID1 = FIELD(OFS.MSG.VAL1,'/',1)

  IF SECOND1 EQ '-1' THEN
    ERR.MSG1 = FIELD(OFS.MSG.VAL1,'/',4)
    I=2
    LOOP
      Y.CURR.FLD1=FIELD(ERR.MSG1,',',I)
    WHILE Y.CURR.FLD1
      Y.FLD1=FIELD(Y.CURR.FLD1,'=',1)
      Y.FLD.NAME1=FIELD(Y.FLD1,':',1)
      Y.ERR1=FIELD(Y.CURR.FLD1,'=',2)
      GOSUB REINV.ACC.ERR
      I++
    REPEAT
  END

  RETURN
*
*-----------------------------------------------------------------------------
ACC.ERR:
*-----------------------------------------------------------------------------
*
  BEGIN CASE

  CASE Y.FLD.NAME="CUSTOMER"
    AF=REDO.AZ.REINV.CUSTOMER
    ETEXT=Y.FLD.NAME:'-':Y.ERR
    CALL STORE.END.ERROR

  CASE Y.FLD.NAME="CATEGORY"
    AF=REDO.AZ.REINV.PRODUCT.CODE
    ETEXT=Y.FLD.NAME:'-':Y.ERR
    CALL STORE.END.ERROR

  CASE Y.FLD.NAME="CURRENCY"
    AF=REDO.AZ.REINV.CURRENCY
    ETEXT=Y.FLD.NAME:'-':Y.ERR
    CALL STORE.END.ERROR

  CASE Y.FLD.NAME="MNEMONIC"
    AF=REDO.AZ.REINV.MNEMONIC
    ETEXT=Y.FLD.NAME:'-':Y.ERR
    CALL STORE.END.ERROR

  END CASE

  RETURN
*
*-----------------------------------------------------------------------------
REINV.ACC.ERR:
*-----------------------------------------------------------------------------
*
  BEGIN CASE

  CASE Y.FLD.NAME1="CUSTOMER"
    AF=REDO.AZ.REINV.CUSTOMER
    ETEXT=Y.FLD.NAME1:'-':Y.ERR1
    CALL STORE.END.ERROR

  CASE Y.FLD.NAME1="CATEGORY"
    AF=REDO.AZ.REINV.REINVINT.CATEG
    ETEXT=Y.FLD.NAME1:'-':Y.ERR1
    CALL STORE.END.ERROR

  CASE Y.FLD.NAME1="CURRENCY"
    AF=REDO.AZ.REINV.CURRENCY
    ETEXT=Y.FLD.NAME1:'-':Y.ERR1
    CALL STORE.END.ERROR

  CASE Y.FLD.NAME1="MNEMONIC"
    AF=REDO.AZ.REINV.MNEMONIC
    ETEXT=Y.FLD.NAME1:'-':Y.ERR1
    CALL STORE.END.ERROR

  END CASE

  RETURN
*
*--------------------------------------------------------------------------------
CHK.PI.AMT:
*--------------------------------------------------------------------------------
*
  FOR VAR3 = 1 TO Y.SM.CNT
    R.NEW(REDO.AZ.REINV.INTEREST.RATE)=''
    Y.AMT=R.PERIODIC.INTEREST<PI.AMT,VAR2,VAR3>
    IF Y.PRINCIPAL LT Y.AMT THEN
      R.NEW(REDO.AZ.REINV.INTEREST.RATE)=R.PERIODIC.INTEREST<PI.OFFER.RATE,VAR2,VAR3>
      VAR3 = Y.SM.CNT
    END
  NEXT VAR3
  RETURN
*
*-----------------------------------------------------------------------------
VALIDATE.AUTHORISATION:
*-----------------------------------------------------------------------------
*
  IF MESSAGE EQ 'AUT' OR MESSAGE EQ 'VER' THEN
    GOSUB OFS.VALIDATE
    CALL REDO.V.AUTH.DEPOSIT(AC.OGM.ID,AC.OGM.ID1)
    R.NEW(REDO.AZ.REINV.AZ.ACCT.NO)=AC.OGM.ID1
  END
  RETURN
*
END
