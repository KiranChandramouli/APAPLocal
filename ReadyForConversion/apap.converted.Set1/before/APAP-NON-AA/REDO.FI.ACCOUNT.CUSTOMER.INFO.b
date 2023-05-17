*-----------------------------------------------------------------------------
* <Rating>-53</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FI.ACCOUNT.CUSTOMER.INFO(I.ACCOUNT, O.CUSTOMER.INFO, O.ERROR.MSG)
*
******************************************************************************
*
*    Routine for return customer account information
*    Parameters:
*        I.ACCOUNT:  Input parameter is a valid T24 Account number
*        O.CUSTOMER.INFO: Output parameter to send customer information
*        O.ERR.MSG:  Output parameter to send the ERROR message get in the process
*
* =============================================================================
*
*    First Release : R09
*    Developed for : APAP
*    Developed by  : Cristhian Herrera
*    Date          : 2012/Abr/09
*
*=======================================================================
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER

*
*************************************************************************
*
* DEBUG
  GOSUB INITIALISE
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
*
  LOOP.CNT            = 1
  MAX.LOOPS           = 1
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD  DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1        ;*



    END CASE
    IF O.ERROR.MSG THEN

      GOSUB CONTROL.MSG.ERROR ;*    MESSAGE ERROR
    END
    LOOP.CNT +=1
  REPEAT

  IF O.ERROR.MSG THEN
    Y.ERR.MSG = O.ERROR.MSG
  END

  IF PROCESS.GOAHEAD THEN
    GOSUB READ.CUSTOMER.INFO

  END

*
  RETURN

* -----------------
READ.CUSTOMER.INFO:
* -----------------

  W.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>

  CALL CACHE.READ(FN.CUSTOMER,W.CUSTOMER,R.CUSTOMER, Y.ERR)
  IF Y.ERR THEN
    PROCESS.GOAHEAD = 0
    E = "EB-PARAMETER.MISSING"
    CALL ERR
  END

  O.CUSTOMER.INFO = ""
  O.CUSTOMER.INFO<1> = W.CUSTOMER
  O.CUSTOMER.INFO<2> = R.CUSTOMER<EB.CUS.SHORT.NAME>


  RETURN

*
* ---------
INITIALISE:
* ---------
*
*   WORK VARIABLES
  PROCESS.GOAHEAD         = 1
  LOOP.CNT                = ""
  MAX.LOOPS               = ""

  O.ERROR.MSG             = ""
  ERR.TEXT                = ""
  Y.ERR                   = ""

  F.ACCOUNT               = ""
  FN.ACCOUNT              = "F.ACCOUNT"
  R.ACCOUNT               = ""
  W.ACCOUNT               = I.ACCOUNT

  F.CUSTOMER              = ""
  FN.CUSTOMER             = "F.CUSTOMER"
  R.CUSTOMER              = ""
  W.CUSTOMER              = ""
  FI.PATH.REJ             = ""

  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  CALL CACHE.READ(FN.ACCOUNT,W.ACCOUNT,R.ACCOUNT, Y.ERR)
  IF Y.ERR THEN
    PROCESS.GOAHEAD = 0
    E = "EB-PARAMETER.MISSING"
    CALL ERR
  END


  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  RETURN

* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph

  IF O.ERROR.MSG THEN
    E.TEXT     = O.ERROR.MSG
    Y.NAME.DIR = FI.PATH.REJ
  END
*
  IF ERR.TEXT THEN
    PROCESS.GOAHEAD = 0
    ETEXT           = ERR.TEXT
    O.ERR.MSG       = ""
    CALL STORE.END.ERROR
    O.ERROR.MSG     = ETEXT
    ETEXT           = ""
  END
*
  RETURN

*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
  LOOP.CNT            = 1
  MAX.LOOPS           = 1

  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1        ;*


    END CASE
    LOOP.CNT +=1
  REPEAT

*   MESSAGE ERROR
  IF O.ERROR.MSG THEN
    GOSUB CONTROL.MSG.ERROR
  END
*
  RETURN
*

END
