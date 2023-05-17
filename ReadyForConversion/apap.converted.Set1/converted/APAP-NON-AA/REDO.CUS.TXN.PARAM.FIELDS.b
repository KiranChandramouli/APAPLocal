SUBROUTINE REDO.CUS.TXN.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CUS.TXN.PARAM
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
    $INSERT I_F.PGM.FILE
    $INSERT I_F.EB.API
*** </region>
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB DEFINE.FIELDS
RETURN

*-----------------------------------------------------------------------------
DEFINE.FIELDS:
*-----------------------------------------------------------------------------
* TODO Define name, type and length for the key
    ID.F = "CUS.TXN.PARAM.ID" ; ID.N = "6" ; ID.T =  "" : @FM : "SYSTEM"
    ID.CHECKFILE = ""
    Z=0
    Z+=1 ; F(Z)  = "XX<APPLICATION"    ; N(Z) = "40.1.C" ; T(Z) = "PG" : @FM : "HU"
    CHECKFILE(Z) = "PGM.FILE" : @FM : EB.PGM.SCREEN.TITLE : @FM :"L.A"
    Z+=1 ; F(Z)  = "XX-EVALUATOR.RTN"  ; N(Z) = "40.1"   ; T(Z) = "HOOK"
    CHECKFILE(Z) = "EB.API" : @FM : EB.API.DESCRIPTION : @FM :"L.A"

    Z+=1 ; F(Z)  = "XX-CUSTOMER.FIELD"     ; N(Z) = "35"   ; T(Z) = "A"
    Z+=1 ; F(Z)  = "XX-ID.FIELD"     ; N(Z) = "35"   ; T(Z) = "A"
    Z+=1 ; F(Z)  = "XX-RESERVED.1"     ; N(Z) = "35"   ; T(Z) = ""  ; T(Z)<3> = 'NOINPUT'
    Z+=1 ; F(Z)  = "XX-RESERVED.2"     ; N(Z) = "35"   ; T(Z) = ""  ; T(Z)<3> = 'NOINPUT'
    Z+=1 ; F(Z)  = "XX>RESERVED.3"     ; N(Z) = "35"   ; T(Z) = ""  ; T(Z)<3> = 'NOINPUT'
    Z+=1 ; F(Z)  = "RESERVED.4"        ; N(Z) = "35"   ; T(Z) = ""  ; T(Z)<3> = 'NOINPUT'
    Z+=1 ; F(Z)  = "RESERVED.5"        ; N(Z) = "35"   ; T(Z) = ""  ; T(Z)<3> = 'NOINPUT'
    Z+=1 ; F(Z)  = "RESERVED.6"        ; N(Z) = "35"   ; T(Z) = ""  ; T(Z)<3> = 'NOINPUT'
    V = Z + 9
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
