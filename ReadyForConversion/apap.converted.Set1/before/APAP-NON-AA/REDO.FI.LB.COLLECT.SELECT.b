*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.FI.LB.COLLECT.SELECT
*
* ====================================================================================
*
*    - Selects records from REDO.FI.LB.BPROC.DET TABLE
*
* ====================================================================================
* Subroutine Type : Multithreaded ROUTINE - SELECT
* Attached to     : REDO.FI.COLLECT service
* Attached as     : Service
* Primary Purpose : Apply payments reported in APAP-Planillas
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
    $INSERT I_BATCH.FILES
*
    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON
    $INSERT I_F.REDO.FI.LB.BPROC
*
*************************************************************************
*

    GOSUB PROCESS


    RETURN
*
* ======
PROCESS:
* ======

    IF CONTROL.LIST EQ '' THEN
        CALL OCOMO('Running BNK/REDO.FI.PLANILLA.COLLECT to apply PAYMENTS reported in APAP-Planillas')
        CONTROL.LIST = 'BATCH.PROCESS':FM:'PROCESS.DET':FM:'BALANCE.ADJUST'
    END

    YACTION = CONTROL.LIST<1,1>

    SEL.CMD = ''

    BEGIN CASE
    CASE YACTION EQ 'BATCH.PROCESS'
        Y.SEL.CMD = "SELECT " : FI.QUEUE.PATH
        CALL EB.READLIST(Y.SEL.CMD,PLANILLA.LIST,"",NO.OF.REC,YER.SEL)

        CALL BATCH.BUILD.LIST(LIST.PARAM,PLANILLA.LIST)
        Y.PARAM.IDS = PLANILLA.LIST

    CASE YACTION EQ 'PROCESS.DET'
        Y.SEL.CMD = "SELECT ":FN.REDO.FI.LB.BATCH.PROCESS.DET: " WITH ( "
        LOOP
            REMOVE Y.PARAM.ID FROM Y.PARAM.IDS SETTING Y.POS.FILE
        WHILE Y.PARAM.ID:Y.POS.FILE
            PARAM.TXN.ID = FIELD(Y.PARAM.ID,'.',1):'.': FIELD(Y.PARAM.ID,'.',2)
            Y.SEL.CMD = Y.SEL.CMD: " @ID LIKE '":PARAM.TXN.ID:"...' OR"
        REPEAT
        Y.SEL.CMD = Y.SEL.CMD[1,LEN(Y.SEL.CMD)-2]
        Y.SEL.CMD := " ) AND WITH ESTADO EQ 'NO PAGO' AND EXCLUYO NE 'SI'"
        CALL EB.READLIST(Y.SEL.CMD,PLANILLA.LIST,"",NO.OF.REC,YER.SEL)
        CALL BATCH.BUILD.LIST(LIST.PARAM,PLANILLA.LIST)

    CASE YACTION EQ 'BALANCE.ADJUST'
        Y.SEL.CMD = "SELECT " : FI.QUEUE.PATH
        CALL EB.READLIST(Y.SEL.CMD,PLANILLA.LIST,"",NO.OF.REC,YER.SEL)
        CALL BATCH.BUILD.LIST(LIST.PARAM,PLANILLA.LIST)

    END CASE

    RETURN

END
