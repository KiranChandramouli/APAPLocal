SUBROUTINE REDO.H.PROVISION.PARAMETER.FIELDS
*-------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.PROVISION.PARAMETER.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.H.PROVISION.PARAMETER is an H type template; this template is used to record
*                    the allowed security debit and credit codes, exempted sectors, MM product categories
*                    and batch run frequency
*</doc>
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Descript
*   ------         ------               -------------            --------- -
* 22 Sep 2010     Mudassir V         ODR-2010-09-0167 B.23B     Initial Creation
* 21 Oct 2010     Bharath G          ODR-2009-11-0159 B.23A     New Fields Added
* 10 May 2011     Sudharsanan S        PACS00061656             Add New fields and @ID changed to system
* 21 JUL 2011     JEEVA T              PACS00093284             new field added
* ------------------------------------------------------------------------
* <region name= Header>
* <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
*    $INCLUDE GLOBUS.BP I_Table
    $INSERT I_DataTypes
* </region>
*-------------------------------------------------------------------------
*CALL Table.defineId("@ID", T24_String)        ;* Define Table id
*PACS00061656 - S
    ID.F = '@ID'
    ID.N = '6'
    ID.T = '':@FM:'SYSTEM'
*PACS00061656 - E
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'XX.SEC.DR.CODE'   ; fieldLength = '3.1'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('SC.TRANS.NAME')

    fieldName = 'XX.SEC.CR.CODE'   ; fieldLength = '3.1'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('SC.TRANS.NAME')

    fieldName = 'XX.MM.PROD.CATEG' ; fieldLength = '5.1'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CATEGORY')

    fieldName = 'XX.EXEMP.SECTOR'  ; fieldLength = '4'     ; fieldType = ''   ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('SECTOR')

    fieldName = 'COB.FREQUENCY'    ; fieldLength = '35.1'  ; fieldType = 'FQU'  ;  GOSUB ADD.FIELDS

    fieldName = 'NEXT.RUN.DATE'    ; fieldLength = '8'     ; fieldType = 'D'; fieldType<3>='NOINPUT'  ;  GOSUB ADD.FIELDS

*------------------------------
*   ODR-2009-11-0159 - S
*------------------------------

    fieldName = 'COMM.MAJOR.AMOUNT'; fieldLength = '20.1'  ; fieldType = 'AMT'  ;  GOSUB ADD.FIELDS

    fieldName = 'DAYS.JUDICOLL'    ; fieldLength = '3'     ; fieldType = 'A'    ;  GOSUB ADD.FIELDS

    fieldName = 'DAYS.OVERDUE'     ; fieldLength = '3'     ; fieldType = 'A'    ;  GOSUB ADD.FIELDS

    fieldName = 'XX<LOAN.TYPE'  ; fieldLength = '10.1'
    fieldType = ''
    fieldType<2> = 'COMMERCIAL_CONSUMER_MORTGAGE'
    GOSUB ADD.FIELDS

    fieldName = 'XX-XX.PRODUCT.GROUP' ; fieldLength = '35.1'; fieldType = 'A'   ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('AA.PRODUCT.GROUP')

    fieldName = 'XX-XX<CLASSIFICATION'; fieldLength = '35.1'; fieldType = 'A'   ;  GOSUB ADD.FIELDS

    fieldName = 'XX-XX-SECUR.CLASSI'  ; fieldLength = '35'  ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

    fieldName = 'XX-XX-UNSECUR.CLASSI'; fieldLength = '35'  ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

    fieldName = 'XX-XX-MIN.DAYS'      ; fieldLength = '3.1' ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

    fieldName = 'XX-XX-MAX.DAYS'      ; fieldLength = '6.1' ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

    fieldName = 'XX>XX>PERCENTAGE'    ; fieldLength = '10.1'; fieldType = 'A'   ;  GOSUB ADD.FIELDS

*------------------------------
*   ODR-2009-11-0159 - E
*------------------------------
*PACS00061656 - S
*------------------------------
    fieldName = 'XX<RATING.TYPE'      ; fieldLength = '1.1' ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

    fieldName = 'XX-RATING.PERCENTAGE'      ; fieldLength = '9.1' ; fieldType = 'R'   ;  GOSUB ADD.FIELDS

    fieldName = 'XX>TYPE.DESCRIPTION'      ; fieldLength = '20' ; fieldType = 'ANY'   ;  GOSUB ADD.FIELDS


    fieldName = 'JUD.PRINC.PERCT'      ; fieldLength = '10.1' ; fieldType = ''   ;  GOSUB ADD.FIELDS

    fieldName = 'JUD.INT.PERCT'       ; fieldLength = '10.1' ; fieldType = ''   ;  GOSUB ADD.FIELDS
*------------------------------
*PACS00061656 - E
*------------------------------
*    CALL Table.addReservedField('RESERVED.7')
*    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

    CALL Table.addLocalReferenceField('XX.LOCAL.REF')

    CALL Table.addOverrideField

    CALL Table.setAuditPosition ;* Poputale audit information

RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN
*-----------------------------------------------------------------------------
END
