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

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INCLUDE LAPAP.BP I_REDO.B.COMMER.DEBTOR.DET.COMMON
    $INCLUDE LAPAP.BP I_DR.REG.COMM.LOAN.SECTOR.COMMON

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
