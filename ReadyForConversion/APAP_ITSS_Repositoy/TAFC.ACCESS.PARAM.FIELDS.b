*-----------------------------------------------------------------------------
* <Rating>159</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE TAFC.ACCESS.PARAM.FIELDS
*-----------------------------------------------------------------------------
* Subroutine for field definitions for TALERT.EVENT.PARAM
*-----------------------------------------------------------------------------
* Modification History :
*
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
