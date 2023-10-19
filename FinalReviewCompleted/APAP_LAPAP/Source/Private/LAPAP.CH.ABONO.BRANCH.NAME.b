* @ValidationCode : MjotMzEzOTY2NzY5OkNwMTI1MjoxNjg4NDY0ODgxMjYzOnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jul 2023 15:31:21
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
$PACKAGE APAP.LAPAP


*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------

*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*04-07-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.CH.ABONO.BRANCH.NAME
    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY ;*R22 MANUAL CONVERSION END

    Y.BRANCH.ID         = O.DATA

    FN.COMPANY = 'F.COMPANY';
    F.COMPANY = '';
    CALL OPF(FN.COMPANY, F.COMPANY)

    R.COMPANY.LIST = ''; COMPANY.ERR = '';
    CALL F.READ(FN.COMPANY,Y.BRANCH.ID,R.COMPANY.LIST,F.COMPANY,COMPANY.ERR)
    Y.BRANCH.NAME       = R.COMPANY.LIST<EB.COM.COMPANY.NAME>

    O.DATA                = Y.BRANCH.NAME
RETURN
END
