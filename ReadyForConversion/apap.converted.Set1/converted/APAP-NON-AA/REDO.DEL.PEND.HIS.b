SUBROUTINE  REDO.DEL.PEND.HIS(DEL.REC)
*---------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is to delete the records from REDO.PENDING.CHARGE$HIS file

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
* 10-JAN-2010     SHANKAR RAJU     ODR-2009-10-0529     Initial Creation
*---------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_REDO.DEL.PEND.HIS.COMMON
*---------------------------------------------------------------------------
    GOSUB DEL.PENDING.CHARGE
RETURN
*---------------------------------------------------------------------------
DEL.PENDING.CHARGE:
*~~~~~~~~~~~~~~~~~~
    CALL F.DELETE(FN.PEND.CHG.HIS,DEL.REC)
RETURN
*---------------------------------------------------------------------------
END
