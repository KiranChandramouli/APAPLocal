*-----------------------------------------------------------------------------
* <Rating>-16</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.LY.V.CR.FOR.CUS
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the proper setup for point use of the customer.
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.CR.FOR.CUS
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*07.06.2013    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
* -----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LY.PROGRAM

  GOSUB PROCESS

  RETURN

*-------
PROCESS:
*-------

  Y.ACCT.FOR.DR.SET = R.NEW(REDO.PROG.DR.ACCT.US)
  Y.ACCT.FOR.CR.SET = R.NEW(REDO.PROG.CR.ACCT.US)

  Y.VALID.TO.CR.CUS = 0
*    Y.VALID.TO.CR.INT = 0

  Y.ACCT.FOR.CR.TOT = DCOUNT(Y.ACCT.FOR.CR.SET,VM)
  Y.ACCT.FOR.CR.CNT = 1
  LOOP
  WHILE Y.ACCT.FOR.CR.CNT LE Y.ACCT.FOR.CR.TOT
    Y.ACCT.FOR.DR = FIELD(Y.ACCT.FOR.DR.SET,VM,Y.ACCT.FOR.CR.CNT)
    Y.ACCT.FOR.CR = FIELD(Y.ACCT.FOR.CR.SET,VM,Y.ACCT.FOR.CR.CNT)
    IF Y.ACCT.FOR.CR EQ 'CUST.ACCT' AND Y.ACCT.FOR.DR NE '' THEN
      Y.VALID.TO.CR.CUS++
    END
*        IF Y.ACCT.FOR.CR EQ 'INT.ACCT' AND Y.ACCT.FOR.DR NE '' THEN
*            Y.VALID.TO.CR.INT++
*        END
    Y.ACCT.FOR.CR.CNT++
  REPEAT

  IF Y.VALID.TO.CR.CUS NE 1 THEN
    AF = REDO.PROG.DR.ACCT.US
    ETEXT = 'EB-REDO.LY.V.CR.FOR.CUS'
    CALL STORE.END.ERROR
  END

*    IF Y.VALID.TO.CR.INT NE 1 THEN
*        AF = REDO.PROG.DR.ACCT.US
*        ETEXT = 'EB-REDO.LY.V.CR.FOR.CUS2'
*        CALL STORE.END.ERROR
*    END

  RETURN

*----------------------------------------------------------------------------------
END
