* @ValidationCode : MjoyMDcyMDY4MzY6Q3AxMjUyOjE2ODExMjkwMTUyMzg6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 17:46:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.CHK.INT.CR.ACBAL
*
*=======================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2012/JUL/19
*
*=======================================================================
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*10-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.TELLER
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
*--------
PROCESS:
*--------
*
    CALL APAP.TAM.REDO.VVR.INTER.CR.ACBAL
*
RETURN
*
*----------------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------------
*
    PROCESS.GOAHEAD = "1"
*
RETURN
*
*----------
OPEN.FILES:
*----------
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF R.NEW(TT.TE.RECORD.STATUS)[1,3] NE "RNA" THEN
                    PROCESS.GOAHEAD = ""
                END
        END CASE
*
*       Increase
*
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END
