*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.PORTFOLIO(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Pradeep S
* PROGRAM NAME: REDO.DS.PORTFOLIO
* PACS REF    : PACS00051213
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the PORTFOLIO used

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SEC.ACC.MASTER

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN

INIT:
*****
  FN.SAM = 'F.SEC.ACC.MASTER'
  F.SAM = ''

  RETURN

OPENFILES:
**********
  CALL OPF(FN.SAM,F.SAM)
  RETURN

PROCESS:
********

  SAM.ID = Y.RET


  CALL F.READ(FN.SAM,SAM.ID,R.SAM,F.SAM,SAM.ERR)
  Y.PORTFOLIO.NAME = R.SAM<SC.SAM.ACCOUNT.NAME>

  Y.RET = Y.PORTFOLIO.NAME

  RETURN

END
