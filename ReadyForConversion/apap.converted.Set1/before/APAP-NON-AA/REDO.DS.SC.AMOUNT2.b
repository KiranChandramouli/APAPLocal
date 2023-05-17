*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.SC.AMOUNT2(Y.AMOUNT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos.
*Developed By      :btorresalbornoz
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

  FN.CURRENCY = 'F.CURRENCY'
  F.CURRENCY = ''
  CALL OPF(FN.CURRENCY,F.CURRENCY)

  Y.CURRENCY=R.NEW(TT.TE.CURRENCY.2)
  CALL F.READ(FN.CURRENCY,Y.CURRENCY,R.CURRENCY,F.CURRENCY,Y.ERR)
  Y.CCY=R.CURRENCY<EB.CUR.CCY.NAME>


  IF Y.CCY ='PESOS DOMINICANOS' THEN

    Y.AMOUNT=R.NEW(TT.TE.AMOUNT.LOCAL.2)
    Y.AMOUNT=FMT(Y.AMOUNT,"R2,#19")
  END
  IF Y.CCY ='USD DOLLAR' THEN

    Y.AMOUNT=R.NEW(TT.TE.AMOUNT.FCY.2)
    Y.AMOUNT=FMT(Y.AMOUNT,"R2,#19")
  END



  RETURN
END
