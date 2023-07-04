* @ValidationCode : MjoxODc5OTQ3NTEwOkNwMTI1MjoxNjgwNjgwMjgxOTc3OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:08:01
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
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RCL.CUS.ID.CONV.RTN
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.EXT.COMMON
    $INSERT I_DR.REG.COMM.LOAN.SECTOR.COMMON

    R.CUSTOMER = RCL$COMM.LOAN(2)

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS> THEN
        CUSTOMER.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,CIDENT.POS>
    END ELSE
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS> THEN
            CUSTOMER.ID = R.CUSTOMER<EB.CUS.LOCAL.REF,RNC.POS>
        END ELSE
            CUSTOMER.ID = R.CUSTOMER<EB.CUS.NATIONALITY>:R.CUSTOMER<EB.CUS.LEGAL.ID,1>
        END
    END
*
    COMI = CUSTOMER.ID
*
RETURN
END
