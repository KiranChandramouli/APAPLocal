*-----------------------------------------------------------------------------
* <Rating>-45</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOFILE.AI.LIST.APAP.BEN.ACCTS(FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By :
* Program Name REDO.NOFILE.AI.LIST.APAP.BEN.ACCTS
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry REDO.SAV.ACCOUNT.LIST
* Linked with : Enquiry REDO.SAV.ACCOUNT.LIST  as BUILD routine
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*01/11/11       PACS00146410            PRABHU N                MODIFICAION
*
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.CATEGORY
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.AI.REDO.ARCIB.PARAMETER
$INSERT I_F.AI.REDO.ARCIB.ALIAS.TABLE
$INSERT I_F.BENEFICIARY
$INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER

  GOSUB INITIALISE
  GOSUB FORM.ACCT.ARRAY

  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------


  F.CUSTOMER.ACCOUNT = ''
  FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'

  CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

  FN.ACC = 'F.ACCOUNT'
  F.ACC = ''
  CALL OPF(FN.ACC,F.ACC)

  FN.BENEFICIARY = 'F.BENEFICIARY'
  F.BENEFICIARY = ''
  CALL OPF(FN.BENEFICIARY,F.BENEFICIARY)

  FN.AI.REDO.ARCIB.ALIAS.TABLE = 'F.AI.REDO.ARCIB.ALIAS.TABLE'
  F.AI.REDO.ARCIB.ALIAS.TABLE = ''
  CALL OPF(FN.AI.REDO.ARCIB.ALIAS.TABLE,F.AI.REDO.ARCIB.ALIAS.TABLE)

  FN.AI.REDO.ACCT.RESTRICT.PARAMETER = 'F.AI.REDO.ACCT.RESTRICT.PARAMETER'

  Y.VAR.EXT.CUSTOMER = ''
  Y.VAR.EXT.ACCOUNTS=''
  FN.CATEGORY = "F.CATEGORY"
  F.CATEGORY = ''

  FN.CUS.BEN.LIST = 'F.CUS.BEN.LIST'
  F.CUS.BEN.LIST  = ''
  CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)

  Y.FIELD.COUNT = ''
  R.ACCT.REC = ''
  LOAN.FLG = ''
  DEP.FLG = ''
  Y.FLAG = ''
  R.AZ.REC = ''
  R.ACC = ''
  LREF.POS = ''
  LREF.APP='ACCOUNT':FM:'BENEFICIARY'
  LREF.FIELDS='L.AC.STATUS1':VM:'L.AC.AV.BAL':VM:'L.AC.NOTIFY.1':VM:'L.AC.STATUS2':FM:'L.BEN.CUST.NAME':VM:'L.BEN.CEDULA':VM:'L.BEN.BANK':VM:':L.BEN.OWN.ACCT':VM:'L.BEN.PROD.TYPE'
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
  ACCT.STATUS.POS  = LREF.POS<1,1>
  ACCT.OUT.BAL.POS = LREF.POS<1,2>
  NOTIFY.POS       = LREF.POS<1,3>
  ACCT.STATUS2.POS = LREF.POS<1,4>
  POS.L.BEN.CUST.NAME = LREF.POS<2,1>
  POS.L.BEN.CEDULA    = LREF.POS<2,2>
  POS.L.BEN.BANK      = LREF.POS<2,3>
  POS.L.BEN.OWN.ACCT  = LREF.POS<2,4>
  POS.L.BEN.PROD.TYPE = LREF.POS<2,5>
  CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')

  Y.CUSTOMER.BEN.ID = CUSTOMER.ID:'-OWN'

  RETURN
