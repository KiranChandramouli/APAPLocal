* @ValidationCode : MjozNjY2MjUyOTpDcDEyNTI6MTY4Mzg2NTc3MTE1NjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 09:59:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
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
** 13-04-2023 Skanda R22 Manual Conversion added APAP.TAM
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
*CALL APAP.TAM.REDO.V.AVAIL.PROGRAM ;* R22 Manual conversion
        CALL APAP.REDOVER.redoVAvailProgram();* R22 Manual conversion
*CALL APAP.TAM.REDO.V.DISDELAY ;* R22 Manual conversion
        CALL APAP.REDOVER.redoVDisdelay() ;* R22 Manual conversion
*CALL APAP.TAM.REDO.LY.DIS.FIELDS.T ;* R22 Manual conversion
        CALL APAP.TAM.redoLyDisFieldsT() ;* R22 Manual conversion
*CALL APAP.TAM.REDO.LY.DIS.FIELDS.P ;* R22 Manual conversion
        CALL APAP.TAM.redoLyDisFieldsP() ;* R22 Manual conversion
*CALL APAP.TAM.REDO.LY.DIS.FIELDS.P2 ;* R22 Manual conversion
        CALL APAP.TAM.redoLyDisFieldsP2() ;* R22 Manual conversion
* CALL APAP.TAM.REDO.V.TXN.INT ;* R22 Manual conversion
        CALL APAP.REDOVER.redoVTxnInt();* R22 Manual conversion
        
        VAL.TEXT = ''
    END ELSE
*CALL APAP.TAM.REDO.V.AVAIL.PROGRAM ;* R22 Manual conversion
        APAP.REDOVER.redoVAvailProgram();* R22 Manual conversion
* CALL APAP.TAM.REDO.V.DISDELAY ;* R22 Manual conversion
        CALL APAP.REDOVER.redoVDisdelay() ;* R22 Manual conversion
* CALL APAP.TAM.REDO.LY.DIS.FIELDS.T ;* R22 Manual conversion
        CALL APAP.TAM.redoLyDisFieldsT() ;* R22 Manual conversion
* CALL APAP.TAM.REDO.LY.DIS.FIELDS.P ;* R22 Manual conversion
        CALL APAP.TAM.redoLyDisFieldsP() ;* R22 Manual conversion
*CALL APAP.TAM.REDO.LY.DIS.FIELDS.P2 ;* R22 Manual conversion
        CALL APAP.TAM.redoLyDisFieldsP2() ;* R22 Manual conversion
*CALL APAP.TAM.REDO.V.TXN.INT ;* R22 Manual conversion
        CALL APAP.REDOVER.redoVTxnInt();* R22 Manual conversion
    END

    IF VAR.EXP.TYPE EQ 'POR.DIAS' THEN
        T(REDO.PROG.EXP.DATE)<3> = 'NOINPUT'
    END ELSE
        T(REDO.PROG.DAYS.EXP)<3> = 'NOINPUT'
    END

RETURN

*------------------------------------------------------------------------------------
END
