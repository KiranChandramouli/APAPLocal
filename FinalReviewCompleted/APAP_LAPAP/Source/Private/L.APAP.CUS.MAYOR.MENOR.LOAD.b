* @ValidationCode : MjoxMDMzODQwNzk4OkNwMTI1MjoxNjkwMTY3NTI5Mjg4OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CUS.MAYOR.MENOR.LOAD
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed in INSERTFILE
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON                                ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_L.APAP.CUS.MAYOR.MENOR.COMMON         ;*R22 Auto conversion - End


    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    R.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)


END
