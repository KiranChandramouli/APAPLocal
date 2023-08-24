* @ValidationCode : Mjo2NzY0MjA2MzA6Q3AxMjUyOjE2ODA2MDMyMzYwMTI6SVRTUzotMTotMTotNDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:43:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -4
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.ACT.PRES.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Fields definition for REDO.FC.ACT.PRES
*
* @author btorresalbornoz@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
* --------------------
* 07.01.2011 - Initial Version
*  DATE             WHO                   REFERENCE                  
* 04-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 04-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*** <region name= Header>
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_DataTypes
*** </region>

*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id

*-----------------------------------------------------------------------------


    neighbour = ''
    fieldName = 'DESC.PRODUCT'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addReservedField('RESERVED.10')
    CALL Table.addReservedField('RESERVED.9')
    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')



    CALL Table.setAuditPosition ;* Populate audit information

RETURN
*------------------------------------------------------------------------------------------------------------------
END
