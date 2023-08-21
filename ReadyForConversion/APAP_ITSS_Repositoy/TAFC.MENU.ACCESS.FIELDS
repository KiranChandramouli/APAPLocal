*-----------------------------------------------------------------------------
* <Rating>159</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE TAFC.MENU.ACCESS.FIELDS
*-----------------------------------------------------------------------------
* Subroutine for field definitions for TALERT.EVENT.PARAM
*-----------------------------------------------------------------------------
* Modification History :
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PGM.FILE
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.USER
    $INSERT I_F.VERSION
    $INSERT I_F.TAFC.MENU.ACCESS
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB DEFINE.FIELDS

    RETURN
*
*-----------------------------------------------------------------------------
DEFINE.FIELDS:

    ID.F = 'MENU.NAME' ; ID.N = '42.1' ; ID.T<1> = 'A'
*
    Z=0
*
    Z += 1 ; F(Z) = 'LL.MENU.DESCRIPTION' ; N(Z) = '35' ; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX.SUB.MENU' ; N(Z) = 35 ; T(Z) = 'A' ; CHECKFILE(Z) = 'TAFC.MENU.ACCESS':@FM:EB.TMA.MENU.DESCRIPTION
    Z += 1 ; F(Z) = 'XX<CASE.DESC' ; N(Z) = 35 ; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX-APPL.VERSION' ; N(Z) = 35 ; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX-FUNCTION' ; N(Z) = 1 ; T(Z)<2> = 'I_A_V'
    Z += 1 ; F(Z) = 'XX-APPL.ID' ; N(Z) = 35 ; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX-XX<APPL.FLD' ; N(Z) = 35 ; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX-XX>APPL.FLD.VAL' ; N(Z) = 35 ; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX-CALL.ROUT' ; N(Z) = 35 ; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX-EXEC.JSH.CMD'; N(Z) = 35 ; T(Z) = 'A'
    Z += 1 ; F(Z) = 'XX>EXEC.SH.CMD'; N(Z) = 35 ; T(Z) = 'A'
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
