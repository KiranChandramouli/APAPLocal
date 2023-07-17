* @ValidationCode : MjotMzYxNzQ1NzA6Q3AxMjUyOjE2ODE4MjgwMDU5OTM6SVRTUzotMTotMTotODoxOnRydWU6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.REQ.STATUS.FIELDS
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACI POPULAR DE AHORROS Y PRTAMOS
*Developed By      : TEMENOS APPLICATION MANAGEMENT
*Program   Name    : REDO.CARD.REQ.STATUS.FIELDS
*By                : Kavitha
*Initial Creation  : 3-Mar-2011
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID",T24_String)
*-----------------------------------------------------------------------------
* CALL Table.addField(fieldName, fieldType, args, neighbour)
* CALL Field.setCheckFile(fileName)

    CALL Table.addFieldDefinition("XX.LL.DESCRIPTION", "65.1", "A", "")
    CALL Table.addField("XX.LOCAL.REF", T24_String,"","")
    CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput ,"")

* CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
* CALL Field.setDefault(defaultValue)
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
