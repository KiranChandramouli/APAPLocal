*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INTERFACE.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*This routine is used to define fields for  REDO.INTERFACE.PARAMETER.FIELDS table
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.INTERFACE.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
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
*   Date               who           Reference            Description
* 16-apr-2010        Prabhu.N       ODR-2009-10-0536     Initial Creation
*-----------------------------------------------------------------------------
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  ID.F="@ID"
  ID.N="20"
  ID.T="A"
*-----------------------------------------------------------------------------
  fieldName="INTERFACE.NAME"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="PROCESS"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="DESCRIPTION"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="SENDING.METHOD"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ENCRYPTION"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="FOLDERS.PATHS"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="FILES.NAME"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="OUT.REPORT.FMT"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="MOVEMENT.SOURCE"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="EXEC.FREQUENCY"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="HOURS.RG.REPORT"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="SQL.SERVER.CONF"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ORACLE.CONFIG"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="WEBSERVICE.CONF"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="FTP.CONFIG"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="EMAIL.CONFIG"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="AUTOMATIC.EXEC"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="AUTHORIZATION"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ORACLE.HOST"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ORACLE.PORT"
  fieldLength="35"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ORACLE.SID"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ORACLE.USER"
  fieldLength="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ORACLE.PASSWORD"
  fieldLength="55"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="CREDIT.STATUS"
  fieldLength="20"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName ="RESERVED.15"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.14"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.13"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""

  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.12"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.11"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.10"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.9"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.8"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.7"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.6"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.5"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.4"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.3"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.2"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="RESERVED.1"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName ="XX.STMT.NO"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="XX.OVERRIDE"
  fieldLength ="35"
  fieldType<2>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
