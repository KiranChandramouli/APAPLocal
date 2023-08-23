* @ValidationCode : MjoxNzcyMjgyNjAwOlVURi04OjE2OTI2MDQ0NTMwMjE6QWRtaW46LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Aug 2023 13:24:13
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TESTAPAP
*-----------------------------------------------------------------------------
* <Rating>159</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TAFC.ACCESS.PARAM.FIELDS
*-----------------------------------------------------------------------------
* Subroutine for field definitions for TALERT.EVENT.PARAM
*-----------------------------------------------------------------------------
* Modification History :
* DATE          WHO            REFERENCE               DESCRIPTION
* 21 AUG 2023   Narmadha V     Manual R22 Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PGM.FILE
    $INSERT I_F.FILE.CONTROL
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB DEFINE.FIELDS

RETURN
*
*-----------------------------------------------------------------------------
DEFINE.FIELDS:

    ID.F = 'USER.ID' ; ID.N = '42.1' ; ID.T<1> = 'A'
*
    Z=0
*
    Z += 1 ; F(Z) = 'XX<SENSITIVE.FILES' ; N(Z) = '35' ; T(Z) = 'A'    ;* Check later if not ALL. CHECKFILE(Z) = 'FILE.CONTROL':@FM:EB.FILE.CONTROL.DESC ;*'PGM.FILE':@FM:EB.PGM.SCREEN.TITLE
    Z += 1 ; F(Z) = 'XX-XX.SENSITIVE.FIELDS' ; N(Z) = 35 ; T(Z) = ''A  ;* Check later
    Z += 1 ; F(Z) = 'XX>XX.SENSITIVE.FILES.CMDS' ; N(Z) = 48 ; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX<EXCEPT.FILES' ; N(Z) = 35 ; T(Z) = 'A'        ;* Check later if not ALL.
    Z += 1 ; F(Z) = 'XX>XX.EXCEPT.FILES.CMDS' ; N(Z) = 48 ; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX.RESTRICT.CMDS' ; N(Z) = 35 ; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX.EXCEPT.CMDS' ; N(Z) = 35 ; T(Z) = 'A' ;* T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'RESERVED6' ; N(Z) = 16 ; T(Z) = 'A' ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'RESERVED5' ; N(Z) = 35 ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'RESERVED4' ; N(Z) = 35 ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'RESERVED3' ; N(Z) = 35 ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'RESERVED2' ; N(Z) = 35 ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'RESERVED1' ; N(Z) = 35 ; T(Z)<3> = 'NOINPUT'
    Z += 1 ; F(Z) = 'XX.LOCAL.REF' ; N(Z) = 35; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX.OVERRIDE' ; N(Z) = 35 ; T(Z) = 'A' ; T(Z)<3> = 'NOINPUT'
*
    V = Z + 9

RETURN
*
*-----------------------------------------------------------------------------
INITIALISE:

    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
*
* Define often used checkfile variables
*
RETURN

*-----------------------------------------------------------------------------

END
