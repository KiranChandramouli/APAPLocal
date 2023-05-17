*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FT.DS.TAX.AMT(Y.WV.TAX.AMT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :BTORRESALBORNOZ
*Program   Name    :REDO.DS.MET.PAY.METHOD
*Modify            :btorresalbornoz
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the PAY.METHOD value from EB.LOOKUP TABLE
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.USER
$INSERT I_F.FUNDS.TRANSFER
  GOSUB PROCESS
  RETURN
*********
PROCESS:
*********
  Y.WV.TAX.AMT=0
  LOC.REF.FIELD = 'L.TT.TAX.AMT':VM:'L.TT.WV.TAX'
  LOC.REF.APP = 'FUNDS.TRANSFER'
  LOC.POS = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
  L.TT.TAX.AMT.POS = LOC.POS<1,1>
  L.TT.WV.TAX  = LOC.POS<1,2>


  Y.WV.TAX =  R.NEW(FT.LOCAL.REF)<1,L.TT.WV.TAX>

  IF Y.WV.TAX = 'NO' THEN
    Y.WV.TAX.AMT  = R.NEW(FT.LOCAL.REF)<1,L.TT.TAX.AMT.POS>
    Y.WV.TAX.AMT =  Y.WV.TAX.AMT[1,9]


  END

  Y.WV.TAX.AMT= FMT(Y.WV.TAX.AMT,"9R,2")
  RETURN
END
