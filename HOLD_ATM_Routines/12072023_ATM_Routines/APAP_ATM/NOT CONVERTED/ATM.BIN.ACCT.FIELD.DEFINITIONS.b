*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATM.BIN.ACCT.FIELD.DEFINITIONS

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.BIN.ACCT
    $INSERT I_F.ACCOUNT


    GOSUB INIT
    GOSUB DEFINE.FLDS

    RETURN

INIT:

    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
    ID.F = "BIN" ; ID.N = "6.1" ; ID.T = "A"
*
    Z = 0
*
    RETURN


DEFINE.FLDS:

    Z+=1 ; F(Z) = "XX.LL.DESCRIPTION" ; N(Z) ="35.1" ; T(Z) = "A"
    Z+=1 ; F(Z) = "PAY.ACCOUNT.NO" ; N(Z) = "16" ; T(Z) = "A"
    Z+=1 ; F(Z) = "RECEIVE.ACCOUNT.NO" ; N(Z) = "16" ; T(Z) = "A"
*    CHECKFILE(Z) = "ACCOUNT":FM:AC.SHORT.TITLE:FM:"L"
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
