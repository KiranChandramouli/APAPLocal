* @ValidationCode : MjoxODg0OTUwMjM1OkNwMTI1MjoxNjgxMjM5MDkxNTU3OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
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
SUBROUTINE REDO.OFAC.DBCM.FIELDS
*-----------------------------------------------------------------------------

* COMPANY NAME   : APAP
* DEVELOPED BY   : RAJA SAKTHIVEL K P
* PROGRAM NAME   : REDO.OFAC.DBCM.FIELDS
*-----------------------------------------------------------------------------
* Description : This is the field template definition routine to create the table
* 'REDO.T.DEP.COLLATERAL'
*-----------------------------------------------------------------------------
* Input/Output :
*--------------------------------------------------
* IN : NA
* OUT : NA
*--------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id

    ID.F = ''
    ID.N = '6'
    ID.T = ''
    ID.T<2> = 'SYSTEM'


*-----------------------------------------------------------------------------
* CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
* CALL Field.setCheckFile(fileName)        ;* Use DEFAULT.ENRICH from SS or just field 1

    CALL Table.addFieldDefinition("IP.ADD","15","A","")       ;* Add a new field
    CALL Table.addFieldDefinition("PORT","6","A","");
    CALL Table.addFieldDefinition("DB.NAME","35","ANY","");
    CALL Table.addFieldDefinition("TB.NAME","35","ANY","");
    CALL Table.addFieldDefinition("DB.USER","35","A","");
    CALL Table.addFieldDefinition("DB.PWD","35","A","");
    CALL Table.addFieldDefinition("MSG.IF.EX.CU","100","A","");
    CALL Table.addFieldDefinition("MSG.IF.DB.ER","100","A","");
    CALL Table.addFieldDefinition("XX.EMAIL.TO.ADD","35","A","");
    CALL Table.addFieldDefinition("EMAIL.REQ.DIR","60","A","");
    CALL Table.addFieldDefinition("EMAIL.FROM.ADD","35","A","");
    CALL Table.addFieldDefinition("STORE.PROC.NAME","35","ANY","");


* CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
* CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
