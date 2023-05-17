*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.T.MSG.DET.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine defines field for REDO.T.MSG.DET

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 10-FEB-2010       Prabhu.N       ODR-2009-12-0279    Initial Creation
*---------------------------------------------------------------------------------
***<region>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>

*------------------------------------------------------------------------------------
  ID.F="@ID"
  ID.N="10"
  ID.T="A"
*-----------------------------------------------------------------------------------
  fieldName="SECURE.ID"
  fieldLength="15"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
