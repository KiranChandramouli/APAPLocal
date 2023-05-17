SUBROUTINE REDO.LY.PROGRAM.FIELDS
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
*  DATE             WHO         REFERENCE         DESCRIPTION
* 05-04-2010      GANESH      ODR-2009-12-0276   INITIAL CREATION
* 18-07-2011    RMONDRAGON    ODR-2011-06-0243   UPDATE TO ENTIRE APPLICATION
* 03-08-2011    RMONDRAGON    ODR-2011-06-0243   NEW FIELDS FOR PHASE III -
*                                                I/E CONDITIONS
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("REDO.LY.PROGRAM", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '15'
    ID.T = 'A'

    fieldName='NAME'
    fieldLength='50'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MODALITY'
    fieldLength='7'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.LY.MODALITY")

    fieldName='AIRL.PROG'
    fieldLength='2'
    fieldType=''
    neighbour=''
    fieldType<2>="SI_NO"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='START.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='END.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='STATUS'
    fieldLength='10'
    fieldType=''
    fieldType<2>='Activo_No Activo'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='NEG.POINT.SHIP'
    fieldLength='2'
    fieldType=''
    fieldType<2>='SI_NO'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='AVAILABILITY'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.LY.AVAIL")

    fieldName='AVAIL.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='POINT.VALUE'
    fieldLength='7'
    fieldType='AMT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MIN.POINT.USED'
    fieldLength='7'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='MAX.POINT.USED'
    fieldLength='7'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='AVAIL.IF.DELAY'
    fieldLength='3'
    fieldType=''
    fieldType<2>='SI_NO'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.PROD.DELAY'
    fieldLength='5'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CATEGORY")

    fieldName='PER.IF.DELAY'
    fieldLength='5'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='GROUP.CUS'
    fieldLength='5'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.LY.CUSGROUP")

    fieldName='APP.EXC.COND'
    fieldLength='12'
    fieldType=''
    fieldType<2>='TODAS_ESPECIFICA'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.EXC.COND'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='APP.INC.COND'
    fieldLength='12'
    fieldType=''
    fieldType<2>='TODAS_ESPECIFICA'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.INC.COND'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='POINT.USE'
    fieldLength='1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.LY.POINTUS")

    fieldName='GEN.FREC'
    fieldLength='8'
    fieldType=''
    fieldType<2>='DIARIO_MENSUAL'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='DAYS.EXP'
    fieldLength='4'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='EXP.DATE'
    fieldLength='11'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='TXN.TYPE.F.INT'
    fieldLength='5'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("FT.TXN.TYPE.CONDITION")

    fieldName='INT.ACCT'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.PRODUCT'
    fieldLength='5'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CATEGORY")
*--New fields

    fieldName='TXN.TYPE.GEN'
    fieldLength='5'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("FT.TXN.TYPE.CONDITION")

    fieldName='XX.DR.ACCT.GEN'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.CR.ACCT.GEN'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='TXN.TYPE.AVA'
    fieldLength='5'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("FT.TXN.TYPE.CONDITION")

    fieldName='XX.DR.ACCT.AVA'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.CR.ACCT.AVA'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='TXN.TYPE.US'
    fieldLength='5'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("FT.TXN.TYPE.CONDITION")

    fieldName='XX.DR.ACCT.US'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.CR.ACCT.US'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='TXN.TYPE.DUE'
    fieldLength='5'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("FT.TXN.TYPE.CONDITION")

    fieldName='XX.DR.ACCT.DUE'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.CR.ACCT.DUE'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName='TXN.TYPE.MAN'
    fieldLength='5'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("FT.TXN.TYPE.CONDITION")

    fieldName='XX.DR.ACCT.MAN'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.CR.ACCT.MAN'
    fieldLength='19'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='COND.TYPE.EXINC'
    fieldLength='20'
    fieldType=''
    fieldType<2>='ESTADO.CUENTA_ESTADO.PRESTAMO_CONDICION.PRESTAMO_MCC.TDEBITO_MERCHANTID.TDEBITO'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.EXC.EST.ACCT'
    fieldLength='17'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.INC.EST.ACCT'
    fieldLength='17'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.EXC.EST.LOAN'
    fieldLength='20'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.INC.EST.LOAN'
    fieldLength='20'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.EXC.COND.LOAN'
    fieldLength='20'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.INC.COND.LOAN'
    fieldLength='20'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='EXP.TYPE'
    fieldLength='9'
    fieldType=''
    fieldType<2>='POR.DIAS_POR.FECHA'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
