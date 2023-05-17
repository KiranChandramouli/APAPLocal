*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.DS.CUSTOMER.CODES
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.DS.CUSTOMER.CODES
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display Owner and
*               Beneficiary(joint holder) customer codes of deposit
*
*Linked With  :
*In Parameter : O.DATA
*Out Parameter: O.DATA
*Linked File  : REDO.APAP.ENQ.CPH.DEAL.SLIP
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 25-08-2010        JEEVA T         ODR-2009-10-0346 B.21       Initial Creation
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.CUSTOMER
*--------------------------------------------------------------------------------
MAIN.PARA:
*--------------------------------------------------------------------------------

  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA
  RETURN

*--------------------------------------------------------------------------------
OPEN.PARA:
*--------------------------------------------------------------------------------

  FN.CUSTOMER='F.CUSTOMER'
  F.CUSTOMER=''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN
*--------------------------------------------------------------------------------
PROCESS.PARA:
*--------------------------------------------------------------------------------

  ACCOUNT.ID=O.DATA
  GOSUB READ.ACCOUNT
  CUSTOMER.ID=R.ACC<AC.CUSTOMER>
  Y.CUS.NAMES=CUSTOMER.ID
  GOSUB READ.CUSTOMER
  Y.REL.COUNT=DCOUNT(Y.REL.CODE,VM)
  REL.NO=1
  LOOP
  WHILE REL.NO LE Y.REL.COUNT
    Y.RELATION.CODE=R.ACC<AC.RELATION.CODE,REL.NO>
    IF Y.RELATION.CODE GT 500 AND Y.RELATION.CODE LT 529 THEN
      Y.CUS.NAMES<-1>:= R.ACC <AC.JOINT.HOLDER,REL.NO>
    END
    REL.NO++
  REPEAT
  CHANGE FM TO VM IN Y.CUS.NAMES
  O.DATA=Y.CUS.NAMES
  VM.COUNT=DCOUNT(O.DATA,VM)
  O.DATA=O.DATA<1,VC>
  RETURN

*--------------------------------------------------------------------------------
READ.ACCOUNT:
*--------------------------------------------------------------------------------

  CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACC,F.ACCOUNT,Y.ACCOUNT.ERR)
  Y.REL.CODE=R.ACC<AC.RELATION.CODE>
  RETURN

*--------------------------------------------------------------------------------
READ.CUSTOMER:
*--------------------------------------------------------------------------------

  CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUS,F.CUSTOMER,Y.CUSTOMER.ERR)
  RETURN

*---------------------------------------------------------------------------------
