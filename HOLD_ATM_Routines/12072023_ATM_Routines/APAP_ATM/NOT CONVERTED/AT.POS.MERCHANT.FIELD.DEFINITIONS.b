*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
*--------------------------------------------------------------------------*
* Field Definitions for AT.POS.MERCHANT.ACCT
*--------------------------------------------------------------------------*

      SUBROUTINE AT.POS.MERCHANT.FIELD.DEFINITIONS

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
      CHECKFILE(Z) ="ACCOUNT":FM:AC.SHORT.TITLE:FM:'L'

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
