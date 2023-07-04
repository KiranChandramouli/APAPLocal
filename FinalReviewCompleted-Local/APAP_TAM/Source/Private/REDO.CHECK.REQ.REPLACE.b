* @ValidationCode : Mjo5NTU2MTE2MTE6Q3AxMjUyOjE2ODA2NzE3NTc0ODc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:45:57
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
SUBROUTINE REDO.CHECK.REQ.REPLACE
*----------------------------------------------------
*Description: This is a Check Req routine for the version REDO.RATE.CHANGE,REPLACE.INPUT.

*-----------------------------------------------------------------------------
* Modification History :
*
*   Date            Who                   Reference               Description
* 05 Dec 2011   H Ganesh               Massive rate              Initial Draft
** 05-04-2023 R22 Auto Conversion no changes
** 05-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.RATE.CHANGE

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*----------------------------------------------------
OPENFILES:
*----------------------------------------------------
    FN.REDO.RATE.CHANGE = 'F.REDO.RATE.CHANGE'
    F.REDO.RATE.CHANGE = ''
    CALL OPF(FN.REDO.RATE.CHANGE,F.REDO.RATE.CHANGE)

RETURN
*----------------------------------------------------
PROCESS:
*----------------------------------------------------

    R.REDO.RATE.CHANGE.CRIT = ''

    CALL F.READ(FN.REDO.RATE.CHANGE,ID.NEW,R.REDO.RATE.CHANGE.CRIT,F.REDO.RATE.CHANGE,RATE.ERR)

    IF R.REDO.RATE.CHANGE.CRIT THEN
        IF R.REDO.RATE.CHANGE.CRIT<REDO.RT.FILE.TYPE> NE 'REPLACE' AND R.REDO.RATE.CHANGE.CRIT<REDO.RT.FILE.TYPE> NE '' THEN
            E = 'EB-REDO.NOT.A.REPLACE'
            RETURN
        END
    END ELSE
        R.NEW(REDO.RT.FILE.TYPE) = 'REPLACE'
    END
RETURN
END
