* @ValidationCode : MjotMjczMDE0OTY5OkNwMTI1MjoxNjg0ODU2ODcyNjI0OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:52
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
$PACKAGE APAP.DRREG
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE DR.REG.RCL.LIQ.AC.INT.TAX
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STMT.ACCT.CR
    $INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
    $INSERT I_DR.REG.INT.TAX.COMMON

    AC.ID = FIELD(COMI,'-',1)
    R.STMT.ACCT.CR = RCL$INT.TAX(1)
    IF R.STMT.ACCT.CR<IC.STMCR.LIQUIDITY.ACCOUNT> EQ '' THEN
        CREDIT.ACCOUNT = AC.ID
    END ELSE
        CREDIT.ACCOUNT = R.STMT.ACCT.CR<IC.STMCR.LIQUIDITY.ACCOUNT>
    END
    COMI = CREDIT.ACCOUNT
RETURN
END
