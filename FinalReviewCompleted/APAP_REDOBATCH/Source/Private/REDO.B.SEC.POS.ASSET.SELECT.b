* @ValidationCode : MjotMTAwNjk3MjMxNjpDcDEyNTI6MTY4NDg1NDM5ODI4NjpJVFNTOi0xOi0xOi0xOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.SEC.POS.ASSET.SELECT
* -------------------------------------------------------------------------------------------------
* Description           : This is the Batch Select Routine used to select the records based on the
*                         conditions and pass the selected record array to main routine
* Developed By          : Vijayarani G
* Development Reference : 786942(FS-219-OA01)
* Attached To           : NA
* Attached As           : NA
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA

*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM 
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------------------
* Include files
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.SEC.POS.ASSET.COMMON
    $INSERT I_BATCH.FILES


    IF CONTROL.LIST EQ "" THEN
        CONTROL.LIST = "MM.MONEY.MARKET":@FM:"SECURITY.POSITION"
    END
    IF CONTROL.LIST<1> EQ "MM.MONEY.MARKET" THEN
        SEL.CMD = "SELECT ":FN.MM:" WITH STATUS EQ 'CUR'"
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
        CALL BATCH.BUILD.LIST('',SEL.LIST)
    END
    IF CONTROL.LIST<1> EQ "SECURITY.POSITION" THEN
        SEL.CMD1 = "SELECT ":FN.SEC.POS:" WITH CLOSING.BAL.NO.NOM GT '0'"
        CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NO.OF.REC,SEL.ERR)
        CALL BATCH.BUILD.LIST('',SEL.LIST1)
    END
*
RETURN
END
