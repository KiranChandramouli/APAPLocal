*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.LETTER.OFFICER
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.VAL.LETTER.OFFICER
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Validation Routine for REDO.LETTER.ISSUE to
*default the value for the fields



*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.03.2010  H GANESH     ODR-2009-10-0838   INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LETTER.ISSUE
$INSERT I_F.REDO.OFFICERS.LIST

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN


*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

  FN.REDO.OFFICERS.LIST='F.REDO.OFFICERS.LIST'
  F.REDO.OFFICERS.LIST=''
  RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------

  CALL OPF(FN.REDO.OFFICERS.LIST,F.REDO.OFFICERS.LIST)

  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
  Y.ISSUE.OFFICER=COMI
  CALL F.READ(FN.REDO.OFFICERS.LIST,Y.ISSUE.OFFICER,R.REDO.OFFICERS.LIST,F.REDO.OFFICERS.LIST,REDO.OFF.ERR)
  R.NEW(REDO.LET.ISS.DESIGNATION)=R.REDO.OFFICERS.LIST<REDO.OFF.LIS.DESIGNATION>
  R.NEW(REDO.LET.ISS.BRANCH)=R.REDO.OFFICERS.LIST<REDO.OFF.LIS.DEPT.BRANCH>
  R.NEW(REDO.LET.ISS.ISSUE.DATE)=TODAY

  RETURN
