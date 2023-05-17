*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.CON.LNS.BY.DEBTOR.SELECT
*-----------------------------------------------------------------------------
*
* Description           : This is a Batch routine used to SELECT the all LENDING Arrangements
*
* Developed On          : 10-Sep-2013
*
* Developed By          : Emmanuel James Natraj Livingston
*
* Development Reference : 786790(FS-205-DE13)
*
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)             NA                              NA                     NA
* PACS00365441           Ashokkumar.V.P                  27/02/2015      Optimized the relation between the customer
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT TAM.BP I_REDO.B.CON.LNS.BY.DEBTOR.COMMON
    SEL.LIST = ''
    GOSUB MAIN.PROCESS
    RETURN
*
*------------
MAIN.PROCESS:
**-----------
*
    LIST.PARAMETER = ''
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*    LIST.PARAMETER<3> = "START.DATE LE ":LAST.WORK.DAY
    LIST.PARAMETER<3> := " PRODUCT.GROUP EQ ":Y.TXNPGRP.VAL.ARR
    LIST.PARAMETER<3> := " AND PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
    RETURN
*
END
