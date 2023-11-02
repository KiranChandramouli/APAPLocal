* @ValidationCode : MjoxNjI2ODczODkxOkNwMTI1MjoxNjk4NzUwNjc0NjM3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>-47</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.TXN.FIELD.DEFINITIONS
*
* Field definition subroutine for TFS.TRANSACTION template.
*
*----------------------------------------------------------------------------------------
* Modification history:
*
* 09/07/04 - Sathish PS
*            New Development
*
* 04 SEP 07 - Sathish PS
*             Added flag to indicate, in the case of account transfer, whether the 'SURROGATE.AC'
*             must be defaulted to ACCOUNT.TO or ACCOUNT.FROM.
*
* 23 OCT 07 - Sathish PS
*             Currency Market fix - Include the right Currency markets for each side of the transaction
*----------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion             FM to @FM
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
    Z += 1 ; F(Z) = 'INTERFACE.TO' ; N(Z) = '5.1.C' ; T(Z)<1> = 'ANY'
    CHECKFILE(Z) = 'EB.PRODUCT' :@FM: EB.PRD.DESCRIPTION :@FM: 'L' ;*R22 Manual Conversion
    Z += 1 ; F(Z) = 'INTERFACE.AS' ; N(Z) = '20.1.C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'OFS.VERSION' ; N(Z) = '35..C' ; T(Z)<1> = 'A'
    Z += 1 ; F(Z) = 'SURROGATE.AC' ; N(Z) = '20..C' ; T(Z)<1> = '' ; T(Z)<2> = 'ACCOUNT.DR_ACCOUNT.CR'        ;* 04 SEP 07 - Sathish PS s/e
    ADDNL.FIELDS = 8 ; FIELD.NAME = 'RESERVED' ; GOSUB ADD.RESERVED.FIELDS

    Z += 1 ; F(Z) = 'CHARGE' ; N(Z) = '20..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'FT.CHARGE.TYPE' :@FM: FT5.DESCRIPTION
    Z += 1 ; F(Z) = 'COMMISSION' ; N(Z) = '20..C' ; T(Z)<1> = 'A'
    CHECKFILE(Z) = 'FT.COMMISSION.TYPE' :@FM: FT4.DESCRIPTION
* The following 8 fields will be populated by TFS.LOAD.TRANSACTION during run time
    Z += 1 ; F(Z) = 'CR.TXN.CODE' ; N(Z) = '20..C' ; T(Z)<1> = 'ANY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'DR.TXN.CODE' ; N(Z) = '20..C' ; T(Z)<1> = 'ANY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'CR.ALLOWED.AC' ; N(Z) = '20..C' ; T(Z)<1> = 'ANY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'DR.ALLOWED.AC' ; N(Z) = '20..C' ; T(Z)<1> = 'ANY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'CR.ALLOWED.CCY' ; N(Z) = '20..C' ; T(Z)<1> = 'ANY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'DR.ALLOWED.CCY' ; N(Z) = '20..C' ; T(Z)<1> = 'ANY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'CR.CATEG' ; N(Z) = '5..C' ; T(Z)<1> = 'ANY' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'DR.CATEG' ; N(Z) = '5..C' ; T(Z)<1> = 'ANY' ; T(Z)<3> = 'NOINPUT'
* These two codes will be used when DC is used for Reversing a Line
    Z += 1 ; F(Z) = 'DC.TXN.CODE.CR' ; N(Z) = '5..C' ; T(Z)<1> = ''
    CHECKFILE(Z) = 'TRANSACTION' :@FM: AC.TRA.NARRATIVE :@FM: 'L'
    Z += 1 ; F(Z) = 'DC.TXN.CODE.DR' ; N(Z) = '5..C' ; T(Z)<1> = ''
    CHECKFILE(Z) = 'TRANSACTION' :@FM: AC.TRA.NARRATIVE :@FM: 'L'
    Z += 1 ; F(Z) = 'TILL.TO.TILL' ; N(Z) = '3..C' ; T(Z)<1> = '' ; T(Z)<2> = 'YES_NO'

    ! 23 OCT 07 - Sathish PS /s
    Z += 1 ; F(Z) = 'DR.CURR.MKT' ; N(Z) = '10..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'  ;* Dont need checkfile though...
    Z += 1 ; F(Z) = 'CR.CURR.MKT' ; N(Z) = '10..C' ; T(Z)<1> = 'A' ; T(Z)<3> = 'NOINPUT'  ;* Dont need checkfile though...
    ADDNL.FIELDS = 7 ; FIELD.NAME = 'RESERVED' ; GOSUB ADD.RESERVED.FIELDS
    ! 23 OCT 07 - Sathish PS /e
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

