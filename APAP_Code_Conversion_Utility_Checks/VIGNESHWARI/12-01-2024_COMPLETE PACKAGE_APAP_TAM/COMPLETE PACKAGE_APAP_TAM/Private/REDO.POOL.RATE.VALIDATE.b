* @ValidationCode : MjoxOTc5NDYyNDYzOkNwMTI1MjoxNjgwODg4MzAxODY3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Apr 2023 22:55:01
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.POOL.RATE.VALIDATE
*-----------------------------------------------------------------------------
*  Description
* ------------------------------------------------------------------------
* Its a .VALIDATE Routine
* If Bank Product Equal to ASSET Then Sell Rate Field is Made Mandatory
* If Bank Product Equal to LIABILITY Then Buy Rate Field is Mandatory
*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - ! TO *, ++ TO += 1
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

* COMPANY      : APAP
* DEVELOPED BY : Kishore.SP
* PROGRAM NAME : REDO.POOL.RATE.VALIDATE
* REFERENCE    : ODR-2009-10-0325
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.POOL.RATE
*-----------------------------------------------------------------------------
    GOSUB GET.VALUES
RETURN
*-----------------------------------------------------------------------------
GET.VALUES:
*----------
*Get The Value from Bank Product
*           ;** R22 Auto conversion ! TO *
    Y.BANK.PRODUCT.ARR = R.NEW(PL.RATE.BANK.PRODUCT)
    Y.SELL.RATE.ARR = R.NEW(PL.RATE.SELL.RATE)
    Y.BUY.RATE.ARR = R.NEW(PL.RATE.BUY.RATE)
    Y.BANK.PRODUCT.CNT = DCOUNT(Y.BANK.PRODUCT.ARR,@VM)
    Y.CNTR = 1
    LOOP
    WHILE Y.CNTR LE Y.BANK.PRODUCT.CNT
*       ;** R22 Auto conversion ! TO *
* Locating the Asset and Liablity
*           ;** R22 Auto conversion ! TO *
        LOCATE 'ASSET' IN Y.BANK.PRODUCT.ARR<1,Y.CNTR> SETTING Y.POS.ASS THEN
            Y.SELL.RATE = Y.SELL.RATE.ARR<1,Y.POS.ASS,1>
            GOSUB ASSET.PROCESS
        END
*            ;** R22 Auto conversion ! TO *
        LOCATE 'LIABILITY' IN Y.BANK.PRODUCT.ARR<1,Y.CNTR> SETTING Y.POS.LIAB THEN
            Y.BUY.RATE = Y.BUY.RATE.ARR<1,Y.POS.LIAB,1>
            GOSUB LIAB.PROCESS
        END
        Y.CNTR += 1          ;** R22 Auto conversion ++ TO += 1
    REPEAT
*                    ;** R22 Auto conversion ! TO *
RETURN
*-----------------------------------------------------------------------------
ASSET.PROCESS:
*-------------
*If Bank Product Equal to ASSET Then Sell Rate Field is Mandatory
*                           ;** R22 Auto conversion ! TO *
    IF Y.POS.ASS NE '' AND Y.SELL.RATE EQ '' THEN
        ETEXT = 'AA-REDO.POOL.RATE.ASSET'
        CALL STORE.END.ERROR
    END
*                     ;** R22 Auto conversion ! TO *
RETURN
*------------------------------------------------------------------------------
LIAB.PROCESS:
*-------------
*If Bank Product Equal to LIABILITY Then Buy Rate Field is Mandatory
*            ;** R22 Auto conversion ! TO *
    IF Y.POS.LIAB NE '' AND Y.BUY.RATE EQ '' THEN
        ETEXT = 'AA-REDO.POOL.RATE.LIAB'
        CALL STORE.END.ERROR
    END
*                  ;** R22 Auto conversion ! TO *
RETURN
*-----------------------------------------------------------------------------
END
