*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOFILE.AI.SAV.ACCT.DET(SAVE.ACCT.DET)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name :
*-----------------------------------------------------------------------------
* Description    :  This Nofile routine will get required details of Customer Accts
* Linked with    :
* Out Parameter  :
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.CATEGORY
$INSERT I_F.AI.REDO.ARCIB.PARAMETER
$INSERT I_F.AI.REDO.ARCIB.ALIAS.TABLE
*Tus Start
$INSERT I_F.EB.CONTRACT.BALANCES
*Tus End


*---------*
MAIN.PARA:
*---------*
  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN
*----------*
INITIALISE:
*----------*
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  LREF.POS = ''
  ACCT.STATUS=''
  SAV.ACCT.POS=''
  SAVINGS.ACCT= ''
  LREF.APP='ACCOUNT'
  LREF.FIELDS='L.AC.STATUS1':VM:'L.AC.AV.BAL':VM:'L.AC.ALPH.AC.NO'

  RETURN
*----------*
OPEN.FILES:
*----------*
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
  ACCT.STATUS.POS   = LREF.POS<1,1>
  ACCT.OUT.BAL.POS  = LREF.POS<1,2>
  AC.ALPH.AC.NO.POS = LREF.POS<1,3>
  RETURN

*--------*
PROCESS:
*--------*
  ACCT.ID = System.getVariable('CURRENT.ACCT.NO')

  CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCT,F.ACCOUNT,ACCT.ERR)
  R.ECB='' ; ECB.ERR='' ;*Tus Start
  CALL EB.READ.HVT("EB.CONTRACT.BALANCES",ACCT.ID,R.ECB,ECB.ERR);*Tus End
  IF NOT(ACCT.ERR) THEN
    CUR.ACCT.STATUS=R.ACCT<AC.LOCAL.REF><1,ACCT.STATUS.POS>
    Y.SAV.ACCT.BAL = R.ACCT<AC.LOCAL.REF><1,ACCT.OUT.BAL.POS>
    Y.CATEGORY = R.ACCT<AC.CATEGORY>
    Y.CURRENCY = R.ACCT<AC.CURRENCY>
    Y.CUSTOMER = R.ACCT<AC.CUSTOMER>
*   Y.ONLINE.ACTUAL.BAL = R.ACCT<AC.ONLINE.ACTUAL.BAL>;*Tus Start
    Y.ONLINE.ACTUAL.BAL = R.ECB<ECB.ONLINE.ACTUAL.BAL>;*Tus End
    Y.ACCOUNT.OFFICER = R.ACCT<AC.ACCOUNT.OFFICER>
    Y.CO.CODE = R.ACCT<AC.CO.CODE>
    CUR.ACCT.OPEN.DTE = R.ACCT<AC.OPENING.DATE>
    Y.REG.AC.NUM = R.ACCT<AC.LOCAL.REF><1,AC.ALPH.AC.NO.POS>
    SAVE.ACCT.DET = ACCT.ID:'*':Y.CATEGORY:'*':Y.CURRENCY:'*':Y.CUSTOMER:'*':Y.ONLINE.ACTUAL.BAL:'*':Y.SAV.ACCT.BAL:'*':Y.ACCOUNT.OFFICER:'*':Y.CO.CODE:'*':Y.REG.AC.NUM
  END
  RETURN
END
