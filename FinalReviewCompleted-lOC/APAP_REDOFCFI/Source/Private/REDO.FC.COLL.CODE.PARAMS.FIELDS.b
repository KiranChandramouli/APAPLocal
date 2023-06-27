* @ValidationCode : MjoxMDEzMzkxMDg4OkNwMTI1MjoxNjgwNjcxNTYzMDkxOklUU1M6LTE6LTE6LTEwOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:42:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -10
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.COLL.CODE.PARAMS.FIELDS


*
* Subroutine Type : TEMPLATE.FIELDS
* Attached to     : TEMPLATE REDO.FC.COLL.CODE.PARAMS
* Attached as     :
* Primary Purpose : Define the fields to table REDO.FC.PARAMS
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Meza William - TAM Latin America
* Date            : 08 Junio 2011
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

* CALL Table.defineId("@ID", T24_String)        ;* Define Table id
* CALL Field.setCheckFile("COLLATERAL.CODE")
    ID.F = "@ID" ; ID.N = "3" ; ID.T = ""
*    ID.CHECKFILE = "COLLATERAL.CODE"



*neighbour = ''
    fieldName = 'TIP.REV.TASA'
*fieldLength = '16'
*fieldType = 'A'
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
    CALL Table.addOptionsField(fieldName,"BACK.TO.BACK_FIJO_PERIODICO","","")


    neighbour = ''
    fieldName = 'PER.MAX.PRESTAR'
    fieldLength = '16'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'XX.CAMPO.MAND'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field


    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

*----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information

RETURN
END
