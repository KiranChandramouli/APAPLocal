* @ValidationCode : MjotMTUxODY0MDAzNDpDcDEyNTI6MTY4NTU0NTUyMzAyMDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 20:35:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VVR.CALC.RATE.LCYFCY
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SHANKAR RAJU
* PROGRAM NAME: REDO.VVR.CALC.RATE.LCYFCY
* ODR NO      : PACS00172912
*----------------------------------------------------------------------
*
*   Validation routine attached to TT-FX versions.
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE         WHO             REFERENCE          DESCRIPTION
*
*  18.04.2012   NAVA V.         GROUP7-FX          Based on REDO.VVR.CALC.AMOUNTS
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION        CALL routine format modified
*----------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_TT.COMMON
    $INSERT I_TT.EQUATE
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
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*
    R.NEW(TT.TE.DEAL.RATE)                 = Y.DEAL
*
    CALL TT.PERFORM.DEF.PROCESSING
    CALL TT.GENERAL.LIBRARY(CALL.CALCULATE.NET.AMOUNT)
*
    R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1> = R.NEW(TT.TE.AMOUNT.FCY.2)<1,1> * Y.DEAL
*
    APAP.TAM.redoHandleCommTaxFields()  ;*MANUAL R22 CODE CONVERSION
*
RETURN
*
*----------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------
*
    PROCESS.GOAHEAD = "1"
    LOOP.CNT        = 1
    MAX.LOOPS       = 1
*
    R.NEW(TT.TE.AMOUNT.LOCAL.2)<1,1> = ''
*
    IF COMI NE "" THEN
        Y.DEAL       = COMI
    END
*
RETURN
*
*----------------------------------------------------------------------------------------------------------
OPEN.FILES:
*~~~~~~~~~~
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1
*
                IF MESSAGE EQ "VAL" THEN
                    PROCESS.GOAHEAD = ""
                END
*
        END CASE
        LOOP.CNT +=1
*
    REPEAT
*
RETURN
*
END
