* @ValidationCode : MjotMjY0ODY1OTk0OkNwMTI1MjoxNjgxMjgyNDMxMjIzOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:23:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.PENDING.SCH.PROJECTOR(Y.PROCESS.ID)
*-------------------------------------------------------------
*Description: This routine is to update the concat table REDO.AA.SCHEDULE with the loan's
*             Full schedule details by projecting the schedule using the API - AA.SCHEDULE.PROJECTOR
*             This is an activation service(.SELECT not required) which will be running in AUTO mode.
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - VM TO @VM
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.PENDING.SCH.PROJECTOR.COMMON

    GOSUB PROCESS
RETURN
*-------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------

    CALL OCOMO("Processing the id - ":Y.PROCESS.ID)

    Y.AA.ID  = FIELD(Y.PROCESS.ID,'*',1)
    R.REDO.AA.SCHEDULE    = ''
    CALL F.READU(FN.REDO.AA.SCHEDULE,Y.AA.ID,R.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE,AA.ERR,'')         ;* It will run only in single agent. Anyway we use the locking.
    Y.AAA.ID = FIELD(Y.PROCESS.ID,'*',2)
    NO.RESET       = ''
    DATE.RANGE     = ''
    SIMULATION.REF = ''
    CALL AA.SCHEDULE.PROJECTOR(Y.AA.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
    R.REDO.AA.SCHEDULE<1> = LOWER(TOT.PAYMENT)
    R.REDO.AA.SCHEDULE<2> = LOWER(DUE.DATES)
    R.REDO.AA.SCHEDULE<3> = LOWER(DUE.TYPES)
    R.REDO.AA.SCHEDULE<4> = LOWER(DUE.METHODS)
    R.REDO.AA.SCHEDULE<5> = LOWER(DUE.TYPE.AMTS)
    R.REDO.AA.SCHEDULE<6> = LOWER(DUE.PROPS)
    R.REDO.AA.SCHEDULE<7> = LOWER(DUE.PROP.AMTS)
    R.REDO.AA.SCHEDULE<8> = LOWER(DUE.OUTS)
    Y.AAA.CNT = DCOUNT(R.REDO.AA.SCHEDULE<9>,@VM)
    IF Y.AAA.CNT GE 20 THEN     ;* No need to store more than last 20 AAA ids.
        DEL R.REDO.AA.SCHEDULE<9,1>
        R.REDO.AA.SCHEDULE<9,-1> = Y.AAA.ID
    END ELSE
        R.REDO.AA.SCHEDULE<9,-1> = Y.AAA.ID
    END
    CALL F.WRITE(FN.REDO.AA.SCHEDULE,Y.AA.ID,R.REDO.AA.SCHEDULE)
    CALL F.RELEASE(FN.REDO.AA.SCHEDULE,Y.AA.ID,F.REDO.AA.SCHEDULE)
    CALL OCOMO("Processed the id - ":Y.PROCESS.ID)
RETURN
END
