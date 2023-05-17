SUBROUTINE REDO.FI.LB.GENERATE.DATA.SELECT
*
* ====================================================================================
*
*    - Selects records from AA.PAYMENT.SCHEDULE TABLE
*
*    - Formats LIST of ID's to be processed: adds sequental number before AA ID
*
* ====================================================================================
*
* Subroutine Type : Multithreaded ROUTINE - SELECT
* Attached to     : REDO.FI.PLANILLA service
* Attached as     : Service
* Primary Purpose : Generate data for APAP-Planillas
*
*-------------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos ODR-2010-03-0025
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Nov. 15, 2010
*=====================================================================================
* Modified by     : Adriana Velasco - TAM Latin America
* Date            : Oct. 21, 2011
* Details         : Change select conditions to use L.AA.FORM or L.AA.PAY.METHD depending of
*                   some validations
*=====================================================================================
*=====================================================================================
* Modified by     : Gopala Krishnan R - Temenos India Pvt Ltd - PACS00652589
* Date            : Feb. 20, 2018
* Details         : Arrangement with status EQ CURRENT AND EXPIRED
*=====================================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
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
    N.SEQ= 1

    LOOP
        REMOVE AA.ID FROM SEL.LIST2 SETTING POSS2
    WHILE AA.ID:POSS2
        AA.PS.LIST<-1> = N.SEQ:"*":AA.ID
        N.SEQ += 1
    REPEAT


    CALL BATCH.BUILD.LIST("",AA.PS.LIST)
*
RETURN
*
* =========
INITIALISE:
* =========
*
    LOOP.CNT                  = 1
    MAX.LOOPS                 = 1
    WPARAM.POS                = 1
    LIST.PARAM                = ""
    AA.PS.LIST                = ""
    PROCESS.GOAHEAD = 1
*

    SEL.CMD1  = "SELECT ":FN.AA.ARRANGEMENT
    SEL.CMD1 := " WITH PRODUCT.LINE EQ LENDING AND ARR.STATUS EQ CURRENT EXPIRED"        ;*PACS00652589


    CRT 'SEL.CMD1->':SEL.CMD1
RETURN
*
*
* =========
OPEN.FILES:
* =========
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*

    NO.OF.REC2 = 0
    PLANILLA.ID     = "PLANILLA"
    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, PLANILLA.ID, R.REDO.PLANILLA.INTERFACE.PARAM, Y.ERR)
    PLANILLA.GROUP.LIST =  R.REDO.PLANILLA.INTERFACE.PARAM<REDO.INT.PARAM.AFF.COMPANY>
    PLANILLA.STATUS     =  R.REDO.PLANILLA.INTERFACE.PARAM<REDO.INT.PARAM.SERVICE.CONTROL>

    LOOP
        REMOVE FI.GROUP.ID FROM PLANILLA.GROUP.LIST SETTING Y.GROUP.POS.FILE
    WHILE FI.GROUP.ID:Y.GROUP.POS.FILE
        CALL F.READ(FN.REDO.INTERFACE.PARAM, FI.GROUP.ID, R.REDO.GRP.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM, Y.ERR)
        PLANILLA.LIST = R.REDO.GRP.INTERFACE.PARAM<REDO.INT.PARAM.AFF.COMPANY>
        IF FI.GROUP.ID EQ 'APAP-EXEC-EMPLEADOS' THEN
            PLANILLA.LIST = 'APAP-EXEC-EMPLEADOS'
        END
        IF FI.GROUP.ID EQ 'APAP-EMPLEADOS' THEN
            PLANILLA.LIST = 'APAP-EMPLEADOS'
        END
        LOOP
            REMOVE Y.ID.PLANILLA FROM  PLANILLA.LIST SETTING Y.POS.FILE
        WHILE Y.ID.PLANILLA:Y.POS.FILE
            CALL F.READ(FN.REDO.INTERFACE.PARAM, Y.ID.PLANILLA, R.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM, Y.ERR)
            RIP.PARAM.STATUS = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.SERVICE.CONTROL>
            IF RIP.PARAM.STATUS EQ 'ACTIVE' THEN
                GOSUB ACTIVE.CHECK
                RETURN
            END
        REPEAT
    REPEAT

RETURN
* =============
ACTIVE.CHECK:
* =============

    IF PLANILLA.STATUS EQ 'ACTIVE' THEN
        CALL EB.READLIST(SEL.CMD1,SEL.LIST2,'',NO.OF.REC2,Y.ERR5)

    END

    IF NO.OF.REC2 EQ 0 THEN
        PROCESS.GOAHEAD = 0
    END

RETURN
*
END
