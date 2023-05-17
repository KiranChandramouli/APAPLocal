SUBROUTINE LATAM.GL.CONC3.FIELDS
*******************************************************************************************************************
*Company   Name    : BCDX Bank
*Developed By      : Temenos Application Management (Mohamed Raffikulla [raffiq@temenos.com])
*Program   Name    : Template
*------------------------------------------------------------------------------------------------------------------
*Description : This template will have excluded ID of Journal entries
*
*

*Linked With       : n/a
*In  Parameter     : n/a
*Out Parameter     : n/a
*------------------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*23/07/2009 - ODR-2009-12-0080
*             Development For Journal Pack
*************************************************************************************************
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------

**********************@ID FIELD*****************
    ID.F='ID'
    ID.N='70'
    ID.T='ANY'

*******************DESCRIPTION FIELD *****************

    fieldName = 'XX.LL.DESCRIPTION'
    fieldLength = '70'
    fieldType = 'ANY'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour) ;



*-----------------------------------------------------------------------------
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
