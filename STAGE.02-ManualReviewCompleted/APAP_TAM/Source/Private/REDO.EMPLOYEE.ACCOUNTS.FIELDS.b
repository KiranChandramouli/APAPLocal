* @ValidationCode : Mjo5MTczNDQ5NTk6Q3AxMjUyOjE2ODA3NzM2NjgzMzY6SVRTUzotMTotMTowOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:04:28
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
SUBROUTINE REDO.EMPLOYEE.ACCOUNTS.FIELDS
*-----------------------------------------------------------------------------

* COMPANY NAME   : APAP
* DEVELOPED BY   : RAJA SAKTHIVEL K P
* PROGRAM NAME   : REDO.EMPLOYEE.ACCOUNTS.FIELDS
*-----------------------------------------------------------------------------
* Description : This is the field template definition routine to create the table
* 'REDO.EMPLOYEE.ACCOUNTS'
*-----------------------------------------------------------------------------
* Input/Output :
*-------------------------------------------------
* IN : NA
* OUT : NA
*--------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
*------------------------------------------------------------------------------------------------------------

*Modification Details:
*=====================
* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id

    ID.N = '25'
    ID.T = ''
    ID.CHECKFILE='CUSTOMER'

*-----------------------------------------------------------------------------
    fieldName="XX.ACCOUNT"
    fieldLength="19"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile('ACCOUNT')

    fieldName="USER.ID"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="XX.REL.CUSTOMER"
    fieldLength="25"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

*-----------------------------------------------------------------------------
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
