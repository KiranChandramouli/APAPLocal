* @ValidationCode : MjotMTQ2NjAwMTgxNjpDcDEyNTI6MTY4MjQxMjM0NjM4NjpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
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
SUBROUTINE  REDO.V.EXP.DAYS
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
* PROGRAM NAME : REDO.V.EXP.DAYS
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
*-------------------------------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        VAR.EXP.DAYS = R.NEW(REDO.PROG.DAYS.EXP)
    END ELSE
        VAR.EXP.DAYS = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    Y.EXP.TYPE = R.NEW(REDO.PROG.EXP.TYPE)

    IF Y.EXP.TYPE EQ 'POR.DIAS' AND VAR.EXP.DAYS EQ '' THEN
        AF = REDO.PROG.DAYS.EXP
        ETEXT = 'EB-REDO.V.EXP'
        CALL STORE.END.ERROR
        RETURN
    END

    IF NOT(NUM(VAR.EXP.DAYS)) THEN
        AF = REDO.PROG.DAYS.EXP
        ETEXT = 'EB-REDO.CHECK.FIELDS.F.NONUM'
        CALL STORE.END.ERROR
    END

RETURN

*------------------------------------------------------------------------------------
END
