* @ValidationCode : MjotMTIyMzMwNDcyMjpDcDEyNTI6MTY4MTA1NjQ4NjEwNjpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:06
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
SUBROUTINE REDO.SOLICITUD.CANAL.FIELDS
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
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    ID.F = "SOLCAN.ID" ;  ID.N = "18" ;  ID.T = "" ; ID.T<4> = '########-#########'
*-----------------------------------------------------------------------------
    CALL Table.addOptionsField("TIPO.CANAL", "INTERNET_IVR", "", "")
    CALL Table.addFieldDefinition('NUMERO.IDENT', 16, 'A', '')
    CALL Table.addOptionsField('TIPO.IDENT', "CEDULA_PASAPORTE", "", "")
    CALL Table.addFieldDefinition('PAIS.IDENT', 50, 'A', '')
    CALL Table.addFieldDefinition('NOMBRES', 60, 'A', '')
    CALL Table.addFieldDefinition('APELLIDOS', 80, 'A', '')
    CALL Table.addFieldDefinition('TEL.RESIDENCIA', 20, 'A', '')
    CALL Table.addFieldDefinition('TEL.OFICINA', 20, 'A', '')
    CALL Table.addFieldDefinition('TEL.MOVIL', 20, 'A', '')
    CALL Table.addFieldDefinition('ID.USUARIO', 32, 'A', '')
    CALL Table.addFieldDefinition('NUM.PRODUCTO', 20, 'A', '')
    CALL Table.addOptionsField("TIPO.PRODUCTO", "1_2_3_4_5", "", "")
    CALL Table.addFieldDefinition('EMAIL', 50, 'A', '')
    CALL Table.addOptionsField("ESTATUS.SOL", "EN.PROCESO_RECHAZADA_ACTIVADA", "", "")
*-----------------------------------------------------------------------------
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
