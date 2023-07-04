* @ValidationCode : MjotMTI3OTQ1MTA5NTpDcDEyNTI6MTY4MjUyODQ2Mzc5NDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.LY.V.MINMAX.USED
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
* PROGRAM NAME : REDO.LY.V.MINMAX.USED
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        Y.MAX.POINT.USED = R.NEW(REDO.PROG.MAX.POINT.USED)
    END ELSE
        Y.MAX.POINT.USED = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    Y.MIN.POINT.USED = R.NEW(REDO.PROG.MIN.POINT.USED)

    VAL.IF.N = Y.MIN.POINT.USED
    AF = REDO.PROG.MIN.POINT.USED
    GOSUB VAL.IF.NUM

    VAL.IF.N = Y.MAX.POINT.USED
    AF = REDO.PROG.MAX.POINT.USED
    GOSUB VAL.IF.NUM

    IF Y.MAX.POINT.USED LT Y.MIN.POINT.USED THEN
        ETEXT = 'EB-REDO.LY.V.MAX.POINT.USED'
        CALL STORE.END.ERROR
    END

RETURN

*----------
VAL.IF.NUM:
*----------

    IF NOT(NUM(VAL.IF.N)) THEN
        ETEXT = 'EB-REDO.CHECK.FIELDS.F.NONUM'
        CALL STORE.END.ERROR
    END

RETURN

*------------------------------------------------------------------------------------
END
