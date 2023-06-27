* @ValidationCode : MjoyODAxMjYwMDI6Q3AxMjUyOjE2ODU1NDUzMjMyNzI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 20:32:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.LY.DIS.FIELDS.T
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* The functionality is to disable EXC.COND or INC.COND fields according
* if value parameterized in the APP.EXC.COND or APP.INC.COND fields is "TODAS" (All)
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 04-Jul-2011       RMONDRAGON       ODR-2011-06-0243     Modification for Phase III -
*                                                         I/E Conditions
* 28-Nov-2011       RMONDRAGON       ODR-2011-06-0243     Update
** 12-04-2023 R22 Auto Conversion no changes
** 12-04-2023 Skanda R22 Manual Conversion - No changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM
    $USING APAP.REDOVER

    IF VAL.TEXT THEN
        VAR.COND.TYPE.EXINC = R.NEW(REDO.PROG.COND.TYPE.EXINC)
    END ELSE
        VAR.COND.TYPE.EXINC = COMI
    END

    GOSUB PROCESS

RETURN

********
PROCESS:
********

    IF VAL.TEXT EQ '' THEN
        VAL.TEXT = 'VALIDATED'
*       CALL REDO.V.AVAIL.PROGRAM
        APAP.REDOVER.redoVAvailProgram() ;* R22 Manual Converion
*       CALL REDO.V.DISDELAY
        APAP.REDOVER.redoVDisdelay() ;* R22 Manual Converion
        VAL.TEXT = ''
    END ELSE
*       CALL REDO.V.AVAIL.PROGRAM
        APAP.REDOVER.redoVAvailProgram() ;* R22 Manual Converion
*       CALL REDO.V.DISDELAY
        APAP.REDOVER.redoVDisdelay() ;* R22 Manual Converion
    END

    IF VAR.COND.TYPE.EXINC EQ '' THEN
        VAR.COND.TYPE.EXINC = R.NEW(REDO.PROG.COND.TYPE.EXINC)
    END

    IF VAR.COND.TYPE.EXINC EQ 'ESTADO.CUENTA' THEN
        T(REDO.PROG.EXC.COND)<3>='NOINPUT'
        T(REDO.PROG.EXC.EST.LOAN)<3>='NOINPUT'
        T(REDO.PROG.EXC.COND.LOAN)<3>='NOINPUT'
        T(REDO.PROG.INC.COND)<3>='NOINPUT'
        T(REDO.PROG.INC.EST.LOAN)<3>='NOINPUT'
        T(REDO.PROG.INC.COND.LOAN)<3>='NOINPUT'
    END

    IF VAR.COND.TYPE.EXINC EQ 'ESTADO.PRESTAMO' THEN
        T(REDO.PROG.EXC.COND)<3>='NOINPUT'
        T(REDO.PROG.EXC.EST.ACCT)<3>='NOINPUT'
        T(REDO.PROG.EXC.COND.LOAN)<3>='NOINPUT'
        T(REDO.PROG.INC.COND)<3>='NOINPUT'
        T(REDO.PROG.INC.EST.ACCT)<3>='NOINPUT'
        T(REDO.PROG.INC.COND.LOAN)<3>='NOINPUT'
    END

    IF VAR.COND.TYPE.EXINC EQ 'CONDICION.PRESTAMO' THEN
        T(REDO.PROG.EXC.COND)<3>='NOINPUT'
        T(REDO.PROG.EXC.EST.ACCT)<3>='NOINPUT'
        T(REDO.PROG.EXC.EST.LOAN)<3>='NOINPUT'
        T(REDO.PROG.INC.COND)<3>='NOINPUT'
        T(REDO.PROG.INC.EST.ACCT)<3>='NOINPUT'
        T(REDO.PROG.INC.EST.LOAN)<3>='NOINPUT'
    END

    IF VAR.COND.TYPE.EXINC EQ 'MCC.TDEBITO' OR VAR.COND.TYPE.EXINC EQ 'MERCHANTID.TDEBITO' THEN
        T(REDO.PROG.EXC.EST.ACCT)<3>='NOINPUT'
        T(REDO.PROG.EXC.EST.LOAN)<3>='NOINPUT'
        T(REDO.PROG.EXC.COND.LOAN)<3>='NOINPUT'
        T(REDO.PROG.INC.EST.ACCT)<3>='NOINPUT'
        T(REDO.PROG.INC.EST.LOAN)<3>='NOINPUT'
        T(REDO.PROG.INC.COND.LOAN)<3>='NOINPUT'
    END

RETURN

END
