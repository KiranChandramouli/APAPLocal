$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.RETURN.BANLACE.CANCELACION(AA.ID,OUT.RECORD)
* Input Parameter:
* ---------------*
* Argument#1 : AA.ID
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : OUT.RECORD

* <region name= Inserts>
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - I to I.VAR and T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.EB.CONTRACT.BALANCES
* </region>
*-----------------------------------------------------------------------------
    GOSUB MAIN.PROCESS
*
RETURN
*
*------------
MAIN.PROCESS:
*------------
*
    OUT.RECORD = ''
    Y.AA.ARR.ID = AA.ID
    L.APA.CUENTA = ""
    Y.MONTO.EB = 0
    Y.MONTO.ACCRUAL = 0
    Y.CAPITAL.PENDIENTE = 0
    GOSUB AA.AA.ARRANGEMENT.GET.ACCOUNT
    GOSUB GET.BALANCE.EN.EB
    GOSUB AA.INTEREST.ACCRUALS.READ
    GOSUB FORM.ARRAY
RETURN
*-------------------
AA.AA.ARRANGEMENT.GET.ACCOUNT:
**------------------
    FN.AA = "F.AA.ARRANGEMENT"
    FV.AA = ""
    CALL OPF (FN.AA, FV.AA)
    AA.ERROR = ''
    R.AA = ''
    CALL F.READ(FN.AA,Y.AA.ARR.ID,R.AA,FV.AA, AA.ERROR)
    L.APA.CUENTA = R.AA<AA.ARR.LINKED.APPL.ID>
RETURN
*-----------------------
GET.BALANCE.EN.EB:
*----------------------
    FN.CB = "F.EB.CONTRACT.BALANCES"
    FV.CB = ""
    CB.ERROR = ''
    R.CB = ''
    Y.CREDIT.AMT = 0
    Y.DEBIT.AMT = 0
    Y.SUMA.AMT = 0
    Y.TOTAL.AMT = 0
    YPR.MONTO.EB = 0; YPR.TO.OPEN = 0; YPR.CREDIT.AMT = 0
    YPR.DEBIT.AMT = 0; YPR.SUMA.AMT = 0; YPR.TOTAL.AMT = 0; YPR.MONTO.EB = 0
    CALL OPF (FN.CB, FV.CB)
    CALL F.READ(FN.CB, L.APA.CUENTA, R.CB, FV.CB, CB.ERROR)
    Y.TYPE.CB =  R.CB<ECB.TYPE.SYSDATE>

    Y.CNT = DCOUNT(Y.TYPE.CB,@VM)
    Y.CB.ACCOUN.TYPE = ""
    FOR I.VAR = 1 TO Y.CNT
        Y.CB.ACCOUN.TYPE = R.CB<ECB.TYPE.SYSDATE,I.VAR>
        FINDSTR "ACCOUNT" IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN

            Y.TO.OPEN = R.CB<ECB.OPEN.BALANCE,I.VAR,1>
            Y.CREDIT.AMT = R.CB<ECB.CREDIT.MVMT,I.VAR,1>
            Y.DEBIT.AMT = R.CB<ECB.DEBIT.MVMT,I.VAR,1>
            Y.SUMA.AMT = Y.TO.OPEN + Y.CREDIT.AMT + Y.DEBIT.AMT
            Y.TOTAL.AMT += Y.SUMA.AMT
            Y.MONTO.EB = Y.TOTAL.AMT
        END

        FINDSTR "PRINCIPALINT" IN Y.CB.ACCOUN.TYPE SETTING App, Vpp THEN
            YPR.TO.OPEN = R.CB<ECB.OPEN.BALANCE,I.VAR,1>
            YPR.CREDIT.AMT = R.CB<ECB.CREDIT.MVMT,I.VAR,1>
            YPR.DEBIT.AMT = R.CB<ECB.DEBIT.MVMT,I.VAR,1>
            YPR.SUMA.AMT = YPR.TO.OPEN + YPR.CREDIT.AMT + YPR.DEBIT.AMT
            YPR.TOTAL.AMT += YPR.SUMA.AMT
            YPR.MONTO.EB = YPR.TOTAL.AMT
        END

    NEXT I.VAR

RETURN
*-------------------------
AA.INTEREST.ACCRUALS.READ:
**------------------------
    FN.ACU = "F.AA.INTEREST.ACCRUALS"
    FV.ACU = ""
    FN.ERROR = ""
    R.ACU = ""
    Y.VALUE = "-PRINCIPALINT"
    Y.AA.ARR.IDS = Y.AA.ARR.ID :"-PRINCIPALINT"
    CALL OPF(FN.ACU,FV.ACU)
    CALL F.READ(FN.ACU, Y.AA.ARR.IDS, R.ACU, FV.ACU, FN.ERROR)
    Y.MONTO.ACCRUAL = R.ACU<AA.INT.ACC.ACCRUAL.AMT,1,1>
    IF NOT(Y.MONTO.ACCRUAL) THEN
        Y.MONTO.ACCRUAL = 0
    END
    IF NOT(Y.MONTO.EB) THEN
        Y.MONTO.EB = 0
        Y.MONTO.ACCRUAL = 0
    END
    Y.CAPITAL.PENDIENTE = Y.MONTO.ACCRUAL + Y.MONTO.EB
RETURN

FORM.ARRAY:
*---------
    OUT.RECORD = Y.CAPITAL.PENDIENTE:"*":Y.MONTO.EB:"*":Y.MONTO.ACCRUAL:"*":YPR.MONTO.EB
RETURN
END
