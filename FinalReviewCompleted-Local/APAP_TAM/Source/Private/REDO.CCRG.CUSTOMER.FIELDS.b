* @ValidationCode : MjotMTUyMDcxMzMxOTpDcDEyNTI6MTY4MDYxNzUwNDk4OTpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 19:41:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CCRG.CUSTOMER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CCRG.CUSTOMER
*
* @author anoriega@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package redo.ccrg
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/04/2011 - APAP : B5
*              First Version
*
*
* Date           Who                 Ref                  Modification
* 04.04.2023    Conversion Tool      R22                 Auto Conversion     - No changes
* 04.04.2023    Shanmugapriya M      R22                 Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table
*
    $INSERT I_F.CUSTOMER
*
*** </region>
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB DEFINE.FIELDS
RETURN

*-----------------------------------------------------------------------------
DEFINE.FIELDS:
*-----------------------------------------------------------------------------

* TODO Define name, type and length for the key
    ID.F = "CCRG.CUS.ID" ; ID.N = "20" ; ID.T =  ""
*
    Z=0
    Z+=1 ; F(Z)  = "CU.CIDENT"           ; N(Z) = "11"    ; T(Z) = "ANY"
    Z+=1 ; F(Z)  = "CU.RNC"              ; N(Z) = "9"     ; T(Z) = "ANY"
    Z+=1 ; F(Z)  = "CU.LEGAL.ID"         ; N(Z) = "20"    ; T(Z) = "ANY"
    Z+=1 ; F(Z)  = "CUSTOMER.ID"         ; N(Z) = "10"    ; T(Z) = "CUS" ;        ;*T(Z)<3> = "NOINPUT"
    CHECKFILE(Z) = "CUSTOMER":@FM:EB.CUS.SHORT.NAME:@FM:'.A'
    Z+=1 ; F(Z)  = "IGNORE.EFFECTIVE"    ; N(Z) = "2.1"     ; T(Z)<2> = "SI_NO"
    Table.currentFieldPosition = Z
    CALL Field.setDefault('NO')
    Z+=1 ; F(Z)  = "RESERVED.1"          ; N(Z) = "35"    ; T(Z) = "" ; T(Z)<3> = 'NOINPUT'
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
