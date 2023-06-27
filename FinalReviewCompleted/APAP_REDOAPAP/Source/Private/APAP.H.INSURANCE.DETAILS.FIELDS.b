* @ValidationCode : MjotNzY3OTU2MDM4OkNwMTI1MjoxNjg0ODM2MDMxMzM0OklUU1M6LTE6LTE6LTQ2OjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -46
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.H.INSURANCE.DETAILS.FIELDS
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



*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_DataTypes
    $INSERT I_F.PGM.FILE
    $INSERT I_F.EB.API
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
    fieldName = 'INS.POLICY.TYPE'
    fieldLength = '35.1'
    fieldType='A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("APAP.H.INSURANCE.POLICY.TYPE")
*
    fieldName = 'CLASS.POLICY'
    fieldLength = '35.1'
    neighbour = ''
    fieldType='A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile("APAP.H.INSURANCE.CLASS.POLICY")
*
    fieldName = 'POLICY.NUMBER'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    fieldName = 'SEN.POLICY.NUMBER'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
    fieldName = 'XX.FHA.CASE.NUMBER'
    fieldLength = '30'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'XX.CUSTOMER'
    fieldLength = '35'
    fieldType = ""
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile('CUSTOMER')
*
    fieldName = 'CURRENCY'
    fieldLength = '3.1'
    fieldType = 'CCY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile('CURRENCY')
*
*    MANAGEMENT.TYPE = 'REDO.INS.MANAGEMENT.TYPE'
*    CALL EB.LOOKUP.LIST(MANAGEMENT.TYPE)

    CALL Table.addOptionsField("MANAGEMENT.TYPE","INCLUIR EN CUOTA_NO INCLUIR EN CUOTA","","")
*
    fieldName = 'INS.COMPANY'
    fieldLength = '35.1'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('REDO.APAP.H.COMP.NAME')
*
    fieldName = 'XX<INS.AMOUNT'
    fieldLength = '35'
    fieldType<1> = 'AMT'
    fieldType<2,2> = LCCY
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
    fieldName = 'XX>INS.AMOUNT.DATE'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
    fieldName = 'XX<MON.POL.AMT'
    fieldLength = '21'
    fieldType<1> = 'AMT'
    fieldType<2,2> = LCCY
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
*    fieldName = 'XX>MON.POL.AMT.DATE'
*    fieldLength = '8'
*    fieldType = "D"
*    neighbour = ''
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
    fieldName = "XX-CHARGE"
    fieldLength = '35'
    neighbour = ''
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile('AA.PROPERTY')
*
    fieldName = 'XX-EXTRA.AMT'
    fieldLength = '21'
    fieldType<1> = 'AMT'
    fieldType<2,2> = LCCY
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
    fieldName = "XX-CHARGE.EXTRA.AMT"
    fieldLength = '35'
    neighbour = ''
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile('AA.PROPERTY')
*
    fieldName = 'XX-MON.TOT.PRE.AMT'
    fieldLength = '21'
    fieldType<1> = 'AMT'
    fieldType<2,2> = LCCY
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*Z+=1 ; F(Z) = 'MONTO.PFIJO'   ; N(Z) = '16'; T(Z)<1> = 'AMT'; T(Z)<2,2> = LCCY

*
    fieldName = "XX-PAYMENT.TYPE"
    fieldLength = '35'
    neighbour = ''
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile('AA.PAYMENT.TYPE')
*
    fieldName = 'XX-INS.START.DATE'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX>INS.END.DATE'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'TOTAL.PRE.AMT'
    fieldLength = '35'
    fieldType = "AMT"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
    fieldName = 'POLICY.ORG.DATE'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'POL.ISS.DATE'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'POL.START.DATE'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'POL.EXP.DATE'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'REMARKS'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'XX.REMARKS.2'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'XX<ASSOCIATED.LOAN'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*    CALL Field.setCheckFile('AA.ARRANGEMENT') removed for version APAP.H.INSURANCE.DETAILS,REDO.FC
*
    fieldName = 'XX>XX.COLLATERAL.ID'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('COLLATERAL')
*
    CANCEL.REASON = 'REDO.INS.CANCEL.REASON'
    CALL EB.LOOKUP.LIST(CANCEL.REASON)

    fieldName = 'CANCEL.REASON'
    fieldLength = '50'
    fieldType = CANCEL.REASON
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    POLICY.STATUS = 'REDO.INS.POLICY.STATUS'
    CALL EB.LOOKUP.LIST(POLICY.STATUS)

    fieldName = 'POLICY.STATUS'
    fieldLength = '35.1'
    fieldType = POLICY.STATUS
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName = 'INS.CTRL.APP.DT'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'INS.CTRL.REC.DT'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FHA.CASE.NO'
    fieldLength = '25'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'INS.POL.DESC'
    fieldLength = '50'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'CLASS.POL.DESC'
    fieldLength = '50'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'ID.TEMPORAL'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FEC.SOL.RESGUAR'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FEC.RECP.RESGUA'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'FEC.EMIS.POLFHA'
    fieldLength = '8'
    fieldType = "D"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'INDICADOR'
    fieldLength = '25'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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
