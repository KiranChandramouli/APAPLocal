* @ValidationCode : MjotNzEzOTY1NjQ2OkNwMTI1MjoxNjgxMjc4MzE1OTEzOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 11:15:15
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
SUBROUTINE REDO.B.MOVE.UNUSED.LOAD
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    :
*--------------------------------------------------------------------------------------------------------
*Description       :               This load routine initialises and opens necessary files
*                   and gets the position of the local reference fields
*In Parameter      :
*Out Parameter     :
*Files  Used       : As             I/O          Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  02/08/2010       REKHA S            ODR-2010-03-0400 B.166      Initial Creation
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES

*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MOVE.UNUSED.COMMON

    GOSUB INIT
RETURN

*****
INIT:
*****

    FN.REDO.CARD.NO.LOCK = 'F.REDO.CARD.NO.LOCK'
    F.REDO.CARD.NO.LOCK =''
    CALL OPF(FN.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK)

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

    FN.REDO.CARD.NO.LOCK = 'F.REDO.CARD.NO.LOCK'
    F.REDO.CARD.NO.LOCK = ''
    CALL OPF(FN.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK)

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)
RETURN
END
