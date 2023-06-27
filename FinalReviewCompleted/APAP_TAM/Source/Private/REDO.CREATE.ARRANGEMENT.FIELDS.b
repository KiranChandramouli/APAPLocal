* @ValidationCode : Mjo0NjgyMzE3NzM6Q3AxMjUyOjE2ODQ4NDIwOTMyNTA6SVRTUzotMTotMTotMTIwOjE6dHJ1ZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -120
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CREATE.ARRANGEMENT.FIELDS
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
*  DATE              WHO                REF       Modification
*                    MGUDINO
*  19/3/2013         PRAKASH                   Change of field type of the field TERM from 'A' to 'PERIOD'
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.PRODUCT
    $INSERT I_Table
    $INSERT I_F.CURRENCY
    $INSERT I_F.REDO.COLL.TYPE.DET
    $INSERT I_F.REDO.EMP.RESP.MVMT
    $INSERT I_F.REDO.CAMPAIGN.TYPES
    $INSERT I_F.REDO.AFFILIATED.COMPANY
*    $INCLUDE TAM.BP I_F.REDO.H.SUCURSAL
    $INSERT I_F.REDO.CIUU.LOAN.DESTINATION
    $INSERT I_F.REDO.CATEGORY.CIUU


*** </region>
    C$NS.OPERATION = 'ALL'    ;*PACS00546636

    GOSUB DEFINE.GENERAL.FIELDS
    GOSUB DEFINE.GENERAL.FIELDS.PAYMENT.SCHEDULE

*APAP.TAM.REDO.CREATE.ARRANGEMENT.FIELDS.COLL.BR.VS ;** R22 Manual conversion - CALL method format changed
    APAP.TAM.redoCreateArrangementFieldsCollBrVs() ;*R22 Manual Conversion

RETURN
 

DEFINE.GENERAL.FIELDS:

*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------
*
    neighbour = ''
    fieldName = 'PRODUCT'
    fieldLength = '30.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("AA.PRODUCT")

*
    neighbour = ''
    fieldName = 'LOAN.GEN.LED'
    fieldLength = '35'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    fieldType ='':@FM:'SI_NO'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition("SECURED", "2", fieldType, '')
*
    fieldType ='':@FM:'SI_NO'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition("REVOLVING", "2", fieldType, '')
*-----------------------------------------------------------------------------

*
    neighbour = ''
    fieldName = 'CUSTOMER'
    fieldLength = '20.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")
*
    neighbour = ''
    fieldName = 'LOAN.CURRENCY'
    fieldLength = '3.1'
    fieldType = 'CCY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")
*
    neighbour = ''
    fieldName = 'EFFECT.DATE'
    fieldLength = '8.1'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'AMOUNT'
    fieldLength = '19.1'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'TERM'
    fieldLength = '19.1'
    fieldType = 'PERIOD'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'FIXED.RATE'
    fieldLength = '16'
    fieldType = 'R'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'PRIM.OFFICER'
    fieldLength = '20'
    fieldType = 'DAO'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("DEPT.ACCT.OFFICER")
*
    neighbour = ''
    fieldName = 'XX<OTHER.PARTY'
    fieldLength = '20'
    fieldType = 'CUS'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")
*
*neighbour = ''
    fieldName = 'XX>OTHER.PARTY.ROLE'
    ebLoookUpTable = "AA.PARTY.ROLE"
    CALL Table.addFieldWithEbLookup(fieldName, ebLoookUpTable, '');
*CALL Table.addOptionsField("XX>OTHER.PARTY.ROLE","CODEUDOR_GARANTE_APODERADO_REFERIDOR_VENDEDOR","","")


*
    neighbour = ''
    fieldName = 'CAMPA.TYPE'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.CAMPAIGN.TYPES")
*
    neighbour = ''
    fieldName = 'AFF.COMP'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.AFFILIATED.COMPANY")
*
    neighbour = ''
    fieldName = 'AGENCY.CO'
    fieldLength = '20'
    fieldType = 'DAO'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("DEPT.ACCT.OFFICER")

*
    neighbour = ''
    fieldName = 'DEST.LOAN'
    fieldLength = '2'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.CIUU.LOAN.DESTINATION")
