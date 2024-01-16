* @ValidationCode : MjotMTQwNDY5Mjg0MTpDcDEyNTI6MTcwNTA1MzIzMzA0ODphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2024 15:23:53
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
* @(#) REDO.B.CUS.TAX.RETENTIONS.SELECT Ported to jBASE 16:17:06  28 NOV 2017
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CUS.TAX.RETENTIONS.SELECT
*---------------------------------------------------------------------------------------------
*
* Description           : This is the Routine used to select the REDO.NCF.ISSUED Application with Based on the Date Value.

* Developed By          : Amaravathi Krithika B
*
* Development Reference : RegN11
*
* Attached To           : Batch - BNK/REDO.B.CUS.TAX.RETENTIONS
*
* Attached As           : Online Batch Routine to COB
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*---------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*-----------------------------------------------------------------------------------------------------------------
* PACS00375393           Ashokkumar.V.P                 11/12/2014            New mapping changes - Rewritten the whole source.
* APAP-132               Ashokkumar.V.P                 03/02/2016            Spliting the file based on customer identification.
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
   * $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_ENQUIRY.COMMON ;* R22 Auto conversion
    $INSERT I_F.STMT.ENTRY ;* R22 Auto conversion
    $INSERT I_REDO.B.CUS.TAX.RETENTIONS.COMMON ;* R22 Auto conversion
   $USING EB.Service
*

    GOSUB SELECT.PROCESS
RETURN
*
SELECT.PROCESS:
*--------------
*    CALL EB.CLEAR.FILE(FN.DR.REG.REGN11.WORKFILE, F.DR.REG.REGN11.WORKFILE)
EB.Service.ClearFile(FN.DR.REG.REGN11.WORKFILE, F.DR.REG.REGN11.WORKFILE);* R22 UTILITY AUTO CONVERSION
    YGP.STMT.ID.LIST = ''
    D.FIELDS = "ACCOUNT":@FM:"BOOKING.DATE"
    D.LOGICAL.OPERANDS = "1":@FM:"2"
    D.RANGE.AND.VALUE = YTAX.ACCT:@FM:Y.DATE.FROM:@SM:Y.DATE.TO
    CALL E.STMT.ENQ.BY.CONCAT(YGP.STMT.ID.LIST)
*    CALL BATCH.BUILD.LIST('',YGP.STMT.ID.LIST)
EB.Service.BatchBuildList('',YGP.STMT.ID.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
*---------------------------------------------------------------------------------------------
END
*---------------------------------------------------------------------------------------------
*
