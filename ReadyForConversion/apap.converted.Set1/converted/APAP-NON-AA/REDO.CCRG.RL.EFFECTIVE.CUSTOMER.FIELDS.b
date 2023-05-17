SUBROUTINE REDO.CCRG.RL.EFFECTIVE.CUSTOMER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CCRG.RL.EFFECTIVE
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
* 24/03/2011 - APAP : B5
*              First Version
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.USER
    $INSERT I_F.CUSTOMER

*** </region>
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB DEFINE.FIELDS
RETURN

*-----------------------------------------------------------------------------
DEFINE.FIELDS:
*-----------------------------------------------------------------------------

* Customer Id
    ID.F = "CUSTOMER.ID" ; ID.N = "10" ; ID.T =  "CUS"
    ID.CHECKFILE = "CUSTOMER":@FM:EB.CUS.SHORT.NAME:@FM:'.A'
    Z=0

* Start Date
    Z+=1 ; F(Z)  = "START.DATE"        ; N(Z) = "11"   ; T(Z) = "RELTIME":@FM:@FM:"":@FM:"RDD DD  DD ##:##"
*    Z+=1 ; F(Z)  = "END.DATE"          ; N(Z) = "11"   ; T(Z) = "RELTIME":FM:FM:"":FM:"RDD DD  DD ##:##"
    Z+=1 ; F(Z)  = "RESERVED.1"        ; N(Z) = "35"   ; T(Z) = "" ; T(Z)<3> = 'NOINPUT'
    Z+=1 ; F(Z)  = "RESERVED.2"        ; N(Z) = "35"   ; T(Z) = "" ; T(Z)<3> = 'NOINPUT'
    Z+=1 ; F(Z)  = "RESERVED.3"        ; N(Z) = "35"   ; T(Z) = "" ; T(Z)<3> = 'NOINPUT'
    V = Z + 9
*
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
