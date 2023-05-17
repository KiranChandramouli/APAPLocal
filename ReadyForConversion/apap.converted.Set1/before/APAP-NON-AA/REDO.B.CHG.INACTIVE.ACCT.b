*-----------------------------------------------------------------------------
* <Rating>-63</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CHG.INACTIVE.ACCT(Y.ACCT.ID)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.CHG.INACTIVE.ACCT
*--------------------------------------------------------------------------------------------------------
*Description  : This is a batch routine to post the FT for the Customer accounts which satisfy the conditions
*               mentioned in the param table REDO.CHARGE.PARAM
*In Parameter : Y.ACCT.ID - will hold the Account number returned from the SELECT routine
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 30 Mar 2011    Krishna Murthy T.S   ODR-2011-03-0142           Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_EQUATE
$INSERT I_COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.FT.COMMISSION.TYPE
$INSERT I_F.REDO.CHARGE.PARAM
$INSERT I_REDO.B.CHG.INACTIVE.ACCT.COMMON
* Tus Start
$INSERT I_F.EB.CONTRACT.BALANCES
* Tus End

  CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
*  Tus Start
  R.ECB = ''
  ECB.ERR = ''
  CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.ACCT.ID, R.ECB,ECB.ERR) ; * Tus End
  Y.CUSTOMER   = R.ACCOUNT<AC.CUSTOMER>
  Y.ACCT.CATEG = R.ACCOUNT<AC.CATEGORY>
  *Y.AC.BAL     = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
  * Tus Start
  Y.AC.BAL     = R.ECB<ECB.ONLINE.ACTUAL.BAL>
  * Tus End
  Y.AC.CUR     = R.ACCOUNT<AC.CURRENCY>
  FLG.1 = ''

  IF Y.CUSTOMER THEN
    Y.CHG.ACCT = Y.DUP.CHG.ACCT
    Y.CHG.CATEGORY = Y.DUP.CHG.CATEGORY
    Y.AC.STAT.1 = Y.DUP.AC.STAT.1
    Y.AC.STAT.2 = Y.DUP.AC.STAT.2
    Y.CHG.AMT = Y.DUP.CHG.AMT
    Y.FTCT = Y.DUP.FTCT
    Y.CNT.TOT = DCOUNT(Y.FTCT,VM)
    GOSUB PROCESS
    IF Y.FLAG EQ 0 THEN
      GOSUB CHK.NEXT.ACCT
    END
  END
  RETURN

*-------
PROCESS:
*-------
  Y.FLAG = ''
  LOCATE Y.ACCT.ID IN Y.ADD.CHD.ACCT<1,1> SETTING Y.AC.POS THEN
    RETURN
  END
  ELSE
    Y.FLAG = 1
    Y.L.AC.STATUS.1 = R.ACCOUNT<AC.LOCAL.REF><1,Y.L.AC.STATUS.1.POS>
    Y.L.AC.STATUS.2 = R.ACCOUNT<AC.LOCAL.REF><1,Y.L.AC.STATUS.2.POS>

*checking the Category condition
    IF Y.L.AC.STATUS.1 NE '3 YEARS INACTIVE' THEN
      LOOP
      WHILE Y.CNT.TOT GT 0 DO
        FLG.1 += 1
        Y.TST.CATEG = Y.CHG.CATEGORY<1,FLG.1>
        Y.TST.CATEG = CHANGE(Y.TST.CATEG,SM,VM)
        LOCATE Y.ACCT.CATEG IN Y.TST.CATEG<1,1> SETTING CHG.POS THEN
          GOSUB CHECK.NXT.COND
          Y.FLAG = 1
          BREAK
        END
        Y.CNT.TOT -= 1
      REPEAT
    END
  END
  RETURN

