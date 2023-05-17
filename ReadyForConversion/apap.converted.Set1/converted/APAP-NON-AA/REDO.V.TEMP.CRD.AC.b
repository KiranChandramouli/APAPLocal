SUBROUTINE REDO.V.TEMP.CRD.AC

* Developed for : APAP
* Developed by : Edwin Charles D
* Date         : 2017/Jun/07
* Attached to : VERSION
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FT.TT.TRANSACTION


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.CR.AC = COMI
    CALL F.READ(FN.ACCOUNT,Y.CR.AC,R.ACCOUNT,F.ACCOUNT,AC.ERR)

    Y.CUR = R.ACCOUNT<AC.CURRENCY>
    R.NEW(FT.TN.CREDIT.CURRENCY) = Y.CUR

RETURN

END
