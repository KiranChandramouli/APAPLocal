* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.B.EXT.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
* job REDO.CCRG.B.EXT
*REM Just for compile
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_BATCH.FILES
*
$INSERT I_REDO.CCRG.B.EXT.COMMON
$INSERT I_REDO.CCRG.CONSTANT.COMMON
*

  LIST.PARAMETERS = '' ; ID.LIST = ''
  LIST.PARAMETERS<2> = FN.REDO.CCRG.EXT.QUEUE

  CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)

  RETURN
*-----------------------------------------------------------------------------
END
