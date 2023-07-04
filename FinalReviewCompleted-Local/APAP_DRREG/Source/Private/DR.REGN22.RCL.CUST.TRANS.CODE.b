* @ValidationCode : MjoxNTgwMDc1NTQ1OkNwMTI1MjoxNjgxMTIyMzc1OTIxOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 15:56:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REGN22.RCL.CUST.TRANS.CODE
    $INSERT I_COMMON
    $INSERT I_EQUATE

    TRANS.CODE = COMI
    BEGIN CASE
        CASE TRANS.CODE EQ 'BUY'
            CUS.TRAN.CODE = 'C'
        CASE TRANS.CODE EQ 'SEL'
            CUS.TRAN.CODE = 'V'
    END CASE

    COMI = CUS.TRAN.CODE

RETURN
END
