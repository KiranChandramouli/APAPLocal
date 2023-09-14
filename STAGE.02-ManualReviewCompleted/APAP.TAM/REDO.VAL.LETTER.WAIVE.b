* @ValidationCode : MjotMTA3MjI1MDMwNTpDcDEyNTI6MTY4MTE1MTYxNzk0NzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 00:03:37
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
SUBROUTINE REDO.VAL.LETTER.WAIVE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.VAL.LETTER.WAIVE
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Validation Routine for REDO.LETTER.ISSUE to
*CHECK THE CUSTOMER WAIVE CHARGE

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*24.06.2011    RIYAS          PACS00072842   INITIAL CREATION
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.LETTER.ISSUE
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB LOCAL.REF
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------
    LOC.REF.APPLICATION="ACCOUNT"
    LOC.REF.FIELDS='L.AC.STATUS1'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------


    Y.WAIVE=R.NEW(REDO.LET.ISS.WAIVE.CHARGES)
    IF Y.WAIVE EQ 'YES' THEN
        R.NEW(REDO.LET.ISS.CHARGE.LIQ.ACT)=''
        T(REDO.LET.ISS.CHARGE.LIQ.ACT)<3> = 'NOINPUT'
        R.NEW(REDO.LET.ISS.CHARGE.AMT) = ''
        T(REDO.LET.ISS.CHARGE.AMT)<3> = 'NOINPUT'
    END

RETURN
END
