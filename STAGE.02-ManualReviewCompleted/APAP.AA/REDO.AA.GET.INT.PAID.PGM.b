* @ValidationCode : MjotMTQwNjg0ODUyNTpDcDEyNTI6MTY4MDAwODAwMTc3MDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Mar 2023 18:23:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
PROGRAM REDO.AA.GET.INT.PAID.PGM
*--------------------------------------------------------------------------------------
* Date               who                   Reference              
* 29-03-2023          Convrsion Tool      R22 AUTO CONVERSTION - No Change
* 29-03-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
    $INSERT I_AA.LOCAL.COMMON
* DEBUG
    Y.ACCOUNT.ID       =1000009807
    Y.BALANCE.TYPE     ='REPAYINT'
    Y.REQUEST.DATE.LAST='20101107'
    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ACCOUNT.ID,Y.BALANCE.TYPE,Y.REQUEST.DATE.LAST,Y.BALANCE.AMOUNT.LAST,Y.RET.ERROR)
    Y.REQUEST.DATE.TODAY=TODAY
    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ACCOUNT.ID, Y.BALANCE.TYPE, Y.REQUEST.DATE.TODAY, Y.BALANCE.AMOUNT.NEW,Y.RET.ERROR)

RETURN
END
