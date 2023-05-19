* @ValidationCode : MjoxMDI3MTQ1MDM2OkNwMTI1MjoxNjg0NDEwMDg0MTM3OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 May 2023 17:11:24
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHECKREC.AA.OVERPAYMENT
*-------------------------------------------------
*Description: This routine is to throw the validation error messages.
** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*-------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AA.OVERPAYMENT


    IF V$FUNCTION EQ 'I' THEN
        GOSUB PROCESS
    END

RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------


    IF R.NEW(REDO.OVER.STATUS) NE 'PENDIENTE' THEN
        E     = 'EB-REDO.NOT.ALLOWED'
    END ELSE
        R.NEW(REDO.OVER.STATUS) = "REVERSADO"
    END

RETURN

END
