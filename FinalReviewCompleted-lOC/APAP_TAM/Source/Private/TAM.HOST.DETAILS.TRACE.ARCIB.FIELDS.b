* @ValidationCode : MjotODcwNTQ1NTExOkNwMTI1MjoxNjg0ODQyMTU2MjQ2OklUU1M6LTE6LTE6LTM6MTp0cnVlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -3
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE TAM.HOST.DETAILS.TRACE.ARCIB.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : TAM.HOST.DETAILS.TRACE.FIELDS
*-----------------------------------------------------------------------------
*Description       : This is a T24 routine which retrieves the information from the
*                    local table TAM.HOST.DETAILS.TRACE and stores it in the INPUTTER field of the transaction
*                    Attach this Routine in the AUTH.RTN field of VERSION.CONTROL file with SYSTEM as id
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date           Who              Reference          Description
*   -----         ------            -------------       ------------
* 03 Oct  2010    Mudassir V       ODR-2010-08-0465    Initial Creation
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>

*-----------------------------------------------------------------------------
    ID.F = '@ID';  ID.T<1> = 'A';  ID.N = '35'
*-----------------------------------------------------------------------------

    fieldName = 'HOST.NAME'
    fieldLength = '50'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'IP.ADDRESS'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'DATE'
    fieldLength = '16'
    fieldType = 'D'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
