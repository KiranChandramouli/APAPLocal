* @ValidationCode : MjotMzU3MjkwMzI0OkNwMTI1MjoxNjg0ODQyMDkzMDEzOklUU1M6LTE6LTE6MzkyOjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 392
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CREATE.ARRANGEMENT.FIELDS.COLL.TP.DI
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
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*** </region>
    GOSUB DEFINE.COLL.TP
    GOSUB DEFINE.COLL.DI

*APAP.TAM.REDO.CREATE.ARRANGEMENT.FIELDS.COLL.DE.FS
    APAP.TAM.redoCreateArrangementFieldsCollDeFs() ;*R22 Manual Conversion

RETURN

DEFINE.COLL.TP:
*
*
    GOSUB DEFINE.COLL.TP1       ;*
    fieldName = 'XX-TYPE.OF.INSMNT.TP'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.INSTRUMENT.TYPE")
*
    fieldName = 'XX-ISSUR.ENT.INMNT.TP'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-NATION.TAXPYR.TP'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'XX-INSMNT.NO.TP'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-NATION.DATE.PYR.TP'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    CALL Table.addReservedField('XX-RESERVED.5.TP')
    CALL Table.addReservedField('XX-RESERVED.4.TP')
    CALL Table.addReservedField('XX-RESERVED.3.TP')
    CALL Table.addReservedField('XX-RESERVED.2.TP')
    CALL Table.addReservedField('XX>RESERVED.1.TP')

RETURN
*-----------------------------------------------------------------------------------------------------------------
DEFINE.COLL.DI:

*

    fieldName = 'XX<SEC.NO.STATE.DI'
    fieldLength = '18'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL")
*

    fieldName = 'XX-TYPE.OF.SEC.DI'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL.CODE")
*


    fieldName = 'XX-SEC.CLASSIFY.DI'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL.TYPE")
*

    fieldName = 'XX-SEC.HLD.IDEN.DI'
    fieldLength = '10'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")
*

    fieldName = 'XX-COLL.CURRENCY.DI'
    fieldLength = '3'
    fieldType = 'CCY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")
*

    fieldName = 'XX-SEC.CREATE.DATE.DI'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-GRANTING.DATE.DI'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-EXECUTING.DATE.DI'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-SEC.VALUE.DI'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-SEC.EXE.VAL.DI'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-GEN.LEDGER.VAL.DI'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-CENT.BANK.VAL.DI'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-LOAN.MAX.PERC.DI'
    fieldLength = '3'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-MAX.LOAN.AMT.DI'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-AVAIL.COLL.BAL.DI'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-REMARKS.DI'
    fieldLength = '100'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-NUM.INST.COLL.DI'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-NAME.COLL.OWNER.DI'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-MATUR.DATE.DI'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-AVAIL.COLL.VAL.DI'
    fieldLength = '35'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-COLL.RE.USED.DI'
    fieldLength = '2'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field ;*Add new field, this will be use to indicate if One Collateral was create previously.

    CALL Table.addReservedField('XX-RESERVED.4.DI')
    CALL Table.addReservedField('XX-RESERVED.3.DI')
    CALL Table.addReservedField('XX-RESERVED.2.DI')
    CALL Table.addReservedField('XX>RESERVED.1.DI')

RETURN
*-----------------------------------------------------------------------------------------------------------------



*-----------------------------------------------------------------------------

*** <region name= DEFINE.COLL.TP1>
DEFINE.COLL.TP1:
*** <desc> </desc>
    neighbour = ''
    fieldName = 'XX<SEC.NO.STATE.TP'
    fieldLength = '18'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL")

*

    fieldName = 'XX-TYPE.OF.SEC.TP'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL.CODE")
*

    fieldName = 'XX-SEC.CLASSIFY.TP'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("COLLATERAL.TYPE")
*

    fieldName = 'XX-SEC.HLD.IDEN.TP'
    fieldLength = '10'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")
*
    fieldName = 'XX-COLL.CURRENCY.TP'
    fieldLength = '3'
    fieldType = 'CCY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")
*

    fieldName = 'XX-SEC.CREATE.DATE.TP'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-GRANTI.DATE.TP'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-EXECUTING.DATE.TP'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-SEC.VALUE.TP'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-SEC.EXE.VAL.TP'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-GEN.LEDGER.VAL.TP'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-CENT.BANK.VAL.TP'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-LOAN.MAX.PERC.TP'
    fieldLength = '3'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*

    fieldName = 'XX-MAX.LOAN.AMT.TP'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-AVAIL.COLL.BAL.TP'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-REMARKS.TP'
    fieldLength = '100'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldName = 'XX-INSMNT.ISS.ENTY.TP'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.ISSUE.ENTITY")
*

RETURN
*** </region>

END
