*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.H.CHEQUE.REGISTER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*  DATE             WHO                 REFERENCE         DESCRIPTION
* 24-02-2010      SUDHARSANAN S      ODR-2009-12-0275   INITIAL CREATION
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F='@ID' ; ID.N='35' ; ID.T='A'
*------------------------------------------------------------------------------

  fieldName = "ISSUED.TO.DATE"
  fieldLength = "5"
  fieldType = ""
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "USED.TO.DATE"
  fieldLength = "5"
  fieldType = ""
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "ISSUE.PD.START"
  fieldLength = "8"
  fieldType = "D"
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


  fieldName = "ISSUED.THIS.PD"
  fieldLength = "5"
  fieldType = ""
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "USED.THIS.PD"
  fieldLength = "5"
  fieldType = ""
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "NO.HELD"
  fieldLength = "5"
  fieldType = ""
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX.CHEQUE.NOS"
  fieldLength = "35"
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX.PRESENTED.CHQS"
  fieldLength = "14"
  fieldType = "A"
  fieldType<3> = "EXTERN"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX.STOPPED.CHQS"
  fieldLength = "14"
  fieldType = ""
  fieldType<3> = "EXTERN"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX.RETURNED.CHQS"
  fieldLength = "14..C"
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "LAST.EVENT.SEQ"
  fieldLength = "5"
  fieldType = ""
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "USED.LAST.PD"
  fieldLength = "5"
  fieldType = ""
  fieldType<3> = "EXTERN"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "ISSUED.LAST.PD"
  fieldLength = "5"
  fieldType = ""
  fieldType<3> = "EXTERN"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "LAST.PERIOD.CHG"
  fieldLength = "19"
  fieldType = "AMT"
  fieldType<2,2>= "LCCY"
  fieldType<3> = "EXTERN"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "LAST.PD.CHG.DATE"
  fieldLength = "11"
  fieldType = "D"
  fieldType<3> = "EXTERN"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A'
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "XX.AUTO.CHEQUE.NO"
  fieldLength = "20"
  fieldType = ""
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "RESERVED.9"
  fieldLength = "35"
  fieldType = "A"
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


  fieldName = "RESERVED.8"
  fieldLength = "35"
  fieldType = "A"
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "RESERVED.7"
  fieldLength = "35"
  fieldType = "A"
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "RESERVED.6"
  fieldLength = "35"
  fieldType = "A"
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "RESERVED.5"
  fieldLength = "35"
  fieldType = "A"
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "RESERVED.4"
  fieldLength = "35"
  fieldType = "A"
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "RESERVED.3"
  fieldLength = "35"
  fieldType = "A"
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "RESERVED.2"
  fieldLength = "35"
  fieldType = "A"
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "RESERVED.1"
  fieldLength = "35"
  fieldType = "A"
  fieldType<3> = "NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


  fieldName = "XX.STMT.NO"
  fieldLength = "16"
  fieldType = ""
  fieldType<3> = "EXTERN"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


  fieldName = "XX.OVERRIDE"
  fieldLength = "35"
  fieldType = ""
  fieldType<3> = "EXTERN"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
