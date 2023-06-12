* @ValidationCode : MjoxNjcwMjExODgxOkNwMTI1MjoxNjgwNjA3MTMzMDUyOklUU1M6LTE6LTE6LTQzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:48:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -43
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.LB.BPROC.VALIDA.STATUS
*
******************************************************************************
*
*    Version routine to validate status change for APAP-Planillas Batch Process
*    Parameters:
*       DATA.IN   Planilla type
*       ERR.OUT   Error Code 1 = An error occured
* =============================================================================
*
*    First Release : Adriana Velasco
*    Developed for : APAP ODR-2010-03-0025
*    Developed by  : Adriana Velasco
*    Date          : 2010/Nov/12
*  DATE             WHO                   REFERENCE                  
* 05-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 05-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.FI.LB.BPROC
    $INSERT I_REDO.FI.VAR.LOAN.BILL.COMMON
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
    IF Y.ESTADO.ANT EQ 'DESESTIMADO' OR Y.ESTADO.ANT EQ 'APLICADO' THEN
        AF = REDO.FI.LB.BPROC.ESTADO
        ETEXT = "EB-Can.not.change.status"
        CALL STORE.END.ERROR
    END
*
RETURN
*

* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD           = 1
    LOOP.CNT                  = 1
    MAX.LOOPS                 = 1
*
    Y.ESTADO       = R.NEW(REDO.FI.LB.BPROC.ESTADO)
    Y.ESTADO.ANT   = R.OLD(REDO.FI.LB.BPROC.ESTADO)
*
RETURN
*
* =========
OPEN.FILES:
* =========
*

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
