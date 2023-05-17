*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MULTI.TXN.PROCESS.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEEVA T
* PROGRAM NAME: REDO.MULTI.TXN.PROCESS.AUTORTN
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.TFS.REJECT to
* default the value for the REDO.TFS.PROCESS application from REDO.TFS.REJECT
* It is AUTOM NEW CONTENT routine

*IN PARAMETER : NA
*OUT PARAMETER: NA
*LINKED WITH  : REDO.MULTI.TXN.REJECT
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE           WHO           REFERENCE         DESCRIPTION
*11.11.2010     JEEVA T   ODR-2010-08-0017    INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.MULTI.TXN.REJECT
$INSERT I_F.REDO.MULTI.TXN.PROCESS

  GOSUB INIT
  GOSUB PROCESS
  RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------


  FN.REDO.MULTI.TXN.REJECT = 'F.REDO.MULTI.TXN.REJECT'
  F.REDO.MULTI.TXN.REJECT = ''
  CALL OPF(FN.REDO.MULTI.TXN.REJECT,F.REDO.MULTI.TXN.REJECT)
  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

  Y.DATA = ""
  CALL BUILD.USER.VARIABLES(Y.DATA)
  Y.REDO.MULTI.REJECT.ID=FIELD(Y.DATA,"*",2)
  CALL F.READ(FN.REDO.MULTI.TXN.REJECT,Y.REDO.MULTI.REJECT.ID,R.REDO.MULTI.TXN.REJECT,F.REDO.MULTI.TXN.REJECT,REJ.ERR)
  R.NEW(MUL.TXN.PRO.ARRANGEMENT.ID) = R.REDO.MULTI.TXN.REJECT<MUL.TXN.REJ.ARRANGEMENT.ID>

  Y.CNT=DCOUNT(R.REDO.MULTI.TXN.REJECT<MUL.TXN.REJ.CURRENCY>,VM)
  FOR Y.COUNT=1 TO Y.CNT
    R.NEW(MUL.TXN.PRO.TRAN.TYPE)<1,Y.COUNT>= R.REDO.MULTI.TXN.REJECT<MUL.TXN.REJ.TRAN.TYPE,Y.COUNT>
    R.NEW(MUL.TXN.PRO.CURRENCY)<1,Y.COUNT> = R.REDO.MULTI.TXN.REJECT<MUL.TXN.REJ.CURRENCY,Y.COUNT>
    R.NEW(MUL.TXN.PRO.AMOUNT)<1,Y.COUNT>   = R.REDO.MULTI.TXN.REJECT<MUL.TXN.REJ.AMOUNT,Y.COUNT>
  NEXT Y.COUNT

  R.NEW(MUL.TXN.PRO.VALUE.DATE)    = R.REDO.MULTI.TXN.REJECT<MUL.TXN.REJ.VALUE.DATE>
  R.NEW(MUL.TXN.PRO.NO.OF.OD.BILLS)= R.REDO.MULTI.TXN.REJECT<MUL.TXN.REJ.NO.OF.OD.BILLS>
  R.NEW(MUL.TXN.PRO.TOT.AMT.OVRDUE)= R.REDO.MULTI.TXN.REJECT<MUL.TXN.REJ.TOT.AMT.OVRDUE>
  R.NEW(MUL.TXN.PRO.REMARKS)       = R.REDO.MULTI.TXN.REJECT<MUL.TXN.REJ.REMARKS>
  Y.LOAN.STAT                      = R.REDO.MULTI.TXN.REJECT<MUL.TXN.REJ.LOAN.STATUS>
  Y.LOAN.STAT.CNT = DCOUNT(Y.LOAN.STAT,VM)
  FOR STAT = 1 TO Y.LOAN.STAT.CNT
    R.NEW(MUL.TXN.PRO.LOAN.STATUS)<1,STAT> = Y.LOAN.STAT<1,STAT>
  NEXT STAT
  Y.LOAN.COND     = R.REDO.MULTI.TXN.REJECT<MUL.TXN.REJ.LOAN.CONDITION>
  Y.LOAN.COND.CNT = DCOUNT(Y.LOAN.COND,VM)
  FOR COND = 1 TO Y.LOAN.COND.CNT
    R.NEW(MUL.TXN.PRO.LOAN.CONDITION )     = Y.LOAN.COND<1,COND>
  NEXT COND
  RETURN
*------------------------------------------------------------------------------
END
