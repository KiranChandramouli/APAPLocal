*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.EXCEP.V.APP
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RMONDRAGON
* PROGRAM NAME: REDO.EXCEP.V.APP
* ODR NO      : ODR-2009-12-0307
*----------------------------------------------------------------------
*DESCRIPTION: This subroutine is performed in REDO.EXCEP.REC.PARAM,CREATION version
* The functionality is to validate the application name entered in APPLICATION-NAME
* field of the version.

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:  REDO.EXCEP.REC.PARAM
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*05.12.2012  RMONDRAGON    ODR-2009-12-0307    FIRST VERSION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.EXCEP.REC.PARAM

  IF VAL.TEXT THEN
    GOSUB INIT
    GOSUB PROCESS
  END

  RETURN

*----
INIT:
*----

  FN.FILE.CONTROL = 'F.FILE.CONTROL'
  F.FILE.CONTROL = ''
  CALL OPF(FN.FILE.CONTROL,F.FILE.CONTROL)

  RETURN

*-------
PROCESS:
*-------

  Y.APP.FIELD = R.NEW(EXCEP.APPLICATION.NAME)

  Y.CNT.TOT.APP = DCOUNT(Y.APP.FIELD,VM)

  Y.CNT = 1
  LOOP
  WHILE Y.CNT LE Y.CNT.TOT.APP
    Y.APP.NAME = FIELD(Y.APP.FIELD,VM,Y.CNT)
    GOSUB VAL.APP.NULL
    Y.CNT++
  REPEAT

  RETURN

*------------
VAL.APP.NULL:
*------------

  IF Y.APP.NAME EQ '' THEN
    AF = EXCEP.APPLICATION.NAME
    AV = Y.CNT
    ETEXT = 'TT-APP.NOT.VAL'
    CALL STORE.END.ERROR
  END ELSE
    GOSUB VAL.APP.DUP
    IF Y.FLG.N.VAL EQ 'Y' THEN
      GOSUB VAL.APP.NAME
    END
  END

  RETURN

*-----------
VAL.APP.DUP:
*-----------

  Y.CNT.2 = 1
  Y.FLG.N.VAL = 'Y'
  LOOP
  WHILE Y.CNT.2 LE Y.CNT.TOT.APP
    Y.APP.NAME.TO.COMP = FIELD(Y.APP.FIELD,VM,Y.CNT.2)
    IF Y.APP.NAME EQ Y.APP.NAME.TO.COMP AND Y.CNT GT Y.CNT.2 THEN
      Y.FLG.N.VAL = 'N'
      Y.CNT.2 = Y.CNT.TOT.APP + 1
      AF = EXCEP.APPLICATION.NAME
      AV = Y.CNT
      ETEXT = 'TT-APP.NOT.VAL'
      CALL STORE.END.ERROR
    END ELSE
      Y.CNT.2++
    END
  REPEAT

  RETURN

*------------
VAL.APP.NAME:
*------------

  R.FILE.CONTROL = ''; FC.ERR = ''
  CALL F.READ(FN.FILE.CONTROL,Y.APP.NAME,R.FILE.CONTROL,F.FILE.CONTROL,FC.ERR)
  IF R.FILE.CONTROL THEN
    RETURN
  END ELSE
    AF = EXCEP.APPLICATION.NAME
    AV = Y.CNT
    ETEXT = 'TT-APP.NOT.VAL'
    CALL STORE.END.ERROR
  END

  RETURN

END
