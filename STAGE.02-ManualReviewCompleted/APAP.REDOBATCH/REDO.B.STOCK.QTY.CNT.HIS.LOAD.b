* @ValidationCode : MjoxNTAzNTY2NTEyOkNwMTI1MjoxNjgxMzYzNDgzNzA0OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 10:54:43
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
SUBROUTINE REDO.B.STOCK.QTY.CNT.HIS.LOAD
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This load routine initialises and opens necessary files
*  and gets the position of the local reference fields
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who             Reference            Description
* 8-MARCH-2010     S.R.SWAMINATHAN   ODR-2010-03-0400      Initial Creation
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - NO CHAMNGES
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.STOCK.QTY.CNT.HIS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_GTS.COMMON
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.REDO.STOCK.QTY.COUNT

    GOSUB INIT
    GOSUB OPEN.FILE

RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------

    FN.STOCK.REGISTER = 'F.STOCK.REGISTER'
    F.STOCK.REGISTER = ''

    FN.REDO.STOCK.QTY.COUNT = 'F.REDO.STOCK.QTY.COUNT'
    F.REDO.STOCK.QTY.COUNT = ''
    R.REDO.STOCK.QTY.COUNT = ''

    FN.REDO.STOCK.QTY.COUNT.HIS = 'F.REDO.STOCK.QTY.COUNT$HIS'
    F.REDO.STOCK.QTY.COUNT.HIS = ''
    R.REDO.STOCK.QTY.COUNT.HIS = ''

    FN.DATES = 'F.DATES'
    F.DATES = ''

RETURN
*---------
OPEN.FILE:
*---------
*---------------------------------------
* This section opens the necessary files
*---------------------------------------

    CALL OPF(FN.REDO.STOCK.QTY.COUNT,F.REDO.STOCK.QTY.COUNT)
    CALL OPF(FN.STOCK.REGISTER,F.STOCK.REGISTER)
    CALL OPF(FN.DATES,F.DATES)

RETURN

END
