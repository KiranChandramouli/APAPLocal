*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.MG.LNS.BY.DEBTOR.SELECT
*-----------------------------------------------------------------------------
*
* Description           : This is a Batch routine used to SELECT the all LENDING Arrangements.
*
* Developed On          : 22-Oct-2013
*
* Developed By          : Emmanuel James Natraj Livingston
*
* Development Reference : 786816(FS-206-DE15)
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
*
* PACS00355150           Ashokkumar.V.P                  24/02/2015           Optimized the relation between the customer
* PACS00460184           Ashokkumar.V.P                  27/05/2015            New changes for updated mapping.
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT TAM.BP I_REDO.B.MG.LNS.BY.DEBTOR.COMMON
*
    GOSUB MAIN.PROCESS

    RETURN
*
*------------
MAIN.PROCESS:
**-----------
*Selecting the AA.ARRANGEMENT application
*
    LIST.PARAMETER = ''
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*    LIST.PARAMETER<3> = "START.DATE LE ":LAST.WORK.DAY
    LIST.PARAMETER<3> := "PRODUCT.GROUP EQ ":Y.TXNPGRP.VAL.ARR
    LIST.PARAMETER<3> := " AND PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
    RETURN
END
