* @ValidationCode : MjoyMDAyMDc0MTAzOkNwMTI1MjoxNjgyNTk0MzkyMTAxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Apr 2023 16:49:52
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
SUBROUTINE  REDO.LY.V.EXP.TYPE
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
* PROGRAM NAME : REDO.LY.V.EXP.TYPE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243       UPDATE
** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion Call routine prefix added
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM
    
    $USING APAP.REDOVER

    IF VAL.TEXT THEN
        VAR.EXP.TYPE = R.NEW(REDO.PROG.EXP.TYPE)
    END ELSE
        VAR.EXP.TYPE = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    IF VAL.TEXT EQ '' THEN
        VAL.TEXT = 'VALIDATED'
        APAP.REDOVER.redoVAvailProgram() ;* R22 Manual conversion
        APAP.REDOVER.redoVDisdelay() ;* R22 Manual conversion
        APAP.TAM.redoLyDisFieldsT() ;* R22 Manual conversion
        APAP.TAM.redoLyDisFieldsP() ;* R22 Manual conversion
        APAP.TAM.redoLyDisFieldsP2() ;* R22 Manual conversion
        APAP.REDOVER.redoVTxnInt() ;* R22 Manual conversion
        VAL.TEXT = ''
    END ELSE
        APAP.REDOVER.redoVAvailProgram() ;* R22 Manual conversion
        APAP.REDOVER.redoVDisdelay() ;* R22 Manual conversion
        APAP.TAM.redoLyDisFieldsT() ;* R22 Manual conversion
        APAP.TAM.redoLyDisFieldsP() ;* R22 Manual conversion
        APAP.TAM.redoLyDisFieldsP2() ;* R22 Manual conversion
        APAP.REDOVER.redoVTxnInt() ;* R22 Manual conversion
    END

    IF VAR.EXP.TYPE EQ 'POR.DIAS' THEN
        T(REDO.PROG.EXP.DATE)<3> = 'NOINPUT'
    END ELSE
        T(REDO.PROG.DAYS.EXP)<3> = 'NOINPUT'
    END

RETURN

*------------------------------------------------------------------------------------
END
