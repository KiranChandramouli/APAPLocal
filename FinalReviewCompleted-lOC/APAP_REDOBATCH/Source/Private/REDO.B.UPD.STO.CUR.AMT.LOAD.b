* @ValidationCode : MjoxNjc0Mjk2NzAzOkNwMTI1MjoxNjg0ODU0NDAwNTA1OklUU1M6LTE6LTE6ODA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 80
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPD.STO.CUR.AMT.LOAD
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the load routine of the batch job REDO.B.UPD.STO.CUR.AMT
*  which updates the CURRENT.AMOUNT.BAL, L.LOAN.STATUS.1 & L.LOAN.COND
* This routine Opens the necessary files and gets the position for the local reference fields
* ------------------------------------------------------------------------------------------------
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
*   Date               who              Reference                   Description
* 03-JUN-2010   N.Satheesh Kumar    TAM-ODR-2009-10-0331          Initial Creation
* Date                   who                   Reference              
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM 
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_REDO.B.UPD.STO.CUR.AMT.COMMON

    GOSUB OPEN.FILES
    GOSUB GET.LRF.POS
RETURN

*----------
OPEN.FILES:
*----------
*---------------------------------------
* This section opens the necessary files
*---------------------------------------

    FN.STANDING.ORDER = 'F.STANDING.ORDER'
    F.STANDING.ORDER = ''
    CALL OPF(FN.STANDING.ORDER,F.STANDING.ORDER)

RETURN

*-----------
GET.LRF.POS:
*-----------
*----------------------------------------------------------------------
* This section gets the position of the local reference field positions
*----------------------------------------------------------------------

    LR.APP = 'STANDING.ORDER':@FM:'AA.PRD.DES.OVERDUE'
    LR.FLDS = 'L.LOAN.ARR.ID':@VM:'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@FM
    LR.FLDS := 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND'
    LR.POS = ''
    CALL MULTI.GET.LOC.REF(LR.APP,LR.FLDS,LR.POS)

    STO.ARR.ID.POS = LR.POS<1,1>
    STO.LOAN.STATUS.POS = LR.POS<1,2>
    STO.LOAN.COND.POS =  LR.POS<1,3>
    OD.LOAN.STATUS.POS = LR.POS<2,1>
    OD.LOAN.COND.POS =  LR.POS<2,2>

RETURN

END
