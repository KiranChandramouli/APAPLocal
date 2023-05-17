SUBROUTINE REDO.PART.TT.REJECT.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to define id and fields for the table REDO.PART.TT.REJECT.FIELDS
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date        who                Reference       Description
* 23-06-2010    S.Sudharsanan      B.12            Initial Creation
* 10-08-2011    SUDHARSANAN S      PACS00094144
* 15-10-2011    MARIMUTHU S        PACS00126000
* 01/03/2013    Vignesh Kumaar R   PACS00251031    To Display the Payment Type in Spanish
*------------------------------------------------------------------------------
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
    ID.N="35"
    ID.T="A"
*-----------------------------------------------------------------------------
    fieldName="ARRANGEMENT.ID"
    fieldLength="25.1"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CURRENCY"
    fieldLength="3.1"
    fieldType="CCY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CURRENCY')

* Fix for PACS00251031 [To Display the Payment Type in Spanish]

    virtualTableName = 'PAYMENT.METHOD'
    CALL EB.LOOKUP.LIST(virtualTableName)

* End of Fix

    fieldName="TRAN.TYPE"
    fieldLength="35.1"
    fieldType=virtualTableName
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="AMOUNT"
    fieldLength="25.1"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="VALUE.DATE"
    fieldLength="25.1"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="NO.OF.OD.BILLS"
    fieldLength="20"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="TOT.AMT.OVRDUE"
    fieldLength="20"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="REMARKS"
    fieldLength="65"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX.LOAN.STATUS.1"
    fieldLength="30"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX.LOAN.CONDITION"
    fieldLength="30"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* PACS00126000 -S

    fieldName="PRINCIPAL.AMT"
    fieldLength="18"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="PRINCIPAL.INT"
    fieldLength="18"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CHARGE.AMT"
    fieldLength="18"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="PENALTY.INT"
    fieldLength="18"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="PENALTY.CHG"
    fieldLength="18"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* PACS00126000 -E

    fieldName="NO.OF.INSTALLMENT"
    fieldLength="3"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addField("RESERVED.19", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.18", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.17", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.16", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
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

    fieldName ="XX.STMT.NO"
    fieldLength ="35"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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
