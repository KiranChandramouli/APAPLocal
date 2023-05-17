* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.B.POP.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
* job REDO.CCRG.B.POP
*REM Just for compile
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_REDO.CCRG.B.POP.COMMON
*
  LIST.PARAMETERS = '' ; ID.LIST = ''
  LIST.PARAMETERS<2> = FN.REDO.CCRG.POP.QUEUE

  CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)

  RETURN
*-----------------------------------------------------------------------------
END
