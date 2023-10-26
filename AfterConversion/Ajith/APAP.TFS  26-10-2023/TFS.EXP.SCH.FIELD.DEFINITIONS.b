* @ValidationCode : MjoxNDMzNTcxODkxOkNwMTI1MjoxNjk4MzA3NjI3OTYzOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Oct 2023 13:37:07
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
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.EXP.SCH.FIELD.DEFINITIONS
*
* Field definition subroutine for TFS.EXPOSURE.SCHEDULE template.
*
*----------------------------------------------------------------------------------------
* Modification history:
*
* 29 AUG 07 - Sathish PS
*            New Development
*
*----------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion                No Change
*

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.TRANSACTION
    $INSERT I_F.EB.PRODUCT
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_F.FT.COMMISSION.TYPE

    ID.F = '' ; ID.N = '' ; ID.T = ''
    MAT F = '' ; MAT N = '' ; MAT T = ''
    ID.CHECKFILE = '' ; ID.CONCATFILE = ''
    MAT CHECKFILE = '' ; MAT CONCATFILE = ''

    ID.F = 'TRANS.TYPE' ; ID.N = '15.1.C' ; ID.T<1> = 'A'

    Z = 0
    Z += 1 ; F(Z) = 'XX.LL.DESCRIPTION' ; N(Z) = '35.1.C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'NO.OF.EXP.DAYS' ; N(Z) = '20.1.C' ; T(Z)<1> = 'US.EXPDAYS'

    ADDNL.FIELDS = 20 ; FIELD.NAME = 'RESERVED' ; GOSUB ADD.RESERVED.FIELDS

    Z += 1 ; F(Z) = 'XX.LOCAL.REF' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'XX.OVERRIDE' ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'

    V = Z + 9

RETURN
*----------------------------------------------------------------------------------------
ADD.RESERVED.FIELDS:

    FOR XX = 1 TO ADDNL.FIELDS
        Z += 1 ; F(Z) = FIELD.NAME:'.':Z ; N(Z) = '35..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'
    NEXT XX

RETURN
*----------------------------------------------------------------------------------------------------------
END
