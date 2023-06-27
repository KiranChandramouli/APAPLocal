* @ValidationCode : MjotMTI2OTA0MjgzOTpDcDEyNTI6MTY4NTU0NTMyMTExNzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 20:32:01
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
SUBROUTINE REDO.LY.DIS.FIELDS.P
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
* 06-Apr-2010        Ganesh R        ODR-2009-12-0276     Initial Creation
* 04-Jul-2011       RMONDRAGON       ODR-2011-06-0243     Modification for Phase III
* 30-Nov-2011       RMONDRAGON       ODR-2011-06-0243     Update
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           CALL Rtn format modified
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM
    $USING APAP.REDOVER

    IF VAL.TEXT THEN
        VAR.APP.EXC.COND = R.NEW(REDO.PROG.APP.EXC.COND)
    END ELSE
        VAR.APP.EXC.COND = COMI
    END

    GOSUB PROCESS

RETURN

********
PROCESS:
********

    IF VAL.TEXT EQ '' THEN
        VAL.TEXT = 'VALIDATED'
*       CALL REDO.V.AVAIL.PROGRAM
        APAP.REDOVER.redoVAvailProgram() ;*MANUAL R22 CODE CONVERSION
*       CALL REDO.V.DISDELAY
        APAP.REDOVER.redoVDisdelay() ;*MANUAL R22 CODE CONVERSION
*       CALL REDO.LY.DIS.FIELDS.T
        APAP.TAM.redoLyDisFieldsT() ;*MANUAL R22 CODE CONVERSION
        VAL.TEXT = ''
    END ELSE
*       CALL REDO.V.AVAIL.PROGRAM
        APAP.REDOVER.redoVAvailProgram() ;*MANUAL R22 CODE CONVERSION
*       CALL REDO.V.DISDELAY
        APAP.REDOVER.redoVDisdelay() ;*MANUAL R22 CODE CONVERSION
*       CALL REDO.LY.DIS.FIELDS.T
        APAP.TAM.redoLyDisFieldsT() ;*MANUAL R22 CODE CONVERSION
    END

    VAR.COND.TYPE.EXINC=R.NEW(REDO.PROG.COND.TYPE.EXINC)

    IF VAR.COND.TYPE.EXINC EQ 'ESTADO.CUENTA' AND VAR.APP.EXC.COND EQ 'ESPECIFICA' THEN
        GOSUB PROCESS1
    END

    IF VAR.COND.TYPE.EXINC EQ 'ESTADO.CUENTA' AND VAR.APP.EXC.COND EQ 'TODAS' THEN
        T(REDO.PROG.EXC.EST.ACCT)<3>='NOINPUT'
        GOSUB PROCESS1
    END

    IF VAR.COND.TYPE.EXINC EQ 'ESTADO.PRESTAMO' AND VAR.APP.EXC.COND EQ 'ESPECIFICA' THEN
        GOSUB PROCESS2
    END

    IF VAR.COND.TYPE.EXINC EQ 'ESTADO.PRESTAMO' AND VAR.APP.EXC.COND EQ 'TODAS' THEN
        T(REDO.PROG.EXC.EST.LOAN)<3>='NOINPUT'
        GOSUB PROCESS2
    END

    IF VAR.COND.TYPE.EXINC EQ 'CONDICION.PRESTAMO' AND VAR.APP.EXC.COND EQ 'ESPECIFICA' THEN
        GOSUB PROCESS3
    END

    IF VAR.COND.TYPE.EXINC EQ 'CONDICION.PRESTAMO' AND VAR.APP.EXC.COND EQ 'TODAS' THEN
        T(REDO.PROG.EXC.COND.LOAN)<3>='NOINPUT'
        GOSUB PROCESS3
    END

    IF VAR.COND.TYPE.EXINC EQ 'MCC.TDEBITO' OR VAR.COND.TYPE.EXINC EQ 'MERCHANTID.TDEBITO' AND VAR.APP.EXC.COND EQ 'ESPECIFICA' THEN
        GOSUB PROCESS4
    END

    IF VAR.COND.TYPE.EXINC EQ 'MCC.TDEBITO' OR VAR.COND.TYPE.EXINC EQ 'MERCHANTID.TDEBITO' AND VAR.APP.EXC.COND EQ 'TODAS' THEN
        T(REDO.PROG.EXC.COND)<3>='NOINPUT'
        GOSUB PROCESS4
    END

RETURN

*--------
PROCESS1:
*--------

    T(REDO.PROG.EXC.EST.LOAN)<3>='NOINPUT'
    T(REDO.PROG.EXC.COND.LOAN)<3>='NOINPUT'
    T(REDO.PROG.EXC.COND)<3>='NOINPUT'
    T(REDO.PROG.INC.EST.LOAN)<3>='NOINPUT'
    T(REDO.PROG.INC.COND.LOAN)<3>='NOINPUT'
    T(REDO.PROG.INC.COND)<3>='NOINPUT'

RETURN

*--------
PROCESS2:
*--------

    T(REDO.PROG.EXC.EST.ACCT)<3>='NOINPUT'
    T(REDO.PROG.EXC.COND.LOAN)<3>='NOINPUT'
    T(REDO.PROG.EXC.COND)<3>='NOINPUT'
    T(REDO.PROG.INC.EST.ACCT)<3>='NOINPUT'
    T(REDO.PROG.INC.COND.LOAN)<3>='NOINPUT'
    T(REDO.PROG.INC.COND)<3>='NOINPUT'

RETURN

*--------
PROCESS3:
*--------

    T(REDO.PROG.EXC.EST.ACCT)<3>='NOINPUT'
    T(REDO.PROG.EXC.EST.LOAN)<3>='NOINPUT'
    T(REDO.PROG.EXC.COND)<3>='NOINPUT'
    T(REDO.PROG.INC.EST.ACCT)<3>='NOINPUT'
    T(REDO.PROG.INC.EST.LOAN)<3>='NOINPUT'
    T(REDO.PROG.INC.COND)<3>='NOINPUT'

RETURN

*--------
PROCESS4:
*--------

    T(REDO.PROG.EXC.EST.ACCT)<3>='NOINPUT'
    T(REDO.PROG.EXC.EST.LOAN)<3>='NOINPUT'
    T(REDO.PROG.EXC.COND.LOAN)<3>='NOINPUT'
    T(REDO.PROG.INC.EST.ACCT)<3>='NOINPUT'
    T(REDO.PROG.INC.EST.LOAN)<3>='NOINPUT'
    T(REDO.PROG.INC.COND.LOAN)<3>='NOINPUT'

RETURN

END
