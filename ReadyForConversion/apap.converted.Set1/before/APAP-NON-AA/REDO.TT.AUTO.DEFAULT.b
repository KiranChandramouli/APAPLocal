*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TT.AUTO.DEFAULT
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: N. Satheesh Kumar
* PROGRAM NAME: REDO.TT.AUTO.DEFAULT
* ODR NO      : ODR-2009-10-0331
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for TELLER to
* default the value for the TELLER application
* It is AUTOM NEW CONTENT routine

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE               WHO           REFERENCE         DESCRIPTION
*29.06.2010 N. Satheesh Kumar   ODR-2009-10-0331   INITIAL CREATION
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.AA.OVERDUE

  GOSUB MULTI.GET.LOC.REF
  GOSUB PROCESS
  RETURN

*----------------------------------------------------------------------
MULTI.GET.LOC.REF:
*----------------------------------------------------------------------

  LOC.REF.APPLICATION = "TELLER":FM:'AA.PRD.DES.OVERDUE'
  LOC.REF.FIELDS = 'L.TT.DUE.PRS':VM:'L.LOAN.STATUS.1':VM:'L.LOAN.COND':FM
  LOC.REF.FIELDS := 'L.LOAN.STATUS.1':VM:'L.LOAN.COND'
  LOC.REF.POS = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.TT.DUE.PRS = LOC.REF.POS<1,1>
  TT.LOAN.STATUS.POS = LOC.REF.POS<1,2>
  TT.LOAN.COND.POS = LOC.REF.POS<1,3>
  OD.LOAN.STATUS.POS = LOC.REF.POS<2,1>
  OD.LOAN.COND.POS = LOC.REF.POS<2,2>

  RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
  IF R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.DUE.PRS> EQ '' THEN

    IN.ACC.ID=COMI
    CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
    GOSUB GET.OVERDUE
  END


  CALL REDO.V.VAL.DEFAULT.AMT

  RETURN
*----------------------------------------------------------------------
GET.OVERDUE:
*----------------------------------------------------------------------

  PROP.CLASS = 'OVERDUE'
  PROPERTY = ''
  R.Condition = ''
  ERR.MSG = ''
  EFF.DATE = ''
  CALL REDO.CRR.GET.CONDITIONS(OUT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
  LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
  LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>
  CHANGE SM TO VM IN LOAN.STATUS
  CHANGE SM TO VM IN LOAN.COND
  R.NEW(TT.TE.LOCAL.REF)<1,TT.LOAN.STATUS.POS> = LOAN.STATUS
  R.NEW(TT.TE.LOCAL.REF)<1,TT.LOAN.COND.POS> = LOAN.COND

  RETURN
END
