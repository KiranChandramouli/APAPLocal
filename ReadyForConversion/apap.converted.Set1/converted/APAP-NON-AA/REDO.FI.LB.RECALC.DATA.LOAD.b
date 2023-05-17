SUBROUTINE REDO.FI.LB.RECALC.DATA.LOAD
*
* =============================================================================
*
*    - Looks for  ".rec"  file in a directory specified in  PLANILLA record of
*      REDO.INTERFACE.PARAM table. The name of the file defines which PLANILLA
*      process should be executed
*
*    - Deletes the ".rec" file
*
*    - Opens required T24 Tables
*
*    - Looks for LOCAL.REF.FIELD positions
*
*    - Stores required variables in a COMMON area for .SELECT and PROCESS routines
*
* ==============================================================================
*
* Subroutine Type : Multithreaded ROUTINE
* Attached to     : REDO.FI.PLANILLA.R service
* Attached as     : Service
* Primary Purpose : Recalculate data for APAP-Planillas
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos ODR-2010-03-0025
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Nov. 26, 2010
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.FI.LB.BPROC
    $INSERT I_F.REDO.FI.LB.BPROC.DET

*
    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON

    $INSERT I_F.REDO.INTERFACE.PARAM

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
    LOOKING.FOR        = 1
    L.ID.PROCESO.BATCH = ""
    PLANILLA.LIST      = ""
    FI.FILE.ID         = ""
    POINT.POS          = 0
*
    Y.SEL.CMD = "SELECT " : FI.QUEUE.PATH
    CALL EB.READLIST(Y.SEL.CMD,PLANILLA.LIST,"",NO.OF.REC,YER.SEL)

*    SELECT QUEUE.DIR.POINTER TO PLANILLA.LIST
    PROCESS.GOAHEAD = 0
    LOOP
        REMOVE FI.FILE.ID FROM PLANILLA.LIST SETTING Y.POS.FILE
    WHILE FI.FILE.ID:Y.POS.FILE AND LOOKING.FOR DO
        L.ID.PROCESO.BATCH = FIELD(FI.FILE.ID,".rec",1)
        POINT.POS          = INDEX(FI.FILE.ID,".rec",1)
        IF L.ID.PROCESO.BATCH AND POINT.POS THEN
            PROCESS.GOAHEAD = 1
            COMM.ID.PROCESO.BATCH = L.ID.PROCESO.BATCH
            PARAM.ID              = FIELD(L.ID.PROCESO.BATCH,".",1)
            GOSUB B140.READ.PLANILLA.PARAM
*DELETE QUEUE.DIR.POINTER, FI.FILE.ID
            LOOKING.FOR           = ""
        END
    REPEAT
*

RETURN
*
* =======================
B140.READ.PLANILLA.PARAM:
* =======================
*
    METODO.PAGO               = "METODO.PAGO"
    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, PARAM.ID, R.REDO.INTERFACE.PARAM, Y.ERR)
    RIP.PARAM = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    RIP.VALUE = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
* Locate METODO.PAGO
    WPARAM.POS = 1
    LOCATE METODO.PAGO IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
        L.PAY.METH = RIP.VALUE<1,PARAM.POS>
    END ELSE
        WERROR.MSG = "&.Metodo.de.Pago.not.defined.in.&":@FM:METODO.PAGO
        PROCESS.GOAHEAD = 0
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
    LOOP.CNT        = 1
    MAX.LOOPS       = 3

*Id planilla to generate
    PARAM.ID        = COMM.PLANILLA.PROCESS
    PLANILLA.ID     = "PLANILLA"
*

*   CONSTANTS
*
    L.PAY.METH     = ""
    Y.DEST.PATH     = ""        ;* Path for APAP file
    FI.FILE.NEW     = ""        ;* Name for APAP File
    QUEUE.PATH.ID   = "PROC.QUEUE"        ;* Directory path to store the process key

*   Batch Process Detail table
    FN.REDO.FI.LB.BATCH.PROCESS.DET = "F.REDO.FI.LB.BPROC.DET"
    F.REDO.FI.LB.BATCH.PROCESS.DET  = ""
    R.REDO.FI.LB.BATCH.PROCESS.DET  = ""
*   Batch Process Header table
    FN.REDO.FI.LB.BATCH.PROCESS = "F.REDO.FI.LB.BPROC"
    F.REDO.FI.LB.BATCH.PROCESS  = ""
    R.REDO.FI.LB.BATCH.PROCESS  = ""
*
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM  = ""
    R.REDO.INTERFACE.PARAM  = ""


*
RETURN
*
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.REDO.FI.LB.BATCH.PROCESS,F.REDO.FI.LB.BATCH.PROCESS)
    CALL OPF(FN.REDO.FI.LB.BATCH.PROCESS.DET,F.REDO.FI.LB.BATCH.PROCESS.DET)

    CALL OPF (FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
*
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
                CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, PLANILLA.ID, R.REDO.INTERFACE.PARAM, Y.ERR)
                IF Y.ERR THEN
                    W.ERROR = "PARAMETER.MISSING.&":@FM:PLANILLA.ID
                END

            CASE LOOP.CNT EQ 2
                WPARAM.POS = 1
                RIP.PARAM = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
                RIP.VALUE = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
                LOCATE QUEUE.PATH.ID IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
                    FI.QUEUE.PATH  = RIP.VALUE<1,PARAM.POS>
                END ELSE
                    WERROR.MSG = "&.Directory.not.defined.in.&":@FM:QUEUE.PATH.ID:@VM:PLANILLA.ID
                END

            CASE LOOP.CNT EQ 3
                Y.PATH.SEND.ID = "PATH.SEND"
                FI.PATH.SEND   = ""

*  Locate PATH.SEND
                WPARAM.POS = 1
                LOCATE Y.PATH.SEND.ID IN RIP.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
                    FI.PATH.SEND   = RIP.VALUE<1,PARAM.POS>
                END


        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
