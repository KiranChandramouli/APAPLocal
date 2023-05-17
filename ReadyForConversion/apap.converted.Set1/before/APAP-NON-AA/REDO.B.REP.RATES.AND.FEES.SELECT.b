*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.REP.RATES.AND.FEES.SELECT
*---------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about files

* Developed By          : Thilak Kumar K
*
* Development Reference : TC01
*
* Attached To           : Batch - BNK/REDO.B.REP.RATES.AND.FEES
*
* Attached As           : Online Batch Routine to COB
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*---------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* NA                      Thenmalar T                     19-Feb-2014          Modified as per the selection
*---------------------------------------------------------------------------------------------

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_BATCH.FILES
$INSERT I_REDO.B.REP.RATES.AND.FEES.COMMON
*
  GOSUB CONTROL.LIST
*
  RETURN
*---------------------------------------------------------------------------------------------
*
CONTROL.LIST:
*------------

  SEL.CMD = "SELECT ":FN.REDO.L.ALL.FT.TT.FX.IDS:" WITH DATE GE ":Y.ONE.MONTH.PREV.DATE:" AND WITH DATE LE ":Y.LAST.WORK.DAY
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,RET.CODE)

  GOSUB BATCH.BUILD.LIST
*
  RETURN
*---------------------------------------------------------------------------------------------
*
BATCH.BUILD.LIST:
*----------------
  CALL BATCH.BUILD.LIST('',SEL.LIST)
*
  RETURN
*---------------------------------------------------------------------------------------------
END
