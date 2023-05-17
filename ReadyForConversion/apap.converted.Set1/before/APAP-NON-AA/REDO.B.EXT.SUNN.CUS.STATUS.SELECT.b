*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.EXT.SUNN.CUS.STATUS.SELECT

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.EXT.SUNN.COMMON
$INSERT I_F.REDO.INTERFACE.PARAM

  CALL F.READ(FN.REDO.INTERFACE.PARAM,'SUN001',R.INT.PARAM,F.REDO.INTERFACE.PARAM,PAR.ERR)
  F.FILE.PATH = R.INT.PARAM<REDO.INT.PARAM.FI.AUTO.PATH>

  OPEN F.FILE.PATH TO Y.PTR ELSE

    RETURN
  END

  Y.FILE.NAME = 'customerestatus.txt'
  READ Y.MSG FROM Y.PTR,Y.FILE.NAME THEN
 
    CALL BATCH.BUILD.LIST('',Y.MSG)
  END

  RETURN
END