*
    neighbour = ''
    fieldName = 'CIUU.CATEG'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*   CALL Field.setCheckFile("REDO.CATEGORY.CIUU")
    CHECKFILE(Table.currentFieldPosition) = "REDO.CATEGORY.CIUU" : @FM : CAT.CIU.DESCRIPTION
*

    neighbour = ''
    fieldName = 'XX<LOAN.DOC'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.LOAN.DOCUMENTATION")
*
    neighbour = ''
    fieldName = 'XX-IMG.TYPE'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("IM.IMAGE.TYPE")
*
    neighbour = ''
    fieldName = 'XX-IMG.ID'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    CALL Table.addOptionsField("XX-DOCS.RECVD","RECIBIDO","","")
*    CALL Field.setDefault(" ")
*
    neighbour = ''
    fieldName = 'XX>REMARK'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    CALL Table.addOptionsField("TYPE.RATE.REV","BACK.TO.BACK_FIJO_PERIODICO","","")
*
    CALL Table.addOptionsField("FORM.REVIEW","AUTOMATICA_MANUAL","","")
*    CALL Field.setDefault("AUTOMATICA")
*
    neighbour = ''
    fieldName = 'RATE.FQY'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'FST.RE.DATE'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
DEFINE.GENERAL.FIELDS.PAYMENT.SCHEDULE:

    neighbour = ''
    fieldName = 'PAYMT.SCH.TYPE'
    fieldLength = '80'
    fieldType = 'ANY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("AA.PRD.DES.PAYMENT.SCHEDULE")
*
*   neighbour = ''
    fieldName = 'PAYMT.DAY'
    ebLoookUpTable= 'PAYMT.DAY.VALUE'
    CALL Table.addFieldWithEbLookup(fieldName, ebLoookUpTable, '');
*   fieldLength = '2'
*   fieldType = ''
*   CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

* CALL Table.addOptionsField("PAYMT.MHD","MANUAL_DEBITO DIRECTO_NOMINA EMPLEADO DE APAP_NOMINA FUNCIONARIOS APAP_NOMINA EXTERNA","","")
    CALL Table.addOptionsField("PAYMT.MHD","Manual_Direct Debit_APAP Employee Payroll_APAP Executive Payroll_External Payroll","","")
*   fieldName = "PAYMT.MHD"
*   ebLoookUpTable = "L.AA.PAY.METHD"
*   CALL Table.addFieldWithEbLookup(fieldName, ebLoookUpTable, '');
*
    neighbour = ''
    fieldName = 'ACC.TO.DEBIT'
    fieldLength = '20'
    fieldType = 'ACC'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("ACCOUNT")
*
*
    neighbour = ''
    fieldName = 'FORM'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*CALL Field.setCheckFile("REDO.FC.NOMEXT.EMPRESA")  Instaed to look for on a table it was create an Enquiry JV28012012
*
    neighbour = ''
    fieldName = 'XX<PAYMENT.TYPE'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("AA.PAYMENT.TYPE")
*
    neighbour = ''
    fieldName = 'XX-PAYMENT.METHOD'
    fieldLength = '10'
    fieldType ='':@FM:'DUE_CAPITALISE'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'XX-PAYMENT.FREQ'
    fieldLength = '30'
    fieldType = 'FQU'
    fieldType<6> = "EXTENDED"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'XX-XX<PROPERTY'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("AA.PROPERTY")
*
    neighbour = ''
    fieldName = 'XX-XX-DUE.FREQ'
    fieldLength = '30'
    fieldType = 'FQU'
    fieldType<6> = "EXTENDED"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'XX-XX>PERCENTAGE'
    fieldLength = '12'
    fieldType = 'R'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'XX-XX<START.DATE'
    fieldLength = '11'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'XX-XX-END.DATE'
    fieldLength = ''
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'XX-XX-NUM.PAYMENTS'
    fieldLength = '3'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'XX-XX-CALC.AMOUNT'
    fieldLength = '18'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
*fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'XX>XX>ACTUAL.AMT'
    fieldLength = '18'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'AMORTISATION.TERM'
    fieldLength = '4'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'RESIDUAL.AMOUNT'
    fieldLength = '18'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'ID.ARRANGEMENT'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
RETURN
*----------------------------------------------------------------------------

END
