*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.GET.APP.DESC(VAR.APP.DESC)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.GET.APP.DESC
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the APP description value
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT.CLOSURE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.AZ.PRODUCT.PARAMETER

  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN
***********
OPENFILES:
***********

  FN.APP = 'F.AZ.PRODUCT.PARAMETER'
  F.APP = ''
  CALL OPF(FN.APP,F.APP)

  LOC.REF.APP = 'ACCOUNT.CLOSURE'
  LOC.REF.FIELD = 'L.AC.AZ.ACC.REF'
  LOC.REF.POS = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)

  L.AC.AZ.ACC.REF.POS = LOC.REF.POS<1,1>

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

    APP.ID  = R.AZ.ACCOUNT<AZ.ALL.IN.ONE.PRODUCT>

  CASE APPLICATION EQ 'AZ.ACCOUNT'

    APP.ID = R.NEW(AZ.ALL.IN.ONE.PRODUCT)

  END CASE

  CALL F.READ(FN.APP,APP.ID,R.APP,F.APP,APP.ERR)

  VAR.APP.DESC = R.APP<AZ.APP.DESCRIPTION,LNGG>

  IF NOT(VAR.APP.DESC) THEN
    VAR.APP.DESC = R.APP<AZ.APP.DESCRIPTION,1>
  END

  RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
