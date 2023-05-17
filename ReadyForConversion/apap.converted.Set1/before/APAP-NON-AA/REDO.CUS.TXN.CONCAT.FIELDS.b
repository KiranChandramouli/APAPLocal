*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CUS.TXN.CONCAT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CUS.TXN.CONCAT
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
$INSERT I_F.CUSTOMER
*** </region>
*-----------------------------------------------------------------------------
  GOSUB INITIALISE
  GOSUB DEFINE.FIELDS
  RETURN

*-----------------------------------------------------------------------------
DEFINE.FIELDS:
*-----------------------------------------------------------------------------
* TODO Define name, type and length for the key
  ID.F = "CUSTOMER.ID" ; ID.N = "10.1" ; ID.T =  "CUS"
  ID.CHECKFILE = "CUSTOMER" : FM : EB.CUS.SHORT.NAME

  Z=0
  Z+=1 ; F(Z)  = "CONTRACT.ID"    ; N(Z) = "40" ; T(Z) = "ANY"

  RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

  MAT F = "" ; MAT N = "" ; MAT T = ""
  MAT CHECKFILE = "" ; MAT CONCATFILE = ""
  ID.CHECKFILE = "" ; ID.CONCATFILE = ""

  RETURN
*-----------------------------------------------------------------------------
END
