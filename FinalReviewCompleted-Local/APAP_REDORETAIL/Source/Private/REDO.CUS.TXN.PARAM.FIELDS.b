* @ValidationCode : MjoxNzA1NTAxNzpDcDEyNTI6MTY4MTgyOTA5MDgzMTpJVFNTOi0xOi0xOi0xNjoxOnRydWU6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -16
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 FM TO @FM
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
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
