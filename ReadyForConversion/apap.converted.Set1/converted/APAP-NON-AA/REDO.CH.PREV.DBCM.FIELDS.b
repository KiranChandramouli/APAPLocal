SUBROUTINE REDO.CH.PREV.DBCM.FIELDS
*-----------------------------------------------------------------------------

* COMPANY NAME   : APAP
* DEVELOPED BY   : RMONDRAGON
* PROGRAM NAME   : REDO.CH.PREV.DBCM.FIELDS
*-----------------------------------------------------------------------------
* Description : This is the field template definition routine to create the table
* 'REDO.CH.PREV.DBCM'
*-----------------------------------------------------------------------------
* Input/Output :
*--------------------------------------------------
* IN : NA
* OUT : NA
*--------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id

    ID.F = ''
    ID.N = '6'
    ID.T = ''
    ID.T<2> = 'SYSTEM'


*-----------------------------------------------------------------------------
* CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
* CALL Field.setCheckFile(fileName)        ;* Use DEFAULT.ENRICH from SS or just field 1

    CALL Table.addFieldDefinition("IP.ADD","15","A","")       ;* Add a new field
    CALL Table.addFieldDefinition("PORT","6","A","");
    CALL Table.addFieldDefinition("SIDSERV","35","ANY","");
    CALL Table.addFieldDefinition("DB.USER","35","A","");
    CALL Table.addFieldDefinition("DB.PWD","35","A","");
    CALL Table.addFieldDefinition("MSG.IF.DB.ER","100","A","");

* CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
* CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
