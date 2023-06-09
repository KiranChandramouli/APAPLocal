SUBROUTINE REDO.INTERFACE.C18.PARAM.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to define id and fields for the table AI.REDO.ARCIB.PARAMETER
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    ID.F="@ID"
    ID.N = '6'
    ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------

    Y.FINAL.TABLE=''
    table = 'L.AC.STATUS1'
    CALL EB.LOOKUP.LIST(table)
    table1 = 'L.AC.STATUS2'
    CALL EB.LOOKUP.LIST(table1)
    Y.FINAL.TABLE<2> = table<2>:'_':table1<2>
    Y.FINAL.TABLE<11>=  table<11>:'_':table1<11>


    Y.LOAN.TABLE =''
    AA.LOAN.STATUS = 'L.LOAN.STATUS.1'
    CALL EB.LOOKUP.LIST(AA.LOAN.STATUS)
    AA.LOAN.COND = 'L.LOAN.COND'
    CALL EB.LOOKUP.LIST(AA.LOAN.COND)
    Y.LOAN.TABLE<2> = AA.LOAN.STATUS<2>:'_':AA.LOAN.COND<2>
    Y.LOAN.TABLE<11>= AA.LOAN.STATUS<11>:'_':AA.LOAN.COND<11>


    fieldName="XX<RESTRICT.ACCT.TYPE"
    fieldLength="65"
    neighbour=''
    fieldType=Y.FINAL.TABLE
    virtualTableName='AI.ACCOUNT.TYPE'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName="XX-XX.ACCT.STATUS"
    fieldLength="65"
    neighbour=''
    fieldType=Y.FINAL.TABLE
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="XX-XX.ACCT.NOTIFY.1"
    fieldLength="65"
    fieldType="A"
    neighbour=''
    virtualTableName='L.AC.NOTIFY.1'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName="XX>XX.POSTING.RESTRICT"
    fieldLength="2"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('POSTING.RESTRICT')

    fieldName="XX.RELATION.CODE"
    fieldLength="3"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('RELATION')

    fieldName="XX.ACCT.CATEGORY"
    fieldLength="4"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CATEGORY')


    fieldName="XX.LOAN.ACCT.STATUS"
    fieldLength="65"
    fieldType=Y.LOAN.TABLE
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)




    CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

    fieldName ="XX.OVERRIDE"
    fieldLength ="35"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
