*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.YER.END.FX.SALE.PRE.SELECT
*----------------------------------------------------------------------------------------------------------
* Description           : This Select routine is used to Select the details of Last Year Sales in Forex
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : RegN21
*
* Attached To           : BATCH>BNK/REDO.B.YER.END.FX.SALE
*
* Attached As           : Batch Routine
*----------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*----------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*----------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*----------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*----------------------------------------------------------------------------------------------------------
*XXXX                   <<name of modifier>>                                 <<modification details goes he
*----------------------------------------------------------------------------------------------------------
* Include files
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.YER.END.FX.SALE.PRE.COMMON
$INSERT I_F.FOREX
  GOSUB INIT
  GOSUB DELETE.HIST.PREV.REC
  GOSUB PROCESS
  RETURN
INIT:
*---
  SEL.LIST = ''
  CMD = ''
  RETURN
DELETE.HIST.PREV.REC:
*-------------------
  CMD = "CLEAR.FILE ":FN.REDO.FX.HIST.LIST
  EXECUTE CMD
  RETURN
PROCESS:
*------
  SEL.FX = "SELECT ":FN.FX.HIST:" WITH @ID LIKE ":Y.YEAR:"..."
  CALL EB.READLIST(SEL.FX,SEL.LIST,'',NO.OF.REC,SEL.ERR)
  CALL BATCH.BUILD.LIST("",SEL.LIST)
  RETURN
END
