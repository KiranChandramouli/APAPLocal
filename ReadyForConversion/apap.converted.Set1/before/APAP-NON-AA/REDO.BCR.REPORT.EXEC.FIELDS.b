*-----------------------------------------------------------------------------
* <Rating>-15</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BCR.REPORT.EXEC.FIELDS
*-----------------------------------------------------------------------------
* <doc>
*
* FIELDS for REDO.BCR.REPORT.EXEC application, allows to execute processes related
* with BURO DE CREDITO interface manually
*
* author: hpasquel@temenos.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 29/10/2010 - C.21 Buro de Credito
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_Table
  $INSERT I_F.REDO.INTERFACE.PARAM

*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id

  ID.F = '@ID'
  ID.N = '6'
  ID.T = 'A'
  ID.CHECKFILE = "REDO.INTERFACE.PARAM" : FM : REDO.INT.PARAM.NAME
*-----------------------------------------------------------------------------

  fieldName="NAME"
  fieldLength="35.3"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    fieldName="PROCESS"
*    fieldLength="100"
*    fieldType="A"
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
*
*    fieldName="DESCRIPTION"
*    fieldLength="100"
*    fieldType="A"
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="SEND.METHOD"
  fieldLength="50.1"
  ebLoookUpTable = "REDO.INT.PARAM.SEND.METHOD"
  CALL Table.addFieldWithEbLookup(fieldName, ebLoookUpTable, '');
  N(Table.currentFieldPosition) = fieldLength
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="ENCRIPTATION"    ;* Please don't change this name, this means ENCRYPTION
  fieldLength="2.1"
  fieldType=""
  fieldType<2>="SI_NO"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ENCRIP.KEY"
  fieldLength="135"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ENCRIP.MET"
  ebLoookUpTable = "REDO.INT.PARAM.ENCRIP.MET"
  CALL Table.addFieldWithEbLookup(fieldName, ebLoookUpTable, '');

  fieldName="DIR.PATH"
  fieldLength="100.1"
  fieldType="DIR"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="FILE.NAME"
  fieldLength="35.1"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    fieldName="MOV.ORIGIN"
*    fieldLength="2"
*    fieldType=""
*    fieldType<2>="DR_CR"
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
*    fieldName="REP.TIME.RANGE"
*    fieldLength="15"
*    fieldType="A"
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
*    fieldName="XX<TYPE.CONFIG"
*    fieldLength="15"
*    fieldType=""
*    fieldType<2>="SQL_ORACLE_WS_FTP_EMAIL"
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
*    fieldName="XX>DATA.CONFIG"
*    fieldLength="100"
*    fieldType="A"
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    fieldName="AUTOM.EXEC"
*    fieldLength="2"
*    fieldType=""
*    fieldType<2>="SI_NO"
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
*    fieldName="AUTOM.EXEC.FREC"
*    fieldLength="35"
*    fieldType="FQU" ;* C.21
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
*    fieldName="AUTHORIZATION"
*    fieldLength="7"
*    fieldType=""
*    fieldType<2>="MAKER_CHECKER"
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="XX<PARAM.TYPE"
  ebLoookUpTable = "REDO.INT.PARAM.TYPE"
  CALL Table.addFieldWithEbLookup(fieldName, ebLoookUpTable, '');

  fieldName="XX>PARAM.VALUE"
  fieldLength="100"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="PROC.TO.EXEC"
  fieldLength="35.1"
  ebLoookUpTable = "REDO.BCR.REP.PROC.TO.EXEC"
  CALL Table.addFieldWithEbLookup(fieldName, ebLoookUpTable, '');
  N(Table.currentFieldPosition) = fieldLength

  fieldName="GET.INT.PARAM"
  fieldLength="2"
  fieldType=""
  fieldType<2>="SI_NO"
  fieldType<9>="HOT.FIELD"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RUN.PROCESS"     ;* Please don't change this name, this means ENCRYPTION
  fieldLength="2.1"
  fieldType=""
  fieldType<2>="SI_NO"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName   = 'XX.LOAN.PRODUCT.GROUP'
  fieldLength = '65'
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("REDO.PRODUCT.GROUP")



*CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")


  neighbour = ''
  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
