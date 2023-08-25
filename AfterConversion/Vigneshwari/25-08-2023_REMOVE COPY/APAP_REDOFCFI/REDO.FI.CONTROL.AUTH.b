* @ValidationCode : Mjo3NzQ2OTk4ODA6Q3AxMjUyOjE2OTI5Mzg1MDQ2Mzc6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Aug 2023 10:11:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*14-07-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE MODIFIED,VARIABLE NAME MODIFIED
*14-07-2023    VIGNESHWARI S       R22 MANUAL CONVERSION   PATH IS MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.FI.CONTROL.AUTH
******************************************************************************
*
*
*     Authorization Routine for REDO.FI.CONTROL,AUTH Version
*     Copy file from one directory to another
*
*
* =============================================================================
*
*    First Release : R09
*    Developed for : APAP
*    Developed by  : AVELASCO
*    Date          : 2010/Oct/22
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.FI.CONTROL
    $USING APAP.TAM
*

*
**************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN



* ======
* ======
PROCESS:
* ======
*
*

    IF PROCESS.GOAHEAD THEN
        GOSUB MOVE.FILE
    END


RETURN
*
*
* ======
MOVE.FILE:
    F.FILE = R.NEW(REDO.FI.CON.FILE.NAME)

    F.CONFIRM = R.NEW(REDO.FI.CON.PROCESS.CONFIRM)
* TODO: ACTUALIZAR EL ARCHIVO I_F.REDO.FI.CONTROL
    F.TOT.AMOUNT =  R.NEW(REDO.FI.CON.TOT.AMOUNT.CALC)
    F.VAL.TRX.ENT = R.NEW(REDO.FI.CON.VAL.TRX.ENT)
    F.TRANSACTION.ID = R.NEW(REDO.FI.CON.TRANSACTION.ID)
    F.INTERFACE = R.NEW(REDO.FI.CON.TRANSACTION.ID)

    R.PARAMS<1> = F.TRANSACTION.ID
    R.PARAMS<2> = F.VAL.TRX.ENT
    R.PARAMS<3> = F.TOT.AMOUNT
    R.PARAMS<4> = ID.NEW

    IF F.CONFIRM EQ "SI" THEN

*IF FI.INTERFACE EQ 'NOMINA' THEN
        IF F.INTERFACE EQ 'NOMINA' THEN ;*R22 MANUAL CONVERSION
*CALL REDO.FI.DEBIT.PROCES(R.PARAMS, OUT.RESP, OUT.ERR)
*R22 MANUAL CONVERSION
            APAP.TAM.redoFiDebitProces(R.PARAMS, OUT.RESP, OUT.ERR) 
        END
        IF OUT.ERR NE "" THEN
            E = "EB-ERROR.FAILED.FT"
        END

       * Y.CMD = "COPY FROM ":Y.PATH.WORK:" TO ":Y.PATH.OFS:" ":F.FILE
        Y.CMD = 'SH -c cp ':Y.PATH.WORK: '/':F.FILE:' ':Y.PATH.OFS:'/':F.FILE ;* R22 MANUAL CONVERSION - PATH IS MODIFIED

        COPY.ERR = ''
        GOSUB EXECUTE.COPY
        IF COPY.ERR NE "" THEN
            E = "EB-ERROR.FAILED.COPY " : COPY.ERR
            RETURN
        END
        X.CMD = "DELETE "::Y.PATH.WORK:" ":F.FILE
        DELETE.ERR = ''
        GOSUB EXECUTE.DELETE
        IF DELETE.ERR NE "" THEN
            E = "EB-ERROR.FAILED.DELETE " : COPY.ERR
            RETURN
        END

    END ELSE
        *Y.CMD = "COPY FROM ":Y.PATH.WORK:" TO ":Y.PATH.REJ:" ":F.FILE
        Y.CMD = 'SH -c cp ':Y.PATH.WORK: '/':F.FILE:' ':Y.PATH.REJ:'/':F.FILE ;* R22 MANUAL CONVERSION - PATH IS MODIFIED
        COPY.ERR = ''
        GOSUB EXECUTE.COPY
        IF COPY.ERR NE "" THEN
            E = "EB-ERROR.FAILED.COPY " : COPY.ERR
            RETURN
        END
        X.CMD = "DELETE "::Y.PATH.WORK:" ":F.FILE
        DELETE.ERR = ''
        GOSUB EXECUTE.DELETE
        IF DELETE.ERR NE "" THEN
            E = "EB-ERROR.FAILED.DELETE " : COPY.ERR
            RETURN
        END
    END



