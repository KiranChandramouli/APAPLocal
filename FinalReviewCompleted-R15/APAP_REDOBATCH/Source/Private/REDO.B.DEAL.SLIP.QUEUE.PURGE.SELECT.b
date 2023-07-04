* @ValidationCode : MjoxNDczNTQ1OTEwOkNwMTI1MjoxNjg0ODU0Mzg1MDYxOklUU1M6LTE6LTE6LTk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -9
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.APAP.H.DEAL.SLIP.QUEUE
    $INSERT I_F.REDO.APAP.H.DEAL.SLIP.QUEUE.PARAM
    $INSERT I_REDO.B.DEAL.SLIP.QUEUE.PURGE.COMMON


    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------

    SEL.INPUT.CMD=" SELECT ":FN.REDO.APAP.H.DEAL.SLIP.QUEUE
    CALL EB.READLIST(SEL.INPUT.CMD,SEL.LIST,'',NO.OF.RECS,REC.ERR)

    Y.PURGE.ID = SEL.LIST

    CALL BATCH.BUILD.LIST('',Y.PURGE.ID)

RETURN
************************************
END
*-------------------------------------*END OF SUBROUTINE*----------------------------------
