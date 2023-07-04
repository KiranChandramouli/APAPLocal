* @ValidationCode : MjotMTYxMjczNDQ4MjpDcDEyNTI6MTY4NDg0MjA5Mjg5MTpJVFNTOi0xOi0xOjEyNjc6MTpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1267
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CREATE.ARRANGEMENT.FIELDS.COLL.BR.VS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine GENERAL ARRANGEMENT FIELDS
* @author MGUDINO@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*  DATE              WHO                       Modification
* 2/6/2011   MGUDINO
* 5/3/2012        JORGE VALAREZO               ADD SUBVALUE TO FIELDS ADDRESS.BR AND PROP.DESCR.BR
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*** </region>
    neighbour = ''
    GOSUB DEFINE.COLL.BR
    GOSUB DEFINE.COLL.VS
* APAP.TAM.REDO.CREATE.ARRANGEMENT.FIELDS.COLL.TP.DI
    APAP.TAM.redoCreateArrangementFieldsCollTpDi() ;*R22 Manual Conversion
RETURN

DEFINE.COLL.BR:
    GOSUB DEFINE.COLL.BR1
    GOSUB DEFINE.COLL.BR2       ;*
    GOSUB DEFINE.COLL.BR3       ;*
*    neighbour = ''
    fieldName = 'XX-BUILD.UNIT.VAL.BR'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*    neighbour = ''
    fieldName = 'XX-TOT.BUIL.AREA.BR'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*    neighbour = ''
    fieldName = 'XX-YEARS.OF.BUILD.BR'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*    neighbour = ''
    fieldName = 'XX-TOT.DEPREC.BR'
    fieldLength = '2'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*    neighbour = ''
    fieldName = 'XX-DEPREC.VAL.BR'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*    neighbour = ''
    fieldName = 'XX-TOT.VAL.BR'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*    neighbour = ''
    fieldName = 'XX-CONSTR.PROG.BR'
    fieldLength = '4'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*    neighbour = ''
    fieldName = 'XX-REVIEW.DT.FQU.BR'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-VALUA.DUE.DATE.BR'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-XX.ENCUM.VAL.BR'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-XX.ENCUM.NUMBER.BR'
    fieldLength = '2'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-XX.NAME.MORTG.CRED.BR'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-XX.INSUR.POLICY.BR'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    GOSUB ADD.RESERV.VS
RETURN
*-------------------------------------------------
ADD.RESERV.VS:
*-------------------------------------------------
    CALL Table.addReservedField('XX-RESERVED.5.BR')
    CALL Table.addReservedField('XX-RESERVED.4.BR')
    CALL Table.addReservedField('XX-RESERVED.3.BR')
    CALL Table.addReservedField('XX-RESERVED.2.BR')
    CALL Table.addReservedField('XX>RESERVED.1.BR')

RETURN
*
*-------------------------------------------------
DEFINE.COLL.BR1:
*-------------------------------------------------

    fieldName = 'XX<SEC.NO.STATE.BR'
    fieldLength = '18'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL")
*
*    neighbour = ''
    fieldName = 'XX-TYPE.OF.SEC.BR'
    fieldLength = '3'
    fieldType = ''
* JP20111006
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL.CODE")
*
*    neighbour = ''
    fieldName = 'XX-SEC.CLASSIFY.BR'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL.TYPE")
*
*    neighbour = ''
    fieldName = 'XX-SEC.HLD.IDEN.BR'
    fieldLength = '10'
    fieldType = 'CUS'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")
*
*    neighbour = ''
    fieldName = 'XX-COLL.CURRENCY.BR'
    fieldLength = '3'
    fieldType = 'CCY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")
*
*    neighbour = ''
    fieldName = 'XX-SEC.CREATE.DATE.BR'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-GRANTING.DATET.BR'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-EXECUTING.DATE.BR'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-SEC.VALUE.BR'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
RETURN
*----------------------------------------------------------------------------------------------------------------
DEFINE.COLL.VS:
*-----------------------------------------------------------------------------------------------------------------
*    neighbour = ''
    fieldName = 'XX<SEC.NO.STATE.VS'
    fieldLength = '18'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL")
*
*    neighbour = ''
    fieldName = 'XX-TYPE.OF.SEC.VS'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL.CODE")
*
*    neighbour = ''
    fieldName = 'XX-SEC.CLASSIFY.VS'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL.TYPE")
*
*    neighbour = ''
    fieldName = 'XX-SEC.HLD.IDEN.VS'
    fieldLength = '10'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")
