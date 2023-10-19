* @ValidationCode : MjotNjAwNjk1Njg1OkNwMTI1MjoxNjgwNjgxMDYzNzcwOjMzM3N1Oi0xOi0xOjA6MDp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:21:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             FM TO @FM
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
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
    ID.CHECKFILE = "EB.PRODUCT":@FM:EB.PRD.DESCRIPTION:@FM:"L.A"
    Z=0
    Z+=1 ; F(Z)  = "XX<BALANCE.TYPE"      ; N(Z) = "40.1.C" ; T(Z) = "" : @FM : ID.VALUES
    Z+=1 ; F(Z)  = "XX-XX<FIELD.NO"       ; N(Z) = "40"   ; T(Z) = "" : @FM : "CATEGORY_CUS.RELATION.CODE_AA.CAMP.TY"
    Z+=1 ; F(Z)  = 'XX-XX-OPERATOR'       ; N(Z) = '40'   ; T(Z) = "" : @FM : 'EQ_NE_RG_NR'
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
