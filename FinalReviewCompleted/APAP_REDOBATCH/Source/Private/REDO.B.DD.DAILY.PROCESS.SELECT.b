* @ValidationCode : MjoxMTkyODEzODc1OkNwMTI1MjoxNjg0ODU0Mzg0ODg2OklUU1M6LTE6LTE6LTc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.DD.DAILY.PROCESS.SELECT

*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.DD.DAILY.PROCESS.SELECT
*------------------------------------------------------------------
* Description : passing ARRANGEMENT value
******************************************************************
*31-10-2011         JEEVAT             passing ARR value
*Modification
* Date                   who                   Reference              
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM 
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.W.DIRECT.DEBIT
    $INSERT I_REDO.B.DIRECT.DEBIT.COMMON


    GOSUB ACCOUNT.SELECT
RETURN
*-----------------------------------------------------
ACCOUNT.SELECT:
*-----------------------------------------------------

    SEL.LIST = R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.ARR.ID>
    CHANGE @VM TO @FM IN SEL.LIST
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
