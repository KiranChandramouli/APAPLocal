**==================================================================================================================================
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.RAISE.ENTRY.IN.LOAD
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


    GOSUB INITIALISE
    GOSUB OPENFILES

    RETURN

INITIALISE:
*==========
    RETURN
OPENFILES:
*=========

    FN.SAVEDLISTS = '&SAVEDLISTS&'
    F.SAVEDLISTS = ''
    CALL OPF(FN.SAVEDLISTS,F.SAVEDLISTS)

    FN.AA.ARR = 'F.AA.ARRANGEMENT'
    F.AA.ARR = ''
    CALL OPF(FN.AA.ARR,F.AA.ARR)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.CLOSURE = 'F.ACCOUNT.CLOSURE'
    F.ACCOUNT.CLOSURE = ''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.AC='F.ACCOUNT'
    F.AC=''
    CALL OPF(FN.AC,F.AC)

    FN.AC.HIS='F.ACCOUNT$HIS'
    F.AC.HIS=''
    CALL OPF(FN.AC.HIS,F.AC.HIS)

    FN.AC.ACT = 'F.ACCOUNT.ACT'
    FV.AC.ACT = ''
    CALL OPF(FN.AC.ACT, FV.AC.ACT)

    FN.AC.ENT.TODAY = 'F.ACCT.ENT.TODAY'
    FV.AC.ENT.TODAY = ''
    CALL OPF(FN.AC.ENT.TODAY, FV.AC.ENT.TODAY)

    AA.SEP = '#'
    FN.COMO='&COMO&'
    F.COMO=''
    CALL OPF(FN.COMO,F.COMO)

    FN.SL='&SAVEDLISTS&'
    F.SL=''
    CALL OPF(FN.SL,F.SL)

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FAILED = ''; PROCESSED = ''

    LIST.NAME = "AA.ADJ.CLEAR.BAL"

    RETURN

END
