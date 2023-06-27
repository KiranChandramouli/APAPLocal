* @ValidationCode : MjotMTU2MDU3OTI3OkNwMTI1MjoxNjg0ODM2MDMxMDY3OklUU1M6LTE6LTE6LTg6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.H.INSURANCE.AUT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine APAP.H.INSURANCE.DETAILS.FIELDS *
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR2009100340
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*------------------------
* 04/01/10 - EN_10003543
*            New Template changes
*
* 25/03/11 - PACS00039601
*            Modified the field definition for INS.POLICY.TYPE, CLASS.POLICY. It should
*            get its values from the EB.LOOKUP table defined for each of the fields
*
* 22/06/11 - CR010 - pgarzongavilanes@temenos.com
*
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE

*** </region>
*-----------------------------------------------------------------------------
*
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'
*------------------------------------------------------------------------------
*
*
    fieldName = 'ARRANGEMENT'
    fieldLength = '35'
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*


    CALL Table.addReservedField("RESERVED.8")
    CALL Table.addReservedField("RESERVED.7")
    CALL Table.addReservedField("RESERVED.6")
    CALL Table.addReservedField("RESERVED.5")
    CALL Table.addReservedField("RESERVED.4")
    CALL Table.addReservedField("RESERVED.3")
    CALL Table.addReservedField("RESERVED.2")
    CALL Table.addReservedField("RESERVED.1")

    CALL Table.addLocalReferenceField(XX.LOCAL.REF)
    CALL Table.addOverrideField

*
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
