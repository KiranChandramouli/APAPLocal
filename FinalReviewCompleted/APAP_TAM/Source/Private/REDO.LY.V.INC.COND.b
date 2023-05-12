* @ValidationCode : Mjo0OTM4ODM4OTA6Q3AxMjUyOjE2ODI0OTIzMjMwNTc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 12:28:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.LY.V.INC.COND
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
* PROGRAM NAME : REDO.LY.V.INC.COND
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*04.04.2023    Conversion Tool      R22               Auto Conversion     - No changes
*04.04.2023    Shanmugapriya M      R22               Manual Conversion   - No changes
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

    VAR.APP.INC.COND = R.NEW(REDO.PROG.APP.INC.COND)

    IF VAR.COND.TYPE.EXINC EQ 'ESTADO.CUENTA' AND VAR.APP.INC.COND EQ 'ESPECIFICA' AND Y.INC.EST.ACCT EQ '' THEN
        AF = REDO.PROG.INC.EST.ACCT
        ETEXT = 'EB-REDO.LY.APP.COND'
        CALL STORE.END.ERROR
    END

    IF VAR.COND.TYPE.EXINC EQ 'ESTADO.PRESTAMO' AND VAR.APP.INC.COND EQ 'ESPECIFICA' AND Y.INC.EST.LOAN EQ '' THEN
        COMI = ''
        AF = REDO.PROG.INC.EST.LOAN
        ETEXT = 'EB-REDO.LY.APP.COND'
        CALL STORE.END.ERROR
    END

    IF VAR.COND.TYPE.EXINC EQ 'CONDICION.PRESTAMO' AND VAR.APP.INC.COND EQ 'ESPECIFICA' AND Y.INC.COND.LOAN EQ '' THEN
        COMI = ''
        AF = REDO.PROG.INC.COND.LOAN
        ETEXT = 'EB-REDO.LY.APP.COND'
        CALL STORE.END.ERROR
    END

    IF VAR.COND.TYPE.EXINC EQ 'MCC.TDEBITO' OR VAR.COND.TYPE.EXINC EQ 'MERCHANTID.TDEBITO' AND VAR.APP.INC.COND EQ 'ESPECIFICA' AND Y.INC.COND EQ '' THEN
        COMI = ''
        AF = REDO.PROG.INC.COND
        ETEXT = 'EB-REDO.LY.APP.COND'
        CALL STORE.END.ERROR
    END

RETURN

*--------------------
GET.VALUES.FROM.RNEW:
*--------------------

    BEGIN CASE
        CASE VAR.COND.TYPE.EXINC EQ 'ESTADO.CUENTA'
            Y.INC.EST.ACCT = R.NEW(REDO.PROG.INC.EST.ACCT)
        CASE VAR.COND.TYPE.EXINC EQ 'ESTADO.PRESTAMO'
            Y.INC.EST.LOAN = R.NEW(REDO.PROG.INC.EST.LOAN)
        CASE VAR.COND.TYPE.EXINC EQ 'CONDICION.PRESTAMO'
            Y.INC.COND.LOAN = R.NEW(REDO.PROG.INC.COND.LOAN)
        CASE VAR.COND.TYPE.EXINC EQ 'MCC.TDEBITO'
            Y.INC.COND = R.NEW(REDO.PROG.INC.COND)
        CASE VAR.COND.TYPE.EXINC EQ 'MERCHANTID.TDEBITO'
            Y.INC.COND = R.NEW(REDO.PROG.INC.COND)
    END CASE

RETURN

*--------------------
GET.VALUES.FROM.COMI:
*--------------------

    BEGIN CASE
        CASE VAR.COND.TYPE.EXINC EQ 'ESTADO.CUENTA'
            Y.INC.EST.ACCT = COMI
        CASE VAR.COND.TYPE.EXINC EQ 'ESTADO.PRESTAMO'
            Y.INC.EST.LOAN = COMI
        CASE VAR.COND.TYPE.EXINC EQ 'CONDICION.PRESTAMO'
            Y.INC.COND.LOAN = COMI
        CASE VAR.COND.TYPE.EXINC EQ 'MCC.TDEBITO'
            Y.INC.COND = COMI
        CASE VAR.COND.TYPE.EXINC EQ 'MERCHANTID.TDEBITO'
            Y.INC.COND = COMI
    END CASE

RETURN

END
