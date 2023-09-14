* @ValidationCode : MjoxNTMxMTAyMjc3OkNwMTI1MjoxNjgwNzgxMjIxOTQ1OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:10:21
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
SUBROUTINE REDO.B.ARCHIEVE.TRACE.SELECT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 06-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AUDIT.TRAIL.LOG
    $INSERT I_F.REDO.EX.AUDIT.TRAIL.LOG
    $INSERT I_REDO.B.ARCHIEVE.TRACE.COMMON

    IF CONTROL.LIST EQ '' THEN
        CONTROL.LIST<-1>='Y.PROCESS'
        CONTROL.LIST<-1>='Y.CLEAR'
    END

    IF CONTROL.LIST<1> EQ 'Y.PROCESS' THEN
        SEL.CMD.LCO = "SELECT ":FN.REDO.AUDIT.TRAIL.LOG

        CALL EB.READLIST(SEL.CMD.LCO,SEL.LIST.LCO,'',NO.REC.LCO,PGM.ERR.LCO)

        CALL BATCH.BUILD.LIST('',SEL.LIST.LCO)
    END

    IF CONTROL.LIST<1> EQ 'Y.CLEAR' THEN
        Y.DEL.CMD = 'CLEAR.FILE ':FN.REDO.AUDIT.TRAIL.LOG
        EXECUTE Y.DEL.CMD
    END

RETURN
END
