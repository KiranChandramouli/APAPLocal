* @ValidationCode : MjotMjg3NTQyODU4OkNwMTI1MjoxNjkzOTkzNjM0NTA0OnZpY3RvOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Sep 2023 15:17:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*06-09-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE ADDED
*----------------------------------------------------------------------------------------
SUBROUTINE AT.ISO.FMT.BAL.RTN(R.ACCT,WRK.BAL,AVAIL.BAL,BALANCE.FORMATTED)
*
*    $INCLUDE T24.BP  I_COMMON ;*/ TUS START
*    $INCLUDE T24.BP I_EQUATE
*    $INCLUDE T24.BP I_F.ACCOUNT
*    $INCLUDE T24.BP  I_F.ACCOUNT.CLASS
*    $INCLUDE T24.BP I_F.CURRENCY

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.CURRENCY
    $INSERT I_F.EB.CONTRACT.BALANCES    ;*/ TUS END

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

*------------------------------------------------------------------------------------------*
*
INITIALISE:
*--------*

    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)
*
    FN.CURRENCY = 'F.CURRENCY'
    CALL OPF(FN.CURRENCY,F.CURRENCY)
*
    CALL CACHE.READ(FN.ACCOUNT.CLASS,'SAVINGS',R.ACCT.CLASS,ER.AC.CLASS)
    SAV.ACCT.CATEG = R.ACCT.CLASS<AC.CLS.CATEGORY>


RETURN          ;*From Initialise

*------------------------------------------------------------------------------------------*

PROCESS:
*-------*

    CCY.CODE = R.ACCT<AC.CURRENCY>
    CALL CACHE.READ(FN.CURRENCY,CCY.CODE,R.CCY,ER.CCY)
    NUM.CCY = R.CCY<EB.CUR.NUMERIC.CCY.CODE>
    NUM.CCY = FMT(NUM.CCY,'R%3')


    ACCATEG = R.ACCT<AC.CATEGORY>

    ACC.TYPE='20'
    AMT.TYPE='01'

    WRK.BAL = R.ACCT<AC.WORKING.BALANCE>
*   ;*/ TUS S/E
* WRK.BAL = R.ECB<ECB.WORKING.BALANCE>

*CALL AT.CALC.AVAIL.BALANCE(R.ACCT,WRK.BAL,AVAIL.BAL)
    APAP.ATM.atCalcAvailBalance(R.ACCT,WRK.BAL,AVAIL.BAL) ;*R22 MANUAL CONVERSION

    IF AVAIL.BAL LE '0' THEN
        AVAIL.BAL.SIGN ='D'
    END ELSE
        AVAIL.BAL.SIGN ='C'
    END
    AVAIL.BAL = ABS(AVAIL.BAL)

    BALANCE.TO.FMT = AVAIL.BAL

    BALANCE.FMT1 = FIELD(BALANCE.TO.FMT,'.',1)
    BALANCE.FMT2 = FIELD(BALANCE.TO.FMT,'.',2)
    BALANCE.FMT1 = FMT(BALANCE.FMT1,'R%10')
    BALANCE.FMT2 = FMT(BALANCE.FMT2,'R%2')
    BALANCE.FMT = BALANCE.FMT1:BALANCE.FMT2


    AVAIL.BAL = BALANCE.FMT

    BALANCE.FORMATTED =ACC.TYPE:AMT.TYPE:NUM.CCY:AVAIL.BAL.SIGN:AVAIL.BAL

RETURN          ;*From process
END
