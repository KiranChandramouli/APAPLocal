$PACKAGE APAP.TFS
* @ValidationCode : MjotMTY5NDU0OTA2NTpDcDEyNTI6MTY5ODMwNjgyNjQ1NjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Oct 2023 13:23:46
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

*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE IN2TFS.AC(N1,T1)
*
* IN2 Subroutine developed specifically for T24.FUND.SERVICES Account fields, to
* mask the display based on what has been defined in TFS.PARAMETER with the category
* of the Account being entered.
*
* Any normal parameter will now be available in T(Z)<2>, in a level lower - any other
* IN2 Routine for instance.
*-------------------------------------------------------------------------------------
* Modification History:
*
* 05/13/05 - Sathish PS
*            New Development
*
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion             GLOBUS.BP File Removed
*-------------------------------------------------------------------------------------
    $INCLUDE I_COMMON ;*R22 Manual Conversion
    $INCLUDE I_EQUATE ;*R22 Manual Conversion

    GOSUB INIT
    GOSUB PRELIM.CONDS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*--------------------------------------------------------------------------------------
PROCESS:

    REAL.T1 = RAISE(T1<2>)
    IF REAL.T1 THEN
        REAL.IN2 = 'IN2' : REAL.T1<1,1,1>
        CALL @REAL.IN2(N1, REAL.T1)
    END
*
    IF NOT(ETEXT) THEN
        V$DISPLAY = 'CASH'
    END

RETURN
*--------------------------------------------------------------------------------------
*/////////////////////////////////////////////////////////////////////////////////////*
*///////////////////P R E  P R O C E S S  S U B R O U T I N E S///////////////////////*
*/////////////////////////////////////////////////////////////////////////////////////*
INIT:

    PROCESS.GOAHEAD = 1

RETURN
*--------------------------------------------------------------------------------------
PRELIM.CONDS:

RETURN
*--------------------------------------------------------------------------------------
END

*
