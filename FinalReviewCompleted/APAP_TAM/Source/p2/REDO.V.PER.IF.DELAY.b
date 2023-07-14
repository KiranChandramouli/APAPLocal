* @ValidationCode : MjotMTEyODkxNzQxNjpDcDEyNTI6MTY4NDQ5MTA0NTIzNDpJVFNTOi0xOi0xOjg1OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 85
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.V.PER.IF.DELAY
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.LY.PROGRAM table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.V.PER.IF.DELAY
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*19.07.2011    RMONDRAGON         ODR-2011-06-0243       UPDATE
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_GTS.COMMON

    GOSUB INIT
    GOSUB PROCESS
RETURN

*---
INIT:
*---
    FN.REDO.LY.PROGRAM='F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM=''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)
RETURN
*-------
PROCESS:
*-------
    VAR.PER.IF.DELAY = R.NEW(REDO.PROG.PER.IF.DELAY)

    IF VAR.PER.IF.DELAY NE '' AND VAR.PER.IF.DELAY LT '0' OR VAR.PER.IF.DELAY GT '100' THEN
        AF = REDO.PROG.PER.IF.DELAY
        ETEXT = 'EB-LY.PERIFDELAY'
        CALL STORE.END.ERROR
    END

RETURN
*------------------------------------------------------------------------------------
END
