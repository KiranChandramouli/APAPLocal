*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TT.REJECT.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEEVA T
* PROGRAM NAME: REDO.PART.TT.REJECT.AUTORTN
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.TELLER.REJECT to
* default the value for the REDO.TELLER.PROCESS application from REDO.TELLER.REJECT
* It is AUTOM NEW CONTENT routine
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.PART.TT.PROCESS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*10-11-2010   JEEVA T        ODR-2010-08-0017   Baselined after few logic changes
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.TT.PROCESS
$INSERT I_F.REDO.TT.REJECT

  GOSUB INIT
  GOSUB PROCESS
  RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

  FN.REDO.TT.PROCESS = 'F.REDO.TT.PROCESS'
  F.REDO.TT.PROCESS = ''
  CALL OPF(FN.REDO.TT.PROCESS,F.REDO.TT.PROCESS)

  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

  Y.DATA = ""
  CALL BUILD.USER.VARIABLES(Y.DATA)
  Y.REDO.PART.TT.PROCESS.ID=FIELD(Y.DATA,"*",2)
  CALL F.READ(FN.REDO.TT.PROCESS,Y.REDO.PART.TT.PROCESS.ID,R.REDO.TT.PROCESS,F.REDO.TT.PROCESS,PRO.ERR)

  Y.AA.ID          = R.REDO.TT.PROCESS<TT.PRO.ARRANGEMENT.ID>
  Y.CURRENCY       = R.REDO.TT.PROCESS<TT.PRO.CURRENCY>
  Y.TRAN.TYPE      = R.REDO.TT.PROCESS<TT.PRO.TRAN.TYPE>
  Y.TRAN.CODE      = R.REDO.TT.PROCESS<TT.PRO.TRAN.CODE>
  Y.AMOUNT         = R.REDO.TT.PROCESS<TT.PRO.AMOUNT>
  Y.VALUE.DATE     = R.REDO.TT.PROCESS<TT.PRO.VALUE.DATE>
  Y.NOF.BILLS      = R.REDO.TT.PROCESS<TT.PRO.NO.OF.OD.BILLS>
  Y.TOT.AMT.OVRDUE = R.REDO.TT.PROCESS<TT.PRO.TOT.AMT.OVRDUE>
  Y.REMARKS        = R.REDO.TT.PROCESS<TT.PRO.REMARKS>
  Y.LOAN.STAT      = R.REDO.TT.PROCESS<TT.PRO.LOAN.STATUS>
  Y.LOAN.STAT.CNT  = DCOUNT(Y.LOAN.STAT,VM)
  Y.LOAN.COND      = R.REDO.TT.PROCESS<TT.PRO.LOAN.CONDITION>
  Y.LOAN.COND.CNT  = DCOUNT(Y.LOAN.COND,VM)

  R.NEW(TT.REJ.ARRANGEMENT.ID)   = Y.AA.ID
  Y.CHECK = R.NEW(TT.REJ.ARRANGEMENT.ID)

  R.NEW(TT.REJ.CURRENCY)         = Y.CURRENCY
  Y.CHECK1 = R.NEW(TT.REJ.CURRENCY)
  R.NEW(TT.REJ.TRAN.TYPE)        = Y.TRAN.TYPE

  R.NEW(TT.REJ.TRAN.CODE)        = Y.TRAN.CODE

  R.NEW(TT.REJ.AMOUNT)           = Y.AMOUNT

  R.NEW(TT.REJ.VALUE.DATE)       = Y.VALUE.DATE

  R.NEW(TT.REJ.NO.OF.OD.BILLS)   = Y.NOF.BILLS

  R.NEW(TT.REJ.TOT.AMT.OVRDUE)   = Y.TOT.AMT.OVRDUE

  R.NEW(TT.REJ.REMARKS)          = Y.REMARKS

  FOR STAT=1 TO Y.LOAN.STAT.CNT
    R.NEW(TT.REJ.LOAN.STATUS.1)<1,STAT> = Y.LOAN.STAT<1,STAT>
  NEXT STAT

  FOR COND=1 TO Y.LOAN.COND.CNT
    R.NEW(TT.REJ.LOAN.CONDITION)<1,COND> = Y.LOAN.COND<1,COND>
  NEXT COND

  RETURN
*--------------------------------------------------------------------------
END
