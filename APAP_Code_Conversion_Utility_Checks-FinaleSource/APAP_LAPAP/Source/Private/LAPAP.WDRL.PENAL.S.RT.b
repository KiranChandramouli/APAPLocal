$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   T24.BP,BP is Removed,CALL RTN FORMAT CAN BE MODIFIED , INSERT FILE MODIFIED
*---------------------------------------------------------------------------------------	-
SUBROUTINE LAPAP.WDRL.PENAL.S.RT(ACCOUNT.ID)
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT I_F.ACCOUNT ;*R22 MANUAL CODE CONVERSION
    $INSERT  I_F.DATES
    $INSERT  I_F.AC.CHARGE.REQUEST
    $INSERT  I_F.ST.LAPAP.DECREASE.CHG.PAR
    $INSERT I_LAPAP.WDRL.PENAL.S.RT.COMMON  ;*R22 MANUAL CODE CONVERSION

    GOSUB DO.READ.ACC
RETURN
*---------------------------------------------------------------------------------------------------
DO.READ.ACC:
    CALL OCOMO("Processing Account No. : " : ACCOUNT.ID)
    CALL F.READ(FN.AC,ACCOUNT.ID,R.AC, FV.AC, AC.ERR)
    IF R.AC THEN
        GOSUB DO.GET.CHARGE
    END
RETURN
*---------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------
DO.PROCESS:


    IF Y.MONTH EQ 1 THEN
        Y.PREV.MONTH = 12
        Y.PREV.YEAR = Y.YEAR -1
    END ELSE
        Y.PREV.MONTH = Y.MONTH -1
        Y.PREV.YEAR = Y.YEAR
    END
*------------------------------------------------
*Y.AVG.BAL.ACT Holds current month avg amount.
*Y.AVG.BAL.PRE  Holds previous month avg amount.
*------------------------------------------------
    Y.AVG.BAL.ACT = ''
    Y.AVG.BAL.PRE = ''

* CALL LAPAP.ACCT.AVG.AMT.RT(ACCOUNT.ID,Y.YEAR,Y.MONTH,Y.AVG.BAL.ACT)
    APAP.LAPAP.lapapAcctAvgAmtRt(ACCOUNT.ID,Y.YEAR,Y.MONTH,Y.AVG.BAL.ACT) ;*R22 MANUAL CODE CONVERSION

* CALL LAPAP.ACCT.AVG.AMT.RT(ACCOUNT.ID,Y.PREV.YEAR,Y.PREV.MONTH,Y.AVG.BAL.PRE)
    APAP.LAPAP.lapapAcctAvgAmtRt(ACCOUNT.ID,Y.YEAR,Y.MONTH,Y.AVG.BAL.ACT) ;*R22 MANUAL CODE CONVERSION

    IF Y.AVG.BAL.ACT NE '0.0nan' AND Y.AVG.BAL.PRE NE '0.0nan' THEN
        Y.AVG.DIFF = Y.AVG.BAL.PRE - Y.AVG.BAL.ACT
        IF Y.AVG.DIFF GT 0 THEN
            CALL OCOMO("Account: " : ACCOUNT.ID : ", applies for charge.")
            CALL OCOMO("Previous avg: ":Y.AVG.BAL.PRE:", Actual avg: " : Y.AVG.BAL.ACT)
            GOSUB DO.CHARGE.REQUEST
        END ELSE
            CALL OCOMO("Account: " : ACCOUNT.ID : ", does not applies for charge!")
        END
    END

RETURN
*---------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------
DO.GET.CHARGE:
    Y.ACC.CATEGORY = R.AC<AC.CATEGORY>
    Y.ACC.CUS = R.AC<AC.CUSTOMER>
    FIND Y.ACC.CATEGORY IN Y.PA.CATEGORY SETTING V.FLD, V.VAL THEN
        Y.CHARGE.CODE = Y.PA.CHG.CODE<1,V.VAL>
        CALL OCOMO("Processing Account No. : " : ACCOUNT.ID : ", with charge: " : Y.CHARGE.CODE)
        IF Y.CHARGE.CODE THEN
            GOSUB DO.PROCESS
        END
    END
RETURN
*---------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------
DO.CHARGE.REQUEST:
    Y.TRANS.ID = ""
    Y.APP.NAME = "AC.CHARGE.REQUEST"
    Y.VER.NAME = Y.APP.NAME :",LAPAP.WDRL.CHG"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""
    R.ACR = ""

    R.ACR<CHG.CHARGE.CODE> = Y.CHARGE.CODE
    R.ACR<CHG.CUSTOMER.NO> = Y.ACC.CUS
    R.ACR<CHG.DEBIT.ACCOUNT> = ACCOUNT.ID


    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACR,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"WDRL.CHG",'')
    CALL OCOMO("Charge request posted for account:" : ACCOUNT.ID)
RETURN
END