*-----------
SUB.PROCESS:
*-----------
  Y.FT.AMT = ''
  Y.MY.FTCT = Y.FTCT<1,FLG.1>
  CALL F.READ(FN.FT.COMMISSION.TYPE,Y.MY.FTCT,R.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE,Y.FCT.ERR)
  Y.MY.FTCT.CUR.LIST = R.FT.COMMISSION.TYPE<FT4.CURRENCY>
  Y.MY.FTCT.AMT.LIST = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT>
  Y.MY.FTCT.CATEGORY = R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
  IF Y.CHG.AMT<1,FLG.1> EQ '' THEN
    LOCATE Y.AC.CUR IN Y.MY.FTCT.CUR.LIST<1,1> SETTING Y.CUR.POS THEN
      Y.FT.AMT = Y.MY.FTCT.AMT.LIST<1,Y.CUR.POS>
    END
  END
  ELSE
    IF Y.AC.BAL LT Y.CHG.AMT<1,FLG.1> THEN
      LOCATE Y.AC.CUR IN Y.MY.FTCT.CUR.LIST<1,1> SETTING Y.CUR.POS THEN
        Y.FT.AMT = Y.MY.FTCT.AMT.LIST<1,Y.CUR.POS>
      END
    END
  END
  IF Y.FT.AMT NE '' THEN
    GOSUB POST.FT.REC
  END
  RETURN

*--------------
CHECK.NXT.COND:
*--------------
  Y.FLAG = 1

*checking the AC.STATUS.1 condition
  IF (Y.L.AC.STATUS.1 EQ '') OR (Y.L.AC.STATUS.1 EQ Y.AC.STAT.1<1,FLG.1>) THEN
    Y.FLAG = 1

*checking the AC.STATUS.2 condition
    IF Y.L.AC.STATUS.2 EQ '' THEN
      Y.FLAG = 1
      GOSUB SUB.PROCESS
    END
    ELSE
      Y.AC.STAT2.VAL = Y.AC.STAT.2<1,FLG.1>
      LOCATE Y.AC.STAT2.VAL IN Y.L.AC.STATUS.2<1,1,1> SETTING Y.AC.STAT2.POS  THEN
        Y.FLAG = 1
        GOSUB SUB.PROCESS
      END
      ELSE
        Y.FLAG = 0
        RETURN
      END
    END
  END
  ELSE
    Y.FLAG = 0
    RETURN
  END
  RETURN

*--------------
CHK.NEXT.ACCT:
*--------------
  DEL Y.CHG.ACCT<1,FLG.1>
  DEL Y.CHG.CATEGORY<1,FLG.1>
  DEL Y.AC.STAT.1<1,FLG.1>
  DEL Y.AC.STAT.2<1,FLG.1>
  DEL Y.CHG.AMT<1,FLG.1>
  DEL Y.FTCT<1,FLG.1>
  GOSUB PROCESS
  RETURN

*-----------
POST.FT.REC:
*-----------
  Y.CR.AC = "PL":Y.FTCT.CATEGORY

  R.OFS.HDR = ''
  Y.NO.AUH = 0
  R.OFS.HDR = "FUNDS.TRANSFER,/I/PROCESS//":Y.NO.AUH:",//":ID.COMPANY:",,"

  R.OFS.BDY = ''
  R.OFS.BDY := 'TRANSACTION.TYPE::=':'AC,'
  R.OFS.BDY := 'DEBIT.ACCT.NO::=':Y.ACCT.ID:','
  R.OFS.BDY := 'DEBIT.CURRENCY::=':Y.AC.CUR:','
  R.OFS.BDY := 'DEBIT.AMOUNT::=':Y.FT.AMT:','
  R.OFS.BDY := 'DEBIT.VALUE.DATE::=':TODAY:','
  R.OFS.BDY := 'CREDIT.ACCT.NO::=':Y.CR.AC

  R.OFS.REC = ''
  OFS.MSG.ID = ''
  OPTIONS = ''
  OFS.SRC = 'REDO.POST.FT'
  R.OFS.REC = R.OFS.HDR:R.OFS.BDY
  CALL OFS.POST.MESSAGE(R.OFS.REC,OFS.MSG.ID,OFS.SRC,OPTIONS)
  RETURN
END
