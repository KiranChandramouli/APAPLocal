* @ValidationCode : Mjo0NDk0MDAyNTM6Q3AxMjUyOjE2ODM2MzYwOTgyNzg6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 May 2023 18:11:38
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
SUBROUTINE INTRF.MESSAGE.FIELD.DEFINITIONS
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

*** FIELD DEFINITIONS FOR INTRF.MESSAGE

    ID.F = "INTRF.MESSAGE.KEY" ; ID.N = "6.1" ; ID.T = ''
*
    Z = 0
*
    Z+=1 ; F(Z) = "XX.LL.DESCRIPTION" ; N(Z) ="35.1" ; T(Z) = "A"
    Z+=1 ; F(Z) = "TRACK.FILE.NAME" ; N(Z) = "35" ; T(Z) = "A"
    Z+=1 ; F(Z) = "INTRF.PRE.CHECK" ; N(Z) = "35" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX.MAPPING.ID" ; N(Z) = "35" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX<INTRF.FLD.NAME" ; N(Z) = "35" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-INTRF.FLD.DELIM" ; N(Z) = "2" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-INTRF.FLD.POS" ; N(Z) = "3" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-INTRF.FLD.LEN" ; N(Z) = "4" ; T(Z)=""
    Z+=1 ; F(Z) = "XX-INTRF.FLD.TYPE" ; N(Z) = "10" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-INTRF.FLD.S.M" ; N(Z)="1" ; T(Z)=""; T(Z)<2> = "S_M"
    Z+=1 ; F(Z) = "XX-INTRF.FLD.MAND" ; N(Z) = "1" ; T(Z) = "" ; T(Z)<2> = "Y_N"

    Z+=1 ; F(Z) = "XX-TRACK.FLD" ; N(Z)="18" ; T(Z)="A"
    Z+=1 ; F(Z) = "XX>TRACK.POS" ; N(Z) = "3" ; T(Z) = ""
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
