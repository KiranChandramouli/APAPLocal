* @ValidationCode : MjotMTMwMTMyNTQxMjpDcDEyNTI6MTcwMzU4Mjk5Nzg5NDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Dec 2023 14:59:57
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
SUBROUTINE REDO.B.DIRECT.DEBIT.SELECT

*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.DIRECT.DEBIT.SELECT
*------------------------------------------------------------------
* Description : This is the update rotuine which will select all the customer
* accounts for processing
******************************************************************
*31-10-2011         JEEVAT             EB.LOOKUP select has been removed
* Date                   who                   Reference
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion    CALL routine modified
*------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.W.DIRECT.DEBIT
    $INSERT I_REDO.B.DIRECT.DEBIT.COMMON
   
    $USING EB.Service ;*R22 Manual Conversion

    GOSUB ACCOUNT.SELECT
RETURN
*-----------------------------------------------------
ACCOUNT.SELECT:
*-----------------------------------------------------

    SEL.LIST = R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.ARR.ID>
    CHANGE @VM TO @FM IN SEL.LIST
*    CALL BATCH.BUILD.LIST('',SEL.LIST)
    EB.Service.BatchBuildList('',SEL.LIST) ;*R22 Manual Conversion

RETURN
END
