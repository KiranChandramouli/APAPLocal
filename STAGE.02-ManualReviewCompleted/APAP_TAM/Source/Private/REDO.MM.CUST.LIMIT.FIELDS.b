* @ValidationCode : MjotMjA3NDAwNTk5MTpDcDEyNTI6MTY4MTIzOTA5MTQ1NzpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 00:21:31
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
SUBROUTINE REDO.MM.CUST.LIMIT.FIELDS
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CPH.PARAMETER.FIELDS
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* * 20-Jan-2012   BALAGURUNATHAN
* 13.04.2023      Conversion Tool            R22                Auto Conversion     - No changes
* 13.04.2023      Shanmugapriya M            R22                Manual Conversion   - No changes
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes


*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '20'
    ID.CHECKFILE='CUSTOMER'
*-----------------------------------------------------------------------------
    fieldName='XX.LIMIT.ID'
    fieldLength='35.1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('LIMIT')

    fieldName='XX.MAIL.ID'
    fieldLength='65.1'
    fieldType='ANY'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
