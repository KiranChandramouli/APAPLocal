SUBROUTINE REDO.B.UPD.STO.CUR.AMT.SELECT
*----------------------------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the SELECT routine of the batch job REDO.B.UPD.STO.CUR.AMT
*   which updates the STANDING.ORDER CURRENT.AMOUNT, L.LOAN.STATUS.1 & L.LOAN.COND
* This routine selects STANDING.ORDER records processed on the current date
* ----------------------------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference                     Description
* 03-JUN-2010   N.Satheesh Kumar  TAM-ODR-2009-10-0331           Initial Creation
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.UPD.STO.CUR.AMT.COMMON

    SEL.CMD = 'SELECT ':FN.STANDING.ORDER:' WITH LAST.RUN.DATE EQ ':TODAY:' AND WITH L.LOAN.ARR.ID NE ""'
    CALL EB.READLIST(SEL.CMD,STO.SEL.LST,'',NO.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',STO.SEL.LST)
RETURN
END
