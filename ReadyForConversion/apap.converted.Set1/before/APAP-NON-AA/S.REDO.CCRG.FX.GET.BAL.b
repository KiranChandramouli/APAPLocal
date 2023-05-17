*-----------------------------------------------------------------------------
* <Rating>-52</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE S.REDO.CCRG.FX.GET.BAL(P.CONTRACT.ID, R.FX, P.RETURN)
*
*--------------------------------------------------------------------------------------------
* Company Name : Bank Name
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description: This program get the balances for the contract in ARRANGEMENT application
*
*
* Linked With:
*               SERVICE      REDO.CCRG.B.EXT
*               PARAMETER in REDO.CCRG.PARAMETERS field P.EVALUATOR.RTN
*
* In Parameter:
*               P.CONTRACT.ID    (in)  Contranct Id.
*               R.FX             (in)  Record of the contract in process
*
* Out Parameter:
*               P.RETURN     (out)  Returns balances related: 1 Direct Balance, 2 Income Receivable, 3 Balance Contingent
*               E            (out)  Message in case Error
*
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 18/04/2011 - ODR-2011-03-0154
*              Description of the development associated
*              anoriega@temenos.com
*REM Just for compile
*--------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_REDO.CCRG.B.EXT.COMMON
$INSERT I_REDO.CCRG.CONSTANT.COMMON
*
$INSERT I_F.FOREX

*
*--------------------------------------------------------------------------------------------
*


  GOSUB INITIALISE
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

*
  RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------


*Initialise
  Y.DB = 0
  Y.RB = 0
  Y.CB = 0

*Get Direct Balance
  Y.DB = ABS(R.FX<FX.BUY.LCY.EQUIV>)

*Balances to send go out
  P.RETURN<1> = ABS(Y.DB)
  P.RETURN<2> = ABS(Y.RB)
  P.RETURN<3> = ABS(Y.CB)

  RETURN

*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

  LOOP.CNT         = 1
  MAX.LOOPS        = 2
  PROCESS.GOAHEAD  = @TRUE
  P.RETURN         = ''

  RETURN

*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------

  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1
      IF NOT(P.CONTRACT.ID) THEN
        E = K.PARAMETER.IS.EMPTY : FM : "P.CONTRACT.ID" : VM : "S.REDO.CCRG.FX.GET.BAL"
        PROCESS.GOAHEAD = @FALSE
      END
    CASE LOOP.CNT EQ 2
      IF NOT(R.FX) THEN
        E = K.PARAMETER.IS.EMPTY : FM : "R.FX" : VM : "S.REDO.CCRG.FX.GET.BAL"
        PROCESS.GOAHEAD = @FALSE
      END
    END CASE

    LOOP.CNT +=1
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------

END
