* @ValidationCode : MjoxNzc3MTg0MTcxOkNwMTI1MjoxNjg0ODQyMTUyMjgzOklUU1M6LTE6LTE6LTEzOjE6dHJ1ZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -13
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VISION.PLUS.PARAM.FIELDS
*<doc>
* Template for field definitions for the application REDO.VISION.PLUS.PARAM
*
* @author: Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History
* ====================
* 04/17/2013 - Initial Version
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID", T24_String) ;* Define Table id
    ID.T = 'A'
*-----------------------------------------------------------------------------

    neighbour    = ''
    fieldName    = 'PROCESS.DATE'
    fieldLength  = '8'
    fieldType    = 'D'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = "CUT.TIME"
    fieldLength  = '4'
    fieldType    = ''
    fieldType<4> = "R##:##"
    fieldType<5> = "C"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'EMAIL.ADDRESS'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.FILE.PATH'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.FILE.NAME'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'PD.FILE.PATH'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'PD.FILE.NAME'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'DD.FILE.PATH'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'DD.FILE.NAME'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'VP.ACCT'
    fieldLength = '20'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
* CALL Field.setCheckFile("ACCOUNT")

    neighbour    = ''
    fieldName    = 'APAP.ENT.CODE'
    fieldLength  = '3'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'VP.USER'
    fieldLength  = '20'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'VP.TXN.SEQ'
    fieldLength  = '20'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'CS.FILE.PATH'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'CS.FILE.NAME'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'XX<MON.SOURCE.ID'
    fieldLength  = '3'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'XX>MON.SOURCE.DESC'
    fieldLength  = '15'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.REC.TYPE'
    fieldLength  = '01'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.STATUS'
    fieldLength  = '01'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.SEQ.NO'
    fieldLength  = '03'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.MER.NO'
    fieldLength  = '012'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.BAT.REV'
    fieldLength  = '1'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.ATM.BAT'
    fieldLength  = '01'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.V.PROC.DT'
    fieldLength  = '08'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.MC.PROC.DT'
    fieldLength  = '08'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.ACCEPT.ID'
    fieldLength  = '15'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.USR.REF'
    fieldLength  = '011'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.ARITH.ERR'
    fieldLength  = '1'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.ADJ.TXN'
    fieldLength  = '02'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.ADJ.AMT'
    fieldLength  = '018'
    fieldType    = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.ADJ.CODE'
    fieldLength  = '03'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.H.ADJ.DESCR'
    fieldLength  = '35'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.REC.TYPE'
    fieldLength  = '01'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.TRAN.STAT'
    fieldLength  = '01'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.MON.REC.TYPE'
    fieldLength  = '01'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.TRANS.REF'
    fieldLength  = '23'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.CASH.BACK'
    fieldLength  = '018'
    fieldType    = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.VISA.MAIL'
    fieldLength  = '1'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.MER.CAT'
    fieldLength  = '05'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.POS.CAP'
    fieldLength  = '1'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.POS.ENT'
    fieldLength  = '2'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.CHLD.METH'
    fieldLength  = '1'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.AUTH.SRC'
    fieldLength  = '1'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.ATM.ACCT'
    fieldLength  = '1'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.TER.ID'
    fieldLength  = '1'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.PLAN.NO'
    fieldLength  = '05'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.TXN.ACCT'
    fieldLength  = '8'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'MON.D.PLAN.SEQ'
    fieldLength  = '02'
    fieldType    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'LEGAL.STATUS'
    fieldLength  = '20'
    fieldType    = 'ANY'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'DECEASED.ST'
    fieldLength  = '20'
    fieldType    = 'ANY'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'CLOSED.STATUS'
    fieldLength  = '35'
    fieldType    = 'ANY'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'XX.DM.PARAM.1'
    fieldLength  = '512'
    fieldType    = 'A'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'XX.DM.PARAM.2'
    fieldLength  = '512'
    fieldType    = 'A'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'XX.DM.PARAM.3'
    fieldLength  = '512'
    fieldType    = 'A'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'XX.DM.PARAM.4'
    fieldLength  = '512'
    fieldType    = 'A'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'XX.DM.PARAM.5'
    fieldLength  = '512'
    fieldType    = 'A'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'XX.DM.PARAM.6'
    fieldLength  = '512'
    fieldType    = 'A'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'XX.DM.PARAM.7'
    fieldLength  = '512'
    fieldType    = 'A'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'XX.DM.PARAM.8'
    fieldLength  = '512'
    fieldType    = 'A'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'XX.DM.PARAM.9'
    fieldLength  = '512'
    fieldType    = 'A'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'XX.DM.PARAM.10'
    fieldLength  = '512'
    fieldType    = 'A'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName    = 'XX.DM.PARAM.11'
    fieldLength  = '512'
    fieldType    = 'A'
    neighbour    = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addReservedField('XX-RESERVED.5')
    CALL Table.addReservedField('XX-RESERVED.4')
    CALL Table.addReservedField('XX-RESERVED.3')
    CALL Table.addReservedField('XX-RESERVED.2')
    CALL Table.addReservedField('XX>RESERVED.1')

*-----------------------------------------------------------------------------
    CALL Table.addOverrideField
    CALL Table.setAuditPosition ;* Populate audit information

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
