SUBROUTINE REDO.B.STOCK.QTY.CNT.HIS.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This load routine initialises and opens necessary files
*  and gets the position of the local reference fields
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
*   Date               who             Reference            Description
* 8-MARCH-2010     S.R.SWAMINATHAN   ODR-2010-03-0400      Initial Creation
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.STOCK.QTY.CNT.HIS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_GTS.COMMON
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.REDO.STOCK.QTY.COUNT

    GOSUB INIT
    GOSUB OPEN.FILE

RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------

    FN.STOCK.REGISTER = 'F.STOCK.REGISTER'
    F.STOCK.REGISTER = ''

    FN.REDO.STOCK.QTY.COUNT = 'F.REDO.STOCK.QTY.COUNT'
    F.REDO.STOCK.QTY.COUNT = ''
    R.REDO.STOCK.QTY.COUNT = ''

    FN.REDO.STOCK.QTY.COUNT.HIS = 'F.REDO.STOCK.QTY.COUNT$HIS'
    F.REDO.STOCK.QTY.COUNT.HIS = ''
    R.REDO.STOCK.QTY.COUNT.HIS = ''

    FN.DATES = 'F.DATES'
    F.DATES = ''

RETURN
*---------
OPEN.FILE:
*---------
*---------------------------------------
* This section opens the necessary files
*---------------------------------------

    CALL OPF(FN.REDO.STOCK.QTY.COUNT,F.REDO.STOCK.QTY.COUNT)
    CALL OPF(FN.STOCK.REGISTER,F.STOCK.REGISTER)
    CALL OPF(FN.DATES,F.DATES)

RETURN

END
