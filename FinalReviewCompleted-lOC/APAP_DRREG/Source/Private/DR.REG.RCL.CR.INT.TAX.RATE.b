* @ValidationCode : Mjo1NjU0NzQ1NjQ6Q3AxMjUyOjE2ODA2ODAxNTI5MDM6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:05:52
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
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM , FM to @FM
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE DR.REG.RCL.CR.INT.TAX.RATE
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
    $INSERT I_DR.REG.INT.TAX.COMMON

    CR.INT.RATE = COMI
    IF CR.INT.RATE THEN
        CHANGE @VM TO @FM IN CR.INT.RATE
        CNT.INT.RATE = DCOUNT(CR.INT.RATE,@FM)
        COMI = CR.INT.RATE<CNT.INT.RATE>
    END ELSE
        COMI = ''
    END
RETURN
END
