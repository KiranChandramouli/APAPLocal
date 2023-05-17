*-----------------------------------------------------------------------------
* <Rating>-61</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.COL.GET.PERIOD.BALANCE(Y.ACCOUNT.ID, Y.PROCESS.DATE, R.STATIC.MAPPING, Y.AA.STATUS, Y.AA.PROPERTY, Y.OUT.AA.AMOUNT)
******************************************************************************
*
*    Field PERIOD.BALANCE on Collector-Interface
*
* =============================================================================
*
*    First Release : TAM
*    Developed for : TAM
*    Developed by  : APAP
*    Date          : 2010-11-15 C.1 Collector Interface
*
*=======================================================================
*
$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_F.ACCT.ACTIVITY
$INSERT I_REDO.COL.CUSTOMER.COMMON
*
*************************************************************************
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
*
* Y.AA.STATUS = "STATUS"
* Y.AA.PROPERTY = "ACCOUNT" OR "INTEREST"
* Y.AA.AMOUNT = ""
  ;
* CAPITAL:
* CUR : Vigente      - 1
* AGE : Moroso       - 2
* DUE : Vencido      - 3
  ;
* INTEREST
* ACC : Vigente      - 1
* AGE : Moroso       - 2
* DUE : Vencido      - 3

  Y.MAP.VALUE = Y.AA.STATUS
  BEGIN CASE
  CASE Y.AA.PROPERTY EQ "ACCOUNT"
    Y.MAP.TYPE = "CAPITAL.STATUS"
  CASE Y.AA.PROPERTY EQ "INTEREST"
    Y.MAP.TYPE = "INTEREST.STATUS"
  CASE 1
    E = "ERROR, PROPERTY & WAS NOT DEFINED INTO MAPPING"
    E<2> = Y.AA.PROPERTY
    RETURN
  END CASE

  E = ""
  CALL REDO.R.COL.GET.MAPPING(C.ID.STATIC.MAPPING, R.STATIC.MAPPING, 1, R.STATIC.MAPPING, Y.MAP.TYPE, Y.MAP.VALUE)
  IF E THEN
    RETURN
  END

  Y.AA.STATUS = Y.MAP.VALUE
  BALANCE.TO.CHECK = Y.AA.STATUS : Y.AA.PROPERTY
  BAL.DETAILS = ""
  DATE.OPTIONS = ''
  DATE.OPTIONS<2> = "ALL"     ;* Request NAU movements
  PRESENT.VALUE = ''          ;* THe current balance figure
  ACCOUNT.ID = Y.ACCOUNT.ID
  CALL AA.GET.PERIOD.BALANCES(ACCOUNT.ID, BALANCE.TO.CHECK, DATE.OPTIONS, '', Y.PROCESS.DATE, '', BAL.DETAILS, "")      ;* Get the balance for this date
  Y.OUT.AA.AMOUNT = ABS(BAL.DETAILS<IC.ACT.BALANCE>)        ;* Get the current outstanding amount

  RETURN
*
*
* ---------
INITIALISE:
* ---------
*
  PROCESS.GOAHEAD = 1
*
*
  RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*
  RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
  LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
*    LOOP
*    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
*        BEGIN CASE
*        CASE LOOP.CNT EQ 1
*
*             IF condicion-de-error THEN
*                PROCESS.GOAHEAD = 0
*                E = "EB-mensaje-de-error-para-la-tabla-EB.ERROR"
*             END
**
*        END CASE
*        LOOP.CNT +=1
*    REPEAT
*
  RETURN
*
END
