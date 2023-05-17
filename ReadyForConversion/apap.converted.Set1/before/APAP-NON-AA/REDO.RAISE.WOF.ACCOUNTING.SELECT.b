*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RAISE.WOF.ACCOUNTING.SELECT

*DESCRIPTION:
*------------
* This is the COB routine for CR-43.
*
* This will select the IDs from the REDO.WOF.ACCOUNTING file.
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
* 26 Feb 2012    Ravikiran AV              CR.43                 Initial Creation
*
*------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.RAISE.WOF.ACCOUNTING.COMMON

*------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*
MAIN.LOGIC:

  GOSUB PROCESS

  RETURN
*------------------------------------------------------------------------------------------------------------------
* Load the Arrangement ids for Multi-Threaded Processing
*
PROCESS:

  SELECT.CMD = "SELECT ":FN.REDO.WOF.ACCOUNTING
  CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

  CALL BATCH.BUILD.LIST('', SEL.LIST)

  RETURN
*------------------------------------------------------------------------------------------------------------------
END
