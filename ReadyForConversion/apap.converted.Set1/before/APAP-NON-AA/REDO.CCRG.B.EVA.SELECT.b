* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.B.EVA.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
* job XX
*REM Just for compile
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_BATCH.FILES
*
$INSERT I_REDO.CCRG.B.EVA.COMMON
*-----------------------------------------------------------------------------
* Setup the parameters for BATCH.BUILD.LIST

* LIST.PARAMETERS<1> = blank, this is the list file name, NEVER enter a value here

* LIST.PARAMETERS<2> = the filename to be selected, e.g. F.ACCOUNT, BATCH.BUILD.LIST will open it

* LIST.PARAMETERS<3> = selection criteria for file, e.g. CURRENCY EQ "GBP", this first WITH is not required

*                      and will be added by BATCH.BUILD.LIST

* ID.LIST = predefined list, for example from a CONCAT file record.

*           ID.LIST will take precedence over LIST.PARAMETERS

* CONTROL.LIST = common list used by BATCH.JOB.CONTROL


  LIST.PARAMETERS = '' ; ID.LIST = ''

  LIST.PARAMETERS = ''
  LIST.PARAMETERS<2> = FN.REDO.CCRG.EVA.QUEUE
  CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)

  RETURN
END
