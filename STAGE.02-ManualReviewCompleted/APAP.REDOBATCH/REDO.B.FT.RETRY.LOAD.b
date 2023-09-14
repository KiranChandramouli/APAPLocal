* @ValidationCode : Mjo0NjI4NjI1ODpDcDEyNTI6MTY4MTE5MjExMzk4NjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:18:33
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
SUBROUTINE REDO.B.FT.RETRY.LOAD
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the load routine of the batch job REDO.B.FT.RETRY.LOAD
*  which updates the local table REDO.STO.PENDING.RESUBMISSION
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
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - VM TO @VM AND FM TO @FM 
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES

*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.FT.RETRY.COMMON

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB GET.LRF.POS
    GOSUB GET.STO.ID.LST
RETURN

*----
INIT:
*----
*---------------------------------------------
* This section initialises necessary variables
*---------------------------------------------

    APP.NAME = 'FUNDS.TRANSFER'
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'FUNDS.TRANSFER,AA.LS.LC.ACRP'
    OFS.SOURCE.ID = 'REDO.OFS.STATUS.COND'
RETURN

*----------
OPEN.FILES:
*----------
*---------------------------------------
* This section opens the necessary files
*---------------------------------------

    FN.REDO.RESUBMIT.FT.DET = 'F.REDO.RESUBMIT.FT.DET'
    F.REDO.RESUBMIT.FT.DET = ''
    CALL OPF(FN.REDO.RESUBMIT.FT.DET,F.REDO.RESUBMIT.FT.DET)

    FN.REDO.STO.PENDING.RESUBMISSION = 'F.REDO.STO.PENDING.RESUBMISSION'
    F.REDO.STO.PENDING.RESUBMISSION = ''
    CALL OPF(FN.REDO.STO.PENDING.RESUBMISSION,F.REDO.STO.PENDING.RESUBMISSION)

    FN.STANDING.ORDER = 'F.STANDING.ORDER'
    F.STANDING.ORDER = ''
    CALL OPF(FN.STANDING.ORDER,F.STANDING.ORDER)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CHEQUE.COLLECTION = 'F.CHEQUE.COLLECTION'
    F.CHEQUE.COLLECTION = ''
    CALL OPF(FN.CHEQUE.COLLECTION,F.CHEQUE.COLLECTION)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

RETURN

*-----------
GET.LRF.POS:
*-----------
*----------------------------------------------------------------------
* This section gets the position of the local reference field positions
*----------------------------------------------------------------------

    LR.APP = 'AA.PRD.DES.OVERDUE':@FM:'ACCOUNT':@FM:'STANDING.ORDER':@FM:'FUNDS.TRANSFER'
    LR.FLDS = 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@FM
    LR.FLDS := 'L.AC.STATUS2':@FM
    LR.FLDS := 'L.LOAN.ARR.ID':@FM
    LR.FLDS := 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND'
    LR.POS = ''
    CALL MULTI.GET.LOC.REF(LR.APP,LR.FLDS,LR.POS)

    OD.LOAN.STATUS.POS = LR.POS<1,1>
    OD.LOAN.COND.POS =  LR.POS<1,2>
    POS.STATUS.2 = LR.POS<2,1>
    STO.ARR.ID.POS = LR.POS<3,1>
    FT.LOAN.STATUS.POS = LR.POS<4,1>
    FT.LOAN.COND.POS = LR.POS<4,2>
RETURN

*--------------
GET.STO.ID.LST:
*--------------

    FILE.NAME = FN.STANDING.ORDER
    FILE.DET = ''
    CALL GIT(FILE.NAME,FILE.DET,STO.ID.LST)

    FILE.NAME = FN.CHEQUE.COLLECTION
    FILE.DET = ''
    CALL GIT(FILE.NAME,FILE.DET,CHQ.COL.LST)

RETURN
END
