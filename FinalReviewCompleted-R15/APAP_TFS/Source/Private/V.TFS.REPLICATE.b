* @ValidationCode : MjotMTA1NzY3NDUzNTpDcDEyNTI6MTY5ODc1MDY3NDc0MTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>-44</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE V.TFS.REPLICATE
*
* Subroutine Type : PROCEDURE
* Attached to     : VERSION Name
* Attached as     : FIELD.VAL.RTN
* Primary Purpose : Default previous teller's account
*
* Incoming:
* ---------
*          None
*
* Outgoing:
* ---------
*          None
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 07/05/14 - Ganesh Prasad K
*            UNFCU Teller local devs
*
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion          GLOBUS.BP File Removed
*-----------------------------------------------------------------------------------
* Always use $INCLUDE BpName instead of $INSERT
    $INCLUDE I_COMMON ;*R22 Manual Conversion
    $INCLUDE I_EQUATE ;*R22 Manual Conversion
    $INCLUDE I_GTS.COMMON ;*R22 Manual Conversion

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS


    END

RETURN
*-----------------------------------------------------------------------------------
PROCESS:

    IF AV EQ '2' THEN

        COMI = R.NEW (AF)<1,1>
    END


RETURN
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------
*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:

    PROCESS.GOAHEAD = 1

RETURN
*-----------------------------------------------------------------------------------
OPEN.FILES:

RETURN
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*
* Check for any Pre requisite conditions - like the existence of a record/parameter etc
* if not, set PROCESS.GOAHEAD to 0
*
* When adding more CASEs, remember to assign the number of CASE statements to MAX.LOOPS
*
*
    LOOP.CNT = 1 ; MAX.LOOPS = 2
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1
            CASE AV EQ '1'
                PROCESS.GOAHEAD ='0'
            CASE LOOP.CNT EQ 2


        END CASE
        LOOP.CNT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------
END