RETURN
*
*============
EXECUTE.COPY:
* ===========
*
    COPY.ERR = ""
    EXECUTE Y.CMD RETURNING Y.RET CAPTURING Y.CAP
    Y.RES.POS = 1
    IF OFS$BROWSER EQ 1 THEN
        Y.RES.POS = 2
    END
    IF Y.RET<Y.RES.POS,2> NE 1 THEN
        COPY.ERR = Y.CAP          ;* Error capture from COPY command
    END
*
RETURN
*
*==============
EXECUTE.DELETE:
* =============
*
    DELETE.ERR =""
    EXECUTE X.CMD RETURNING X.RET CAPTURING X.CAP
    X.RES.POS = 1
    IF OFS$BROWSER EQ 1 THEN
        X.RES.POS = 2
    END
    IF X.RET<X.RES.POS,2> NE 1 THEN
        DELETE.ERR = X.CAP        ;* Error capture from DELETE command
        RETURN
    END
*
RETURN
*
* ==============
B100.GET.PARAMS:
* ==============
*
    LOCATE PATH.WORK IN RIP.PARAM<1,1> SETTING PARAM.POS THEN
        Y.PATH.WORK = RIP.VALUE<1,PARAM.POS>
    END ELSE
        PROCESS.GOAHEAD = 0
        E = "EB-PARAMETER.MISSING1"
        CALL ERR
    END

    LOCATE PATH.OFS IN RIP.PARAM<1,1> SETTING PARAM.POS THEN
        Y.PATH.OFS = RIP.VALUE<1,PARAM.POS>
    END ELSE
        PROCESS.GOAHEAD = 0
        E = "EB-PARAMETER.MISSING2"
        CALL ERR
    END
*
    LOCATE PATH.REJ IN RIP.PARAM<1,1> SETTING PARAM.POS THEN
        Y.PATH.REJ = RIP.VALUE<1,PARAM.POS>
    END ELSE
        PROCESS.GOAHEAD = 0
        E = "EB-PARAMETER.MISSING3"
    END
*
RETURN
*
* ---------
INITIALISE:
* ---------
*

    PROCESS.GOAHEAD = 1
    PARAM.ID        = "RFID"
*
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    FV.REDO.INTERFACE.PARAM = ""
    Y.ERR                   = ""
    R.REDO.INTERFACE.PARAM  = ""
*
    RIP.PARAM        = ""
    RIP.VALUE        = ""
    PATH.WORK        = "PATH.WORK"
    PATH.OFS         = "PATH.OFS"
    PATH.REJ         = "PATH.REJ"
    WPARAM.POS       = 1
    NUM.DIR          = 0
    WCONTROL.ID      = ID.NEW
    INI.POS          = 0
    Y.CHAR           = ""
    Y.CONTROL.ID     =""
    Y.CONTROL.ID.LEN = 0
    Y.CONTROL.ID.LEN = LEN(WCONTROL.ID)
*
RETURN
*
* ---------
OPEN.FILES:
* ---------
*
*
    CALL OPF(FN.REDO.INTERFACE.PARAM,FV.REDO.INTERFACE.PARAM)
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                FOR INI.POS = 1 TO Y.CONTROL.ID.LEN
                    Y.CHAR = SUBSTRINGS (WCONTROL.ID, INI.POS, 1)
                    IF Y.CHAR NE '.' THEN
                        Y.CONTROL.ID = Y.CONTROL.ID:Y.CHAR
                    END ELSE
                        INI.POS = Y.CONTROL.ID.LEN
                    END
                NEXT INI.POS

            CASE LOOP.CNT EQ 2

                CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, PARAM.ID, R.REDO.INTERFACE.PARAM, Y.ERR)
                IF Y.ERR THEN

                    PROCESS.GOAHEAD = 0
                    E = "EB-PARAMETER.MISSING"
                    CALL ERR
                END
            CASE LOOP.CNT EQ 3

                RIP.PARAM = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
                RIP.VALUE = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
                GOSUB B100.GET.PARAMS
*
        END CASE
        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
