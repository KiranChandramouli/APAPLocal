* @ValidationCode : Mjo5NjAyOTkwNTk6Q3AxMjUyOjE2ODEzNTgxNDQ1NDI6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 09:25:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REP.RATES.AND.FEES.SELECT
*---------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about files

* Developed By          : Thilak Kumar K
*
* Development Reference : TC01
*
* Attached To           : Batch - BNK/REDO.B.REP.RATES.AND.FEES
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
* NA                      Thenmalar T                     19-Feb-2014          Modified as per the selection
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.REP.RATES.AND.FEES.COMMON
*
    GOSUB CONTROL.LIST
*
RETURN
*---------------------------------------------------------------------------------------------
*
CONTROL.LIST:
*------------

    SEL.CMD = "SELECT ":FN.REDO.L.ALL.FT.TT.FX.IDS:" WITH DATE GE ":Y.ONE.MONTH.PREV.DATE:" AND WITH DATE LE ":Y.LAST.WORK.DAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,RET.CODE)

    GOSUB BATCH.BUILD.LIST
*
RETURN
*---------------------------------------------------------------------------------------------
*
BATCH.BUILD.LIST:
*----------------
    CALL BATCH.BUILD.LIST('',SEL.LIST)
*
RETURN
*---------------------------------------------------------------------------------------------
END
