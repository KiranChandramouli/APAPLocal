*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LY.CUSGROUP.ID
*-----------------------------------------------------------------------------
!** FIELD definitions FOR TEMPLATE
*!
* @author youremail@temenos.com
* @stereotype id
* @package infra.eb
* @uses
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LY.CUSGROUP
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------

  FN.REDO.LY.CUSGROUP = 'F.REDO.LY.CUSGROUP'
  F.REDO.LY.CUSGROUP = ''
  CALL OPF(FN.REDO.LY.CUSGROUP,F.REDO.LY.CUSGROUP)

  R.REDO.LY.CUSGROUP = ''; CUSG.ERR = ''
  CALL F.READ(FN.REDO.LY.CUSGROUP,ID.NEW,R.REDO.LY.CUSGROUP,F.REDO.LY.CUSGROUP,CUSG.ERR)
  IF R.REDO.LY.CUSGROUP AND PGM.VERSION EQ ',INPUT' THEN
    E = 'EB-REDO.LY.V.CUSGRPNAME'
    RETURN
  END

END
