* @ValidationCode : MjoxNDYzMTk5MTEzOkNwMTI1MjoxNjk5MzUzNDM0NjY1OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Nov 2023 16:07:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.PADRON.WS.FIELDS
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*DATE        AUTHOR                   Modification                            DESCRIPTION
*07/10/2023  VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES              NOCHANGES
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F="@ID"
    ID.N="36"
    ID.T="A"

*-----------------------------------------------------------------------------
    fieldName="CEDULA"
    fieldLength="20"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='RESERVED.5'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='RESERVED.4'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    
    fieldName='RESERVED.3'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    
    fieldName='RESERVED.2'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='RESERVED.1'
    fieldLength='30'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

RETURN

END