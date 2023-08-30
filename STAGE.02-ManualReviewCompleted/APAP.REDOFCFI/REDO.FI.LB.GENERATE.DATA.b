* @ValidationCode : MjoxMzI5MjU5NDgyOkNwMTI1MjoxNjgwNjA4NjE2MjQ4OklUU1M6LTE6LTE6MTM3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 17:13:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 137
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.LB.GENERATE.DATA(AA.PAY.SCH.ID)
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
* Primary Purpose : Generate data for APAP-Planillas
*
*
* Incoming:
* ---------
*
*        AA.PAY.SCH.ID  -  Contains sequence of record and AA ID to be processed
*
*                           Example: NNN*AANNNNNNNNN
*
* Outgoing:
* ---------
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos ODR-2010-03-0025
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Nov. 15, 2010
*  DATE             WHO                   REFERENCE                  
* 05-APRIL-2023      Conversion Tool       R22 Auto Conversion - = to EQ
* 05-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOFCFI to CALL                             
*------------------------------------------------------------------------
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON
    $INSERT I_F.REDO.FI.LB.BPROC.DET
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


    ARR.ID = AA.PAY.SCH.ID


    Y.TERM.AMOUNT=0
    EFF.DATE = ''
    PROP.CLASS='PAYMENT.SCHEDULE'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    Y.AFF.COMP = R.CONDITION<AA.PS.LOCAL.REF,L.AA.FORM.POS>
    Y.PAYMENT.METH = R.CONDITION<AA.PS.LOCAL.REF,L.AA.PAY.METHD.POS>

    LOCATE Y.PAYMENT.METH IN L.PAY.METH SETTING Y.PAY.METH.POS THEN
        IF Y.PAYMENT.METH EQ 'External Payroll' AND NOT(Y.AFF.COMP) THEN
            RETURN
        END  ELSE
            IF Y.AFF.COMP THEN
                LOCATE Y.AFF.COMP IN COMMON.AFF.COMP.LIST SETTING AFF.COMP.POS THEN
                END ELSE
                    RETURN
                END
            END
            GOSUB LOAN.COMPANY.HEAD
            IF SERVICE.CONTROL EQ 'ACTIVE' THEN
                CALL APAP.REDOFCFI.REDO.FI.LB.GENERATE.AMNTS(COMP.TYPE,ARR.ID,DATA.OUT)
                IF DATA.OUT<9> EQ 'S' THEN
                    GOSUB B310.WRITE.DETAIL
                END
            END
        END
    END

RETURN
* ================
LOAN.COMPANY.HEAD:
* ================

    BEGIN CASE
        CASE Y.AFF.COMP NE ''
            Y.LOAN.COMP.ID = Y.AFF.COMP
        CASE Y.PAYMENT.METH EQ 'APAP Employee Payroll'
            Y.LOAN.COMP.ID = 'APAP-EMPLEADOS'
        CASE Y.PAYMENT.METH EQ 'APAP Executive Payroll'
            Y.LOAN.COMP.ID = 'APAP-EXEC-EMPLEADOS'
    END CASE
*
    CALL F.READ(FN.REDO.INTERFACE.PARAM, Y.LOAN.COMP.ID, R.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM, Y.ERR)
    SEQ.ID = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PROCES.SEQ>
    SERVICE.CONTROL = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.SERVICE.CONTROL>
    COMP.TYPE = Y.LOAN.COMP.ID
    Y.LOAN.COMP.ID = COMP.TYPE:".":SEQ.ID


RETURN
*
* ================
B310.WRITE.DETAIL:
* ================
*

    Y.ID.REC = Y.LOAN.COMP.ID:".":FMT(Y.CONT.REC,"R%5")
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.ID.PROCESO.BATCH> = Y.LOAN.COMP.ID
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.ID.PRESTAMO>      = AA.PAY.SCH.ID
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.CLIENTE.ID>       = DATA.OUT<1>
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.EMPLEADO.ID>      = DATA.OUT<3>
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.NOMBRE>           = DATA.OUT<2>
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.MONTO.DESCONTAR>  = DATA.OUT<4> * -1
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.CUOTAS_VENCIDAS>  = DATA.OUT<5>
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.BALANCE>          = DATA.OUT<4> * -1
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.INTERES>          = DATA.OUT<6>
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.TASA>             = DATA.OUT<7>
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.MORA>             = DATA.OUT<8>
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.TIPO.PRESTAMO>    = DATA.OUT<10>
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.CAPITAL>          = DATA.OUT<11>
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.SEGUROS>          = DATA.OUT<12>
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.NUEVO.BALANCE>    = 0
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.MNT.APLICAR>      = 0
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.ESTADO>           = "NO PAGO"
    R.REDO.FI.LB.BATCH.PROCESS.DET<REDO.FI.LB.BPROC.DET.EXCLUYO>          = ""
*
    CALL F.WRITE(FN.REDO.FI.LB.BATCH.PROCESS.DET,Y.ID.REC,R.REDO.FI.LB.BATCH.PROCESS.DET)
*
RETURN
*
* =========
INITIALISE:
* =========
*
    LOOP.CNT                  = 1
    MAX.LOOPS                 = 1
*
*   Id planilla to generate

*
    Y.CONT.REC    = FIELD(AA.PAY.SCH.ID,"*",1)
    AA.PAY.SCH.ID = FIELD(AA.PAY.SCH.ID,"*",2)
*
RETURN
*
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

        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
