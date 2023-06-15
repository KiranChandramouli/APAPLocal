* @ValidationCode : MjotMTU2NzQ3NTIyNjpDcDEyNTI6MTY4MTI4MzkzNDE1NjpJVFNTOi0xOi0xOi01OjE6dHJ1ZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:48:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -5
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.ACH.PROCESS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.ACH.PROCESS.FIELDS
* @author rswaminathan@contractor.temenos.com
* @stereotype fields template
* Reference : ODR2009120290
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
*            New Template changes
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                     FM TO @FM
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'
*------------------------------------------------------------------------------
    fieldName = 'EXEC.DATE'
    fieldLength = '8'
    fieldType = 'D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'FILE.NAME'
    fieldLength = '50'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'EXEC.TIME'
    fieldLength = '10'
    fieldType = 'TIME'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'PROCESS.TYPE'
    fieldLength = '20'
    fieldType = '':@FM:'INWARD_OUTWARD_REJECTION'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'TOTAL.REC'
    fieldLength = '4'
    fieldType = ''
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='REJ.GEN'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.19'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.18'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.17'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.16'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.15'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.14'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.13'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.12'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.11'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.10'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.9'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.8'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.7'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.6'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.5'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.4'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.3'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.2'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    fieldName='RESERVED.1'
    fieldLength='35'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

    neighbour = ''
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A':@FM:'':@FM:'NOINPUT'
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
