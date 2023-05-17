*-----------------------------------------------------------------------------
* <Rating>-150</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.FORM.SEL.STMT(IN.FILE, IN.FIXED, IN.SORT, OUT.SELECT)
******************************************************************************************************************
* Component Description:
*    This routine builds the SELECT statement based on the selection criteria from the enquiry
*
* Input/Output
* ------------
* IN.FILE  :  Application Name
* IN.FIXED :  Fixed selection of the enquiry
* IN.SORT  :  Sorting field name
* OUT.SELECT : Select statement
*
* Dependencies
* ------------
* CALLS:
*
* CALLED BY:
*
*-----------------------------------------------------------------------------------------------------------------
* REVISION HISTORY
*
* Date            By Who                 Reference                                   Reason
*
* 08.12.31        N. Satheesh Kumar
******************************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.STANDARD.SELECTION

  GOSUB INIT
  GOSUB OPEN.FILES
  GOSUB BUILD.SELECT.STMT

  RETURN

*----
INIT:
*----

  YFIRST.COND = 1
  YFIXED = TRIM(IN.FIXED, '', "B")
  YSORT = TRIM(IN.SORT, '', "B")
  OUT.SELECT = ''
  RETURN

*----------
OPEN.FILES:
*----------

  FN.STANDARD.SELECTION = 'F.STANDARD.SELECTION'
  CALL OPF(FN.STANDARD.SELECTION, F.STANDARD.SELECTION)
  RETURN

*-----------------
BUILD.SELECT.STMT:
*-----------------

  CALL F.READ(FN.STANDARD.SELECTION, DATA.FILE.NAME, R.SS, F.STANDARD.SELECTION, YERR)

  IF YERR THEN
    ENQ.ERROR<-1> = YERR
    RETURN
  END

  YUSR.FIELD.NAME = R.SS<SSL.USR.FIELD.NAME>
  YUSR.TYPE = R.SS<SSL.USR.TYPE>
  OUT.SELECT = "SELECT " : IN.FILE
  YCOUNT = DCOUNT(D.FIELDS, @FM)

  FOR I = 1 TO YCOUNT
    LOCATE D.FIELDS<I> IN YUSR.FIELD.NAME<1, 1> SETTING YPOS ELSE
      CONTINUE
    END

    IF YUSR.TYPE<1, YPOS> = "R" THEN
      CONTINUE
    END

    GOSUB BUILD.SELECT.CONDITION
  NEXT I

  YCOUNT = DCOUNT(YFIXED, @FM)
  FOR I = 1 TO YCOUNT
    IF YFIRST.COND = 1 THEN
      OUT.SELECT := " WITH "
      YFIRST.COND = 0
    END ELSE
      OUT.SELECT := " AND "
    END

    OUT.SELECT := YFIXED<I>
  NEXT I

  YCOUNT = DCOUNT(YSORT, @FM)
  FOR I = 1 TO YCOUNT
    OUT.SELECT := " " : YSORT<I>
  NEXT I
  CHANGE SM TO ' ' IN OUT.SELECT
  RETURN

*----------------------
BUILD.SELECT.CONDITION:
*----------------------

  IF YFIRST.COND = 1 THEN
    OUT.SELECT := " WITH "
    YFIRST.COND = 0
  END ELSE
    OUT.SELECT := " AND "
  END

  YVALUE = D.RANGE.AND.VALUE<I>
  YOPERATOR = OPERAND.LIST<D.LOGICAL.OPERANDS<I>>

  OUT.SELECT := "("

  BEGIN CASE
  CASE YOPERATOR = "LK"
    GOSUB BUILD.SUB.SELECT.COND
  CASE YOPERATOR = "UL"
    GOSUB BUILD.SUB.SELECT.COND
  CASE YOPERATOR = "RG"
    YUBOUND = FIELD(YVALUE, @SM, 1)
    YLBOUND = FIELD(YVALUE, @SM, 2)
    OUT.SELECT := D.FIELDS<I> : " GE " : "'" : YUBOUND : "'"
    OUT.SELECT := " AND "
    OUT.SELECT := D.FIELDS<I> : " LE " : "'" : YLBOUND : "'"
  CASE YOPERATOR = "NR"
    YUBOUND = FIELD(YVALUE, @SM, 1)
    YLBOUND = FIELD(YVALUE, @SM, 2)
    OUT.SELECT := D.FIELDS<I> : " LT " : "'" : YUBOUND : "'"
    OUT.SELECT := " OR "
    OUT.SELECT := D.FIELDS<I> : " GT " : "'" : YLBOUND : "'"
  CASE YOPERATOR = 'NE'
    IF YVALUE[1,1] = "'" THEN
      YVALUE = TRIM(YVALUE,"'","A")
    END
    GOSUB BUILD.SUB.SELECT.COND
  CASE YOPERATOR = 'EQ'
    IF YVALUE[1,1] = "'" THEN
      YVALUE = TRIM(YVALUE,"'","A")
    END
    GOSUB BUILD.SUB.SELECT.COND
  CASE 1
    OUT.SELECT := D.FIELDS<I> : " "
    OUT.SELECT := YOPERATOR : " "
    OUT.SELECT := "'" : YVALUE : "'"
  END CASE

  OUT.SELECT := ")"
  RETURN

*---------------------
BUILD.SUB.SELECT.COND:
*---------------------

  VAL.COUNT = DCOUNT(YVALUE, @SM)
  FOR J = 1 TO VAL.COUNT
    TEMP.OPERATOR =  YOPERATOR
    BEGIN CASE
    CASE YOPERATOR = 'LK'
      TEMP.OPERATOR = 'LIKE'
    CASE YOPERATOR = 'UL'
      TEMP.OPERATOR = ' UNLIKE '
    END CASE
    OUT.SELECT := D.FIELDS<I> : " "
    OUT.SELECT := TEMP.OPERATOR : " "
    OUT.SELECT := "'" :YVALUE<1,1,J> : "'"
    IF J NE VAL.COUNT THEN
      BEGIN CASE
      CASE YOPERATOR = 'NE' OR YOPERATOR = 'UL'
        OUT.SELECT := ' AND '
      CASE YOPERATOR = 'EQ' OR YOPERATOR = 'LK'
        OUT.SELECT := ' OR '
      END CASE
    END
  NEXT J
  RETURN
*--------------------------------------------------------------------------------
END
