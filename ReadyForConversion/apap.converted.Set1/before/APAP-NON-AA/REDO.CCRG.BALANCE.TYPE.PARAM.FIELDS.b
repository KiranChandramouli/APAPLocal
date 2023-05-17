*-----------------------------------------------------------------------------
* <Rating>-51</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.BALANCE.TYPE.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CCRG.BALANCE.TYPE.PARAM
*
* @author hpasquel@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package redo.ccrg
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 23/03/2011 - APAP B5 : ODR-2011-03-0154
*              First Version
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.EB.PRODUCT
*** </region>
*-----------------------------------------------------------------------------
  GOSUB INITIALISE
  GOSUB DEFINE.FIELDS
  RETURN

*-----------------------------------------------------------------------------
DEFINE.FIELDS:
*-----------------------------------------------------------------------------
* TODO Define name, type and length for the key
  ID.F = "PRODUCT.ID" ; ID.N = "5" ; ID.T =  "ANY"
  ID.CHECKFILE = "EB.PRODUCT":FM:EB.PRD.DESCRIPTION:FM:"L.A"
  Z=0
  Z+=1 ; F(Z)  = "XX<BALANCE.TYPE"      ; N(Z) = "40.1.C" ; T(Z) = "" : FM : ID.VALUES
  Z+=1 ; F(Z)  = "XX-XX<FIELD.NO"       ; N(Z) = "40"   ; T(Z) = "" : FM : "CATEGORY_CUS.RELATION.CODE_AA.CAMP.TY"
  Z+=1 ; F(Z)  = 'XX-XX-OPERATOR'       ; N(Z) = '40'   ; T(Z) = "" : FM : 'EQ_NE_RG_NR'
  Z+=1 ; F(Z)  = "XX-XX-MIN.VALUE"      ; N(Z) = "35"   ; T(Z) = "A"
  Z+=1 ; F(Z)  = "XX-XX-MAX.VALUE"      ; N(Z) = "35"   ; T(Z) = "A"
  Z+=1 ; F(Z)  = 'XX-XX-BOOL.OPER'      ; N(Z) = '3'    ; T(Z)<2> = 'AND_OR'
  Z+=1 ; F(Z)  = "XX-XX>RESERVED.1"     ; N(Z) = "35"   ; T(Z) = "" ; T(Z)<3> = 'NOINPUT'
  Z+=1 ; F(Z)  = "XX>RESERVED.2"        ; N(Z) = "35"   ; T(Z) = "" ; T(Z)<3> = 'NOINPUT'
  Z+=1 ; F(Z)  = "RESERVED.3"           ; N(Z) = "35"   ; T(Z) = "" ; T(Z)<3> = 'NOINPUT'
  V = Z + 9

  RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

  MAT F = "" ; MAT N = "" ; MAT T = ""
  MAT CHECKFILE = "" ; MAT CONCATFILE = ""
  ID.CHECKFILE = "" ; ID.CONCATFILE = ""

  ID.VALUES = 'REDO.CCRG.BAL.TYPE'
  CALL EB.LOOKUP.LIST(ID.VALUES)
  ID.VALUES = ID.VALUES<2>

  RETURN
*-----------------------------------------------------------------------------
END
