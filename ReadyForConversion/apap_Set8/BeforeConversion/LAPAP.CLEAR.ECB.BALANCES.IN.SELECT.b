*---------------------------------------------------------------------
* <Rating>0</Rating>
*---------------------------------------------------------------------

    SUBROUTINE LAPAP.CLEAR.ECB.BALANCES.IN.SELECT

*=====================================================================
* Routine is developed for BOAB client. This routine is used to do the below
* Its used to clear all available balances of AA account
* Update AA.SCHEDULED.ACTIVITY and AA.LENDING.NEXT.ACTIVITY
* PRODUCT.LINE - LENDING - Can modify as required for other lines
* Amount will parked in the Internal account enter by bank.
*======================================================================

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_F.AA.ARRANGEMENT
    $INSERT T24.BP I_F.AA.BILL.DETAILS
    $INSERT T24.BP I_F.AA.ACCOUNT.DETAILS
    $INSERT T24.BP I_F.EB.CONTRACT.BALANCES
    $INSERT T24.BP I_F.AA.OVERDUE
    $INSERT T24.BP I_F.ACCT.ACTIVITY
    $INSERT T24.BP I_F.AC.BALANCE.TYPE
    $INSERT T24.BP I_F.AA.SCHEDULED.ACTIVITY
    $INSERT T24.BP I_F.AA.ACTIVITY.BALANCES
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT LAPAP.BP I_LAPAP.CLEAR.ECB.BALANCES.IN.COMMON

    CALL EB.CLEAR.FILE(FN.ST.LAPAP.INFILEPRESTAMO, FV.ST.LAPAP.INFILEPRESTAMO)
    CALL BATCH.BUILD.LIST('',RREC)

    RETURN
