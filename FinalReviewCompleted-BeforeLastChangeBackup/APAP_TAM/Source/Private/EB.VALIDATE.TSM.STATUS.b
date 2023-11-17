* @ValidationCode : MjoxMjIzOTY4NzAzOkNwMTI1MjoxNjgwNjAyNDgwNTk1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:31:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE EB.VALIDATE.TSM.STATUS(WERROR.MSG)
*
******************************************************************************
* Subroutine Type : BUILD ROUTINE
* Attached to     :
* Attached as     :
* Primary Purpose :
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*        WERROR.MSG       - Mensaje de error si lo hubiere
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Regional TAM
* Development by  : Joaquin Costa
* Date            : Nov. 26, 2010

** 04-04-2023 R22 Auto Conversion – FM TO @FM, VM to @VM, SM to @SM
** 04-04-2023 Skanda R22 Manual Conversion - No changes
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TSA.SERVICE
    $INSERT I_F.TSA.STATUS
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
    Y.SERVICE.STATUS = R.F.TSA.SERVICE<TS.TSM.SERVICE.CONTROL>
    Y.AGENT.STATUS   = R.F.TSA.STATUS<TS.TSS.AGENT.STATUS>
*
    IF Y.SERVICE.STATUS EQ "STOP" AND Y.AGENT.STATUS EQ "RUNNING" THEN
        WERROR.MSG = "EB-Service.Control.&.Agent.Status.&":@FM:Y.SERVICE.STATUS:@VM:Y.AGENT.STATUS
        CALL TXT(WERROR.MSG)
    END
    IF Y.SERVICE.STATUS EQ "START" AND Y.AGENT.STATUS EQ "STOPPED" THEN
        WERROR.MSG = "EB-TSM.service.is.not.started"
        CALL TXT(WERROR.MSG)
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD   = 1
    LOOP.CNT          = 1
    MAX.LOOPS         = 2
    STATUS.ID         = 1
    SERVICE.ID        = "TSM"
*
*   TSA ServicE
*
    FN.F.TSA.SERVICE  = "F.TSA.SERVICE"
    F.F.TSA.SERVICE   = ""
    R.F.TSA.SERVICE   = ""
*
*   TSA STATUS
*
    FN.F.TSA.STATUS  = "F.TSA.STATUS"
    F.F.TSA.STATUS   = ""
    R.F.TSA.STATUS   = ""
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.F.TSA.SERVICE,F.F.TSA.SERVICE)
    CALL OPF(FN.F.TSA.STATUS,F.F.TSA.STATUS)

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
                CALL F.READ(FN.F.TSA.SERVICE, SERVICE.ID, R.F.TSA.SERVICE, F.F.TSA.SERVICE, Y.ERR)
                IF Y.ERR THEN
                    PROCESS.GOAHEAD = 0
                    WERROR.MSG = "MISSING & SERVICE RECORD":@FM:SERVICE.ID
                    CALL TXT(WERROR.MSG)
                END

            CASE LOOP.CNT EQ 2
                CALL F.READ(FN.F.TSA.STATUS, STATUS.ID, R.F.TSA.STATUS, F.F.TSA.STATUS, Y.ERR)
                IF Y.ERR THEN
                    R.F.TSA.STATUS = ""
                END

        END CASE

        LOOP.CNT +=1
    REPEAT
RETURN
*

END
