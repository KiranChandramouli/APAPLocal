SUBROUTINE REDO.B.AUTO.ITEM.REQ.LOAD
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
* 29-JULY-2010       JEEVA             ODR-2010-03-0400      Initial Creation
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AUTO.ITEM.REQ.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.H.INVENTORY.PARAMETER
    $INSERT I_F.REDO.ITEM.STOCK
    $INSERT I_F.REDO.H.MAIN.COMPANY
    $INSERT I_F.REDO.H.REORDER.LEVEL

    GOSUB INIT
    GOSUB OPEN.FILE

RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------

    FN.REDO.H.INVENTORY.PARAMETER = 'F.REDO.H.INVENTORY.PARAMETER'
    F.REDO.H.INVENTORY.PARAMETER = ''

    FN.REDO.H.MAIN.COMPANY = 'F.REDO.H.MAIN.COMPANY'
    F.REDO.H.MAIN.COMPANY =''
    CALL OPF(FN.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY)

    FN.REDO.H.REORDER.LEVEL = 'F.REDO.H.REORDER.LEVEL'
    F.REDO.H.REORDER.LEVEL =''
    CALL OPF(FN.REDO.H.REORDER.LEVEL,F.REDO.H.REORDER.LEVEL)

    FN.REDO.ITEM.STOCK = 'F.REDO.ITEM.STOCK'
    F.REDO.ITEM.STOCK = ''

RETURN
*---------------------------------------
OPEN.FILE:
*---------------------------------------

    CALL OPF(FN.REDO.ITEM.STOCK,F.REDO.ITEM.STOCK)
    CALL OPF(FN.REDO.H.INVENTORY.PARAMETER,F.REDO.H.INVENTORY.PARAMETER)
    Y.SEL.LIST = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.H.INVENTORY.PARAMETER,Y.SEL.LIST,R.REDO.H.INVENTORY.PARAMETER,Y.ERR)
RETURN

END
