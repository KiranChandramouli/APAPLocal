*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.GET.PRINCIPAL(VAR.AMOUNT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.GET.PRINCIPAL
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the AMOUNT VALUE
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT.CLOSURE
$INSERT I_F.AZ.ACCOUNT

  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN
***********
OPENFILES:
***********

  LOC.REF.APP = 'ACCOUNT.CLOSURE':FM:'AZ.ACCOUNT'
  LOC.REF.FIELD = 'L.AC.AZ.ACC.REF':FM:'ORIG.DEP.AMT'
  LOC.REF.POS = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)

  L.AC.AZ.ACC.REF.POS = LOC.REF.POS<1,1>
  L.ORIG.DEP.AMT.POS  = LOC.REF.POS<2,1>
  RETURN
*********
PROCESS:
**********
  BEGIN CASE

  CASE APPLICATION EQ 'ACCOUNT.CLOSURE'

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT$HIS'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    VAR.ID = R.NEW(AC.ACL.LOCAL.REF)<1,L.AC.AZ.ACC.REF.POS>

    CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT,VAR.ID,R.AZ.ACCOUNT,AZ.ERR)

    Y.AMOUNT = R.AZ.ACCOUNT<AZ.LOCAL.REF,L.ORIG.DEP.AMT.POS>
    Y.CURR = R.AZ.ACCOUNT<AZ.CURRENCY>

  CASE APPLICATION EQ 'AZ.ACCOUNT'

    Y.AMOUNT = R.NEW(AZ.LOCAL.REF)<1,L.ORIG.DEP.AMT.POS>
    Y.CURR = R.NEW(AZ.CURRENCY)
  END CASE

  Y.AMOUNT = TRIM(FMT(Y.AMOUNT,"L2,#19")," ",'B')

  VAR.AMOUNT = Y.CURR:" ":Y.AMOUNT

  RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
