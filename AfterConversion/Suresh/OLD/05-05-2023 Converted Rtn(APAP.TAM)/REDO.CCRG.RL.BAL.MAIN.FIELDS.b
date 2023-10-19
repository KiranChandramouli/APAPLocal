* @ValidationCode : MjoxMTQ1NzYzOTA3OkNwMTI1MjoxNjgwNjg3MTUwMDEwOjMzM3N1Oi0xOi0xOjA6MDp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:02:30
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
SUBROUTINE REDO.CCRG.RL.BAL.MAIN.FIELDS
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
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          FM TO @FM, VM TO @VM
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION        NOCHANGE
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.CUSTOMER
*
    $INSERT I_F.REDO.RISK.GROUP
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
    ID.F = "RL.BAL.MAIN.ID" ; ID.N = "10" ; ID.T =  "CUS"
    ID.CHECKFILE = "CUSTOMER":@FM:EB.CUS.SHORT.NAME:@FM:'.A'
*
    Z=0
    Z+=1 ; F(Z)  = "XX<RISK.LIMIT.ID"  ; N(Z) = "35"   ; T(Z) = "" : @FM : Y.RISK.LIMIT.VALUES
    Z+=1 ; F(Z)  = "XX-RISK.GROUP.ID"  ; N(Z) = "10"   ; T(Z) = "ANY" : @FM : "" : @FM : ""
    CHECKFILE(Z) = "REDO.RISK.GROUP":@FM:RG.GRP.SHORT.DESC:@FM:'.A'
    Z+=1 ; F(Z)  = "XX-USED.AMOUNT"    ; N(Z) = "18"   ; T(Z) = "AMT" ; T(Z)<2> = '':@VM:LCCY
    Z+=1 ; F(Z)  = "XX-LINK.DET.1"        ; N(Z) = "45"   ; T(Z) = "A"
    Z+=1 ; F(Z)  = "XX-LINK.DET.2"        ; N(Z) = "45"   ; T(Z) = "A"
    Z+=1 ; F(Z)  = "XX>RESERVED.1"     ; N(Z) = "35"   ; T(Z) = "" ; T(Z)<3> = 'NOINPUT'
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

    Y.RISK.LIMIT.VALUES = 'REDO.CCRG.LIMIT'
    CALL EB.LOOKUP.LIST(Y.RISK.LIMIT.VALUES)
    Y.RISK.LIMIT.VALUES = Y.RISK.LIMIT.VALUES<2>

RETURN
*-----------------------------------------------------------------------------
END
