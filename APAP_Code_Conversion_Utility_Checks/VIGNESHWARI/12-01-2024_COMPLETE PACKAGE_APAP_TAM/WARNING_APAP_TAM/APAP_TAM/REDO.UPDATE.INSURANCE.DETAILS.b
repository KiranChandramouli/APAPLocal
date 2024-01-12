* @ValidationCode : MjotMTkzNDM2MzMxMTpVVEYtODoxNzA0OTcwODc0MTA3OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jan 2024 16:31:14
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*11-01-2024     Narmadha V          Manual R22 Conversion   CALL OPF Added
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.UPDATE.INSURANCE.DETAILS(INSURANCE.ID)

*------------------------------------------------------------------------
* Description: This routine is to update the insurance details as cancelled.
*------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_REDO.B.LOAN.CLOSURE.COMMON

    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
    SEL.CMD = 'SELECT ':FN.APAP.H.INSURANCE.DETAILS:' WITH POLICY.NUMBER EQ ':INSURANCE.ID
    SEL.LIST = ''
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)

    Y.INSURANCE.ID = SEL.LIST<1>
    CALL OPF(FN.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS) ;*Manual R22 Conversion
    CALL F.READ(FN.APAP.H.INSURANCE.DETAILS,Y.INSURANCE.ID,R.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS,INSURANCE.ERR)

    IF R.INSURANCE.DETAILS THEN
        R.INSURANCE.DETAILS<INS.DET.POLICY.STATUS> = 'CANCELADA'
*CALL F.WRITE(FN.APAP.H.INSURANCE.DETAILS,Y.INSURANCE.ID,R.INSURANCE.DETAILS)
        WRITE R.INSURANCE.DETAILS TO F.APAP.H.INSURANCE.DETAILS,Y.INSURANCE.ID
    END
RETURN
END
