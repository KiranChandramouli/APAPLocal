* @ValidationCode : MjoxOTA1ODQyNTY1OkNwMTI1MjoxNjg0ODU2ODcyMTE4OklUU1M6LTE6LTE6OTk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 99
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




SUBROUTINE DR.REG.RCL.CR.ACC.INT.TAX
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STMT.ACCT.CR
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
    $INSERT I_DR.REG.INT.TAX.COMMON

*    AC.ID = FIELD(COMI,'-',1)
    R.STMT.ACCT.CR = RCL$INT.TAX(1)
    R.ACCOUNT = RCL$INT.TAX(2)
    CONSTANT = '0001'
    ACC.CO.CODE = R.ACCOUNT<AC.CO.CODE>
*    ACC.SD.CODE = ACC.CO.CODE[6,4]
    V.COMPANY = ''
    CALL F.READ(FN.COMPANY,ACC.CO.CODE,V.COMPANY,F.COMPANY,COMPANY.ERR)
    ACC.SD.CODE = V.COMPANY<EB.COM.SUB.DIVISION.CODE>
    IF R.STMT.ACCT.CR<IC.STMCR.CR.INT.TAXCATEG> NE '' THEN
        CR.ACCOUNT =  R.STMT.ACCT.CR<IC.STMCR.LIQUIDITY.CCY> : R.STMT.ACCT.CR<IC.STMCR.CR.INT.TAXCATEG> : CONSTANT : ACC.SD.CODE
    END

    COMI = CR.ACCOUNT
RETURN
END
