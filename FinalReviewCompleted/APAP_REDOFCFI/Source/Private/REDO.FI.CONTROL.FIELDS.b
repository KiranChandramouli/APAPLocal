* @ValidationCode : MjotNTI1NTE5OTk1OkNwMTI1MjoxNjgxMTM1MTY0MTYwOklUU1M6LTE6LTE6LTU6MTp0cnVlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 19:29:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -5
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.CONTROL.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.FI.CONTROL
*
* @author avelasco@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 21/10/10 - C18
*            New Template changes
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    ID.F="@ID"
    ID.N="65"
    ID.T="A"
*-----------------------------------------------------------------------------
    CALL Table.addField("FILE.NAME", T24_String,Field_NoInput,'')
    CALL Table.addField("FILE.DIR", T24_String,Field_NoInput,'')
    CALL Table.addOptionsField("PROCESS.CONFIRM","SI_NO",Field_Mandatory,'')
    CALL Table.addField("PROC.DATE", T24_Date,Field_NoInput,'')
    neighbour = ''
    fieldName = 'PROC.TIME'
    fieldLength = '16'
    fieldType = 'TIME'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Table.addField("PROC.DATE.END", T24_Date,Field_NoInput,'')
    neighbour = ''
    fieldName = 'PROC.TIME.END'
    fieldLength = '16'
    fieldType = 'TIME'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addField("PROC.DATE.CONF", T24_Date,Field_NoInput,'')
    neighbour = ''
    fieldName = 'PROC.TIME.CONF'
    fieldLength = '16'
    fieldType = 'TIME'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addField("TOT.RECORD.FILE", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("TOT.AMOUNT.FILE", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("TOT.RECORD.CALC", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("TOT.AMOUNT.CALC", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("PROC.STATUS", T24_String,Field_NoInput,'')
    CALL Table.addField("PROC.STAT.D", T24_String,Field_NoInput,'')
    CALL Table.addField("TRANSACTION.ID", T24_String,'','')
    CALL Table.addField("TOT.RECORDS.OK", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("AMOUNT.PROC.OK", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("TOT.RECORDS.FAIL", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("AMOUNT.PROC.FAIL", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("TOT.RECORD.PROC", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("AMOUNT.PROC", T24_Numeric,Field_NoInput,'')
    CALL Table.addOptionsField("VAL.TRX.ENT","SI_NO",Field_Mandatory,'')
    CALL Table.addField("PARENT.FT.REF", T24_String,Field_NoInput,'')
    CALL Table.addField("XX<ACCOUNT.NUMBER", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("XX.CUSTOMER.NUMBER", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("XX.CUSTOMER.NAME", T24_String,Field_NoInput,'')
    CALL Table.addField("XX.TXN.AMOUNT", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("XX.TXN.STATUS", T24_Numeric,Field_NoInput,'')
    CALL Table.addField("XX.DESCRIPTION", T24_String,Field_NoInput,'')
    CALL Table.addField("XX>FT.REFERENCE", T24_String,Field_NoInput,'')
    CALL Table.addField("RET.FT.REF", T24_String,Field_NoInput,'')
    CALL Table.addField("RET.TAX.FT.REF", T24_String,Field_NoInput,'')

    CALL Table.addReservedField("RESERVED.1")
    CALL Table.addReservedField("RESERVED.2")
    CALL Table.addOverrideField
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
