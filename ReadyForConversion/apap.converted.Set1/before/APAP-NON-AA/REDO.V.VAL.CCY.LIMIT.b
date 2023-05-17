*-----------------------------------------------------------------------------
* <Rating>-90</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.CCY.LIMIT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :NAVA V.
*Program   Name    :REDO.V.VAL.CCY.LIMIT
*Reference Number  :PACS00235401
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to check to avoid duplicate in L.TT.CURRENCY
*                   and L.CI.CATEG.CARD linked values.

*LINKED WITH       : TELLER.ID,BRANCH.LIMIT, TELLER.ID,BRNCH.LMT.EDT, TELLER.ID,MAIN.LIMIT
*                    TELLER.ID,MN.LMT.EDT, TELLER.ID,TELLER.LIMIT, TELLER.ID,TLR.LMT.EDT

* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER.ID
*
  GOSUB INIT
  GOSUB PROCESS
*
  RETURN
*
*-------
PROCESS:
*-------
*
  NO.OF.FLDS = DCOUNT(AF.LIST,FM)
  NO.OF.VLS  = DCOUNT(R.NEW(TT.TID.LOCAL.REF)<1,POS.LOC.TT.CURRENCY>,SM)
*
  Y.FLG.ERR  = ""
  VAL.NO     = 1
  LOOP
  WHILE VAL.NO LE NO.OF.VLS - 1
    GOSUB VALS.PROCESS
    VAL.NO++
  REPEAT
*
  IF Y.FLG.ERR THEN
    CALL STORE.END.ERROR
  END
*
  RETURN
*
*-----------
ERR.MESSAGE:
*-----------
*
  ETEXT       = "EB-REDO.DUPLICATE.REC"
  AF = TT.TID.LOCAL.REF
  AV = YTEMP
  AS = N.VAL.NO
*
  RETURN
*
*-----------
VALS.PROCESS:
*-----------
*
  N.VAL.NO = VAL.NO + 1
  LOOP
  WHILE N.VAL.NO LE NO.OF.VLS
    GOSUB COMPARE.PROCESS
    N.VAL.NO++
  REPEAT
*
  IF Y.FLG.ERR THEN
    RETURN
  END
*
  RETURN
*
*---------------
COMPARE.PROCESS:
*---------------
*
  FLD.NO = 1
  LOOP
  WHILE FLD.NO LE NO.OF.FLDS
    YTEMP = AF.LIST<FLD.NO>
    IF R.NEW(TT.TID.LOCAL.REF)<1,YTEMP,VAL.NO> <> R.NEW(TT.TID.LOCAL.REF)<1,YTEMP,N.VAL.NO> THEN
      RETURN
    END
    GOSUB DUPL.PROC
    FLD.NO++
  REPEAT
*
  IF Y.FLG.ERR THEN
    RETURN
  END
*
  RETURN
*
*---------
DUPL.PROC:
*---------
*
  IF FLD.NO = NO.OF.FLDS THEN
    Y.FLG.ERR = 1
    GOSUB ERR.MESSAGE
    RETURN
  END
*
  RETURN
*
*----
INIT:
*----
*
  LREF.APP   = 'TELLER.ID'
  LREF.FIELD = 'L.TT.CURRENCY' : VM : 'L.CI.CATEG.CARD'
  LREF.POS   = ''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
  POS.LOC.TT.CURRENCY   = LREF.POS<1,1>
  POS.LOC.CI.CAT.CARD   = LREF.POS<1,2>
*
  AF.LIST = POS.LOC.TT.CURRENCY:FM:POS.LOC.CI.CAT.CARD
*
  RETURN
*
END
