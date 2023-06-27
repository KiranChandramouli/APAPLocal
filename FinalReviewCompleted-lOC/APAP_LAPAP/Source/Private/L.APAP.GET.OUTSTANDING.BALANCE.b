$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.OUTSTANDING.BALANCE (ACCOUNT, OUTSTANDING.BALANCE)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - I to I.VAR , ++ to +=1 and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.CONTRACT.BALANCES

    Y.TOTAL.CAPITAL = 0

    IF ACCOUNT NE '' THEN
        GOSUB INIT
        GOSUB GET.BALANCE.EN.EB
    END

RETURN

*----------
INIT:
*----------
    FN.CB = "F.EB.CONTRACT.BALANCES"
    FV.CB = ""
    CB.ERROR = ''
    R.CB = ''
    CALL OPF (FN.CB, FV.CB)

RETURN

*-----------------------
GET.BALANCE.EN.EB:
*----------------------
    CALL F.READ(FN.CB, ACCOUNT, R.CB, FV.CB, CB.ERROR)
    Y.TYPE.CB =  R.CB<ECB.TYPE.SYSDATE>

    Y.CNT = DCOUNT(Y.TYPE.CB,@VM)
    Y.CB.ACCOUN.TYPE = ""

    FOR I.VAR = 1 TO Y.CNT

        Y.CB.ACCOUN.TYPE = R.CB<ECB.TYPE.SYSDATE,I.VAR>

        FINDSTR "ACCOUNT" IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN

            FINDSTR "UNCACCOUNT" IN Y.CB.ACCOUN.TYPE SETTING Ap, Vp THEN
*-- LOS SALDOS UNCACCOUNT NO APLICAN
            END ELSE
                Y.TO.OPEN = R.CB<ECB.OPEN.BALANCE,I.VAR,1>
                Y.CREDIT.AMT = R.CB<ECB.CREDIT.MVMT,I.VAR,1>
                Y.DEBIT.AMT = R.CB<ECB.DEBIT.MVMT,I.VAR,1>
                Y.SUMA.AMT = Y.TO.OPEN + Y.CREDIT.AMT + Y.DEBIT.AMT
                Y.TOTAL.AMT += Y.SUMA.AMT
                Y.TOTAL.CAPITAL = Y.TOTAL.AMT
            END

        END

    NEXT I.VAR

    OUTSTANDING.BALANCE = Y.TOTAL.CAPITAL

RETURN

END
