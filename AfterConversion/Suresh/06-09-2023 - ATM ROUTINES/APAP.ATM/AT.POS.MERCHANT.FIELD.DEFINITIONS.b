* @ValidationCode : MjoxNzk2OTEwMDUzOkNwMTI1MjoxNjkzODk2MTcyNTU5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Sep 2023 12:12:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
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
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
*--------------------------------------------------------------------------*
* Field Definitions for AT.POS.MERCHANT.ACCT
*--------------------------------------------------------------------------*

SUBROUTINE AT.POS.MERCHANT.FIELD.DEFINITIONS
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*05/09/2023      Conversion tool            R22 Auto Conversion             Nochange
*05/09/2023      Suresh                     R22 Manual Conversion           FM TO @FM
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.AT.POS.BIN.ACCT
    $INSERT I_F.ACCOUNT


    GOSUB INIT
    GOSUB DEFINE.FLDS

RETURN

INIT:

    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
    ID.F = "POS.MERCHANT.ID" ; ID.N = "15" ; ID.T = "A"
*
    Z = 0
*
RETURN


DEFINE.FLDS:

    Z+=1 ; F(Z) = "XX.LL.DESCRIPTION" ; N(Z) = "35" ; T(Z) ="A"
    Z+=1 ; F(Z) = "MERCHANT.ACCT.NO" ; N(Z) = "15" ; T(Z) ="ANT"
    CHECKFILE(Z) ="ACCOUNT":@FM:AC.SHORT.TITLE:@FM:'L'

*    Z+=1 ; F(Z) = "COMMISSION.TYPE" ;N(Z) = "15";T(Z) ="A"
*    CHECKFILE(Z) ="FT.COMMISSION.TYPE":FM:FT4.PERCENTAGE
*    Z+=1 ; F(Z) = "XX.MERCHANT.DETLS" ;N(Z) = "15";T(Z) ="A"

    Z+=1 ; F(Z) = "RESERVED.FIELDS5" ; N(Z) = "15" ; T(Z) ="A"
    T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.FIELDS4" ; N(Z) = "15" ; T(Z) ="A"
    T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.FIELDS3" ; N(Z) = "15" ; T(Z) ="A"
    T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.FIELDS2" ; N(Z) = "15" ; T(Z) ="A"
    T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED.FIELDS1" ; N(Z) = "15" ; T(Z) ="A"
    T(Z)<3> = "NOINPUT"

    V = Z + 9

RETURN

END
