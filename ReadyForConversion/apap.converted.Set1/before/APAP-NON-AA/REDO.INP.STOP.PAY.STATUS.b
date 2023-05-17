*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INP.STOP.PAY.STATUS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This subroutine would serve as a cross validation level validation routine
* The purpose of this routine is to check the field STOPPAYMENT.STATUS if the
* value is specified as a CONFIRMED and authorised the value cannot be changed
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 25-Nov-2009       SHANKAR RAJU                            Initial Creation
*------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.PAYMENT.STOP
$INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT

*------------------------------MAIN-------------------------------------
  GOSUB INIT
  GOSUB PROCESS

  RETURN
*-----------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------

  FN.REDO.PAYMENT.STOP.ACCOUNT = 'F.REDO.PAYMENT.STOP.ACCOUNT'
  F.REDO.PAYMENT.STOP.ACCOUNT = ''
  VALUE.NEW = ''
  CALL OPF(FN.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT)

  RETURN
*-----------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------

  STATUS.NOS = DCOUNT(R.NEW(REDO.PS.ACCT.PAY.STOP.STATUS),VM)

  START.COUNT = 1

  LOOP
  WHILE START.COUNT LE STATUS.NOS
    Y.VALUE = R.OLD(REDO.PS.ACCT.PAY.STOP.STATUS)<1,START.COUNT>
    IF Y.VALUE EQ 'CONFIRMED' THEN

      VALUE.NEW = R.NEW(REDO.PS.ACCT.PAY.STOP.STATUS)<1,START.COUNT>

      IF VALUE.NEW EQ 'NONCONFIRMED' THEN

        T(REDO.PS.ACCT.CHEQUE.FIRST)<3> = "NOCHANGE"

        T(REDO.PS.ACCT.CHEQUE.LAST)<3> = "NOCHANGE"

        ETEXT = 'EB-STATUS'
        AF=REDO.PS.ACCT.PAY.STOP.STATUS
* AV=REDO.PS.ACCT.PAY.STOP.STATUS
        AS = START.COUNT
        CALL STORE.END.ERROR

      END
    END

    START.COUNT = START.COUNT + 1

  REPEAT

  RETURN
*-----------------------------------------------------------------------

END
*-----------------------------------------------------------------------
