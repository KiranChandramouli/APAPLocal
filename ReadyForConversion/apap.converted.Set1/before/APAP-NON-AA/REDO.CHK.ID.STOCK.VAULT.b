*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHK.ID.STOCK.VAULT
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : KAVITHA
* PROGRAM NAME : REDO.CHK.ID.STOCK.VAULT
*----------------------------------------------------------


* DESCRIPTION : This routine is to default stock values for Vault
*------------------------------------------------------------

*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*20-1-2011       KAVITHA                 ODR-2010-03-0400  INITIAL CREATION
*----------------------------------------------------------------------


*-------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STOCK.ENTRY
$INSERT I_F.REDO.CARD.REQUEST
$INSERT I_F.REDO.CARD.SERIES.PARAM
$INSERT I_GTS.COMMON
$INSERT I_System
$INSERT I_F.COMPANY

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN

*-------------------------------------------------------------
INIT:
*Initialising
*-------------------------------------------------------------
  AGENCY.POS= ''
  R.STOCK.ENTRY = ''
  LOC.REF.APPLICATION = ''
  LOC.REF.FIELDS=''
  BATCH.POS = ''

  LOC.REF.APPLICATION='STOCK.ENTRY'
  LOC.REF.FIELDS='L.SE.AGENCY':VM:'L.SE.BATCH.NO'
  LOC.REF.POS=''

  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  AGENCY.POS = LOC.REF.POS<1,1>
  BATCH.POS = LOC.REF.POS<1,2>

  RETURN

*-------------------------------------------------------------
OPENFILES:
*Opening File

  FN.STOCK.ENTRY = 'F.STOCK.ENTRY'
  F.STOCK.ENTRY = ''
  CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)

  FN.REDO.CARD.REQ = 'F.REDO.CARD.REQUEST'
  F.REDO.CARD.REQ = ''
  CALL OPF(FN.REDO.CARD.REQ,F.REDO.CARD.REQ)

  FN.REDO.SER.PARAM = 'F.REDO.CARD.SERIES.PARAM'
  F.REDO.SER.PARAM = ''
  CALL OPF(FN.REDO.SER.PARAM,F.REDO.SER.PARAM)

  FN.COMP = 'F.COMPANY'
  F.COMP= ''
  CALL OPF(FN.COMP,F.COMP)

  RETURN
*-------------------------------------------------------------
PROCESS:

*  CALL F.READ(FN.REDO.SER.PARAM,'SYSTEM',R.REDO.SER.PARAM,F.REDO.SER.PARAM,SER.ERR) ;*Tus Start 
CALL CACHE.READ(FN.REDO.SER.PARAM,'SYSTEM',R.REDO.SER.PARAM,SER.ERR) ; * Tus End
  IF R.REDO.SER.PARAM THEN
    EMBOSS.DEPT.CODE = R.REDO.SER.PARAM<REDO.CARD.SERIES.PARAM.EMBOSS.DEPT.CODE>
    RECEIVE.DEPT.CODE = R.REDO.SER.PARAM<REDO.CARD.SERIES.PARAM.RECEIVE.DEPT.CODE>
    VAULT.DEPT.CODE = R.REDO.SER.PARAM<REDO.CARD.SERIES.PARAM.VAULT.DEPT.CODE>
  END

  Y.DEFAULT.BATCH = System.getVariable('CURRENT.BATCH')
  Y.DEFAULT.START.NO =System.getVariable('CURRENT.START.NO') 
  Y.DEFAULT.SERIES = System.getVariable('CURRENT.SERIES')   
  Y.DEFAULT.BRANCH = System.getVariable('CURRENT.BRANCH')

  CALL F.READ(FN.COMP,Y.DEFAULT.BRANCH,R.COMP,F.COMP,Y.COMP.ERR)

  FINAL.COMP = R.COMP<EB.COM.FINANCIAL.COM>
  Y.SERIES.COUNT = DCOUNT(Y.DEFAULT.SERIES,VM)
  Y.CNT = 1
  LOOP
  WHILE Y.CNT LE Y.SERIES.COUNT
    R.NEW(STO.ENT.FROM.REGISTER)<1,Y.CNT> = 'CARD.':Y.DEFAULT.BRANCH:'-':RECEIVE.DEPT.CODE
    R.NEW(STO.ENT.TO.REGISTER)<1,Y.CNT> = 'CARD.':FINAL.COMP:'-':VAULT.DEPT.CODE
    R.NEW(STO.ENT.LOCAL.REF)<1,BATCH.POS> = Y.DEFAULT.BATCH
    R.NEW(STO.ENT.STOCK.SERIES)<1,Y.CNT> = Y.DEFAULT.SERIES<1,Y.CNT>
    R.NEW(STO.ENT.STOCK.START.NO)<1,Y.CNT> = Y.DEFAULT.START.NO<1,Y.CNT>
    R.NEW(STO.ENT.NOTES)<1,Y.CNT,1> = "RETURNED TO VAULT"
    Y.CNT = Y.CNT + 1
  REPEAT
  RETURN
END
