* @ValidationCode : MjoxMTk1NDM4ODMwOkNwMTI1MjoxNjgwNjg4ODQ2MzUxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:30:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHECK.REQ.EXTRACT
*----------------------------------------------------
*Description: This is a Check Req routine for the version REDO.RATE.CHANGE,EXTRACT.INPUT.

*-----------------------------------------------------------------------------
* Modification History :
*
*   Date            Who                   Reference               Description
* 05 Dec 2011   H Ganesh               Massive rate              Initial Draft
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
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
        IF R.REDO.RATE.CHANGE.CRIT<REDO.RT.FILE.TYPE> NE 'EXTRACT' AND R.REDO.RATE.CHANGE.CRIT<REDO.RT.FILE.TYPE> NE '' THEN
            E = 'EB-REDO.NOT.A.EXTRACT'
            RETURN
        END
    END ELSE
        R.NEW(REDO.RT.FILE.TYPE) = 'EXTRACT'
    END
RETURN
END
