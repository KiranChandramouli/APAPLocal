SUBROUTINE  REDO.LY.V.EXC.COND
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.LY.PROGRAM table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.EXC.COND
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    VAR.COND.TYPE.EXINC = R.NEW(REDO.PROG.COND.TYPE.EXINC)

    IF VAL.TEXT THEN
        GOSUB GET.VALUES.FROM.RNEW
    END ELSE
        GOSUB GET.VALUES.FROM.COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    VAR.APP.EXC.COND = R.NEW(REDO.PROG.APP.EXC.COND)

    IF VAR.COND.TYPE.EXINC EQ 'ESTADO.CUENTA' AND VAR.APP.EXC.COND EQ 'ESPECIFICA' AND Y.EXC.EST.ACCT EQ '' THEN
        AF = REDO.PROG.EXC.EST.ACCT
        ETEXT = 'EB-REDO.LY.APP.COND'
        CALL STORE.END.ERROR
    END

    IF VAR.COND.TYPE.EXINC EQ 'ESTADO.PRESTAMO' AND VAR.APP.EXC.COND EQ 'ESPECIFICA' AND Y.EXC.EST.LOAN EQ '' THEN
        COMI = ''
        AF = REDO.PROG.EXC.EST.LOAN
        ETEXT = 'EB-REDO.LY.APP.COND'
        CALL STORE.END.ERROR
    END

    IF VAR.COND.TYPE.EXINC EQ 'CONDICION.PRESTAMO' AND VAR.APP.EXC.COND EQ 'ESPECIFICA' AND Y.EXC.COND.LOAN EQ '' THEN
        COMI = ''
        AF = REDO.PROG.EXC.COND.LOAN
        ETEXT = 'EB-REDO.LY.APP.COND'
        CALL STORE.END.ERROR
    END

    IF VAR.COND.TYPE.EXINC EQ 'MCC.TDEBITO' OR VAR.COND.TYPE.EXINC EQ 'MERCHANTID.TDEBITO' AND VAR.APP.EXC.COND EQ 'ESPECIFICA' AND Y.EXC.COND EQ '' THEN
        COMI = ''
        AF = REDO.PROG.EXC.COND
        ETEXT = 'EB-REDO.LY.APP.COND'
        CALL STORE.END.ERROR
    END

RETURN

*--------------------
GET.VALUES.FROM.RNEW:
*--------------------

    BEGIN CASE
        CASE VAR.COND.TYPE.EXINC EQ 'ESTADO.CUENTA'
            Y.EXC.EST.ACCT = R.NEW(REDO.PROG.EXC.EST.ACCT)
        CASE VAR.COND.TYPE.EXINC EQ 'ESTADO.PRESTAMO'
            Y.EXC.EST.LOAN = R.NEW(REDO.PROG.EXC.EST.LOAN)
        CASE VAR.COND.TYPE.EXINC EQ 'CONDICION.PRESTAMO'
            Y.EXC.COND.LOAN = R.NEW(REDO.PROG.EXC.COND.LOAN)
        CASE VAR.COND.TYPE.EXINC EQ 'MCC.TDEBITO'
            Y.EXC.COND = R.NEW(REDO.PROG.EXC.COND)
        CASE VAR.COND.TYPE.EXINC EQ 'MERCHANTID.TDEBITO'
            Y.EXC.COND = R.NEW(REDO.PROG.EXC.COND)
    END CASE

RETURN

*--------------------
GET.VALUES.FROM.COMI:
*--------------------

    BEGIN CASE
        CASE VAR.COND.TYPE.EXINC EQ 'ESTADO.CUENTA'
            Y.EXC.EST.ACCT = COMI
        CASE VAR.COND.TYPE.EXINC EQ 'ESTADO.PRESTAMO'
            Y.EXC.EST.LOAN = COMI
        CASE VAR.COND.TYPE.EXINC EQ 'CONDICION.PRESTAMO'
            Y.EXC.COND.LOAN = COMI
        CASE VAR.COND.TYPE.EXINC EQ 'MCC.TDEBITO'
            Y.EXC.COND = COMI
        CASE VAR.COND.TYPE.EXINC EQ 'MERCHANTID.TDEBITO'
            Y.EXC.COND = COMI
    END CASE

RETURN

END
