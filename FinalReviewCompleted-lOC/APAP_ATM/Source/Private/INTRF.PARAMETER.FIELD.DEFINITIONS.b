* @ValidationCode : MjotNTQ1NDAxNjgyOkNwMTI1MjoxNjg0NTAyMzc4NDAzOmFqaXRoOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 18:49:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
SUBROUTINE INTRF.PARAMETER.FIELD.DEFINITIONS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
* Date                  who                   Reference
* 24-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 24-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
*-----------------------------------------------------------------------------
    GOSUB INITIALISE

    GOSUB DEFINE.FIELDS

RETURN
*
*-----------------------------------------------------------------------------
*
DEFINE.FIELDS:

*** FIELD DEFINITIONS FOR INTRF.PARAMETER

    ID.F = "INTRF.PARAM.KEY" ; ID.N = "6.1" ; ID.T = '' ; ID.T<2> = 'SYSTEM'
*
    Z = 0
*
    Z+=1 ; F(Z) = "XX.LL.DESCRIPTION" ; N(Z) ="35.1" ; T(Z) = "A"
    Z+=1 ; F(Z) = "FILE.PATH" ; N(Z) = "35.1.C" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX<MSG.PORT" ; N(Z) = "6.1" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-XX<HEAD.TAIL" ; N(Z) = "4.1.C" ; T(Z)<2> = "HEAD_TAIL"
    Z+=1 ; F(Z) = "XX-XX-MSG.POS" ; N(Z) = "4.1" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-XX-MSG.LENGTH" ; N(Z) = "4.1" ; T(Z)=""
    Z+=1 ; F(Z) = "XX-XX-MSG.VAL.Y.N" ; N(Z) = "1" ; T(Z)<2> = "Y_N"
    Z+=1 ; F(Z) = "XX-XX-MSG.VLD.RTN" ; N(Z)="35..C" ; T(Z)="A"
    Z+=1 ; F(Z) = "XX>XX>ERR.MAP.ID" ; N(Z) = "35" ; T(Z) = "A"
*29-10-03 S
    CHECKFILE(Z) = "INTRF.MAPPING"
*29-10-03 E
*
*
    Z+=1 ; F(Z) = "RESERVED10" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED9" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED8" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED7" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED6" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED5" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED4" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED3" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED2" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
    Z+=1 ; F(Z) = "RESERVED1" ; N(Z) = "35" ; T(Z) = '' ; T(Z)<3> = "NOINPUT"
*
    Z+=1 ; F(Z) = "XX.OVERRIDE" ; N(Z) = "35" ; T(Z)<3>= "NOINPUT"

    V = Z + 9
RETURN
*
*-----------------------------------------------------------------------------
*
INITIALISE:
    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
*
* Define often used checkfile variables
*
RETURN
*
*-----------------------------------------------------------------------------
*
END
