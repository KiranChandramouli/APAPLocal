*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LY.V.PROGFORA
**
* Subroutine Type : VERSION
* Attached to     : REDO.LY.PROGAERO,NEW
* Attached as     : INPUT.ROUTINE
* Primary Purpose : Validate if program selected is marked as "Airline Program".
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 3/12/13 - First Version
*           ODR Reference: ODR-2011-06-0243
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*           Roberto Mondragon - TAM Latin America
*           rmondragon@temenos.com
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_F.REDO.LY.PROGRAM
$INSERT I_F.REDO.LY.PROGAERO

  GOSUB OPEN.FILES
  Y.PROGRAM = R.NEW(REDO.PA.PROGRAM.ID)
  GOSUB PROCESS

  RETURN

***********
OPEN.FILES:
***********

  FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
  F.REDO.LY.PROGRAM = ''
  CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

  RETURN

********
PROCESS:
********

  Y.TOT.PROGRAMS = DCOUNT(Y.PROGRAM,VM)

  CNT.PROG = 1
  LOOP
  WHILE CNT.PROG LE Y.TOT.PROGRAMS
    Y.PROGRAM.ID = FIELD(Y.PROGRAM,VM,CNT.PROG)
    R.PROG = ''; PROG.ERR = ''
    CALL F.READ(FN.REDO.LY.PROGRAM,Y.PROGRAM.ID,R.PROG,F.REDO.LY.PROGRAM,PROG.ERR)
    IF R.PROG THEN
      Y.PROG.AIRLINE = R.PROG<REDO.PROG.AIRL.PROG>
    END

    GOSUB VAL.PROG

    CNT.PROG++
  REPEAT

  RETURN

*********
VAL.PROG:
*********

  IF Y.PROG.AIRLINE EQ 'NO' THEN
    AF = REDO.PA.PROGRAM.ID
    AV = CNT.PROG
    ETEXT = 'EB-REDO.LY.V.PROGFORA'
    CALL STORE.END.ERROR
    CNT.PROG = Y.TOT.PROGRAMS + 1
    RETURN
  END

  CNT.DUP = 1
  LOOP
  WHILE CNT.DUP LE Y.TOT.PROGRAMS
    Y.PROGRAM.DUP = FIELD(Y.PROGRAM,VM,CNT.DUP)
    IF (CNT.PROG NE CNT.DUP) AND (Y.PROGRAM.ID EQ Y.PROGRAM.DUP) THEN
      AF = REDO.PA.PROGRAM.ID
      AV = CNT.DUP
      ETEXT = 'EB-REDO.LY.V.PROGFORA2'
      CALL STORE.END.ERROR
      CNT.DUP = Y.TOT.PROGRAMS + 1
      CNT.PROG = Y.TOT.PROGRAMS + 1
    END
    CNT.DUP++
  REPEAT

  RETURN

END
