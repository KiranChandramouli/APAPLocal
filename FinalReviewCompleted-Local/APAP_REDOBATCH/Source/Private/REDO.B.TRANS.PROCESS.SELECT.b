* @ValidationCode : MjotMTIyMjM1ODU0NzpDcDEyNTI6MTY4NDg1NDM5OTUzNTpJVFNTOi0xOi0xOi04OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.TRANS.PROCESS.SELECT
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned application
*------------------------------------------------------------------------------------------
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* PROGRAM NAME : REDO.B.TRANS.PROCESS.SELECT
* ODR          : ODR-2010-08-0031
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                     REFERENCE               DESCRIPTION
*===========      =================        =================       ================
*07.10.2010       Sakthi Sellappillai      ODR-2010-09-0171        INITIAL CREATION
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.TRANS.PROCESS.COMMON
    $INSERT I_F.REDO.SUPPLIER.PAYMENT
    $INSERT I_F.REDO.FILE.DATE.PROCESS
    $INSERT I_F.REDO.SUPPLIER.PAY.DATE
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------
    Y.THIRD.DAY.VAL = TODAY
    SEL.CMD   = "SELECT " :FN.REDO.FILE.DATE.PROCESS: " WITH @ID LIKE " :" ...":Y.THIRD.DAY.VAL:" AND (OFS.PROCESS EQ 'SUCCESS' OR OFS.PROCESS EQ 'FAILURE')"
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
END
*-------------------------------------*END OF SUBROUTINE*----------------------------------
