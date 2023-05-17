*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ISSUE.DEPT.CODE.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to check the ID value for the table REDO.ISSUE.DEPT.CODE.ID
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.ISSUE.DEPT.CODE.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author          Reference         Description
* 04-APR-2010    SUDHARSANAN S  PACS00033050  @ID not equal to numeric then raise the error message
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
  GOSUB PROCESS
  RETURN
*-------
PROCESS:
*-------
  VAR.ID = 0
  VAR.ID = NUM(ID.NEW)
  IF VAR.ID NE 1 THEN
    E = 'EB-NOT.VALID.NUMERIC.ID'
  END ELSE
    ID.NEW = FMT(ID.NEW,'R%3')
  END
  RETURN
END
