* @ValidationCode : MjotNDk2MDI4MzIzOkNwMTI1MjoxNjgyMDY1MjAwNzAwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 13:50:00
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
$PACKAGE APAP.ATM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   F.READ to CACHE.READ , IF STATEMENT MODIFIED
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE AT.FMT.TXN.AMT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CURRENCY
    $INSERT I_F.FUNDS.TRANSFER

    IF MESSAGE NE '' THEN
        RETURN
    END ;*R22 AUTO CODE CONVERSION
    FN.CURRENCY = 'F.CURRENCY'
    CALL OPF(FN.CURRENCY,F.CURRENCY)
    CCY.CODE = R.NEW(FT.DEBIT.CURRENCY)
    CALL CACHE.READ(FN.CURRENCY, CCY.CODE, R.CURRENCY, ERR.CURR) ;*R22 AUTO CODE CONVERSION

* Condition added to avoid the error in forming Transaction amount

    IF NOT(R.CURRENCY) THEN
        CCY.CODE = R.NEW(FT.CREDIT.CURRENCY)
        CALL CACHE.READ(FN.CURRENCY, CCY.CODE, R.CURRENCY, ERR.CURR) ;*R22 AUTO CODE CONVERSION
    END

    CURR.DEC = R.CURRENCY<EB.CUR.NO.OF.DECIMALS>
    COMI = FIELD(COMI,'.',1)
    DIV.VAL = PWR(10,CURR.DEC)
    COMI = COMI/DIV.VAL
RETURN
END
