* @ValidationCode : MjotMTE0MzU3NDY1NzpDcDEyNTI6MTY4NDg0MjE1NjI4NzpJVFNTOi0xOi0xOi0zOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -3
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE TAM.HOST.DETAILS.TRACE.FIELDS
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
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>

*-----------------------------------------------------------------------------
    ID.F = '@ID';  ID.T<1> = 'A';  ID.N = '35';  ID.CHECKFILE = 'USER'
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
