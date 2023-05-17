*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.ELIM.LOAN.PRODUCT(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.E.ELIM.LOAN.PRODUCT
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.LOAN.ACCT.TO
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*26/08/11      PACS00108342          Prabhu N                MODIFICAION
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.AA.OVERDUE
  GOSUB INITIALISE
  GOSUB GET.LOAN.DETAILS
  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

  LR.APP = 'AA.PRD.DES.OVERDUE'
  LR.FLDS = 'L.LOAN.COND':VM:'L.LOAN.STATUS.1'
  LR.POS = ''
  LOAN.LIST.ACCOUNTS=''
  EB.LKP.LOAN.COND.ID=''
  EB.LKP.LOAN.STATUS.ID=''
  CALL MULTI.GET.LOC.REF(LR.APP,LR.FLDS,LR.POS)
  OD.LOAN.COND.POS =  LR.POS<1,1>
  OD.LOAN.STATUS.POS = LR.POS<1,2>

  RETURN
*----------------------------------------------------------------------------
GET.LOAN.DETAILS:
*-----------------------------------------------------------------------------
  R.CUSTOMER.ACCOUNT.REC= System.getVariable("EXT.CUSTOMER.ACCOUNTS")
  PROP.CLASS = 'OVERDUE'
  PROPERTY = ''
  R.Condition = ''
  ERR.MSG = ''
  EFF.DATE = ''


  EB.LKP.LOAN.COND.ID = 'L.LOAN.STATUS.1'
  CALL EB.LOOKUP.LIST(EB.LKP.LOAN.COND.ID)
  LOOKUP.LOAN.COND = EB.LKP.LOAN.COND.ID<2>
  CHANGE '_' TO VM IN LOOKUP.LOAN.COND

  EB.LKP.LOAN.STATUS.ID = 'L.LOAN.COND'
  CALL EB.LOOKUP.LIST(EB.LKP.LOAN.STATUS.ID)
  LOOKUP.LOAN.STATUS=EB.LKP.LOAN.STATUS.ID<2>
  CHANGE '_' TO VM IN LOOKUP.LOAN.STATUS

  CHANGE SM TO FM IN R.CUSTOMER.ACCOUNT.REC

  LOOP

    REMOVE ACC.ID FROM R.CUSTOMER.ACCOUNT.REC SETTING ACCT.POS
  WHILE ACC.ID:ACCT.POS
    LOAN.FLAG=''
    CALL REDO.CONVERT.ACCOUNT(ACC.ID,Y.ARR.ID,ARR.ID,ERR.TEXT)
    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    IF ('JudicialCollection' MATCHES LOAN.STATUS) OR ('Write-off' MATCHES LOAN.STATUS) OR ('Legal' MATCHES LOAN.COND) THEN
      LOAN.FLAG=1
    END ELSE
      LOAN.LIST.ACCOUNTS<-1>=ACC.ID
    END
  REPEAT

  CHANGE FM TO ' ' IN LOAN.LIST.ACCOUNTS
  ENQ.DATA<2, 1>= '@ID'
  ENQ.DATA<3, 1> = 'EQ'
  ENQ.DATA<4, 1>= LOAN.LIST.ACCOUNTS

  RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
