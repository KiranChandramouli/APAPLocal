*-----------------------------------------------------------------------------
* <Rating>-46</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE VERSION.EXT.EXECUTE

*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for TELLER VERSIONS
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : IVAN ROMAN
* PROGRAM NAME : VERSION.EXT.EXECUTE
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*       DATE             WHO                REFERENCE         DESCRIPTION
*       20-01-2012       IVAN ROMAN         VERSION.EXT       Execute routines in versions
* -----------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
*
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER.TRANSACTION
$INSERT I_F.FT.COMMISSION.TYPE
$INSERT I_F.FT.TXN.TYPE.CONDITION
$INSERT I_F.VERSION
* New table
$INSERT I_F.VERSION.EXT
$INSERT I_F.STANDARD.SELECTION
*


  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END
*
  RETURN
*
* ======
PROCESS:
* ======
*
* Read record

  IN.FIELD.NUMBER = AF

  CALL EB.FIELD.NUMBERS.TO.NAMES(IN.FIELD.NUMBER,FIELD.NAME,ERR.MSG)

  CALL F.READ(FN.VERSION.EXT,Y.WORK.FIELD,R.VERSION.EXT,F.VERSION.EXT,Y.ERR)

  XX = RAISE(R.VERSION.EXT<VE.EX.FIELD.NAME>)

  LOCATE FIELD.NAME IN XX<1> SETTING FIELD.POS THEN

    ROUTINES = RAISE(R.VERSION.EXT<VE.EX.ROUTINE.NAME,FIELD.POS>)

  END
****
* Count and execute Routines
* Modifed below from FOR...NEXT to LOOP...REPEAT as part of the code review
****
  NO.OF.RTN = DCOUNT(ROUTINES,VM)
  NO.OF.IT = 1
  LOOP
    EXECUTE.ROUTINE = ROUTINES<1,NO.OF.IT>
  WHILE (NO.OF.IT LE NO.OF.RTN)
*
    IF ROUTINES<1,NO.OF.IT> NE '' THEN
      EXECUTE.ROUTINE = ROUTINES<1,NO.OF.IT>
      CALL @EXECUTE.ROUTINE
    END
*
    NO.OF.IT++
*
  REPEAT
*
  RETURN
*
* =========
OPEN.FILES:
* =========
*
  CALL OPF(FN.VERSION.EXT,F.VERSION.EXT)

  CALL OPF(FN.STANDARD.SELECTION,F.STANDARD.SELECTION)

  RETURN
*
* =========
INITIALISE:
* =========
*
  LOOP.CNT        = 1
  MAX.LOOPS       = 1
  PROCESS.GOAHEAD = 1

  Y.EXE.INC.RTN   = R.VERSION(EB.VER.EXC.INC.RTN)
  Y.VERSION.TYPE  = R.VERSION(EB.VER.VERSION.TYPE)
  Y.WORK.FIELD    = ''

  FN.VERSION.EXT  = 'F.VERSION.EXT'
  F.VERSION.EXT   = ''
  R.VERSION.EXT   = ''
  Y.ERR           = ''

  FN.STANDARD.SELECTION = 'F.STANDARD.SELECTION'
  F.STANDARD.SELECTION  = ''
  R.STANDARD.SELECTION  = ''
  Y.STANDARD.SELECTION.ID = ''
  Y.ERR                 = ''

  FIELD.NAME      = ''
  ERR.MSG         = ''

  NO.OF.RTN       = 0
  NO.OF.IT        = 0

  RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
* Validate Y.WORK.FIELD

  IF Y.EXE.INC.RTN EQ 'YES' THEN
    IF Y.VERSION.TYPE THEN
      Y.WORK.FIELD = APPLICATION : "," : Y.VERSION.TYPE
    END ELSE
      Y.WORK.FIELD = APPLICATION
    END
  END ELSE
*       Y.EXE.INC.RTN EQ 'NO' THEN
    Y.WORK.FIELD = APPLICATION:PGM.VERSION
  END

*
  RETURN
*
END
