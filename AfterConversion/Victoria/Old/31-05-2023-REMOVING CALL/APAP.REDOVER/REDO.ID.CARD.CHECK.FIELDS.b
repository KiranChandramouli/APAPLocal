* @ValidationCode : MjotMTIxOTQ3NTc3OkNwMTI1MjoxNjgyNDEyMzI5MzU2OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOnRydWU6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.ID.CARD.CHECK.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.ID.CARD.CHECK *
* @author tchandru@temenos.com
* @stereotype fields template
* Reference : ODR2010010213
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 01/02/10 - EN_10003543
*            New Template changes
*-----------------------------------------------------------------------------
* Date           Author               Reference                    Description
* 04-May-2010    Chandra Prakash T    ODR-2010-01-0213            Initial creation
* 05-Sep-2013    Vignesh Kumaar M R   PACS00313754               TOO MANY CHARACHERS ISSUE
* 09-Sep-2013    Vignesh Kumaar M R   PACS00306447                  CURRENT VARIABLE ISSUE
*05-04-2023        Conversion Tool      R22 Auto Code conversion      FM TO @FM
*05-04-2023            Samaran T        Manual R22 Code Conversion    No Changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
    C$NS.OPERATION = 'ALL'
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'
*------------------------------------------------------------------------------
    fieldName = 'IDENTITY.TYPE'
    fieldLength = '9.1'
    fieldType = "":@FM:"RNC_CEDULA_PASAPORTE"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'IDENTITY.NUMBER'
    fieldLength = '35.1'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'CUSTOMER.TYPE'
    fieldLength = '35.1'
    fieldType = "A"
    fieldType = "":@FM:"CLIENTE APAP_NO CLIENTE APAP"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'CUSTOMER.NAME'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'T24.MODULE'
    fieldLength = '50.1'      ;* Fix for PACS00313754
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'T24.VERSION'
    fieldLength = '35'
    fieldType = "A"
    fieldType<3> = "NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('VERSION')

    fieldName = 'PASSPORT.COUNTRY'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('COUNTRY')

* Fix for PACS00306447 [CURRENT VARIABLE ISSUE]

    fieldName = 'VAR.NV.INFO'
    fieldLength = '90'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'VAR.CLIENT'
    fieldLength = '20'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* End of Fix

    neighbour = ''
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*  CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

    fieldName = 'XX.STMT.NOS'
    fieldLength = '35'
    fieldType = "":@FM:"":@FM:"NOINPUT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
