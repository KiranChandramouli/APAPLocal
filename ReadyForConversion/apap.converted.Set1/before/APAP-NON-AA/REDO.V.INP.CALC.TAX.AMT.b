*-----------------------------------------------------------------------------
* <Rating>-64</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.CALC.TAX.AMT
***********************************************************
*----------------------------------------------------------
* COMPANY NAME    : APAP
* DEVELOPED BY    : Pradeep S
* PROGRAM NAME    : REDO.V.INP.CALC.TAX.AMT
*----------------------------------------------------------


* DESCRIPTION     : This routine is a input routine attached to verisons
* TELLER,REDO.TRANSF.CTAS.ACCT and TELLER,REDO.TRANSF.CTAS.ACCT.FCY to
* calculate the TAX amount.
*------------------------------------------------------------

* LINKED WITH    : TELLER INPUT ROUTINE
* IN PARAMETER   : NONE
* OUT PARAMETER  : NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO             REFERENCE       DESCRIPTION
*13.10.2011       Pradeep S       PACS00141531    INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.TAX
$INSERT I_GTS.COMMON

  IF OFS.VAL.ONLY THEN
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PRE.PROCESS
  END

  RETURN  ;* END

******
INIT:
******

  LOC.REF.APPLICATION = "TELLER"
  LOC.REF.FIELDS = 'TAX.AMOUNT':VM:'L.TT.TAX.TYPE':VM:'WAIVE.TAX'
  LOC.REF.POS=''

  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LREF.POS)
  POS.TAX.AMOUNT = LREF.POS<1,1>
  POS.TAX.TYPE   = LREF.POS<1,2>
  POS.WAIVE.TAX  = LREF.POS<1,3>

  RETURN  ;* Return INIT

************
OPEN.FILES:
************

  FN.TAX = 'F.TAX'
  F.TAX = ''
  R.TAX = ''
  CALL OPF(FN.TAX,F.TAX)

  RETURN  ;* Return OPEN.FILES

*************
PRE.PROCESS:
*************

  Y.TAX.AMT     = ""
  Y.WAIVE.TAX = R.NEW(TT.TE.LOCAL.REF)<1,POS.WAIVE.TAX>

  BEGIN CASE
  CASE Y.WAIVE.TAX EQ 'YES'
    R.NEW(TT.TE.LOCAL.REF)<1,POS.TAX.AMOUNT> = Y.TAX.AMT
  CASE Y.WAIVE.TAX EQ 'NO'
    GOSUB PROCESS
  END CASE


  RETURN  ;* Return PRE.PROCESS

*************
PROCESS:
*************

  Y.TAX.AMT     = 0.00
  TAXATION.CODE = R.NEW(TT.TE.LOCAL.REF)<1,POS.TAX.TYPE>
  Y.TXN.CCY     = R.NEW(TT.TE.CURRENCY.1)<1,1>
  IF Y.TXN.CCY EQ LCCY THEN
    Y.BASE.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1>
  END ELSE
    Y.BASE.AMT = R.NEW(TT.TE.AMOUNT.FCY.1)<1,1>
  END

  IF TAXATION.CODE THEN
    SEL.CMD = "SELECT ":FN.TAX:" WITH @ID LIKE ":TAXATION.CODE:"... BY-DSND @ID"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,RET.ERR)
    TAXATION.CODE = SEL.LIST<1>
    CALL F.READ(FN.TAX,TAXATION.CODE,R.TAX,F.TAX,ERR.TAX)
    IF R.TAX THEN
      Y.TAX.RATE     = R.TAX<EB.TAX.RATE>
      Y.TAX.AMT      = (Y.BASE.AMT*Y.TAX.RATE)/100
      Y.TAX.AMT      = DROUND(Y.TAX.AMT,2)
      R.NEW(TT.TE.LOCAL.REF)<1,POS.TAX.AMOUNT> = Y.TAX.AMT
    END
  END

  RETURN  ;* Return PROCESS

END
