* @ValidationCode : Mjo5NTQwOTQzMTc6Q3AxMjUyOjE2ODA2MTA3NDgyODM6SVRTUzotMTotMTowOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 17:49:08
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
SUBROUTINE REDO.LY.POINTUSSTA.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.LY.POINTUS.FIELDS
* @author rmondragon@temenos.com
* @stereotype fields template

* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 05/04/10 - EN_10003543
*            New Template changes
*
*DATE             WHO                REFERENCE         DESCRIPTION
*04.04.2023    Conversion Tool        R22               Auto Conversion     - No changes
*04.04.2023    Shanmugapriya M        R22               Manual Conversion   - No changes
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
    ID.N = '1'
    ID.T = 'A'
*------------------------------------------------------------------------------
    fieldName = 'POINTU.NAME'
    fieldLength = '100'
    fieldType = ''
    fieldType<2>='Aplicado al Programa por Uso Normal_Aplicado al Programa por Uso Tarjeta Debito_Aplicado a saldo ONLINE por Uso Tarjeta Debito_Reverso a saldo ONLINE por Uso Tarjeta Debito'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
