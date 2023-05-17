*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.SUNNEL.UPDATE
*-----------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RIYAS
* PROGRAM NAME : REDO.V.INP.SUNNEL.UPDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 27-AUG-2011      Riyas               R35          Initial creation
*-----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.VERSION
$INSERT I_F.TELLER
$INSERT I_GTS.COMMON
$INSERT I_System
$INSERT I_REDO.TELLER.PROCESS.COMMON
$INSERT I_F.REDO.SUNNEL.CARD.DETAILS
  FN.SUNNEL.DETAILS = 'F.REDO.SUNNEL.CARD.DETAILS'
  F.SUNNEL.DETAILS  = ''
  CALL OPF(FN.SUNNEL.DETAILS,F.SUNNEL.DETAILS)
  LREF.APP = 'TELLER'
  LREF.POS = ''
  LREF.FIELDS='L.TT.CR.CARD.NO':VM:'L.TT.AC.STATUS':VM:'L.TT.CR.ACCT.NO'
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
  Y.CARD.NO.POS      = LREF.POS<1,1>
  Y.CARD.ACCT.ST.POS = LREF.POS<1,2>
  Y.CR.ACCT.NO.POS   = LREF.POS<1,3>
  Y.ACCT = R.NEW(TT.TE.LOCAL.REF)<1,Y.CR.ACCT.NO.POS>
  VAR.CARD.NO = R.NEW(TT.TE.LOCAL.REF)<1,Y.CARD.NO.POS>
  Y.ACCT.NO   = ''
  Y.CARD.TYPE = ''
  CALL F.READ(FN.SUNNEL.DETAILS,Y.ACCT,R.SUNNEL.DETAILS,F.SUNNEL.DETAILS,SUNNEL.ERR)
  IF NOT(R.SUNNEL.DETAILS) THEN
    Y.PRESENT.CARD.ID = System.getVariable("CURRENT.CARD.NO")

    CALL REDO.GET.CARD.TYPE(Y.PRESENT.CARD.ID,Y.ACCT,Y.CARD.TYPE)
    R.SUNNEL.DETAILS<SUN.CARD.TYPE> = Y.CARD.TYPE
    CALL F.WRITE(FN.SUNNEL.DETAILS,Y.ACCT,R.SUNNEL.DETAILS)
  END
  RETURN
END