*
*    neighbour = ''
    fieldName = 'XX-COLL.CURRENCY.VS'
    fieldLength = '3'
    fieldType = 'CCY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")
*
*    neighbour = ''
    fieldName = 'XX-SEC.CREATE.DATE.VS'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-GRANTING.DATET.VS'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-EXECUTING.DATE.VS'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-SEC.VALUE.VS'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-SEC.EXE.VAL.VS'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-GEN.LEDGER.VAL.VS'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-CENTR.BANK.VAL.VS'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-LOAN.MAX.PERC.VS'
    fieldLength = '3'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-MAX.LOAN.AMT.VS'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-AVAIL.COLL.BAL.VS'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-REMARKS.VS'
    fieldLength = '100'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*JP20110807 se adicional el nuevo campo
*
*    neighbour = ''
    fieldName = 'XX-VAL.EQUIMAQ.VS'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*----------------------------------------------------
    fieldName = 'XX-SERIAL.NUMBER.VS'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-PLATE.NUMBER.VS'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-VEHI.MARK.VS'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-FABR.YEAR.VS'
    fieldLength = '4'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-MODEL.VS'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-COLOR.VS'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-CHASSIS.NUM.VS'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-VEHI.TYPE.VS'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    CALL Table.addOptionsField("XX-SECURED.VS","NUEVO_USADO","","")
*    CALL Field.setDefault("NUEVO")
*
*    neighbour = ''
    fieldName = 'XX-XX.DESCRIPTION.VS'
    fieldLength = '50'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-VALUATOR.NAME.VS'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.VALUATOR.NAME")
*
*    neighbour = ''
    fieldName = 'XX-VAL.DATE.VS'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-TOT.VAL.VS'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-FREC.REV.VS'
    fieldLength = '2'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-MATUR.DATE.VS'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-XX.INSUR.POLICY.VS'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    GOSUB ADD.RESERV.FLDS
RETURN
*------------------------------------------------------------------------------------------------------------------
ADD.RESERV.FLDS:
*------------------------------------------------------------------------------------------------------------------
    CALL Table.addReservedField('XX-RESERVED.5.VS')
    CALL Table.addReservedField('XX-RESERVED.4.VS')
    CALL Table.addReservedField('XX-RESERVED.3.VS')
    CALL Table.addReservedField('XX-RESERVED.2.VS')
    CALL Table.addReservedField('XX>RESERVED.1.VS')

RETURN
*------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*** <region name= DEFINE.COLL.BR2>
DEFINE.COLL.BR2:
*** <desc> </desc>

*    neighbour = ''
    fieldName = 'XX-SEC.EXE.VAL.BR'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-GEN.LEDGER.VAL.BR'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-CENTR.BANK.VAL.BR'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-LOAN.MAX.PERC.BR'
    fieldLength = '3'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-MAX.LOAN.AMT.BR'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-AVAIL.COLL.BAL.BR'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-REMARKS.BR'
    fieldLength = '100'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*JP20110807 se adicional el nuevo campo
*
*    neighbour = ''
    fieldName = 'XX-VAL.EQUIMAQ.BR'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*----------------------------------------------------
*    neighbour = ''
    fieldName = 'XX-SEC.IDENT.BR'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-DESIGNATION.NO.BR'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-SOLAR.NO.BR'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-BLOCK.NO.BR'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= DEFINE.COLL.BR3>
DEFINE.COLL.BR3:
*** <desc> </desc>
*    neighbour = ''
    fieldName = 'XX-CADASTRAL.DIST.BR'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-COUNTRY.BR'
    fieldLength = '2'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COUNTRY")
*
*    neighbour = ''
    fieldName = 'XX-PROVINCES.BR'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-CITY.BR'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-SECTOR.BR'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.SECTOR.DOMI")
*
*    neighbour = ''
    fieldName = 'XX-XX.ADDRESS.BR'
    fieldLength = '200'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-XX.PROP.DESCR.BR'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-VALUATOR.NAME.BR'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.VALUATOR.NAME")
*
*    neighbour = ''
    fieldName = 'XX-VAL.DATE.BR'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-LAND.AREA.BR'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-LAND.UNIT.VALUE.BR'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    neighbour = ''
    fieldName = 'XX-TOT.LAND.VALUE.BR'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
*    ADD.RESERV.FLDS
    fieldName = 'XX-BUILD.AREA.BR'
    fieldLength = '16'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
RETURN
*** </region>

END
