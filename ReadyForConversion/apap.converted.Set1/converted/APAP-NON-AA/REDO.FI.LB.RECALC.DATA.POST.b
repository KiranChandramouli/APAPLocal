SUBROUTINE REDO.FI.LB.RECALC.DATA.POST
*
* Subroutine Type : Subroutine
* Attached to     : BATCH record REDO.FI.PLANILLA.REC
* Attached as     : Subroutine
* Primary Purpose : Save file answer in process recalculate
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
* Error Variables:
* ----------------
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Ana Noriega - TAM Latin America
* Date            : Nov 26, 2010
*
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON
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
*  Principal Process
*
    LOOP.CNT  = 1
    MAX.LOOPS = 2
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
* Open directory
                GOSUB OPEN.PATH

            CASE LOOP.CNT EQ 2
* Save Answer File in PROC.QUEUE path
                GOSUB SAVE.ANSWER
* Close File
                GOSUB CLOSE.PATH

        END CASE

* Control message error
        GOSUB CONTROL.MSG.ERROR
* Increase option
        LOOP.CNT +=1
    REPEAT
*
RETURN
*
* --------
OPEN.PATH:
* --------
*
*  Opend File to save Answer File
*
    OPENSEQ Y.PROC.QUEUE, I.FILE.ANS.ID TO Y.PROC.QUEUE.POINTER ELSE
        CREATE Y.PROC.QUEUE.POINTER ELSE
            Y.ERR = "ERROR.OPENING.SEND.FILE"
        END
    END
*
RETURN
*
* ----------
SAVE.ANSWER:
* ----------
*
*  SAVE ANSWER
*
    Y.RECORD = "Process Recalculate Planilla ": Y.ID.PROCESS: " completed at ": TODAY
    WRITESEQ Y.RECORD APPEND TO Y.PROC.QUEUE.POINTER ELSE
        Y.ERR ="EB-ERROR.WRITE.PROC.QUEUE"
    END
*
RETURN
*
* ---------
CLOSE.PATH:
* ---------
*  Close File to queue process
*
    WEOFSEQ   Y.PROC.QUEUE.POINTER        ;* Writes an EOF
    CLOSESEQ  Y.PROC.QUEUE.POINTER
*
RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph that control the error in the subroutine
*
    IF Y.ERR NE "" THEN
        PROCESS.GOAHEAD = 0
        CALL TXT(Y.ERR)
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
*  Inicialise Variables
*
    PROCESS.GOAHEAD            = 1
    LOOP.CNT                   = 1
    MAX.LOOPS                  = 3
*
    Y.ERR                      = ""
*
*  Get current Id Process, take from de common variable
    Y.ID.PROCESS               = COMM.ID.PROCESO.BATCH        ;*The first possition is the Id Planilla
*
*  Set path queue
    Y.PROC.QUEUE               = FI.QUEUE.PATH
*
*  Set name file to send to path queue
    I.FILE.ANS.ID              = Y.ID.PROCESS:".anc"
*
RETURN
*
* =========
OPEN.FILES:
* =========
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
* Validate Planilla Process Id
                IF Y.ID.PROCESS EQ "" THEN
                    Y.ERR = "Planilla.Process.Id.Not.Exists"
                END

        END CASE

* Control message error
        GOSUB CONTROL.MSG.ERROR
* Increase option
        LOOP.CNT +=1
    REPEAT
*
RETURN
*
END
