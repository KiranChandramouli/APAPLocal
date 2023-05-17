*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.L.AC.STATUS.CODE.PROCESS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to create a table REDO.L.AC.STATUS.CODE.PROCESS
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 10-11=2010          JEEVA T       ODR-2010-08-0017      Initial Creation
*------------------------------------------------------------------------------------------

* ----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
$INSERT I_F.EB.LOOKUP
$INSERT I_F.REDO.L.AC.STATUS.CODE

  FN.EB.LOOKUP = 'F.EB.LOOKUP'
  F.EB.LOOKUP  = ''
  CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)



  GET.ACCT.STATUS = R.NEW(REDO.LAC.STAT.L.AC.STATUS)
  TOT.CNTR = DCOUNT(GET.ACCT.STATUS,VM)

  R.EB.LOOKUP = ''
  CHANGE VM TO FM IN GET.ACCT.STATUS

  LOOP.CNTR = 1

  LOOP
  WHILE LOOP.CNTR LE TOT.CNTR

    CURR.ACCT.STATUS = GET.ACCT.STATUS<LOOP.CNTR>
    EB.LOOK.ID = "L.AC.STATUS1*":CURR.ACCT.STATUS
    CALL F.READ(FN.EB.LOOKUP,EB.LOOK.ID,R.EB.LOOKUP,F.EB.LOOKUP,LOOK.ERR)
    IF R.EB.LOOKUP EQ '' THEN
      AF = REDO.LAC.STAT.STATUS.CODE
      ETEXT = "EB-INVALID.LAC.STATUS"
      CALL STORE.END.ERROR
    END
    LOOP.CNTR = LOOP.CNTR + 1
  REPEAT
  RETURN
END
