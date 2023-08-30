* @ValidationCode : MjoxMDExMDY1MzY3OkNwMTI1MjoxNjgxNzA3MzI3MzE0OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 10:25:27
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
SUBROUTINE REDO.B.UPDATE.DESTRUCTION.LOAD
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
* 29-JULY-2010     S.R.SWAMINATHAN   ODR-2010-03-0400      Initial Creation
* Date                   who                   Reference              
* 17-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - VM TO @VM 
* 17-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.UPDATE.DESTRUCTION.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.DES.HIS
    $INSERT I_F.REDO.CARD.REORDER.DEST
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES

    GOSUB INIT
    GOSUB GET.LR.FLD.POS
    GOSUB OPEN.FILE

RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------

    FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST = ''

    FN.REDO.CARD.DES.HIS = 'F.REDO.CARD.DES.HIS'
    F.REDO.CARD.DES.HIS = ''

    FN.REDO.CARD.REORDER.DEST = 'F.REDO.CARD.REORDER.DEST'
    F.REDO.CARD.REORDER.DEST = ''

    FN.STOCK.ENTRY = 'F.STOCK.ENTRY'
    F.STOCK.ENTRY = ''

RETURN

*--------------
GET.LR.FLD.POS:
*--------------
*-------------------------------------------------------------
* This section gets the position of the local reference fields
*-------------------------------------------------------------

    Y.LRF.APPL = "STOCK.ENTRY"
    Y.LRF.FIELDS = 'L.SE.BATCH.NO':@VM:'L.SE.CARD.TYPE'
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(Y.LRF.APPL,Y.LRF.FIELDS,FIELD.POS)

    Y.BATCH.NO.POS = FIELD.POS<1,1>
    Y.CARD.TYPE.POS = FIELD.POS<1,2>

    Y.COMPANY = ID.COMPANY
    Y.LAST.WORKING.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.CARD.COMPANY = "CARD.":Y.COMPANY

RETURN

*---------
OPEN.FILE:
*---------
*---------------------------------------
* This section opens the necessary files
*---------------------------------------

    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)
    CALL OPF(FN.REDO.CARD.DES.HIS,F.REDO.CARD.DES.HIS)
    CALL OPF(FN.REDO.CARD.REORDER.DEST,F.REDO.CARD.REORDER.DEST)
    CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)

RETURN

END
