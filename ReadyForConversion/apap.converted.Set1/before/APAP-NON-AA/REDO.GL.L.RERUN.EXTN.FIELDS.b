*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GL.L.RERUN.EXTN.FIELDS
*-------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.GL.L.RERUN.EXTN.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : Fields for the template REDO.GL.L.RERUN.This template is used to store the count for the
*                      extracts/reports that are rerun online
*
*</doc>
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 8 NOV 2010    Mohammed Anies K   ODR-2009-12-0294 C.12          Initial Creation
* ------------------------------------------------------------------------
* <region name= Header>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
* </region>
*-------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.N = '35'    ; ID.T = 'A'
*-----------------------------------------------------------------------------
  neighbour = ''
  fieldName = 'XX<RUN.DATE'   ; fieldLength = '10'   ; fieldType = 'D'   ;  GOSUB ADD.FIELDS

  fieldName = 'XX>RUN.EXTN'   ; fieldLength = '20'   ; fieldType = ''   ;  GOSUB ADD.FIELDS

  RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  RETURN
*-----------------------------------------------------------------------------
END
