*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AUTH.STO.OVERRIDE.PARAM
*---------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*----------------------------------------------------------------------------------------
* Revision History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*24.08.2010      SUDHARSANAN S      PACS00054326    INITIAL CREATION
* ---------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.OVERRIDE
$INSERT I_F.REDO.STO.OVERRIDE.PARAM

  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN
*-----------
OPENFILES:
*-----------
  FN.REDO.STO.OVERRIDE.PARAM = 'F.REDO.STO.OVERRIDE.PARAM'
  STO.PARAM.ID = 'SYSTEM'
  CALL CACHE.READ(FN.REDO.STO.OVERRIDE.PARAM,STO.PARAM.ID,R.STO.OVERRIDE.PARAM,STO.ERR)
  RETURN
*-----------
PROCESS:
*-----------
  Y.OVERRIDE.ID = R.STO.OVERRIDE.PARAM<STO.OVE.OVERRIDE.ID>
  CHANGE VM TO FM IN Y.OVERRIDE.ID
  VAR.OVERRIDE.ID = ID.NEW
  VAR.MESSAGE.NEW = R.NEW(EB.OR.MESSAGE)
  VAR.MESSAGE.OLD = R.OLD(EB.OR.MESSAGE)
  IF VAR.MESSAGE.NEW NE VAR.MESSAGE.OLD THEN
    LOCATE VAR.OVERRIDE.ID IN Y.OVERRIDE.ID SETTING POS THEN
      R.STO.OVERRIDE.PARAM<STO.OVE.MESSAGE,POS> = VAR.MESSAGE.NEW<1,1>
      CALL F.WRITE(FN.REDO.STO.OVERRIDE.PARAM,STO.PARAM.ID,R.STO.OVERRIDE.PARAM)
    END
  END
  RETURN
*----------------------------------------------------------------------------------------
END
