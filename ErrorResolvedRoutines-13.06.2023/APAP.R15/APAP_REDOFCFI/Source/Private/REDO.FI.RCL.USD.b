* @ValidationCode : MjoxMTM2Mjc3NTQ1OkNwMTI1MjoxNjgwNjA3MTM0NzEzOklUU1M6LTE6LTE6LTQ1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:48:54
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
SUBROUTINE REDO.FI.RCL.USD
******************************************************************************
*
*    Provides Currency code
*
* =============================================================================
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*    First Release : Adriana Velasco
*    Developed for : APAP
*    Developed by  : Adriana velasco
*    Date          : 2010/Oct/20
*  DATE             WHO                   REFERENCE                  
* 05-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 05-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.VERSION
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
*
    COMI = "DOP"
RETURN
*
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD = 1
*
*
RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 1

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
