*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LY.GEN.ACCMOV.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
* job XX
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_BATCH.FILES

$INSERT I_REDO.B.LY.GEN.ACCMOV.COMMON

  Y.CURR.YEAR  = TODAY[1,4]
  Y.CURR.MONTH = TODAY[5,2]
  Y.CURR.DAY   = TODAY[7,2]

  SEL.CMD = 'SELECT ':FN.REDO.LY.POINTS.TOT:' WITH @ID LIKE ALL...':Y.CURR.DAY:Y.CURR.MONTH:Y.CURR.YEAR
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',ID.CNT,'')
  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN
END
