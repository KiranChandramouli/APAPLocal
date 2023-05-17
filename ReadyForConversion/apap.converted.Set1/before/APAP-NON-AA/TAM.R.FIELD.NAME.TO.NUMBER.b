*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE TAM.R.FIELD.NAME.TO.NUMBER(tableName, fieldName, fieldNo)
*-----------------------------------------------------------------------------
!** Simple SUBROUTINE template
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package infra.eb
* @description Allows to get the fieldNo for the given fieldname, 0 is returned if the fieldName does not exists into tableName
* @example
*           CALL REDO.R.BCR.GET.PARAM("CUSTOMER","SECTOR", fieldNo)
*           CRT fieldNo                                             ;* in R10 this will print 23
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STANDARD.SELECTION
*-----------------------------------------------------------------------------
  GOSUB INITIALISE
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
PROCESS:
  CALL GET.STANDARD.SELECTION.DETS(tableName, rStandardSelection)
  LOCATE fieldName IN rStandardSelection<SSL.SYS.FIELD.NAME,1> SETTING pos THEN
    fieldNo = rStandardSelection<SSL.SYS.FIELD.NO,pos>
  END

  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
  fieldNo = 0
  RETURN

*-----------------------------------------------------------------------------
END
