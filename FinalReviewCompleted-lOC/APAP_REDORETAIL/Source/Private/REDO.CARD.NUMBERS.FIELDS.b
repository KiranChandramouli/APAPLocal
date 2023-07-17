* @ValidationCode : Mjo1OTAxNjUwMjQ6Q3AxMjUyOjE2ODE4MjgwMDUxMDg6SVRTUzotMTotMTotMTY6MTp0cnVlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -16
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.NUMBERS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.NUMBERS.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.CARD.NUMBERS
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 JUL 2010    Mohammed Anies K       ODR-2010-03-0400         Initial Creation
* 9  Mar 2011    Balagurunathan B       ODR-2010-03-0400         Updating common variable V
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '25'    ; ID.T = 'A'
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'XX<CARD.NUMBER'  ; fieldLength = '35'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-STATUS'       ; fieldLength = '15'   ; fieldType = "A":@FM:"AVAILBLE_INUSE_DESTROY"  ;  GOSUB ADD.FIELDS
* Below Two fields are added as a part of C.15
    fieldName = 'XX-EMBOSS.TYPE'  ; fieldLength = '25'   ; fieldType = "A"  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-PERSONAL.TYPE'; fieldLength = '25'   ; fieldType = "A"  ;  GOSUB ADD.FIELDS
* Below fields added to defalt expiry date and type of card in Latam.card.order
    fieldName = 'XX-TYPE.OF.CARD' ; fieldLength = '25'   ; fieldType = "A"  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-CRD.REQ.ID' ; fieldLength = '25'   ; fieldType = "A"  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-EXPIRY.DATE' ; fieldLength = '10'   ; fieldType = "D"  ;  GOSUB ADD.FIELDS
    fieldName = 'XX>GEN.DATE' ; fieldLength = '10'   ; fieldType = "D"  ;  GOSUB ADD.FIELDS
*PACS00037281 end
    V = Table.currentFieldPosition
*PACS00037281 end
RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN
*----------------------------------------------------------------------------
END
