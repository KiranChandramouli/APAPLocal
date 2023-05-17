*---------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CREDIT.NOSTRO.ACCT.LOAD
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CREDIT.NOSTRO.ACCT.LOAD
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.CREDIT.NOSTRO.ACCT
* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_F.ACCOUNT
$INSERT I_F.TAX
$INSERT I_F.REDO.MANAGER.CHQ.PARAM
$INSERT I_F.REDO.MANAGER.CHQ.DETAILS
$INSERT I_REDO.B.CREDIT.NOSTRO.ACCT.COMMON

  FN.REDO.MANAGER.CHQ.PARAM='F.REDO.MANAGER.CHQ.PARAM'
  F.REDO.MANAGER.CHQ.PARAM=''
  CALL OPF(FN.REDO.MANAGER.CHQ.PARAM,F.REDO.MANAGER.CHQ.PARAM)

  FN.REDO.MANAGER.CHQ.DETAILS='F.REDO.MANAGER.CHQ.DETAILS'
  F.REDO.MANAGER.CHQ.DETAILS=''
  CALL OPF(FN.REDO.MANAGER.CHQ.DETAILS,F.REDO.MANAGER.CHQ.DETAILS)
  FN.TAX='F.TAX'
  F.TAX=''
  CALL OPF(FN.TAX,F.TAX)

  FN.FT.COM.TYPE= 'F.FT.COMMISSION.TYPE'
  F.FT.COM.TYPE = ''
  CALL OPF(FN.FT.COM.TYPE,F.FT.COM.TYPE)

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  CALL CACHE.READ(FN.REDO.MANAGER.CHQ.PARAM,'SYSTEM',R.CHQ.PARAM,ERR)

  LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
  RETURN
END
