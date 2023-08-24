* @ValidationCode : MjotMTAwNzM4MTI5NDpDcDEyNTI6MTY4MTEyNTI3NTIwODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 16:44:35
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
SUBROUTINE REDO.VAL.CHECK.STATUS

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.VAL.CHECK.STATUS
*-------------------------------------------------------------------------
* Description: This routine is attached as validation routine to the versions REDO.CLEARING.INWARD, REFER
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter :
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0148                Initial Creation
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CLEARING.INWARD

    GOSUB PROCESS
RETURN

PROCESS:
    VAL.STATUS = COMI
    IF VAL.STATUS NE 'REFERRED' THEN
        ETEXT = "EB-INVALID.STATUS"
        CALL STORE.END.ERROR
    END

    IF VAL.STATUS EQ 'REJECTED' THEN
        VAR.CURR.STATUS = R.NEW(CLEAR.CHQ.STATUS)
        IF VAL.STATUS NE VAR.CURR.STATUS THEN
            ETEXT = "EB-INVALID.STATUS"
            CALL STORE.END.ERROR
        END
    END
    IF VAL.STATUS EQ 'REJECTED' THEN
        ETEXT = "EB-INVALID.STATUS"
        CALL STORE.END.ERROR
*R.NEW(CLEAR.CHQ.REJECT.TYPE) = 'MANUAL'
    END
RETURN
END
