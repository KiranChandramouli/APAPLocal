*-----------------------------------------------------------------------------

* <Rating>-52</Rating>

*-----------------------------------------------------------------------------

*

  SUBROUTINE REDO.FI.GET.AA.BALS(IN.ACCT.ID,IN.BAL.TYPE,OUT.BAL.ARR)

*

*   ==================================================================

*

*    Gets TODAY's balances for each of the AA properties required

*

*   ==================================================================

*

*    IN PARAMS

*

*       IN.ACCT.ID  - Account ID. linked to the Arrangement -

*                     could be taken from the LINKED.APPL.ID in AA.ARRANGEMENT record

*       IN.BAL.TYPE - Dynamic Array containing the LIST of BALANCES to get

*                     may include REAL or VIRTUAL BALANCES

*

*   ------------------------------------------------------------------

*

*    OUT PARAM

*

*        OUT.BAL.ARR - Dynamic array containing the required BALANCES

*                      in same order as required in IN.BAL.TYPE parameter

*

*   ==================================================================

*

*    MODIFICATION HISTORY

*

*

*   ==================================================================

*

$INSERT I_COMMON

$INSERT I_EQUATE

*

$INSERT I_F.AC.BALANCE.TYPE

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

  YCOUNT.BAL.ID  = 0

  YLIST.BALANCES = ""

*

  LOOP

    REMOVE BALANCE.ID FROM IN.BAL.TYPE SETTING YPOS.BAL

  WHILE BALANCE.ID : YPOS.BAL

    R.AC.BALANCE.TYPE  = ''

    YCALC.BALANCE      = 0

    YCOUNT.BAL.ID     += 1

    CALL CACHE.READ(FN.AC.BALANCE.TYPE, BALANCE.ID, R.AC.BALANCE.TYPE, YERR.ABT)

    IF R.AC.BALANCE.TYPE THEN

      COMPONENTS.LIST = ""

      COMPONENTS.LIST = LOWER(R.AC.BALANCE.TYPE<AC.BT.VIRTUAL.BAL>)

      IF COMPONENTS.LIST EQ "" THEN

        COMPONENTS.LIST = BALANCE.ID

      END

      GOSUB  A100.GET.BALANCE

    END

*

    OUT.BAL.ARR<YCOUNT.BAL.ID> = YCALC.BALANCE

*

  REPEAT

*

  RETURN

*

* ===============

A100.GET.BALANCE:

* ===============

*

  REQUEST.TYPE       = ""

  REQUEST.TYPE<2>    = "ALL"

  REQUEST.TYPE<3>    = "ALL"

  ST.DATE            = TODAY

  END.DATE           = TODAY

  SYSTEM.DATE        = ""

*

  LOOP

    REMOVE BALANCE.ID FROM COMPONENTS.LIST SETTING YPOS.BAL

  WHILE BALANCE.ID : YPOS.BAL

    CALL AA.GET.PERIOD.BALANCES(IN.ACCT.ID,BALANCE.ID,REQUEST.TYPE,ST.DATE,END.DATE,SYSTEM.DATE,BAL.DETAILS,YERR.BAL)

    YCALC.BALANCE += BAL.DETAILS<4>

  REPEAT

*

  RETURN

*

*

* =========

INITIALISE:

* =========

*

  PROCESS.GOAHEAD = 1

  LOOP.CNT        = 1

  MAX.LOOPS       = 1

*

  FN.AC.BALANCE.TYPE = 'F.AC.BALANCE.TYPE'

  F.AC.BALANCE.TYPE  = ''

*

  RETURN

*

* =========

OPEN.FILES:

* =========

*

  CALL OPF(FN.AC.BALANCE.TYPE, F.AC.BALANCE.TYPE)

*

  RETURN

*

* ======================

CHECK.PRELIM.CONDITIONS:

* ======================

*

  LOOP

  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

    BEGIN CASE



    CASE LOOP.CNT EQ 1

      IF IN.ACCT.ID = "" THEN

        PROCESS.GOAHEAD = 0

      END

    END CASE



    LOOP.CNT +=1

  REPEAT

*

  RETURN

*



END
