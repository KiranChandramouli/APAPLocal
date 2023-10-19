* @ValidationCode : MjotNzQ2MDU0MzQ3OkNwMTI1MjoxNjgyNDEyMzQ2MzczOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE  REDO.V.EXP.DATE
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
* PROGRAM NAME : REDO.V.EXP.DATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*19.07.2011    RMONDRAGON         ODR-2011-06-0243       UPDATE
*30.11.2011    RMONDRAGON         ODR-2011-06-0243       UPDATE
* -----------------------------------------------------------------------------------------------------

*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*11-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*11-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        VAR.EXP.DATE = R.NEW(REDO.PROG.EXP.DATE)
    END ELSE
        VAR.EXP.DATE = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    Y.EXP.TYPE = R.NEW(REDO.PROG.EXP.TYPE)

    IF Y.EXP.TYPE EQ 'POR.FECHA' AND VAR.EXP.DATE EQ '' THEN
        AF = REDO.PROG.EXP.DATE
        ETEXT = 'EB-REDO.V.EXP'
        CALL STORE.END.ERROR
    END

    Y.START.DATE = R.NEW(REDO.PROG.START.DATE)

    IF Y.EXP.TYPE EQ 'POR.FECHA' AND VAR.EXP.DATE NE '' THEN
        IF VAR.EXP.DATE LT Y.START.DATE THEN
            AF = REDO.PROG.EXP.DATE
            ETEXT = 'EB-REDO.V.AVAIL.PROGRAM2'
            CALL STORE.END.ERROR
        END
    END

RETURN

*------------------------------------------------------------------------------------
END
