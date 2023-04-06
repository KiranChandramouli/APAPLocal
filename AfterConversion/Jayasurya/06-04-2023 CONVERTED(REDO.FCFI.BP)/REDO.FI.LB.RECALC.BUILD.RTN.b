* @ValidationCode : MjotNzEyOTMxNzAyOkNwMTI1MjoxNjgwNzU5NzYwODAxOklUU1NCTkc6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 11:12:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSSBNG
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.LB.RECALC.BUILD.RTN(ENQ.DATA)
*
******************************************************************************
* Subroutine Type : BUILD ROUTINE
* Attached to     :
* Attached as     :
* Primary Purpose :
*
* Incoming:
* ---------
* DATA.IN        - ID BatchProcess Detail
*
* Outgoing:
* ---------
* DATA.OUT       - recalculate amounts data returned to the enquiry
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos ODR-2010-03-0025
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Nov. 26, 2010
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.TSA.SERVICE

    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON


    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.FI.LB.BPROC

*
*************************************************************************
*

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
    Y.SEL.CMD  = "SELECT " : DIR.PROC.QUEUE
    Y.SEL.CMD := " WITH @ID EQUAL " : ANSWER.FILE
    NO.OF.REC  = 0
    LOOP.CNT   = 0
*
    GOSUB B110.REQUEST
    GOSUB B150.SERVICES
*
    LOOP
    WHILE NO.OF.REC NE 1 AND LOOP.CNT LE 10 DO

        CALL EB.READLIST(Y.SEL.CMD,ANSWER.LIST,"",NO.OF.REC,YER.SEL)
        IF NO.OF.REC EQ 0 THEN
            SLEEP 3
        END
        LOOP.CNT += 1
    REPEAT
*
    IF NO.OF.REC EQ 1 THEN
        GOSUB B130.DELETE
    END
*
    ENQ.DATA<3,Y.POS> = "LK"
    ENQ.DATA <4,Y.POS> = L.ID.PROCESO.BATCH:"..."
*
RETURN
*
* ============
B110.REQUEST:
* ============
*
    OPENSEQ DIR.PROC.QUEUE,REQUEST.FILE TO O.POINTER ELSE
        CREATE O.POINTER ELSE
            WERROR.MSG = "EB-ERROR.CREATE.FILE"
            CALL TXT(WERROR.MSG)
        END
    END

    DATO.OUT=L.ID.PROCESO.BATCH
    WRITESEQ DATO.OUT APPEND TO O.POINTER ELSE
        WERROR.MSG ="EB-ERROR.WRITE.FILE"
        CALL TXT(WERROR.MSG)
    END
    CLOSESEQ O.POINTER
*
RETURN
*
* ============
B130.DELETE:
* ============
*
    X.CMD = "DELETE ":DIR.PROC.QUEUE:" ":REQUEST.FILE
    DELETE.ERR = ''
    EXECUTE X.CMD RETURNING X.RET CAPTURING X.CAP
    X.RES.POS = 1
    IF OFS$BROWSER EQ 1 THEN
        X.RES.POS = 2
    END
    IF X.RET<X.RES.POS,2> NE 1 THEN
        DELETE.ERR = X.CAP
        RETURN
    END
    IF DELETE.ERR NE "" THEN
        WERROR.MSG = "EB-ERROR.FAILED.DELETE " : DELETE.ERR
        CALL TXT(WERROR.MSG)
    END
*
RETURN
*
* ============
B150.SERVICES:
* ============
*
    Y.STATUS=""
    PARAM.ID = "REDO.FI.PLANILLA.REC"
    CALL F.READ(FN.F.TSA.SERVICE, PARAM.ID, R.F.TSA.SERVICE, F.F.TSA.SERVICE, Y.ERR)
    IF Y.ERR THEN
        PROCESS.GOAHEAD = 0
        WERROR.MSG = "FI.PARAMETER.MISSING-&":@FM:PARAM.ID
        CALL TXT(WERROR.MSG)
    END
    Y.STATUS = R.F.TSA.SERVICE<TS.TSM.SERVICE.CONTROL>

    IF Y.STATUS EQ "STOP" THEN
        Y.STATUS = "STOP"
        GOSUB GRABA.TSA.SERVICE
        Y.STATUS = "START"
        GOSUB GRABA.TSA.SERVICE
    END
