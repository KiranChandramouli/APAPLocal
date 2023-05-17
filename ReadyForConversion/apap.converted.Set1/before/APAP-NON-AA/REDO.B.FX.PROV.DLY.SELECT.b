*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.FX.PROV.DLY.SELECT

*DESCRIPTION:
*------------
* This is the COB routine for the ODR-2009-11-0159 and this is Select routine
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
*  25-OCT-2010     JEEVA T             ODR-2009-11-0159         Initial Creation
*
*-------------------------------------------------------------------------------------------------------------------

* All File INSERTS done here
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.FX.PROV.DLY.COMMON

*------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*
  GOSUB PROCESS

  RETURN
*------------------------------------------------------------------------------------------------------------------
* Load the Customer ids for Multi-Threaded Processing
*
PROCESS:

*    SELECT.CMD = 'SELECT ':FN.CUSTOMER.ACCOUNT
  SELECT.CMD = 'SELECT ':FN.REDO.CUSTOMER.ARRANGEMENT
  CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

  CALL BATCH.BUILD.LIST('', SEL.LIST)

  RETURN
*------------------------------------------------------------------------------------------------------------------
END
