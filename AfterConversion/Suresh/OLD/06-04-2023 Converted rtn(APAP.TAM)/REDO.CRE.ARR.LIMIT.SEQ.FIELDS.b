* @ValidationCode : MjoxNDc1MzUwMzk2OkNwMTI1MjoxNjgwNzY5MDkwNDE1OjMzM3N1Oi0xOi0xOjA6MDp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 13:48:10
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
SUBROUTINE REDO.CRE.ARR.LIMIT.SEQ.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CRE.ARR.LIMIT.SEQ
*
* @author hpasquel@temenos.com
* @stereotype fields template
* @uses Live Table
* @public Table Creation
* @package redo.create.arrangement
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("CUSTOMER.ID", T24_Customer)          ;* Define Table id
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = "XX<LIMIT.REF"
    fieldLenght = "7.3"
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("LIMIT.REFERENCE")
    neighbour = ''
    fieldName = "XX>LAST.ID"
    fieldLenght = "2.2"
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    neighbour = ''
    fieldName = "LAST.COL.RIG.ID"
    fieldLenght = "10"
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
