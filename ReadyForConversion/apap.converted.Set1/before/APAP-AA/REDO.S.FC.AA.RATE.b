*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FC.AA.RATE(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA ARRANGEMENT ACTIVITY>EFFECTIVE.DATE  field
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.INTEREST.ACCRUALS

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
  CALL F.READ(FN.AA.INT.ACCRUALS,Y.ARRG.ID,R.AA.INT.ACCRUALS,F.AA.INT.ACCRUALS,"")
  IF R.AA.INT.ACCRUALS THEN
    AA.ARR = R.AA.INT.ACCRUALS<AA.INT.ACC.RATE,1>
  END
  RETURN
*------------------------
INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
  Y.ARRG.ID = AA.ID:"-PRINCIPALINT"

  FN.AA.INT.ACCRUALS = "F.AA.INTEREST.ACCRUALS"
  F.AA.INT.ACCRUALS  = ""
  R.AA.INT.ACCRUALS  = ""
  AA.ARR = 'NULO'
  RETURN

*------------------------
OPEN.FILES:
*=========
  CALL OPF(FN.AA.INT.ACCRUALS, F.AA.INT.ACCRUALS)
  RETURN
*------------
END
