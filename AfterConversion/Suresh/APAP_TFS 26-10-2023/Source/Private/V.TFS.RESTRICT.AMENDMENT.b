* @ValidationCode : MjoxNTM3NjA2NTkyOkNwMTI1MjoxNjk4MzEyMTk2NzA5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Oct 2023 14:53:16
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
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>149</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE V.TFS.RESTRICT.AMENDMENT
*
* Subroutine Type : VERSION.CONTROL
* Attached to     : T24.FUND.SERVICES
* Attached as     : CHECK.REC.RTN
* Primary Purpose : See if the record is already authorised then dont allow opening
*                   the record in Input mode.
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 07 SEP 07 - Sathish PS
*             Enhancement to TFS
*
* 07 SEP 07 - GP
*             Raise error only for authorised records.
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion           GLOBUS.BP File Removed, USPLATFORM.BP File Removed
*-----------------------------------------------------------------------------------
    $INCLUDE I_COMMON ;*R22 Manual Conversion  - START
    $INCLUDE I_EQUATE

    $INCLUDE I_GTS.COMMON
    $INCLUDE I_F.T24.FUND.SERVICES ;*R22 Manual Conversion - END

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:

    IF R.NEW(TFS.AUTHORISER) NE '' THEN ;* 07 SEP 07 GP S/E
        E = 'EB-TFS.ALREADY.AUTHORISED'
    END   ;* 07 SEP 07 GP S/E

RETURN          ;* from PROCESS
*-----------------------------------------------------------------------------------
* <New Subroutines>

* </New Subroutines>
*-----------------------------------------------------------------------------------*
*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:

    PROCESS.GOAHEAD = 1

RETURN          ;* From INITIALISE
*-----------------------------------------------------------------------------------
OPEN.FILES:

RETURN          ;* From OPEN.FILES
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*
    LOOP.CNT = 1 ; MAX.LOOPS = 2
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF R.NEW(TFS.RECORD.STATUS) THEN PROCESS.GOAHEAD = 0      ;* Not an authorised record

            CASE LOOP.CNT EQ 2
                IF NOT(V$FUNCTION MATCHES 'I' :@VM: 'C') THEN PROCESS.GOAHEAD = 0

        END CASE
        LOOP.CNT += 1
    REPEAT

RETURN          ;* From CHECK.PRELIM.CONDITIONS
*-----------------------------------------------------------------------------------
END






