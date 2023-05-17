SUBROUTINE REDO.V.VAL.CRD.AC

* Developed for : APAP
* Developed by : Marimuthu S
* Date         : 2012/Jul/13
* Attached to : VERSION
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.CR.AC = COMI
    CALL F.READ(FN.ACCOUNT,Y.CR.AC,R.ACCOUNT,F.ACCOUNT,AC.ERR)

    Y.CUR = R.ACCOUNT<AC.CURRENCY>
    R.NEW(FT.CREDIT.CURRENCY) = Y.CUR

RETURN

END
