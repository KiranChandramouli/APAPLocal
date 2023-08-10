*-----------------------------------------------------------------------------
* <Rating>-63</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.FT.WV.COMM.TAX
*--------------------------------------------------------------------------------
*Company   Name    : Asociacion Popular de Ahorros y Prestamos
*Developed By      : Joaquin Costa c. - jcosta@temenos.com
*Program   Name    : REDO.V.FT.WV.COMM.TAX
*---------------------------------------------------------------------------------

* DESCRIPTION       : VALIDATION ROUTINE for COMM/TAX funcionality
*                       Attached to LOCAL.FIELDS like L.TT.WV.COMM amd L.TT.WV.TAX
*
* LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who              Reference            Description
*   19-JAN-2012        JOAQUIN COSTA    PACS00163682         Initial Creation
*
*-------------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
*
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.FT.COMMISSION.TYPE
*
  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END
*
  RETURN  ;* Return END
*
* ======
PROCESS:
* ======
*
  WCOMM.VAL   = 0
  WTAX.WAIVED = 0
  YNUM.COMM   = DCOUNT(Y.COMM.AMT,FM)
  YNUM.TAX    = DCOUNT(Y.TAX.AMT,FM)
*
  WTAX.AMT.WAIVED  = R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TAX.AMT,AS>
*
  IF AV EQ Y.L.TT.WV.COMM THEN
    Y.WV.COMM<AS> = COMI
  END
*
  IF AV EQ Y.L.TT.WV.TAX THEN
    Y.WV.TAX<AS> = COMI
  END
*
  GOSUB PROCESS.COMM
  GOSUB PROCESS.TAX
*
  R.NEW(FT.LOCAL.REF)<1,Y.L.TT.WV.TAX.AMT> = WTAX.WAIVED
*
  IF Y.FT.COMM.CODE EQ "DEBIT PLUS CHARGES" OR Y.FT.COMM.CODE EQ "" THEN
    R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TRANS.AMT>  = WCOMM.VAL + WTRAN.AMOUNT
  END ELSE
    R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TRANS.AMT> = WTRAN.AMOUNT
  END
*
  RETURN  ;* Return PROCESS
*
* ===========
PROCESS.COMM:
* ===========
*
  FOR I = 1 TO YNUM.COMM
    IF Y.WV.COMM<I> EQ "NO" THEN
      WCOMM.VAL += Y.COMM.AMT<I>
      IF Y.FT.COMM.CODE EQ "WAIVE" THEN
        R.NEW(FT.LOCAL.REF)<1,Y.L.FT.COMM.POS> = ""
      END
    END
  NEXT I
*
  RETURN
*
* ==========
PROCESS.TAX:
* ==========
*
  FOR I = 1 TO YNUM.TAX
    IF Y.WV.TAX<I> EQ "NO" THEN
      WCOMM.VAL += Y.TAX.AMT<I>
      IF Y.FT.COMM.CODE EQ "WAIVE" THEN
        R.NEW(FT.LOCAL.REF)<1,Y.L.FT.COMM.POS> = ""
      END
    END ELSE
      WTAX.WAIVED += Y.TAX.AMT<I>
    END
  NEXT I
*
  RETURN
*
* =========
INITIALISE:
* =========
*
  PROCESS.GOAHEAD = 1

  Y.LOC.APPL = "FUNDS.TRANSFER"
  Y.LOC.FLD  = "L.TT.COMM.CODE":VM:"L.TT.WV.COMM":VM:"L.TT.COMM.AMT"
  Y.LOC.FLD := VM:"L.TT.TAX.CODE":VM:"L.TT.WV.TAX":VM:"L.TT.TAX.AMT"
  Y.LOC.FLD := VM:"L.TT.WV.TAX.AMT":VM:'L.TT.BASE.AMT':VM:'L.TT.TRANS.AMT'
  Y.LOC.FLD := VM:"L.FT.COMM.CODE"
*
  CALL MULTI.GET.LOC.REF(Y.LOC.APPL,Y.LOC.FLD,Y.LOC.POS)
*
  Y.L.TT.COMM.CODE    = Y.LOC.POS<1,1>
  Y.L.TT.WV.COMM      = Y.LOC.POS<1,2>
  Y.L.TT.COMM.AMT     = Y.LOC.POS<1,3>
  Y.L.TT.TAX.CODE     = Y.LOC.POS<1,4>
  Y.L.TT.WV.TAX       = Y.LOC.POS<1,5>
  Y.L.TT.TAX.AMT      = Y.LOC.POS<1,6>
  Y.L.TT.WV.TAX.AMT   = Y.LOC.POS<1,7>
  Y.L.TT.BASE.AMT     = Y.LOC.POS<1,8>
  Y.L.TT.TRANS.AMT    = Y.LOC.POS<1,9>
  Y.L.FT.COMM.POS     = Y.LOC.POS<1,10>
*
  FN.FTCT = 'F.FT.COMMISSION.TYPE'
  F.FTCT  = ''
*
  Y.COMM.AMT     = RAISE(RAISE(R.NEW(FT.LOCAL.REF)<1,Y.L.TT.COMM.AMT>))
  Y.TAX.AMT      = RAISE(RAISE(R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TAX.AMT>))
  Y.WV.COMM      = RAISE(RAISE(R.NEW(FT.LOCAL.REF)<1,Y.L.TT.WV.COMM>))
  Y.WV.TAX       = RAISE(RAISE(R.NEW(FT.LOCAL.REF)<1,Y.L.TT.WV.TAX>))
  Y.WV.TAX.AMT   = RAISE(RAISE(R.NEW(FT.LOCAL.REF)<1,Y.L.TT.WV.TAX.AMT>))
  Y.TRANS.AMT    = RAISE(RAISE(R.NEW(FT.LOCAL.REF)<1,Y.L.TT.TRANS.AMT>))
  Y.FT.COMM.CODE = R.NEW(FT.LOCAL.REF)<1,Y.L.FT.COMM.POS>
*
  IF R.NEW(FT.DEBIT.AMOUNT) THEN
    WTRAN.AMOUNT = R.NEW(FT.DEBIT.AMOUNT)
  END ELSE
    WTRAN.AMOUNT = R.NEW(FT.CREDIT.AMOUNT)
  END
*
  RETURN  ;*Return INITIALISE
*
* =========
OPEN.FILES:
* =========
*
  CALL OPF(FN.FTCT,F.FTCT)
*
  RETURN  ;*Return OPEN.FILES
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
  IF MESSAGE  EQ "VAL" THEN
    PROCESS.GOAHEAD = ""
  END
*
  RETURN  ;* Return CHECK.PRELIM.CONDITIONS
*
END
