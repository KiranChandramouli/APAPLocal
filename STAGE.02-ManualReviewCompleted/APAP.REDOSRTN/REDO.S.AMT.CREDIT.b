* @ValidationCode : MjotNTgwMTM4MjU4OkNwMTI1MjoxNjgwNzY5OTY3NjE0OjkxNjM4Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:02:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 91638
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.AMT.CREDIT(Y.AMT.CREDIT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.AMT.CREDIT
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the credite amount for particular transaction
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

    GOSUB PROCESS
RETURN

PROCESS:

    Y.OUT = R.NEW(FT.AMOUNT.CREDITED)
    LEN.AMT.CRD = LEN(Y.OUT)
    AMT.CREDIT = Y.OUT[4,LEN.AMT.CRD]
    Y.AMT.CREDIT = TRIM(FMT(AMT.CREDIT,"L2,#19")," ",'B')
RETURN

END
