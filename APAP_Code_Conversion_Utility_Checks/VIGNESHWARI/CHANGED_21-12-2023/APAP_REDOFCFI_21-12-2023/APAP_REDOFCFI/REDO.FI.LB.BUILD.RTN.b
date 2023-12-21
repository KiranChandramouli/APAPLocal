* @ValidationCode : MjoxOTk0NDM2OTUzOkNwMTI1MjoxNzAzMTU3MDMzNjA1OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Dec 2023 16:40:33
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
SUBROUTINE REDO.FI.LB.BUILD.RTN(ENQ.DATA)
*
* ============================================================================
*
* Subroutine Type : BUILD ROUTINE
* Attached to     : ENQUIRY
* Attached as     : Build Routine
* Primary Purpose : Start process of generating data for PAYROLL Interface
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos ODR-2010-03-0025
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Nov. 23, 2010
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*17-12-2023          VIGNESHWARI                     MANUAL R22 CODE CONVERSION             CHANGE F.READ TO CACHE.READ,CALL RTN MODIFIED
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.TSA.SERVICE
    $USING EB.TransactionControl

    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_System
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
    IF WERROR.MSG THEN
        CALL TXT(WERROR.MSG)
        ENQ.ERROR = WERROR.MSG
        ENQ.DATA <4,1> = "ERROR"
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
    WHILE NO.OF.REC NE 1 AND LOOP.CNT LE 20 DO

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
            WERROR.MSG = "EB-ERROR.CREATE.FILE":@FM:REQUEST.FILE
        END
    END

    DATO.OUT=L.ID.PROCESO.BATCH
    WRITESEQ DATO.OUT APPEND TO O.POINTER ELSE
        WERROR.MSG ="EB-ERROR.WRITE.FILE":@FM:REQUEST.FILE
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
        WERROR.MSG = "EB-ERROR.FAILED.DELETE " : @FM : DELETE.ERR : @VM : REQUEST.FILE
    END
*
RETURN
*
* ============
B150.SERVICES:
* ============
*
    Y.STATUS=""
    PARAM.ID = "BNK/REDO.FI.PLANILLA"
    CALL F.READ(FN.F.TSA.SERVICE, PARAM.ID, R.F.TSA.SERVICE, F.F.TSA.SERVICE, Y.ERR)
    IF Y.ERR THEN
        PROCESS.GOAHEAD = 0
        WERROR.MSG = "EB-Record.&.missing.in.&.table":@FM:PARAM.ID:@VM:FN.F.TSA.SERVICE
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
* ================
B210.GENERATE.KEY:
* ================
*
    L.DATE = TODAY
    K.DATE = L.DATE[1,6]
    F.KEY  = PLANILLA.ID:".":K.DATE

    SEL.CMD  = "SELECT ":FN.REDO.FI.LB.BATCH.PROCESS
    SEL.CMD := " WITH @ID LIKE '":F.KEY:"...'"

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.COD)

    F.SEQ = 1
    IF NO.OF.REC GT 0 THEN
        F.SEQ = NO.OF.REC + 1
    END

    L.ID.PROCESO.BATCH  = F.KEY:".":F.SEQ


    COMM.PLANILLA.PROCESS  = PLANILLA.ID
    COMM.PLANILLA.ID<-1>   = PLANILLA.ID
    COMM.PLANILLA.REC<-1>  = 0
    COMM.ID.PROCESO.BATCH  = L.ID.PROCESO.BATCH

*
RETURN
*
* ======================
GRABA.TSA.SERVICE:
* ======================
*
    CALL SERVICE.CONTROL(PARAM.ID,Y.STATUS,Y.ERR3)
 *   CALL JOURNAL.UPDATE("")
 EB.TransactionControl.JournalUpdate("");*MANUAL R22 CODE CONVERSION-CALL RTN MODIFIED
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
    MAX.LOOPS         = 3
    WPARAM.POS        = 1
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
    WERROR.MSG        = ""
*
*   TSA ServicE
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
*
*   Interface Param
*
    FN.REDO.FI.LB.BATCH.PROCESS = "F.REDO.FI.LB.BPROC"
    F.REDO.FI.LB.BATCH.PROCESS  = ""
*
    COMM.PLANILLA.PROCESS  = ""
    COMM.PLANILLA.ID       = ""
    COMM.PLANILLA.REC      = ""
*
    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING Y.POS THEN
        PLANILLA.ID               = ENQ.DATA <4,Y.POS>          ;* ID PLANILLA to generate
    END
*
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.F.TSA.SERVICE,F.F.TSA.SERVICE)
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
    CALL OPF(FN.REDO.FI.LB.BATCH.PROCESS,F.REDO.FI.LB.BATCH.PROCESS)

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
               * CALL F.READ(FN.REDO.INTERFACE.PARAM, PARAM.ID2, R.REDO.INTERFACE.PARAM, F.REDO.INTERFACE.PARAM, Y.ERR)
                CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, PARAM.ID2, R.REDO.INTERFACE.PARAM, Y.ERR);*MANUAL R22 CODE CONVERSION -  CHANGE F.READ TO CACHE.READ
                IF Y.ERR THEN
                    PROCESS.GOAHEAD = 0
                    WERROR.MSG = "EB-PARAMETER.RECORD.&.MISSING":@FM:PARAM.ID:@VM:FN.REDO.INTERFACE.PARAM
                END

                RIP.PARAM1 = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
                RIP.VALUE1 = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

                WPARAM.POS = 1
                LOCATE PROC.QUEUE IN RIP.PARAM1<1,WPARAM.POS> SETTING PARAM.POS THEN
                    DIR.PROC.QUEUE = RIP.VALUE1<1,PARAM.POS>
                    WPARAM.POS   = PARAM.POS + 1
                END ELSE
                    WERROR.MSG = "EB-&.Process.Queue.not.defined.in.&":@FM:PROC.QUEUE:@VM:PARAM.ID2
                END

            CASE LOOP.CNT EQ 2
                CALL EB.VALIDATE.TSM.STATUS(WERROR.MSG)

            CASE LOOP.CNT EQ 3
                GOSUB B210.GENERATE.KEY
                REQUEST.FILE = L.ID.PROCESO.BATCH:".req"
                ANSWER.FILE  = L.ID.PROCESO.BATCH:".ans"
        END CASE

        IF WERROR.MSG THEN
            PROCESS.GOAHEAD = 0
        END

        LOOP.CNT +=1
    REPEAT
RETURN
*

END
