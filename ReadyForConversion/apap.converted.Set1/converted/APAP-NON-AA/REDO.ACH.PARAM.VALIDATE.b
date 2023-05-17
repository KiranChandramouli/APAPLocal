SUBROUTINE REDO.ACH.PARAM.VALIDATE
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : KAVITHA S
* Program Name  : REDO.INTERFACE.PARAMETER
* ODR NUMBER    : ODR-2009-12-0290
*-------------------------------------------------------------------------

* Description : This Routine is used to format the Field values of fields BUSINESS.DIV
*               PECF,AICF,TCF to their required length

* In parameter : None
* out parameter : None
* 28/07/2011  -- Condition check for valid path changed
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ACH.PARAM

    GOSUB PROCESS

RETURN
********
PROCESS:
********
*!* PERF-CHANGE-Start

    BEGIN CASE

        CASE R.NEW(REDO.ACH.PARAM.OUTW.HIST.PATH) NE ''

*IF R.NEW(REDO.ACH.PARAM.OUTW.HIST.PATH) THEN

            FILE.PATH = R.NEW(REDO.ACH.PARAM.OUTW.HIST.PATH)
            OPEN FILE.PATH TO F.FILE.NAME SETTING SET.VAR ELSE
                AF  = REDO.ACH.PARAM.OUTW.HIST.PATH
                ETEXT = 'EB-INVALID.PATH'
                CALL STORE.END.ERROR
            END

*END

        CASE R.NEW(REDO.ACH.PARAM.INW.HIST.PATH) NE ''

*IF R.NEW(REDO.ACH.PARAM.INW.HIST.PATH) THEN

            FILE.PATH = R.NEW(REDO.ACH.PARAM.INW.HIST.PATH)
            OPEN FILE.PATH TO F.FILE.NAME SETTING SET.VAR ELSE
                AF  = REDO.ACH.PARAM.INW.HIST.PATH
                ETEXT = 'EB-INVALID.PATH'
                CALL STORE.END.ERROR
            END

*END

        CASE R.NEW(REDO.ACH.PARAM.OUT.RJ.HIS.PATH) NE ''

*IF R.NEW(REDO.ACH.PARAM.OUT.RJ.HIS.PATH) THEN

            FILE.PATH = R.NEW(REDO.ACH.PARAM.OUT.RJ.HIS.PATH)
            OPEN FILE.PATH TO F.FILE.NAME SETTING SET.VAR ELSE
                AF  = REDO.ACH.PARAM.OUT.RJ.HIS.PATH
                ETEXT = 'EB-INVALID.PATH'
                CALL STORE.END.ERROR
            END

*END
        CASE R.NEW(REDO.ACH.PARAM.IN.REJ.HIST.PATH) NE ''

*IF R.NEW(REDO.ACH.PARAM.IN.REJ.HIST.PATH) THEN

            FILE.PATH = R.NEW(REDO.ACH.PARAM.IN.REJ.HIST.PATH)
            OPEN FILE.PATH TO F.FILE.NAME SETTING SET.VAR ELSE
                AF  = REDO.ACH.PARAM.IN.REJ.HIST.PATH
                ETEXT = 'EB-INVALID.PATH'
                CALL STORE.END.ERROR
            END

*END
    END CASE

*!* PERF-CHANGE-End

RETURN
END
