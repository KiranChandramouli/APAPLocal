* @ValidationCode : MjotOTc5NzMwMTczOkNwMTI1MjoxNjgwNjA3MTMzODAyOklUU1M6LTE6LTE6LTQ1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:48:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -45
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.LB.RECALC.DATA.SELECT
*
* ====================================================================================
*
*    - Selects records from REDO.FI.LB.BPROC.DET TABLE
*
*
* ====================================================================================
*
* Subroutine Type : Multithreaded ROUTINE - SELECT
* Attached to     : REDO.FI.PLANILLA.REC service
* Attached as     : Service
* Primary Purpose : Recalculate data for APAP-Planillas
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos ODR-2010-03-0025
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Nov. 26, 2010
*  DATE             WHO                   REFERENCE 
* 05-APRIL-2023      Harsha                R22 Auto Conversion  - No changes
* 05-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------------------------
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
    $INSERT I_REDO.FI.LB.GENERATE.DATA.COMMON
    $INSERT I_F.REDO.FI.LB.BPROC.DET
*
*************************************************************************
*

    IF PROCESS.GOAHEAD THEN
        GOSUB INITIALISE
        GOSUB OPEN.FILES
        GOSUB CHECK.PRELIM.CONDITIONS
        IF PROCESS.GOAHEAD THEN
            GOSUB PROCESS
        END
    END
*
RETURN
*
* ======
PROCESS:
* ======
*

    CALL BATCH.BUILD.LIST(LIST.PARAM,AA.PS.LIST)
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
    PARAM.ID =""
*
    PARAM.ID                  = COMM.ID.PROCESO.BATCH
*
*   Get the records from planilla detail
*
    SEL.CMD1  = "SELECT ":FN.REDO.FI.LB.BATCH.PROCESS.DET
    SEL.CMD1 := " WITH ID.PROCESO.BATCH EQ '":PARAM.ID:"'"
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

                LIST.PARAM<2> = FN.REDO.FI.LB.BATCH.PROCESS.DET
                LIST.PARAM<3> = SEL.CMD1
        END CASE

        LOOP.CNT +=1
    REPEAT
RETURN
*

END
