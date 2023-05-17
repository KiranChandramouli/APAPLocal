*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RAISE.NAB.ACCOUNTING.SELECT

*DESCRIPTION:
*------------
* This is the COB routine for CR-41.
*
* This will select the IDs from the REDO.NAB.ACCOUNTING file.
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
* 05 Dec 2011    Ravikiran AV              CR.41                 Initial Creation
*
*------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.RAISE.NAB.ACCOUNTING.COMMON

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

  SELECT.CMD = "SELECT ":FN.REDO.NAB.ACCOUNTING
  CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

  CALL BATCH.BUILD.LIST('', SEL.LIST)

  RETURN
*------------------------------------------------------------------------------------------------------------------
END
