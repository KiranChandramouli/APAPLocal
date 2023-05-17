SUBROUTINE REDO.DEL.PEND.HIS.SELECT
*---------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is select file for the multithreaded routine REDO.DEL.PEND.HIS

* Input/Output:
*--------------
* IN :
* OUT :
*
* Dependencies:
*---------------
* CALLS :
* CALLED BY :
*
* Revision History:
*---------------------------------------------------------------------------
*   Date               who           Reference            Description
* 16-FEB-2010     SHANKAR RAJU     ODR-2009-10-0529     Initial Creation
*---------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.DEL.PEND.HIS.COMMON
    SEL.PEND.CMD = "SELECT " :FN.PEND.CHG.HIS
    CALL EB.READLIST(SEL.PEND.CMD,LIST.PEND.CHARGES,'',NO.OF.REC,PEND.ERR)
    CALL BATCH.BUILD.LIST('',LIST.PEND.CHARGES)
RETURN
END
