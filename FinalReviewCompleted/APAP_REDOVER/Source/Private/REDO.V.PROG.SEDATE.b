* @ValidationCode : MjoxNDk3Nzk3MzA4OkNwMTI1MjoxNjg0ODQ1NjI0Mjc0OklUU1M6LTE6LTE6LTg6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 18:10:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
