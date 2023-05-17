*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.CAPTURE.CREDIT.VOUCHER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CAPTURE.CREDIT.VOUCHER
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.CAPTURE.CREDIT.VOUCHER
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------             -------------
* 11-Nov-2019      Vignesh Kumaar M R   CREDIT VOUCHER            INITIAL DRAFT
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INCLUDE GLOBUS.BP I_COMMON
    $INCLUDE GLOBUS.BP I_EQUATE
    $INCLUDE GLOBUS.BP I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("VOUCHER.ID", T24_String) ;* Define Table id
    ID.N = '14'    ; ID.T = 'A'
*-----------------------------------------------------------------------------

    neighbour = ''
    fieldName = 'ACCOUNT.NUMBER'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'DESCRIPTION'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'TXN.AMOUNT'
    fieldLength = '19'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'TXN.AMTLOC'
    fieldLength = '19'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'TXN.CCY.CODE'
    fieldLength = '3'
    fieldType = 'CCY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'AT.UNIQUE.ID'
    fieldLength = '45'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'BIN.NO'
    fieldLength = '6'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'POS.COND'
    fieldLength = '2'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'ATM.TERM.ID'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'FTTC.ID'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

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
    CALL Table.addOverrideField

    CALL Table.setAuditPosition         ;* Poputale audit information

    RETURN
*-----------------------------------------------------------------------------
END
