* @ValidationCode : MjotMTUwMTAxMDE1ODpDcDEyNTI6MTY4NDQ5MTAyNTM5MjpJVFNTOi0xOi0xOi0xMDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE APAP.PARAM.DB.CR.MASK.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine HOB.FATCA.CRS.RPT.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   T24.BP REMOVED
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------





*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE ;*R22 AUTO CODE CONVERSION
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    ID.T="A" ; ID.F = "VER.O.ENQ" ; ID.N = "50"
*-----------------------------------------------------------------------------
    fieldName = "XX.VER.FLD.ENQ.COL"         ; fieldLength = "25"  ; fieldType = "A"     ; neighbour = ""      ;  GOSUB ADD.FIELDS
    fieldName = "MASKING.DIGITS"             ; fieldLength = "40"  ; fieldType = "A"     ; neighbour = ""      ;  GOSUB ADD.FIELDS
    fieldName = "RESERVED.10"            ; fieldLength= "2"   ; fieldType<1> = ""   ; fieldType<3> = "NOINPUT" ; neighbour = "" ;  GOSUB ADD.FIELDS
    fieldName = "RESERVED.9"             ; fieldLength = "2"  ; fieldType<1> = ""   ; fieldType<3> = "NOINPUT" ; neighbour = "" ;  GOSUB ADD.FIELDS
    fieldName = "RESERVED.8"             ; fieldLength = "2"  ; fieldType<1> = ""   ; fieldType<3> = "NOINPUT" ; neighbour = "" ;  GOSUB ADD.FIELDS
    fieldName = "RESERVED.7"             ; fieldLength = "2"  ; fieldType<1> = ""   ; fieldType<3> = "NOINPUT" ; neighbour = "" ;  GOSUB ADD.FIELDS
    fieldName = "RESERVED.5"             ; fieldLength = "2"  ; fieldType<1> = ""   ; fieldType<3> = "NOINPUT" ; neighbour = "" ;  GOSUB ADD.FIELDS
    fieldName = "RESERVED.4"             ; fieldLength = "2"  ; fieldType<1> = ""   ; fieldType<3> = "NOINPUT" ; neighbour = "" ;  GOSUB ADD.FIELDS
    fieldName = "RESERVED.3"             ; fieldLength = "2"  ; fieldType<1> = ""   ; fieldType<3> = "NOINPUT" ; neighbour = "" ;  GOSUB ADD.FIELDS
    fieldName = "RESERVED.2"             ; fieldLength = "2"  ; fieldType<1> = ""   ; fieldType<3> = "NOINPUT" ; neighbour = "" ;  GOSUB ADD.FIELDS
    fieldName = "RESERVED.1"             ; fieldLength = "2"  ; fieldType<1> = ""   ; fieldType<3> = "NOINPUT" ; neighbour = "" ;  GOSUB ADD.FIELDS

    CALL Table.setAuditPosition         ;* Poputale audit information

RETURN
*-----------------------------------------------------------------------------
ADD.FIELDS:

    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

RETURN
*-----------------------------------------------------------------------------
END
