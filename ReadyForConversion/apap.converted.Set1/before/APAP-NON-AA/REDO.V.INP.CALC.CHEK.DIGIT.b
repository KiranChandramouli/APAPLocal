*-----------------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.CALC.CHEK.DIGIT
*-----------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.V.INP.CALC.CHEK.DIGIT
*-----------------------------------------------------------------------------------

*DESCRIPTION       :This Program is used for calculate the value of CHECK.DIGIT,
*                   Alphanumeric Equivalent of the Account Number and its equivalent
*                   Standard account Number
*
*LINKED WITH       :
* -----------------------------------------------------------------------------------

  $INSERT  I_COMMON
  $INSERT  I_EQUATE
  $INSERT  I_F.ACCOUNT

  GOSUB INIT
  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN
*------------------------------------------------------------------------------------
INIT:

  TOTAL.DIGIT=''
  LOC.REF.APPLICATION="ACCOUNT"
  LOC.REF.FIELDS='L.AC.ALPH.AC.NO':VM:'L.AC.STD.ACC.NO':VM:'L.AC.CHEK.DIGIT'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  RETURN
*--------------------------------------------------------------------------------------

OPEN.FILES:

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  RETURN
*---------------------------------------------------------------------------------------
PROCESS:

  LOC.ALPH.AC.NO=LOC.REF.POS<1,1>
  LOC.STD.ACC.NO=LOC.REF.POS<1,2>
  LOC.CHEK.DIGIT=LOC.REF.POS<1,3>
  ACCOUNT.ID=ID.NEW
  NUMERIC.CODE.OF.APOP =10252425
  COUNTRY.CODE = 132400

  ACC.ID.TWTY= FMT(ACCOUNT.ID,'R%20')
  ACC.ID.ELEV = FMT(ACCOUNT.ID,'R%11')

  TOTAL.DIGIT=NUMERIC.CODE.OF.APOP:ACC.ID.TWTY:COUNTRY.CODE
  CHECK.DIGIT=98-MOD(TOTAL.DIGIT,97)
  CHECK.DIGIT = FMT(CHECK.DIGIT,'R%2')          ;*PACS00524368-S/E
  R.NEW(AC.LOCAL.REF)<1,LOC.CHEK.DIGIT>= CHECK.DIGIT

  ALPHA.NUM.ID = 'DO':CHECK.DIGIT:'APOP':ACC.ID.TWTY
  R.NEW(AC.LOCAL.REF)<1,LOC.ALPH.AC.NO>=ALPHA.NUM.ID

  STAND.NUM.ID = 21410252425:ACC.ID.ELEV
  R.NEW(AC.LOCAL.REF)<1,LOC.STD.ACC.NO>=STAND.NUM.ID

  RETURN
END
