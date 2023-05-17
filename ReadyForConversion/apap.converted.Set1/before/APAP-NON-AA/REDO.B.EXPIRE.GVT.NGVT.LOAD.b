*-----------------------------------------------------------------------------
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.EXPIRE.GVT.NGVT.LOAD
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.EXPIRE.GVT.NGVT.LOAD
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.EXPIRE.GVT.NGVT

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_F.ACCOUNT
$INSERT I_F.COMPANY

$INSERT I_F.REDO.ADMIN.CHQ.PARAM
$INSERT I_F.REDO.ADMIN.CHQ.DETAILS
$INSERT I_REDO.B.EXPIRE.GVT.NGVT.COMMON

  FN.REDO.ADMIN.CHQ.PARAM='F.REDO.ADMIN.CHQ.PARAM'
  F.REDO.ADMIN.CHQ.PARAM=''
  CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)

  FN.REDO.ADMIN.CHQ.DETAILS='F.REDO.ADMIN.CHQ.DETAILS'
  F.REDO.ADMIN.CHQ.DETAILS=''
  CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,'SYSTEM',R.CHQ.PARAM,ERR)
  Y.EXPIRE.MONTHS = R.CHQ.PARAM<ADMIN.CHQ.PARAM.EXPIRE.MONTHS>
  Y.EXP.MONTH = Y.EXPIRE.MONTHS:'M'

*Government is taken from the second multivalue set
  GVMNT.ACCT = R.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,2>

*Non-Government is taken from the first multivalue set
  NON.GVMNT.ACCT = R.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,1>

*    LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
  LAST.WORK.DATE = TODAY      ;* Fix for PACS00319443

  Y.COUNTRY = R.COMPANY(EB.COM.LOCAL.COUNTRY)
  RETURN.DATE =''
  RETURN.CODE = ''
  RETURN.DISPLACEMENT = ''

*    CALL WORKING.DAY('',LAST.WORK.DATE, '-', Y.EXP.MONTH, 'B', Y.COUNTRY, '', RETURN.DATE, RETURN.CODE, RETURN.DISPLACEMENT)
*    BEFORE.X.MNTHS = RETURN.DATE

*--- Fix HD1052809 Start

  CALL CALENDAR.DAY(LAST.WORK.DATE,'-',Y.EXP.MONTH)

  BEFORE.X.MNTHS = Y.EXP.MONTH

*--- Fix HD1052809 End

  RETURN
END
