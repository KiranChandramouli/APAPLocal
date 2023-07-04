* @ValidationCode : MjoxODc5OTQ3NTEwOkNwMTI1MjoxNjg0ODU2ODcyMjU1OklUU1M6LTE6LTE6LTI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -2
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
