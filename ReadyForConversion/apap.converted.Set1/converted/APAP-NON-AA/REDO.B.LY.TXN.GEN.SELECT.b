SUBROUTINE REDO.B.LY.TXN.GEN.SELECT
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine selects the REDO.LY.PROGRAM file with POINT.USE field value is 1 (Internal Transaction)
* ------------------------------------------------------------------------------------------
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
*   Date            who           Reference            Description
* 03-MAY-2010   S.Marimuthu  ODR-2009-12-0276      Initial Creation
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.REDO.LY.MODALITY
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.DATES
    $INSERT I_REDO.B.LY.TXN.GEN.COMMON
*-----------------------------------------------------------------------------
    GOSUB SELECT.PRGM
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
SELECT.PRGM:
*-----------------------------------------------------------------------------

    SEL.CMD = 'SELECT ':FN.REDO.LY.PROGRAM:' WITH POINT.USE EQ 1'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END
