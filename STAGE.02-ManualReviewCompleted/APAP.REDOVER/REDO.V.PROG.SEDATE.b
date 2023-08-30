* @ValidationCode : MjoxNDk3Nzk3MzA4OkNwMTI1MjoxNjgxMzAxMTA3ODc5OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 17:35:07
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
SUBROUTINE  REDO.V.PROG.SEDATE
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
* PROGRAM NAME : REDO.V.PROG.SEDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE                    DESCRIPTION
* 19.07.2011    RMONDRAGON         ODR-2011-06-0243                  UPDATE
* 01.02.2013    RMONDRAGON         ODR-2011-06-0243                   UPDATE
*12-04-2023     Conversion Tool    R22 Auto Code conversion          No Changes
*12-04-2023     Samaran T          R22 Manual Code Conversion        No Changes
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_GTS.COMMON

    GOSUB PROCESS
RETURN

*-------
PROCESS:
*-------
    VAR.START.DATE = COMI

    IF VAR.START.DATE NE '' AND VAR.START.DATE LT TODAY THEN
        AF = REDO.PROG.START.DATE
        ETEXT = 'EB-LY.SDLTTODAY'
        CALL STORE.END.ERROR
    END

RETURN
*------------------------------------------------------------------------------------
END
