*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NV.DUP.VERSION.FIELDS


*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------
  ID.F = '@ID'
  ID.CHECKFILE = 'VERSION'
  ID.N = '50'
  ID.T = 'A'
*-----------------------------------------------------------------------------

  CALL Table.addFieldDefinition("AUTH.VERSION", "50", "A", "")        ;* Add a new fields
  CALL Field.setCheckFile("VERSION")    ;* Use DEFAULT.ENRICH from SS or just field 1

  CALL Table.setAuditPosition

  RETURN

END
