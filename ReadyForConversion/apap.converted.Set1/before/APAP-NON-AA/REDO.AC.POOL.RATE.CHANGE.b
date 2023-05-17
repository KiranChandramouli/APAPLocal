*-----------------------------------------------------------------------------
* <Rating>-74</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AC.POOL.RATE.CHANGE
*----------------------------------------------------
* Description: This routine is attached to the account modify versions
* to update the Old pool rate and Profit loss margin.
*----------------------------------------------------
* Input  Arg:  N/A
* Output Arg:  N/A
* Deals With:  ACCOUNT Application.
*----------------------------------------------------

*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*    10-Apr-2012         H Ganesh              PACS00190845 - B16.B        Initial Draft
*----------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_EB.TRANS.COMMON
$INSERT I_F.ACCOUNT.CREDIT.INT
$INSERT I_F.GROUP.CREDIT.INT
$INSERT I_F.GROUP.DATE

  GOSUB INIT
  GOSUB PROCESS

  RETURN
*----------------------------------------------------
INIT:
*----------------------------------------------------

  FN.ACCOUNT.CREDIT.INT = 'F.ACCOUNT.CREDIT.INT'
  F.ACCOUNT.CREDIT.INT = ''
  CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

  FN.GROUP.CREDIT.INT = 'F.GROUP.CREDIT.INT'
  F.GROUP.CREDIT.INT = ''
  CALL OPF(FN.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT)

  FN.GROUP.DATE = 'F.GROUP.DATE'
  F.GROUP.DATE  = ''
  CALL OPF(FN.GROUP.DATE,F.GROUP.DATE)

  LOC.REF.APPLICATION="ACCOUNT"
  LOC.REF.FIELDS='L.EB.PROFITLOSS':VM:'L.EB.OLD.RATE':VM:'L.EB.TASA.POOL'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.EB.PROFITLOSS = LOC.REF.POS<1,1>
  POS.L.EB.OLD.RATE   = LOC.REF.POS<1,2>
  POS.L.EB.TASA.POOL  = LOC.REF.POS<1,3>

  RETURN
*----------------------------------------------------
PROCESS:
*----------------------------------------------------
  Y.OLD.POOL.RATE = R.OLD(AC.LOCAL.REF)<1,POS.L.EB.TASA.POOL>
  Y.NEW.POOL.RATE = R.NEW(AC.LOCAL.REF)<1,POS.L.EB.TASA.POOL>

  IF Y.OLD.POOL.RATE EQ Y.NEW.POOL.RATE THEN      ;* No change in the Pool rate.
    RETURN
  END

  GOSUB GET.INTEREST

  R.NEW(AC.LOCAL.REF)<1,POS.L.EB.OLD.RATE,DCOUNT(R.OLD(AC.LOCAL.REF)<1,POS.L.EB.OLD.RATE>,VM)+1> = Y.OLD.POOL.RATE
  R.NEW(AC.LOCAL.REF)<1,POS.L.EB.PROFITLOSS>  = Y.NEW.POOL.RATE - ACC.INT.RATE

  RETURN
*----------------------------------------------------
GET.INTEREST:
*----------------------------------------------------
  ACC.ID = ID.NEW
  ACC.CUR   = R.NEW(AC.CURRENCY)
  ACC.CATEG = R.NEW(AC.CATEGORY)
  ACC.COND  = R.NEW(AC.CONDITION.GROUP)
  ACC.BAL   = R.NEW(AC.WORKING.BALANCE)

  ACI.DATE.CNT = DCOUNT(R.NEW(AC.ACCT.CREDIT.INT),VM)
  ACI.DATE     = R.NEW(AC.ACCT.CREDIT.INT)<1,ACI.DATE.CNT>

  Y.GD.ID = ACC.COND:ACC.CUR
  R.GROUP.DATE = ''
  CALL F.READ(FN.GROUP.DATE,Y.GD.ID,R.GROUP.DATE,F.GROUP.DATE,ERR.GD)
  GCI.DATE = R.GROUP.DATE<AC.GRD.CREDIT.GROUP.DATE>

  ACC.INT.RATE = ''
  Y.ACI.ID = ACC.ID:"-":ACI.DATE
  R.ACCOUNT.CREDIT.INT = ''
  CALL F.READ(FN.ACCOUNT.CREDIT.INT,Y.ACI.ID,R.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT,CGI.ERR)
  IF R.ACCOUNT.CREDIT.INT THEN
    GOSUB PROCESS.ACI
  END ELSE
    Y.GCI.ID = Y.GD.ID:GCI.DATE
    R.GROUP.CREDIT.INT = ''
    CALL F.READ(FN.GROUP.CREDIT.INT,Y.GCI.ID,R.GROUP.CREDIT.INT,F.GROUP.CREDIT.INT,CGI.ERR)
    GOSUB PROCESS.GCI
  END

  RETURN