*
RETURN
*


*
* ======================
GRABA.TSA.SERVICE:
* ======================
*
    CALL SERVICE.CONTROL(PARAM.ID,Y.STATUS,Y.ERR3)
    CALL JOURNAL.UPDATE("")
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD   = 1
    PROCESS.GOAHEAD1  = 1
    LOOP.CNT          = 1
    MAX.LOOPS         = 2
    WPARAM.POS        = 1


    Y.SWITH           = "N"
    DIRP.COUNT        = 1
    DIRP.LOOPS        = 2
*
    PARAM.ID2         = "PLANILLA"
    PROC.QUEUE        = "PROC.QUEUE"
    DIR.PROC.QUEUE    = ""
    REQUEST.FILE      = ""
    ANSWER.FILE       = ""
*
*   CONSTANTS
*
    L.DATE            = TODAY
    RIP.PARAM1        = ""
    RIP.VALUE1        = ""
*
*   Batch Process Header table
*
    FN.REDO.FI.LB.BATCH.PROCESS = "F.REDO.FI.LB.BPROC"
    F.REDO.FI.LB.BATCH.PROCESS  = ""
*
*   TSA Service
*
    FN.F.TSA.SERVICE  = "F.TSA.SERVICE"
    F.F.TSA.SERVICE   = ""
    R.F.TSA.SERVICE   = ""
*
*   Interface Param
*
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM  = ""
    R.REDO.INTERFACE.PARAM  = ""


    COMM.PLANILLA.PROCESS  = ""
    COMM.PLANILLA.ID       = ""
    COMM.PLANILLA.REC      = ""
    COMM.ID.PROCESO.BATCH  = ""
    L.ID.PROCESO.BATCH     = ""

    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING Y.POS THEN
        L.ID.PROCESO.BATCH = ENQ.DATA <4,Y.POS>       ;* ID PLANILLA to recalculate
    END
*

    REQUEST.FILE = L.ID.PROCESO.BATCH:".rec"
    ANSWER.FILE  = L.ID.PROCESO.BATCH:".anc"
*
    PLANILLA.ID = FIELD(L.ID.PROCESO.BATCH,".",1)

    COMM.PLANILLA.PROCESS  = PLANILLA.ID
    COMM.PLANILLA.ID<-1>   = PLANILLA.ID
    COMM.PLANILLA.REC<-1>  = 0
    COMM.ID.PROCESO.BATCH  = L.ID.PROCESO.BATCH

RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.REDO.FI.LB.BATCH.PROCESS,F.REDO.FI.LB.BATCH.PROCESS)
    CALL OPF(FN.F.TSA.SERVICE,F.F.TSA.SERVICE)
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)

RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
                CALL F.READ(FN.REDO.INTERFACE.PARAM, PARAM.ID2, R.REDO.INTERFACE.PARAM, F.REDO.INTERFACE.PARAM, Y.ERR)
                IF Y.ERR THEN
                    PROCESS.GOAHEAD = 0
                    W.E = "PARAMETER.MISSING.&":@FM:PARAM.ID
                END

                RIP.PARAM1 = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
                RIP.VALUE1 = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

                WPARAM.POS = 1
                LOCATE PROC.QUEUE IN RIP.PARAM1<1,WPARAM.POS> SETTING PARAM.POS THEN
                    DIR.PROC.QUEUE = RIP.VALUE1<1,PARAM.POS>
                    WPARAM.POS   = PARAM.POS + 1
                END ELSE
                    WERROR.MSG = "&.Process.Queue.not.defined.in.&":@FM:PROC.QUEUE:@VM:PARAM.ID2
                END
        END CASE

        LOOP.CNT +=1
    REPEAT
RETURN
*

END
