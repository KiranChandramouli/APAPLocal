* @ValidationCode : MjotMTY3OTY1MjQ3NTpDcDEyNTI6MTY4NDg0MTg1ODk2NTpJVFNTOi0xOi0xOi0xMToxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:07:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -11
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE LATAM.JOURNAL.LINE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author nareshc@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*04/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*04/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------



**********************@ID FIELD*****************
    ID.F='LINE.NAME'
    ID.N='6.1'
    ID.T<1>=''
    ID.T<2> ='SYSTEM'


*******************DESCRIPTION FIELD *****************

    fieldName = 'XX.LL.DESCRIPTION'
    fieldLength = '60'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour) ;

    fieldName = 'ASSET.LIAB'
    fieldLength = '21'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour) ;
    CALL Field.setCheckFile("RE.STAT.REPORT.HEAD")

    fieldName = 'PROFIT.LOSS'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour) ;
    CALL Field.setCheckFile("RE.STAT.REPORT.HEAD")

    fieldName = 'XX.PL.LINE'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour) ;
    CALL Field.setCheckFile("RE.STAT.REP.LINE")


*****************************RESERVED FIELDS**********************
    CALL Table.addField("RESERVED.1",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.2",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.3",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.4",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.5",  T24_String, Field_NoInput,"");


***************************LOCAL.REF FIELDS************************
    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour) ;


***************************OVERRIDE FIELDS******************************
    neighbour = ''
    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
