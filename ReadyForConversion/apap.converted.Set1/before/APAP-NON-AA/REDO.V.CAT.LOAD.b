*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.CAT.LOAD
****************************************************************
*--------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : MGUDINO
* Program Name  : REDO.V.CAT.LOAD
* ODR NUMBER    :
*-------------------------------------------------------------------------

* Description :This i/p routine is triggered when TELLER transaction is made
* In parameter : None
* out parameter : None
*--------------------------------------------------------------------------------
*
* MODIFICATION HISTORY:
*
*----------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CATEGORY
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
*
  GOSUB INITIALISE
  GOSUB OPEN.FILES
*
  GOSUB PROCESS
*
  RETURN
* ======
PROCESS:
* ======
*
  IF APPLICATION EQ "AZ.ACCOUNT" THEN
    Y.ID.CATEGORY = R.NEW(AZ.CATEGORY)
    CALL F.READ(FN.CATEGORY,Y.ID.CATEGORY,R.CATEGORY,F.CATEGORY,Y.ERROR)
    R.NEW(AZ.LOCAL.REF)<1,POS.AZACC.COD> = R.CATEGORY<EB.CAT.LOCAL.REF,POS.CAT.COD>
  END
*
  IF APPLICATION EQ "ACCOUNT" THEN
    Y.ID.CATEGORY = R.NEW(AC.CATEGORY)
    CALL F.READ(FN.CATEGORY,Y.ID.CATEGORY,R.CATEGORY,F.CATEGORY,Y.ERROR)
    R.NEW(AC.LOCAL.REF)<1,POS.ACC.COD> = R.CATEGORY<EB.CAT.LOCAL.REF,POS.CAT.COD>
  END
  RETURN

INITIALISE:
*----------
*
  Y.ID.CATEGORY = ''
*
  FN.CATEGORY = "F.CATEGORY"
  F.CATEGORY = ""
  Y.ERROR = ""
  R.CATEGORY = ""

  LRF.APP='AZ.ACCOUNT':FM:'CATEGORY':FM:'ACCOUNT'
  LRF.FIELD='L.INV.FACILITY':FM:'L.CU.AGE':FM:'L.INV.FACILITY'
  LRF.POS=''
  RETURN
*----------
OPEN.FILES:
*----------
*
  CALL OPF(FN.CATEGORY,F.CATEGORY)
*
  CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
*
  POS.AZACC.COD = LRF.POS<1,1>
  POS.CAT.COD   = LRF.POS<2,1>
  POS.ACC.COD   = LRF.POS<3,1>
  RETURN

END
