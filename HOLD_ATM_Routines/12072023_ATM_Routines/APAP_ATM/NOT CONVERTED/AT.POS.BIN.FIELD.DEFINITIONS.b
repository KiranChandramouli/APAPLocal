*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
*--------------------------------------------------------------------------*
* Field Definitions for AT.POS.BIN.ACCT
*--------------------------------------------------------------------------*

    SUBROUTINE AT.POS.BIN.FIELD.DEFINITIONS

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
    ID.F = "BIN" ; ID.N = "25" ; ID.T = "A"
*
    Z = 0
*
    RETURN


DEFINE.FLDS:

    Z+=1 ; F(Z) = "XX.LL.DESCRIPTION" ; N(Z) ="35.1" ; T(Z) = "A"

    Z+=1 ; F(Z) = "POS.RECEIVE.ACCT" ; N(Z) = "16" ; T(Z) = "ANT"
    CHECKFILE(Z) = "ACCOUNT":FM:AC.ACCOUNT.TITLE.1:FM:"L"

    Z+=1 ; F(Z) = "POS.PAY.ACCT" ; N(Z) = "16" ; T(Z) = "ANT"
    CHECKFILE(Z) = "ACCOUNT":FM:AC.ACCOUNT.TITLE.1:FM:"L"

*      Z+=1 ; F(Z) = "LTAX.COM.TYPE" ; N(Z) = "16" ; T(Z) = "A"
*      CHECKFILE(Z) = "FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:"L"

*      Z+=1 ; F(Z) = "PL.COM.CATEG" ; N(Z) = "16..C" ; T(Z) = "A"
*    CHECKFILE(Z) = "FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:"L"
*
*      Z+=1 ; F(Z) = "EPROC.COM.TYPE" ; N(Z) = "16" ; T(Z) = "A"
*      CHECKFILE(Z) = "FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:"L"

    Z+=1 ; F(Z) = "COMMISSION.TYPE" ; N(Z) = "16" ; T(Z) = "A"
    CHECKFILE(Z) = "FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:"L"

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
    V = Z + 9

    RETURN

END
