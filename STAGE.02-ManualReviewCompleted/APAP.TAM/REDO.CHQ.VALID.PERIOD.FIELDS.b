* @ValidationCode : Mjo1MTg3MzE2MDpDcDEyNTI6MTY4MDY5MzM5NTcxNjozMzNzdTotMTotMTowOjA6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 16:46:35
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
SUBROUTINE REDO.CHQ.VALID.PERIOD.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
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
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
*** DATE           BY     ISSUE            DESC
*  18-01-2012   Pradeep S PACS00175817     EB Lookup added for the field CHEQUE.STATUS
*---------------------------------------------------------------------------

*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("TABLE.NAME.ID", T24_String)          ;* Define Table id
    ID.F = ''
    ID.N = '12'
    ID.T = ''
    ID.T<2> = 'NONE_CONFIRMED_NONCONFIRMED'
*-----------------------------------------------------------------------------
*  CALL Table.addField(fieldName, fieldType, args, neighbour)        ;* Add a new fields
* CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1
* CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field


    fieldName = "CHEQUE.STATUS"
    fieldLength = ""
    fieldType = ""
    neighbour = ""
    virtualTableName = "CHEQUE.STATUS"
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName = "VALIDITY"
    fieldLength = "6"
    fieldType = ""
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)


* CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
* CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
