* @ValidationCode : MjoxNjAyNzIxNTY3OkNwMTI1MjoxNjg1NTM2MDM4NTMyOnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 17:57:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE  REDO.V.VAL.CONV.LCY
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.CONV.LCY
*---------------------------------------------------------------------------------

*DESCRIPTION       :This routine converts  the amount deposited in local currency
*                   into  equivalent indexed currency amount
*LINKED WITH       :
*Modification history
*Date                Who               Reference                  Description
*19-04-2023      conversion tool     R22 Auto code conversion     F.READ TO CACHE.READ
*19-04-2023      Mohanraj R          R22 Manual code conversion   Call Method Format Modified

* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_GTS.COMMON

    IF OFS$HOT.FIELD EQ 'Tab.ORIG.LCY.AMT' OR OFS$HOT.FIELD EQ 'ORIG.LCY.AMT' THEN
        GOSUB INIT
        GOSUB EXCHANGE
    END

RETURN
******
INIT:
******
    LREF.APP='AZ.ACCOUNT'
    LREF.FIELD='ORIG.LCY.AMT'
    LREF.POS=''
    FN.CURRENCY='F.CURRENCY'
    F.CURRENCY=''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

RETURN
**********
EXCHANGE:
**********

    CCY.BUY = R.NEW(AZ.CURRENCY)
    BUY.AMT             = ''
    CCY.SELL            = LCCY
    SELL.AMT            = COMI
    RETURN.CODE         = ''
    CALL CACHE.READ(FN.CURRENCY, CCY.BUY, R.CURRENCY, ERR.CURRENCY) ;*R22 Auto code conversion
    CCY.MKT='1'
    CALL EXCHRATE(CCY.MKT,CCY.BUY,BUY.AMT,CCY.SELL,SELL.AMT,'','','','',RETURN.CODE)
    R.NEW(AZ.PRINCIPAL)=BUY.AMT
*CALL APAP.REDOVER.REDO.V.PRINCIPAL.INT.RATE
    APAP.REDOVER.redoVPrincipalIntRate() ;*R22 Manual Code Conversion-Call Method Format Modified

RETURN
********
END
