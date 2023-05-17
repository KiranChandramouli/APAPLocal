*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.SEC.POS.ASSET.SELECT
* -------------------------------------------------------------------------------------------------
* Description           : This is the Batch Select Routine used to select the records based on the
*                         conditions and pass the selected record array to main routine
* Developed By          : Vijayarani G
* Development Reference : 786942(FS-219-OA01)
* Attached To           : NA
* Attached As           : NA
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA

*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE
$INSERT I_REDO.B.SEC.POS.ASSET.COMMON
  $INSERT I_BATCH.FILES


  IF CONTROL.LIST EQ "" THEN
    CONTROL.LIST = "MM.MONEY.MARKET":FM:"SECURITY.POSITION"
  END
  IF CONTROL.LIST<1> EQ "MM.MONEY.MARKET" THEN
    SEL.CMD = "SELECT ":FN.MM:" WITH STATUS EQ 'CUR'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
  END
  IF CONTROL.LIST<1> EQ "SECURITY.POSITION" THEN
    SEL.CMD1 = "SELECT ":FN.SEC.POS:" WITH CLOSING.BAL.NO.NOM GT '0'"
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST1)
  END
*
  RETURN
END