******************
FORM.ACCT.ARRAY:
*****************


  CALL CACHE.READ(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,'SYSTEM',R.AI.REDO.ACCT.RESTRICT.PARAMETER,RES.ERR)
  Y.RESTRICT.ACCT.TYPE = R.AI.REDO.ACCT.RESTRICT.PARAMETER<AI.RES.PARAM.RESTRICT.ACCT.TYPE>
  CHANGE VM TO FM IN Y.RESTRICT.ACCT.TYPE

  Y.DEBIT.ACCT = System.getVariable('CURRENT.DEBIT.ACCT.NO')
  CALL F.READ(FN.CUS.BEN.LIST,Y.CUSTOMER.BEN.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ERR)

  LOOP
    REMOVE BEN.ID FROM R.CUS.BEN.LIST SETTING BEN.POS
  WHILE BEN.ID:BEN.POS

    ACC.ERR= ''
    CHECK.CATEG=''
    SAV.FLG=''
    CURR.FLG=''
    Y.FLAG = ''
    CUR.ACCT.STATUS = ''
    AC.NOFITY.STATUS = ''
    Y.POSTING.RESTRICT = ''
    ACCT.ID = ''; Y.NICKNAME = ''; Y.TRANSACTION.TYPE = ''; Y.L.BEN.CUST.NAM = ''; Y.L.BEN.CEDULA =''
    Y.L.BEN.BANK = ''; Y.L.BEN.OWN.ACCT =''
    BEN.PART.ID = FIELD(BEN.ID,'*',2)

    GOSUB BENEFICIARY.DET.PARA

    CALL F.READ(FN.ACC,ACCT.ID,R.ACC,F.ACC,ACC.ERR)
    IF R.ACC THEN
* CALL F.READ(FN.AI.REDO.ARCIB.ALIAS.TABLE,ACCCT.ID,R.AI.REDO.ARCIB.ALIAS.TABLE,F.AI.REDO.ARCIB.ALIAS.TABLE,ALIAS.ERR)
* IF NOT(ALIAS.ERR) THEN
*     Y.ALIAS.NAME = R.AI.REDO.ARCIB.ALIAS.TABLE<AI.ALIAS.ALIAS.NAME>
* END
      AC.NOFITY.STATUS = R.ACC<AC.LOCAL.REF><1,NOTIFY.POS>
      CUR.ACCT.STATUS1 = R.ACC<AC.LOCAL.REF><1,ACCT.STATUS.POS>
      CUR.ACCT.STATUS2=R.ACC<AC.LOCAL.REF><1,ACCT.STATUS2.POS>
      ACCT.BAL = R.ACC<AC.LOCAL.REF><1,ACCT.OUT.BAL.POS>
      Y.POSTING.RESTRICT= R.ACC<AC.POSTING.RESTRICT>
      CHANGE SM TO FM IN CUR.ACCT.STATUS2
      CHANGE SM TO FM IN AC.NOFITY.STATUS
      CHECK.CATEG = R.ACC<AC.CATEGORY>

      GOSUB CHECK.ACTIVE.STATUS

    END
  REPEAT

  RETURN
************************
BENEFICIARY.DET.PARA:
************************
  CALL F.READ(FN.BENEFICIARY,BEN.PART.ID,R.BENEFICIARY,F.BENEFICIARY,BENEFICIARY.ERR)
  IF R.BENEFICIARY THEN
    Y.BEN.PROD.TYPE = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.PROD.TYPE>
    IF Y.BEN.PROD.TYPE EQ 'AC.AHO' OR Y.BEN.PROD.TYPE EQ 'AC.CUR' THEN
      ACCT.ID = R.BENEFICIARY<ARC.BEN.BEN.ACCT.NO>
      Y.NICKNAME = R.BENEFICIARY<ARC.BEN.NICKNAME>
      Y.TRANSACTION.TYPE = R.BENEFICIARY<ARC.BEN.TRANSACTION.TYPE>
      Y.L.BEN.CUST.NAME = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.CUST.NAME>
      Y.L.BEN.CEDULA    = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.CEDULA>
      Y.L.BEN.BANK      = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.BANK>
      Y.L.BEN.OWN.ACCT  = R.BENEFICIARY<ARC.BEN.LOCAL.REF,POS.L.BEN.OWN.ACCT>
    END
  END
  RETURN

*******************
CHECK.ACTIVE.STATUS:
*******************
  IF ACCT.ID NE Y.DEBIT.ACCT THEN

    FIN.ARR<-1> = BEN.PART.ID:"@":Y.NICKNAME:"@":ACCT.ID:"@":Y.L.BEN.CUST.NAME:"@":Y.L.BEN.CEDULA:"@":Y.L.BEN.BANK:"@":Y.TRANSACTION.TYPE:"@":Y.L.BEN.OWN.ACCT

  END
  RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
