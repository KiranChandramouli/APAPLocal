$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.BALANCE.SIMULATION
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND I TO I.VAR
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
* <region name= Inserts>
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
    OUT.RECORD = '' ; Y.AA.ARR.ID = COMI;  L.APA.CUENTA = ""
    Y.MONTO.EB = 0
    GOSUB AA.AA.ARRANGEMENT.GET.ACCOUNT
    GOSUB GET.BALANCE.EN.EB
RETURN
**----------------------------
AA.AA.ARRANGEMENT.GET.ACCOUNT:
**----------------------------
    FN.AA = "F.AA.ARRANGEMENT"
    FV.AA = ""
    CALL OPF (FN.AA, FV.AA)
    AA.ERROR = ''
    R.AA = ''
    CALL F.READ(FN.AA,Y.AA.ARR.ID,R.AA,FV.AA, AA.ERROR)
    L.APA.CUENTA = R.AA<AA.ARR.LINKED.APPL.ID>
RETURN
**----------------
GET.BALANCE.EN.EB:
**----------------
    FN.CB = "F.EB.CONTRACT.BALANCES"
    FV.CB = ""; CB.ERROR = ''; R.CB = '';Y.MONTO.EB = 0
    Y.CREDIT.AMT = 0; Y.DEBIT.AMT = 0; Y.SUMA.AMT = 0; Y.TOTAL.AMT = 0
    Y.CAPITAL.PENDIENTE = 0
    CALL OPF (FN.CB, FV.CB)
    CALL F.READ(FN.CB, L.APA.CUENTA, R.CB, FV.CB, CB.ERROR)
    Y.TYPE.CB =  R.CB<ECB.TYPE.SYSDATE>
    Y.CNT = DCOUNT(Y.TYPE.CB,@VM)
    Y.CB.ACCOUN.TYPE = ""
    FOR I.VAR = 1 TO Y.CNT
        Y.CB.ACCOUN.TYPE = R.CB<ECB.TYPE.SYSDATE,I.VAR>
        FINDSTR "ACCOUNT" IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
            FINDSTR "UNCACCOUNT" IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
                CONTINUE
            END
            Y.TO.OPEN = R.CB<ECB.OPEN.BALANCE,I.VAR,1>
            Y.CREDIT.AMT = R.CB<ECB.CREDIT.MVMT,I.VAR,1>
            Y.DEBIT.AMT = R.CB<ECB.DEBIT.MVMT,I.VAR,1>
            Y.SUMA.AMT = Y.TO.OPEN + Y.CREDIT.AMT + Y.DEBIT.AMT
            Y.TOTAL.AMT += Y.SUMA.AMT
            Y.MONTO.EB = Y.TOTAL.AMT
        END
    NEXT I.VAR
    COMI = ABS(Y.MONTO.EB)
RETURN
END
