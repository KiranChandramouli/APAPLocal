$PACKAGE APAP.TAM
SUBROUTINE  REDO.V.PROG.SEDATE2
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
* PROGRAM NAME : REDO.V.PROG.SEDATE2
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 01.02.2013    RMONDRAGON         ODR-2011-06-0243       UPDATE
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
    VAR.START.DATE = R.NEW(REDO.PROG.START.DATE)
    VAR.END.DATE = COMI

    IF VAR.START.DATE NE '' AND VAR.END.DATE LT VAR.START.DATE THEN
        AF = REDO.PROG.END.DATE
        ETEXT = 'EB-LY.EDLTSD'
        CALL STORE.END.ERROR
    END

RETURN
*------------------------------------------------------------------------------------
END
