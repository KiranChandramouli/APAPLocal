*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.GET.AZ.ACC.NAME(CUSTOMER.NAME)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : btorresalbornoz
* Program Name  : REDO.S.GET.CUS.ACC.NAME
* ODR NUMBER    :
* Modify            :btorresalbornoz
*----------------------------------------------------------------------------------
* Description   : Deal slip routine attached to TT to retrieve CUSTOMER name from the transaction, which
*                 depends on the application name
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date             Author             Reference         Description

*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.TELLER


  GOSUB INITIALISE
  GOSUB PROCESS

  RETURN

*---------------------------
INITIALISE:
*---------------------------

  REF.POS = ''
  CONCAT1 = ''




  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
  R.ACCOUNT.REC = ''
  Y.ACCOUNT.ERR = ''
  Y.ACCOUNT.ID = ''
  JOINT.HOLDER.VAL = ''
  CUSTOMER.ID = ''
  IS.CUST.NAMES = ''
  Y.FINAL.ACCT.NAME = ''
  Y.ACC.NAMES = ''


  RETURN


*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------


  APPL.ARRAY = "AZ.ACCOUNT":FM:"TELLER"
  FIELD.ARRAY = "BENEFIC.NAME":FM:"L.TT.AZ.ACC.REF"
  FIELD.POS = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)

  LOC.BENEFIC.NAME = FIELD.POS<1,1>
  LOC.POS = FIELD.POS<2,1>

  Y.ACCOUNT.ID = R.NEW(TT.TE.LOCAL.REF)<1,LOC.POS>


  CALL F.READ(FN.AZ.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.AZ.ACCOUNT,Y.ACCOUNT.ERR)
  CUSTOMER.NAME=R.ACCOUNT<AZ.LOCAL.REF,LOC.BENEFIC.NAME>

  CUSTOMER.NAME=CUSTOMER.NAME<1,1,1>
  CUSTOMER.NAME=CUSTOMER.NAME[1,35]
  CUSTOMER.NAME=FMT(CUSTOMER.NAME,'R#35')


  RETURN


END
