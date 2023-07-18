**==================================================================================================================================
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.RAISE.ENTRY.IN.SELECT
**==================================================================================================================================
* Reads the details from savedlists and raise entry by calling EB.ACCOUNTING
* We will multiply with -1 in the amount provided in the SL. So you have to give the actual available amount. We will pass the opposite entry for that
* Please make sure - AC.BALANCE.TYPE refered correctly and raising ENTRY

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_F.AA.ARRANGEMENT
    $INSERT T24.BP I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT T24.BP I_F.EB.CONTRACT.BALANCES
    $INSERT T24.BP I_F.COMPANY
    $INSERT T24.BP I_F.STMT.ENTRY
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.AC.BALANCE.TYPE
    $INSERT LAPAP.BP I_LAPAP.RAISE.ENTRY.IN.COMMON

    CALL F.READ(FN.SAVEDLISTS,LIST.NAME,ARR.IDS,F.SAVEDLISTS,RET.ERR)
    TEMP.REC = ARR.IDS
    CALL BATCH.BUILD.LIST('',TEMP.REC)

    RETURN

END
