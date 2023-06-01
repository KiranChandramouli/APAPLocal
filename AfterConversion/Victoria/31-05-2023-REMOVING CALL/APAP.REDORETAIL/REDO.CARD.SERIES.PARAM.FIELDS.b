* @ValidationCode : MjotMTMxMTA5NTc5OkNwMTI1MjoxNjgxODI4MDA2NTY3OklUU1M6LTE6LTE6LTEwOjE6dHJ1ZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.SERIES.PARAM.FIELDS
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
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("@ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------
*   ID.F = '@ID' ;  ID.N = "15" ; ID.T = "A"

*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '35'    ; ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------

    neighbour = ''
    fieldName = 'XX<CARD.TYPE'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-CARD.DESC'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    neighbour = ''
    fieldName = 'XX>CARD.SERIES'
    fieldLength = '5'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'EMBOSS.DEPT.CODE'
    fieldLength = '20'
    fieldType = 'DAO'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('DEPT.ACCT.OFFICER')

    neighbour = ''
    fieldName = 'RECEIVE.DEPT.CODE'
    fieldLength = '20'
    fieldType = 'DAO'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('DEPT.ACCT.OFFICER')

    neighbour = ''
    fieldName = 'VIRGIN.DEPT.CODE'
    fieldLength = '20'
    fieldType = 'DAO'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('DEPT.ACCT.OFFICER')
    neighbour = ''
    fieldName = 'TRANSIT.DEPT.CODE'
    fieldLength = '20'
    fieldType = 'DAO'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('DEPT.ACCT.OFFICER')

    fieldName = 'XX.USR.EMB.DPT'
    fieldLength = '20'
    fieldType = 'DAO'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('DEPT.ACCT.OFFICER')
*-------------------------------------------------------------------------------


* CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

*------------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType = 'A':@FM:'':@FM:'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
