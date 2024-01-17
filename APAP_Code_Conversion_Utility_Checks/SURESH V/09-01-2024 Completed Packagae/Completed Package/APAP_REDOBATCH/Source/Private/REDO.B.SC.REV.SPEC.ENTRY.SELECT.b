* @ValidationCode : MjotMTM3NzUyMzAxNTpDcDEyNTI6MTcwNDQzOTM3MDk0OTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2024 12:52:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.SC.REV.SPEC.ENTRY.SELECT
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This BATCH routine will look for Spec entries that raised on the bussiness day from RE.SPEC.ENT.TODAY to reverse and re-calculate interest accrual based on
*               effective interest rate method and raise accounting entries
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Pradeep S
* PROGRAM NAME : REDO.B.SC.REV.SPEC.ENTRY.SELECT
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference           Description
* 06 Jul 2011      Pradeep S          PACS00080124        Initial creation
* 20-Feb-2013      Arundev            RTC-553577          CR008 Effective Discount and Interest Accrual
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SC.TRADING.POSITION
    $INSERT I_REDO.B.SC.REV.SPEC.ENTRY.COMMON
    $USING EB.Service

*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*SEL.CMD = 'SELECT ':FN.SPEC.TODAY:' WITH @ID LIKE SC...'
    SEL.CMD = 'SELECT ':FN.SC.TRADING.POSITION
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
*    CALL BATCH.BUILD.LIST('', SEL.LIST)
    EB.Service.BatchBuildList('', SEL.LIST);* R22 UTILITY AUTO CONVERSION

RETURN
END
