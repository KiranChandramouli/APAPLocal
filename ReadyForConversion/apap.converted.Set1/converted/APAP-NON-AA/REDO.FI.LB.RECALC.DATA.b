SUBROUTINE REDO.FI.LB.RECALC.DATA(AA.PAY.SCH.ID)
*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Stores the AA info in REDO.FI.LB.BPROC.DET table
*
* ====================================================================================
*
* Subroutine Type : Multithreaded ROUTINE - PROCESS
* Attached to     : REDO.FI.PLANILLA service
* Attached as     : Service
* Primary Purpose : Recalculate data for APAP-Planillas
*
*
* Incoming:
* ---------
*
*        AA.PAY.SCH.ID  -  Contains sequence of record detail  to be processed
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
*
    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON
    $INSERT I_F.REDO.FI.LB.BPROC.DET
*
*
*************************************************************************
*

    IF PROCESS.GOAHEAD THEN
        GOSUB INITIALISE
        GOSUB OPEN.FILES
        GOSUB CHECK.PRELIM.CONDITIONS
        IF PROCESS.GOAHEAD THEN
            GOSUB PROCESS
            CALL JOURNAL.UPDATE("")
        END
    END
*
RETURN
*
* ======
PROCESS:
* ======
*

    CALL F.READ(FN.REDO.FI.LB.BATCH.PROCESS.DET, AA.PAY.SCH.ID, R.REDO.FI.LB.BATCH.PROCESS.DET, F.REDO.FI.LB.BATCH.PROCESS.DET, Y.ERR2)

    DATA.IN = R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.ID.PRESTAMO>

    CALL REDO.FI.LB.GENERATE.AMNTS(DATA.IN,DATA.OUT)
*

    GOSUB B310.WRITE.DETAIL

*
RETURN
*
* ================
B310.WRITE.DETAIL:
* ================
*
    CALL F.READU(FN.REDO.FI.LB.BATCH.PROCESS.DET, AA.PAY.SCH.ID, R.REDO.FI.LB.BATCH.PROCESS.DET, F.REDO.FI.LB.BATCH.PROCESS.DET, Y.ERR2," ")
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.NUEVO.BALANCE>    = DATA.OUT<4> * -1


*
    CALL F.WRITE(FN.REDO.FI.LB.BATCH.PROCESS.DET,AA.PAY.SCH.ID,R.REDO.FI.LB.BATCH.PROCESS.DET)
*

RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD           = 1
    PROCESS.GOAHEAD2          = 1
    LOOP.CNT                  = 1
    MAX.LOOPS                 = 1
    WPARAM.POS                = 1
    L.DATE                    = TODAY

*   Id planilla to generate
*
    PARAM.ID                  = COMM.PLANILLA.PROCESS
    L.ID.PROCESO.BATCH        = COMM.ID.PROCESO.BATCH
*


*
RETURN
*
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.REDO.FI.LB.BATCH.PROCESS.DET,F.REDO.FI.LB.BATCH.PROCESS.DET)
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

        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
