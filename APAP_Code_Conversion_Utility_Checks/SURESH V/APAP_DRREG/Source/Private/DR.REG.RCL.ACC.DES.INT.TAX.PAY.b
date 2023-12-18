* @ValidationCode : MjoxMDAxMzc2MjcxOkNwMTI1MjoxNzAyNTUzOTU3MjQ4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Dec 2023 17:09:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.


$PACKAGE APAP.DRREG
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14/12/2023         Suresh                    R22 Manual Conversion      Initialise FN Variable

*----------------------------------------------------------------------------------------

 


SUBROUTINE DR.REG.RCL.ACC.DES.INT.TAX.PAY
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CATEGORY
    $INSERT I_F.ACCOUNT
    $INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
    $INSERT I_DR.REG.INT.TAX.COMMON
*
    
   
    FN.CATEGORY = 'F.CATEGORY' ;*R22 Manual Conversion
    F.CATEGORY = '' ;*R22 Manual Conversion
    CALL OPF(FN.CATEGORY,F.CATEGORY) ;*R22 Manual Conversion

    R.ACCOUNT = RCL$INT.TAX(2)
    CATEG.ID = R.ACCOUNT<AC.CATEGORY>
    R.CATEGORY = ''
    CALL F.READ(FN.CATEGORY,CATEG.ID,R.CATEGORY,F.CATEGORY,CATEGORY.ERR)
    IF R.CATEGORY THEN
        COMI = R.CATEGORY<EB.CAT.DESCRIPTION>
    END
*
END
