* @ValidationCode : MjotMzk3NzE2MzQ5OkNwMTI1MjoxNjgyMDY1MTI2NDYyOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 13:48:46
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
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE AT.DUP.OVERRIDE

* This Routine is Attached to Version FUNDS.TRANSFER,ATM.DUP
* as a Input Routine
* The Purpose of this routine is to raise a Error

*    $INCLUDE T24.BP I_COMMON        ;*/ TUS START
*    $INCLUDE T24.BP I_EQUATE

    $INSERT I_COMMON
    $INSERT I_EQUATE        ;*/ TUS END

    AF='' ; AV=''
    ETEXT = "DUPLICATE ATM TRANSACTION"
    CALL STORE.END.ERROR
    END.ERROR = 1

RETURN
