*-----------------------------------------------------------------------------
* <Rating>-5</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ACC.CR.INT.FIELDS
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
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
  $INSERT I_F.INTEREST.BASIS
  $INSERT I_F.TAX
  $INSERT I_F.BASIC.RATE.TEXT

*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F = '@ID' ; ID.N = '35..C' ; ID.T = 'A' ;
*-----------------------------------------------------------------------------
  fieldName = "INTEREST.DAY.BASIS"
  fieldLength = "7.1"
  fieldType = "":FM:"A_B_C_D_E_F_G_GENERAL_NONE"
  neighbour = ''
*CHECKINT  ='INTEREST.BASIS' : FM : IB.DESCRIPTION : FM : 'L....IGNORE.ERROR'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('INTEREST.BASIS');

  fieldName = "TAX.KEY"
  fieldLength = "12..C"
  fieldType = "TAX"
  neighbour = ''
* CHECKTAX  = "TAX":FM:EB.TAX.DESCRIPTION:FM:"L...D"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
* CALL Field.setCheckFile('TAX') ;

  fieldName = "CR.BALANCE.TYPE"
  fieldLength = "7.1"
  fieldType ="":FM:"AVERAGE_DAILY_MINIMUM"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR.CALCUL.TYPE"
  fieldLength = "5.1"
  fieldType = "":FM:"BAND_LEVEL"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR.MINIMUM.BAL"
  fieldLength = "18"
  fieldType = "AMT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR.OFFSET.ONLY"
  fieldLength = "1"
  fieldType = "":FM:"Y_"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX<CR.BASIC.RATE"
  fieldLength = "4..C"
  fieldType = ''
  neighbour = ''
* CHECKBASIC= "BASIC.RATE.TEXT":FM:EB.BRT.DESCRIPTION:FM:"L"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('BASIC.RATE.TEXT')

  fieldName = "XX-CR.INT.RATE"
  fieldLength = "011"
  fieldType = "R":FM:"-"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX-CR.MARGIN.OPER"
  fieldLength = "8"
  fieldType = "":FM:"ADD_MULTIPLY_SUBTRACT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX-CR.MAX.RATE"
  fieldLength = "11"
  fieldType = "R":FM:"-"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX-CR.MARGIN.RATE"
  fieldLength = "11"
  fieldType = "R"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX-CR.LIMIT.AMT"
  fieldLength = "18"
  fieldType = "AMT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX>CR.MIN.RATE"
  fieldLength = "11"
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.BALANCE.TYPE"
  fieldLength = "7"
  fieldType = "":FM:"AVERAGE_DAILY_MINIMUM"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.CALCUL.TYPE"
  fieldLength = "5"
  fieldType = "":FM:"BAND_LEVEL"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.MINIMUM.BAL"
  fieldLength = "18"
  fieldType = "AMT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.OFFSET.ONLY"
  fieldLength = "1"
  fieldType = "":FM:"Y_"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX<CR2.BASIC.RATE"
  fieldLength = "4..C"
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('BASIC.RATE.TEXT')

  fieldName = "XX-CR2.INT.RATE"
  fieldLength = "011"
  fieldType = "R":FM:"-"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX-CR2.MARGIN.OPER"
  fieldLength = "8"
  fieldType = "":FM:"ADD_MULTIPLY_SUBTRACT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX-CR2.MAX.RATE"
  fieldLength = "11"
  fieldType = "R":FM:"-"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX-CR2.MARGIN.RATE"
  fieldLength = "11"
  fieldType = "R"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX-CR2.LIMIT.AMT"
  fieldLength = "18"
  fieldType = "AMT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX>CR2.MIN.RATE"
  fieldLength = "11"
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "INTEREST.TAX.MIN"
  fieldLength = "19"
  fieldType = "AMT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "NET.TAX"
  fieldLength = "1"
  fieldType = @FM:"Y_N"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR.MIN.BAL.ST.DTE"
  fieldLength = "2"
  fieldType = ""
  fieldType<2> = '1...31'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR.MIN.BAL.ED.DTE"
  fieldLength = "2..C"
  fieldType = ""
  fieldType<2> = '1...31'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR.ACCR.OPEN.AC"
  fieldLength = "3..C"
  fieldType = ""
  fieldType<2> = "YES_NO"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR.ACCR.CLOSE.AC"
  fieldLength = "3..C"
  fieldType = ""
  fieldType<2> = "YES_NO"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.MIN.BAL.ST.DTE"
  fieldLength = "2"
  fieldType = ""
  fieldType<2> = '1...31'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.MIN.BAL.ED.DTE"
  fieldLength = "2..C"
  fieldType = ""
  fieldType<2> = '1...31'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.ACCR.OPEN.AC"
  fieldLength = "3..C"
  fieldType = ""
  fieldType<2> = "YES_NO"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.ACCR.CLOSE.AC"
  fieldLength = "3..C"
  fieldType = ""
  fieldType<2> = "YES_NO"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR.MIN.VALUE"
  fieldLength = "18"
  fieldType = "AMT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR.MIN.WAIVE"
  fieldLength = "4"
  fieldType = "": FM : "YES_NO_"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.MIN.VALUE"
  fieldLength = "18"
  fieldType = "AMT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.MIN.WAIVE"
  fieldLength = "4"
  fieldType = "": FM : "YES_NO_"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR.ZERO.INT.BAL"
  fieldLength = "18"
  fieldType = "AMT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR.ZERO.INT.OC"
  fieldLength = "3..C"
  fieldType = ""
  fieldType<2> = "YES_NO_"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.ZERO.INT.BAL"
  fieldLength = "18"
  fieldType = "AMT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "CR2.ZERO.INT.OC"
  fieldLength = "3..C"
  fieldType = ""
  fieldType<2> = "YES_NO_"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "NEGATIVE.RATES"
  fieldLength = "12..C"
  fieldType = ""
  fieldType<2> = "YES_BLOCK.MARGIN_NO_"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "COMPOUND.TYPE"
  fieldLength = "5"
  fieldType = "COMPFQU"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
