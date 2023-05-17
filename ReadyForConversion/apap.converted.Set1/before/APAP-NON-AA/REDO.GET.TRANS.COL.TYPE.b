*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.TRANS.COL.TYPE(Y.TYPE)
*-----------------------------------------------------------------------------
* PACS00256738
** Marimuthu S

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.PART.TT.PROCESS


  Y.TYPE = R.NEW(PAY.PART.TT.TRAN.TYPE)
  Y.LOOKUP.ID   = "PAYMENT.METHOD"
  Y.LOOOKUP.VAL = Y.TYPE
  Y.DESC.VAL    = ''
  CALL REDO.EB.LOOKUP.LIST(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2)

  Y.TYPE = Y.DESC.VAL

  RETURN


END
