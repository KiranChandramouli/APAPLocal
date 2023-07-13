$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.CLEAR.ECB.BALANCES.IN.LOAD

*=====================================================================
* Routine is developed for BOAB client. This routine is used to do the below
* Its used to clear all available balances of AA account
* Update AA.SCHEDULED.ACTIVITY and AA.LENDING.NEXT.ACTIVITY
* PRODUCT.LINE - LENDING - Can modify as required for other lines
* Amount will parked in the Internal account enter by bank.
*======================================================================
*======================================================================
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - VM to @VM , FM to @FM ,SM to @SM
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AC.BALANCE.TYPE
    $INSERT I_F.AA.SCHEDULED.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.BALANCES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_LAPAP.CLEAR.ECB.BALANCES.IN.COMMON


    GOSUB INITIALISE
RETURN

INITIALISE:

    UPDATE.STRING = ''

    FN.AA = "F.AA.ARRANGEMENT"
    F.AA = ""
    CALL OPF(FN.AA, F.AA)
*
    FN.AC = "F.ACCOUNT"
    F.AC = ""
    CALL OPF(FN.AC, F.AC)
*
    FN.AAH = "F.AA.ACTIVITY.HISTORY"
    F.AAH = ""
    CALL OPF(FN.AAH, F.AAH)
*
    FN.ECB = "F.EB.CONTRACT.BALANCES"
    F.ECB = ""
    CALL OPF(FN.ECB, F.ECB)
*
    FN.AAD = "F.AA.ACCOUNT.DETAILS"
    F.AAD = ""
    CALL OPF(FN.AAD, F.AAD)
*
    FN.ABD = "F.AA.BILL.DETAILS"
    F.ABD = ""
    CALL OPF(FN.ABD, F.ABD)
*
    FN.ASA = "F.AA.SCHEDULED.ACTIVITY"
    F.ASA = ""
    CALL OPF(FN.ASA, F.ASA)
*
    FN.AIA = "F.AA.INTEREST.ACCRUALS"
    F.AIA = ""
    CALL OPF(FN.AIA, F.AIA)
*
    FN.AAB = "F.AA.ACTIVITY.BALANCES"
    F.AAB = ""
    CALL OPF(FN.AAB, F.AAB)
*
    FN.AAM = "F.AA.ACCOUNT.MOVEMENT"
    F.AAM = ""
    CALL OPF(FN.AAM, F.AAM)

    FN.AAS = "F.AA.ARRANGEMENT.STATUS"
    F.AAS = ""
    CALL OPF(FN.AAS, F.AAS)

    FN.ANA = 'F.AA.LENDING.NEXT.ACTIVITY'
    F.ANA = ''
    CALL OPF(FN.ANA, F.ANA)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.ST.LAPAP.INFILEPRESTAMO = "F.LAPAP.CLEAR.ECB.WRITE"
    FV.ST.LAPAP.INFILEPRESTAMO = "";
    CALL OPF (FN.ST.LAPAP.INFILEPRESTAMO,FV.ST.LAPAP.INFILEPRESTAMO)

    GOSUB READ.FILES

RETURN

*=====================================================================

READ.FILES:
**********

    Y.PARAM.ID = "LAPAP.ECB.BALANCES"
    Y.FIELD.NME.PARAM= "";
    Y.FIELD.VAL.PARAM= "";
    Y.CUENTA.INTERNA = "";
    Y.FILE.CLEAR.BALANCE = "";
    T24.FILES = ''

    R.REDO.H.REPORTS.PARAM = '';  PARAM.ERR = '';
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)

    IF R.REDO.H.REPORTS.PARAM NE '' THEN

        Y.DIRECTORIO.ARCHIVO = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>

        Y.FIELD.NME.PARAM      = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.PARAM      = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>

        LOCATE "CUENTA.INTERNA" IN Y.FIELD.NME.PARAM<1,1> SETTING VALD.POS THEN
            Y.CUENTA.INTERNA =Y.FIELD.VAL.PARAM<1,VALD.POS>
            Y.CUENTA.INTERNA = CHANGE(Y.CUENTA.INTERNA,@SM,@VM)
        END

        LOCATE "NOMBRE.ARCHIVO" IN Y.FIELD.NME.PARAM<1,1> SETTING VALD.POS THEN
            Y.FILE.CLEAR.BALANCE = Y.FIELD.VAL.PARAM<1,VALD.POS>
            CHANGE @VM TO @FM IN Y.FILE.CLEAR.BALANCE
            CHANGE @SM TO @FM IN Y.FILE.CLEAR.BALANCE
            Y.FILE.CLEAR.BALANCE = Y.FILE.CLEAR.BALANCE<1>
        END

    END


    OPEN '',Y.DIRECTORIO.ARCHIVO TO T24.FILES ELSE
        ERR.OPEN ='EB.RTN.CANT.OPEN.T24.FILES'
    END

    READ RREC FROM T24.FILES,Y.FILE.CLEAR.BALANCE  ELSE NULL

    BL.STATUS = 'SETTLED'
    SET.STATUS = 'REPAID'
    AGE.STATUS = 'SETTLED'
    CHG.DATE = TODAY



RETURN


END
