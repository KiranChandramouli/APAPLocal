* @ValidationCode : Mjo3NzU3MDU4NzY6Q3AxMjUyOjE2ODEyODI0NzMyNzU6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:24:33
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
SUBROUTINE REDO.B.PENDING.SCH.PROJECTOR.LOAD
*-------------------------------------------------------------
*Description: This routine is to update the concat table REDO.AA.SCHEDULE with the loan's
*             Full schedule details by projecting the schedule using the API - AA.SCHEDULE.PROJECTOR
*             This is an activation service which will be running in AUTO mode.
*-------------------------------------------------------------
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.PENDING.SCH.PROJECTOR.COMMON

    GOSUB PROCESS
RETURN
*-------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------

    FN.REDO.AA.SCHEDULE = 'F.REDO.AA.SCHEDULE'
    F.REDO.AA.SCHEDULE  = ''
    CALL OPF(FN.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE)

RETURN
END
