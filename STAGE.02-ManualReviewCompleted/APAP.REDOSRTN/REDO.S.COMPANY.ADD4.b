* @ValidationCode : MjoxODg1MDg0NDc1OkNwMTI1MjoxNjgwNzc4MDc2NjU5OjkxNjM4Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:17:56
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
SUBROUTINE REDO.S.COMPANY.ADD4(Y.ADD4)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Sudharsanan S
*Program   Name    :REDO.S.COMPANY.ADD4
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the 4th multi value set from name.address field
*LINKED WITH       :
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
    Y.ADD4 = R.COMPANY(EB.COM.NAME.ADDRESS)<1,4>
RETURN
END
