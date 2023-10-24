$PACKAGE APAP.TAM
SUBROUTINE REDO.FX.CCY.POSN.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Template Name : REDO.FX.CCY.POSN.FIELDS

*-----------------------------------------------------------------------------
* Description :
*-----------------------------------------------------------------------------
* Input/Output :
*-----------------
* IN : NA
* OUT : NA
*------------------

*Modification History :
*------------------------------------------------------------------------------

*  DATE             WHO          REFERENCE             DESCRIPTION
* 06-08-2010      PREETHI MD    ODR-2010-07-0073    INITIAL CREATION
* 06-11-2010      A C RAJKUMAR  ODR-2010-08-0430    Ameneded as per the requirement
*                                                   & added certain fields
* 13-04-2011      Pradeep S     PACS00051758        New fields created
*
** 10-04-2023 R22 Auto Conversion no changes
** 10-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID",T24_String) ;* Define Table id
    ID.F = '@ID'
    ID.N = '15'
*-----------------------------------------------------------------------------

    fieldName="BUY.POSITION"
    fieldLength="35"
    fieldType="AMT"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="SELL.POSITION"
    fieldLength="35"
    fieldType="AMT"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="TOTAL.POSN"
    fieldLength="35"
    fieldType="AMT"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*------------------------------------------------------------------------------
*ODR-2010-08-0430 start
*------------------------------------------------------------------------------

    fieldName="XX<BUY.NOM"
    fieldLength="20"
    fieldType="AMT"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX-BUY.RATE"
    fieldLength="8"
    fieldType="R"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX-SELL.NOM"
    fieldLength="20"
    fieldType="AMT"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX-SELL.RATE"
    fieldLength="8"
    fieldType="R"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX>TRANS.REF"
    fieldLength="16"
    fieldType="A"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="WGT.BUY.AVG"
    fieldLength="8"
    fieldType="R"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="WGT.SELL.AVG"
    fieldLength="8"
    fieldType="R"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*------------------------------------------------------------------------------
*ODR-2010-08-0430 end
*------------------------------------------------------------------------------

*PACS00051758 - S

    fieldName="XX<TXN.CCY"
    fieldLength="3"
    fieldType="CCY"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX-TXN.CCY.TOT"
    fieldLength="18"
    fieldType="AMT"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX-XX<TXN.BUY.POS"
    fieldLength="18"
    fieldType="AMT"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX-XX-TXN.SEL.POS"
    fieldLength="18"
    fieldType="AMT"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX>XX>CCY.TXN.REF"
    fieldLength="18"
    fieldType="ANY"
    neighbour = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*PACS00051758 - E

    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

    fieldName         = 'XX.LOCAL.REF'
    fieldLength       = '35'
    fieldType<3>      = 'NOINPUT'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
