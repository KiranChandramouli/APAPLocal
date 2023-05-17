*-----------------------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DEF.ACCT.CCY
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.DEF.ACCT.CCY
*-------------------------------------------------------------------------
* Description: This routine is a Inout routine to default currency and Account.1
*
*----------------------------------------------------------
* Linked with:  T24.FUNDS.SERVICES,FCY.COLLECT
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0251              Initial Creation
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.T24.FUND.SERVICES


  GOSUB OPEN.FILE
  GOSUB PROCESS
  RETURN

OPEN.FILE:
*Opening Files

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN

PROCESS:
*Get the Count of Transaction Field
  VAR.MULTI.TXN = R.NEW(TFS.TRANSACTION)
  VAR.TRANS.COUNT = DCOUNT(VAR.MULTI.TXN,VM)

*Get the values of Account and Currency field
  CCY.FLAG = ''
  VAR.COUNT = 1

  VAR.TRANS.AC = R.NEW(TFS.PRIMARY.ACCOUNT)
  CALL F.READ(FN.ACCOUNT,VAR.TRANS.AC,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
  VAR.TRANC.CCY = R.ACCOUNT<AC.CURRENCY>

  LOOP
    REMOVE TXN FROM VAR.MULTI.TXN SETTING TXN.POS
  WHILE VAR.COUNT LE VAR.TRANS.COUNT
*Assign the Currency and Surrogate Account of Primary Account
    R.NEW(TFS.SURROGATE.AC)<1,VAR.COUNT> = VAR.TRANS.AC
    R.NEW(TFS.CURRENCY)<1,VAR.COUNT> = VAR.TRANC.CCY
    VAR.COUNT++
  REPEAT

  RETURN
END
