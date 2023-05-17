*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MULTI.TXN.REJECT.AUTORTN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEEVA T
* PROGRAM NAME: REDO.MULTI.TXN.REJECT.AUTORTN
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.PART.TFS.REJECT to
* default the value for the REDO.PART.TFS.REJECT application from REDO.PART.TFS.PROCESS
* It is AUTOM NEW CONTENT routine

*IN PARAMETER : NA
*OUT PARAMETER: NA
*LINKED WITH  : REDO.MULTI.TXN.REJECT
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE           WHO           REFERENCE         DESCRIPTION
*JEEVA T        11-11-2010      B.12            INTIAL CREATION
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


  FN.REDO.MULTI.TXN.PROCESS = 'F.REDO.MULTI.TXN.PROCESS'
  F.REDO.MULTI.TXN.PROCESS = ''
  CALL OPF(FN.REDO.MULTI.TXN.PROCESS,F.REDO.MULTI.TXN.PROCESS)
  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

  Y.DATA = ""
  CALL BUILD.USER.VARIABLES(Y.DATA)
  Y.REDO.MULTI.PROCESS.ID=FIELD(Y.DATA,"*",2)
  CALL F.READ(FN.REDO.MULTI.TXN.PROCESS,Y.REDO.MULTI.PROCESS.ID,R.REDO.MULTI.TXN.PROCESS,F.REDO.MULTI.TXN.PROCESS,PRO.ERR)
  R.NEW(MUL.TXN.REJ.ARRANGEMENT.ID) = R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.ARRANGEMENT.ID>

  Y.CNT=DCOUNT(R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.CURRENCY>,VM)
  FOR Y.COUNT=1 TO Y.CNT
    R.NEW(MUL.TXN.REJ.TRAN.TYPE)<1,Y.COUNT>=R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.TRAN.TYPE,Y.COUNT>
    R.NEW(MUL.TXN.REJ.CURRENCY)<1,Y.COUNT> =R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.CURRENCY,Y.COUNT>
    R.NEW(MUL.TXN.REJ.AMOUNT)<1,Y.COUNT>   =R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.AMOUNT,Y.COUNT>
    R.NEW(MUL.TXN.REJ.TRAN.CODE)<1,Y.COUNT>=R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.TRAN.CODE,Y.COUNT>
  NEXT Y.COUNT

  R.NEW(MUL.TXN.REJ.VALUE.DATE)     = R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.VALUE.DATE>
  R.NEW(MUL.TXN.REJ.NO.OF.OD.BILLS) = R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.NO.OF.OD.BILLS>
  R.NEW(MUL.TXN.REJ.TOT.AMT.OVRDUE) = R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.TOT.AMT.OVRDUE>
  R.NEW(MUL.TXN.REJ.REMARKS)        = R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.REMARKS>

  Y.LOAN.STAT = R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.LOAN.STATUS>
  Y.LOAN.STAT.CNT = DCOUNT(Y.LOAN.STAT,VM)
  FOR STAT = 1 TO Y.LOAN.STAT.CNT
    R.NEW(MUL.TXN.REJ.LOAN.STATUS)<1,STAT> = Y.LOAN.STAT<1,STAT>
  NEXT STAT

  Y.LOAN.COND = R.REDO.MULTI.TXN.PROCESS<MUL.TXN.PRO.LOAN.CONDITION>
  Y.LOAN.COND.CNT = DCOUNT(Y.LOAN.COND,VM)
  FOR COND = 1 TO Y.LOAN.COND.CNT
    R.NEW(MUL.TXN.REJ.LOAN.CONDITION)<1,COND> = Y.LOAN.COND<1,COND>
  NEXT COND
  RETURN
*------------------------------------------------------------------------------
END
