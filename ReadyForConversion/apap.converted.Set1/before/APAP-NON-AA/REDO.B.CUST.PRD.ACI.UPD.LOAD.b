*---------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CUST.PRD.ACI.UPD.LOAD
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CUST.PRD.ACI.UPD.LOAD
* ODR Number    : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This routine will open all the files required
*              by the routine REDO.B.CUST.PRD.ACI.UPD.LOAD

* In parameter : None
* out parameter : None
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.ACCOUNT.CREDIT.INT
$INSERT I_F.BASIC.INTEREST
$INSERT I_F.DATES
$INSERT I_F.REDO.CUST.PRD.LIST
$INSERT I_F.REDO.ACC.CR.INT
$INSERT I_REDO.B.CUST.PRD.ACI.UPD.COMMON

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.ACCOUNT.CREDIT.INT='F.ACCOUNT.CREDIT.INT'
  F.ACCOUNT.CREDIT.INT=''
  CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

  FN.REDO.ACC.CR.INT='F.REDO.ACC.CR.INT'
  F.REDO.ACC.CR.INT=''
  CALL OPF(FN.REDO.ACC.CR.INT,F.REDO.ACC.CR.INT)

  FN.BASIC.INTEREST='F.BASIC.INTEREST'
  F.BASIC.INTEREST=''
  CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)

  FN.REDO.CUST.PRD.LIST='F.REDO.CUST.PRD.LIST'
  F.REDO.CUST.PRD.LIST=''
  CALL OPF(FN.REDO.CUST.PRD.LIST,F.REDO.CUST.PRD.LIST)

  LREF.APP='ACCOUNT'
  LREF.FIELD='L.AC.STATUS1':VM:'L.STAT.INT.RATE':VM:'L.DATE.INT.UPD':VM:'L.AC.MAN.UPD'
  LREF.POS=''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
  POS.L.AC.STATUS1=LREF.POS<1,1>
  POS.L.STAT.INT.RATE=LREF.POS<1,2>
  POS.L.DATE.INT.UPD=LREF.POS<1,3>
  POS.L.AC.MAN.UPD=LREF.POS<1,4>

*Shek -s
  // new table
  FN.REDO.BATCH.JOB.LIST.FILE = 'F.REDO.BATCH.JOB.LIST.FILE'
  F.REDO.BATCH.JOB.LIST.FILE = ''
  CALL OPF(FN.REDO.BATCH.JOB.LIST.FILE, F.REDO.BATCH.JOB.LIST.FILE)
*Shek -e

  RETURN
END
