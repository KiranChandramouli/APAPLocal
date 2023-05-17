*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.SC.CREDIT.CARD(Y.CARD)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.DS.SC.CCY
*Modify            :btorresalbornoz
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the Y.CCY value from EB.LOOKUP TABLE
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.USER
$INSERT I_F.CURRENCY

  GOSUB PROCESS
  RETURN
*********
PROCESS:
*********

  LOC.REF.FIELD = 'L.TT.SN.PAYMTHD':VM:'L.TT.TAX.AMT'

  LOC.REF.APP = 'TELLER'
  LOC.POS = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
  L.TT.CREDIT.CARD.POS = LOC.POS<1,1>
  L.TT.WV.TAX  = LOC.POS<1,2>


  Y.CREDIT.CART =  R.NEW(TT.TE.LOCAL.REF)<1,L.TT.CREDIT.CARD.POS>

  Y.CREDIT.CARD1 =Y.CREDIT.CART[1,6]
  Y.CREDIT.CARD2 ='******'
  Y.CREDIT.CARD3=Y.CREDIT.CART[13,16]
  Y.CARD = Y.CREDIT.CARD1:Y.CREDIT.CARD2:Y.CREDIT.CARD3



  RETURN
END
