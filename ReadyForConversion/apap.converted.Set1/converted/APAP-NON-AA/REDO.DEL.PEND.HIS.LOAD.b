SUBROUTINE REDO.DEL.PEND.HIS.LOAD
*---------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is load file for the multithreaded routine REDO.DEL.PEND.HIS

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
    $INSERT I_REDO.DEL.PEND.HIS.COMMON
    FN.PEND.CHG.HIS = 'F.REDO.PENDING.CHARGE$HIS'
    F.PEND.CHG.HIS = ''
    CALL OPF(FN.PEND.CHG.HIS,F.PEND.CHG.HIS)
RETURN
END
