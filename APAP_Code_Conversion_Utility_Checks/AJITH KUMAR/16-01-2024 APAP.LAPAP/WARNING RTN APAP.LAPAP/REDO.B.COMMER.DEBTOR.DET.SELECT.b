* @ValidationCode : MjozOTY0Mjg3NjI6Q3AxMjUyOjE3MDUwNTIxOTU1Mzc6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jan 2024 15:06:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
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
  *  $INSERT  I_BATCH.FILES
    $INSERT  I_REDO.B.COMMER.DEBTOR.DET.COMMON
    $INSERT  I_DR.REG.COMM.LOAN.SECTOR.COMMON
   $USING EB.Service

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
*    CALL EB.CLEAR.FILE(FN.DR.REG.DE08DT.WORKFILE,F.DR.REG.DE08DT.WORKFILE)
EB.Service.ClearFile(FN.DR.REG.DE08DT.WORKFILE,F.DR.REG.DE08DT.WORKFILE);* R22 UTILITY AUTO CONVERSION
    LIST.PARAMETER = ""
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
    LIST.PARAMETER<3> := "PRODUCT.LINE EQ ":"LENDING"
*    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")
EB.Service.BatchBuildList(LIST.PARAMETER, "");* R22 UTILITY AUTO CONVERSION
RETURN
*-----------------------------------------------------------------------------
END