*-----------
PROCESS.GCI:
*-----------
*--------------------------------------------------------------------
* This section gets the required details from GROUP.CREDIT.INT record
*--------------------------------------------------------------------

  CI.LIM.AMT = R.GROUP.CREDIT.INT<IC.GCI.CR.LIMIT.AMT>
  INT.RATE = R.GROUP.CREDIT.INT<IC.GCI.CR.INT.RATE>
  BASIC.RATE.KEY = R.GROUP.CREDIT.INT<IC.GCI.CR.BASIC.RATE>
  GOSUB GET.INT.RATE
  RETURN

*-----------
PROCESS.ACI:
*-----------
*----------------------------------------------------------------------
* This section gets the required details from ACCOUNT.CREDIT.INT record
*----------------------------------------------------------------------

  CI.LIM.AMT = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.LIMIT.AMT>
  INT.RATE = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.INT.RATE>
  BASIC.RATE.KEY = R.ACCOUNT.CREDIT.INT<IC.ACI.CR.BASIC.RATE>
  GOSUB GET.INT.RATE
  RETURN

*------------
GET.INT.RATE:
*------------
*-----------------------------------------------------------------------------------------------------
* This section gets the interest rate based on the amount and assigns it to the common variable O.DATA
*-----------------------------------------------------------------------------------------------------

  INT.RATE.CNT = DCOUNT(INT.RATE,VM)
  IF INT.RATE.CNT EQ 1 THEN
    ACC.INT.RATE = INT.RATE
    RETURN
  END
  BASIC.RATE.CNT = DCOUNT(BASIC.RATE.KEY,VM)
  IF BASIC.RATE.CNT EQ 1 THEN
    BASIC.RATE.KEY := ACC.CUR:TODAY
    BASIC.RATE = ''
    CALL EB.GET.INTEREST.RATE(BASIC.RATE.KEY,BASIC.RATE)
    ACC.INT.RATE = BASIC.RATE
    RETURN
  END
  Y.CNT.CI.LIM.AMT = DCOUNT(CI.LIM.AMT,VM)
  LIM.AMT.CNT = 0
  Y.VAR1 = 1
  LOOP

  WHILE Y.VAR1 LE Y.CNT.CI.LIM.AMT
    LIM.AMT = CI.LIM.AMT<1,Y.VAR1>
    LIM.AMT.CNT++
    IF ACC.BAL LE LIM.AMT THEN
      Y.VAR1 = Y.CNT.CI.LIM.AMT+1
    END
    Y.VAR1++
  REPEAT

  IF INT.RATE<1,LIM.AMT.CNT> EQ '' THEN
    IBASIC.RATE.KEY = BASIC.RATE.KEY<1,LIM.AMT.CNT>
    IBASIC.RATE.KEY := ACC.CUR:TODAY
    BASIC.RATE = ''
    CALL EB.GET.INTEREST.RATE(IBASIC.RATE.KEY,BASIC.RATE)
    ACC.INT.RATE = BASIC.RATE
  END ELSE
    ACC.INT.RATE = INT.RATE<1,LIM.AMT.CNT>
  END
  RETURN

END
