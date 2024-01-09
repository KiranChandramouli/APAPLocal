* @ValidationCode : MjotMTk2NzA5MTA2NTpDcDEyNTI6MTcwMzU4MTE5ODI0NjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Dec 2023 14:29:58
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
SUBROUTINE REDO.B.DEAL.SLIP.QUEUE.PURGE.SELECT
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* LINKED WITH
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Sakthi Sellappillai
* PROGRAM NAME : REDO.B.DEAL.SLIP.QUEUE.PURGE.SELECT
* ODR          :
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                     REFERENCE               DESCRIPTION
*===========      =================        =================       ================
*13.12.2010       SRIRAMAN.C               CR020                   INITIAL CREATION
* Date                  who                   Reference
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion    CALL routine modified
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*    $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_F.REDO.APAP.H.DEAL.SLIP.QUEUE
    $INSERT I_F.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM
    $INSERT I_REDO.B.DEAL.SLIP.QUEUE.PURGE.COMMON
    
    $USING EB.Service ;*R22 Manual Conversion


    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------

    SEL.INPUT.CMD=" SELECT ":FN.REDO.APAP.H.DEAL.SLIP.QUEUE
    CALL EB.READLIST(SEL.INPUT.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)

    Y.PURGE.ID = SEL.LIST

*   CALL BATCH.BUILD.LIST('',Y.PURGE.ID)
    EB.Service.BatchBuildList('',Y.PURGE.ID) ;*R22 Manual Conversion

RETURN
************************************
END
*-------------------------------------*END OF SUBROUTINE*----------------------------------
