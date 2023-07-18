$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.COMMER.DEBTOR.DET.SELECT
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the AA.ARRANGEMENT application where the AA.GROUP.PRODUCT = COMERCIAL
* and the AA.STATUS is equal to  ("CURRENT" or "EXPIRED")
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description.
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-07-2023       Conversion Tool        R22 Auto Code conversion         $INCLUDE TO $INSERT
*13-07-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------

    $INSERT  I_COMMON
    $INSERT I_EQUATE
    $INSERT  I_BATCH.FILES
    $INSERT  I_REDO.B.COMMER.DEBTOR.DET.COMMON
    $INSERT  I_DR.REG.COMM.LOAN.SECTOR.COMMON

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
    CALL EB.CLEAR.FILE(FN.DR.REG.DE08DT.WORKFILE,F.DR.REG.DE08DT.WORKFILE)
    LIST.PARAMETER = ""
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
    LIST.PARAMETER<3> := "PRODUCT.LINE EQ ":"LENDING"
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
RETURN
*-----------------------------------------------------------------------------
END
