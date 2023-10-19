* @ValidationCode : Mjo1MjIzOTE0MTg6Q3AxMjUyOjE2ODEyMzkwOTA1ODY6SVRTUzotMTotMTowOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 00:21:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.H.SOLICITUD.CK.FIELDS
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
* 08-02-2010      GANESH      ODR-2009-12-0275   INITIAL CREATION
* 12.04.2023   Conversion Tool       R22         Auto Conversion     - FM TO @FM
* 12.04.2023   Shanmugapriya M       R22         Manual Conversion   - No changes
*

*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("REDO.H.SOLICITUD.CK", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '10'
    ID.T = 'A'

    GOSUB FIELD.SET.1
    GOSUB FIELD.SET.2
    GOSUB FIELD.SET.3
    GOSUB FIELD.SET.4

    CALL Table.addOverrideField

    CALL Table.setAuditPosition ;* Poputale audit information

RETURN
*-----------------------------------------------------------------------------
FIELD.SET.1:
*-----------------------------------------------------------------------------

    fieldName='ACCOUNT'
    fieldLength='19'
    fieldType='POSANT'
    fieldType<9>='HOT.FIELD'
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("ACCOUNT")

    fieldName='FICHA.IMPR'
    fieldLength='12'
    fieldType='A'
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("STOCK.ENTRY")

    fieldName='DATE.OF.REQ'
    fieldLength='8'
    fieldType='D'
    GOSUB ADD.FIELDS

    fieldName='CHEQUE.TYPE'
    fieldLength='4'
    fieldType='SSS'
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("CHEQUE.TYPE")

    fieldName='CANT.CK'
    fieldLength='5'
    fieldType=''
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("REDO.H.CANT.CK")

    fieldName='CANT.TAL'
    fieldLength='3'
    fieldType=''
    GOSUB ADD.FIELDS

    fieldName='MODELO.CK'
    fieldLength='10'
    fieldType=''
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("REDO.H.MOD.CHEQUERA")

    fieldName='XX<COSTO.CK'
    fieldLength='20'
    fieldType='A'
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("FT.COMMISSION.TYPE")

    fieldName='XX>MONTO.CK'
    fieldLength='15'
    fieldType='AMT'
    GOSUB ADD.FIELDS

    fieldName='TAX'
    fieldLength='16'
    fieldType='A'
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("TAX")

    fieldName='TAX.AMOUNT'
    fieldLength='15'
    fieldType='AMT'
    GOSUB ADD.FIELDS

    fieldName='WAIVE.CHARGES'
    fieldLength='3'
    fieldType=''
    fieldType<2>='YES_NO'
    GOSUB ADD.FIELDS

    fieldName='MOTIVO.EXCEP'
    fieldLength='5'
    fieldType=''
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("REDO.H.MOT.EXCEP")

    fieldName='XX.NAME.ADDR'
    fieldLength='35'
    fieldType='A'
    GOSUB ADD.FIELDS

    fieldName='DOCNO.CL'
    fieldLength='11'
    fieldType=''
    GOSUB ADD.FIELDS
RETURN
*-----------------------------------------------------------------------------
FIELD.SET.2:
*-----------------------------------------------------------------------------

    fieldName='CHEQUE.STATUS'
    fieldLength='2'
    fieldType=''
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("CHEQUE.STATUS")

    fieldName='MOTIVO.DEST'
    fieldLength='5'
    fieldType=''
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("REDO.H.MOT.DEST")

    fieldName='STOCK.REG'
    fieldLength='20'
    fieldType='A'
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("STOCK.REGISTER")

    fieldName='SERIES.ID'
    fieldLength='35'
    fieldType='A'
    GOSUB ADD.FIELDS


    fieldName='CHQ.NO.START'
    fieldLength='6'
    fieldType=''
    GOSUB ADD.FIELDS

    fieldName='NOMBRE.ENT'
    fieldLength='35'
    fieldType='A'
    GOSUB ADD.FIELDS

    fieldName='NO.DOC'
    fieldLength='20'
    fieldType='A'
    GOSUB ADD.FIELDS

RETURN
*-----------------------------------------------------------------------------
FIELD.SET.3:
*-----------------------------------------------------------------------------

    fieldName='SUC.SOL'
    fieldLength='5'
    fieldType=''
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("REDO.H.SUCURSAL")

    fieldName='SUC.ENTREGA'
    fieldLength='5'
    fieldType=''
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("REDO.H.SUCURSAL")

    fieldName='NO.ORDEN'
    fieldLength='20'
    fieldType='A'
    GOSUB ADD.FIELDS

    fieldName='NO.CTA.ALFAN'
    fieldLength='28'
    fieldType='A'
    GOSUB ADD.FIELDS

    fieldName='NO.CTA.NUM'
    fieldLength='28'
    fieldType='A'
    GOSUB ADD.FIELDS

    fieldName='CHECK.DIGIT'
    fieldLength='2'
    fieldType='A'
    GOSUB ADD.FIELDS


    fieldName='TIEMPO.ENT'
    fieldLength='15'
    fieldType='A'
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("REDO.H.TIEMPOENT")

    fieldName='SOL.INTERNET'
    fieldLength='3'
    fieldType=''
    fieldType<2>='YES_NO'
    GOSUB ADD.FIELDS

    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A'
    GOSUB ADD.FIELDS

RETURN
*-----------------------------------------------------------------------------
FIELD.SET.4:
*-----------------------------------------------------------------------------
    fieldName="NCF.REQUIRED"
    fieldLength="3"
    fieldType  = '':@FM:'YES_NO'
    GOSUB ADD.FIELDS

    fieldName="NCF.NUMBER"
    fieldLength="19"
    fieldType="A"
    GOSUB ADD.FIELDS

    fieldName="NCF.TAX.NUM"
    fieldLength="19"
    fieldType="A"
    GOSUB ADD.FIELDS

    fieldName='MONEDA.CK'
    fieldLength='3'
    fieldType='A'
    GOSUB ADD.FIELDS
    CALL Field.setCheckFile("CURRENCY")


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

    fieldName = 'XX.STMT.NO'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3>='NOINPUT'
    GOSUB ADD.FIELDS

RETURN
*-----------------------------------------------------------------------------
ADD.FIELDS:
*--------------------------------------------------------------------------------
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

RETURN
*-------------------------------------------------------------------------------
END
