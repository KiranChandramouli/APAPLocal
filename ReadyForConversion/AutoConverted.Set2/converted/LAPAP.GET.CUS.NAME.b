SUBROUTINE LAPAP.GET.CUS.NAME
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)

    FN.ACC = "F.ACCOUNT$HIS"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)

    ACC = COMI
    CALL LAPAP.VERIFY.ACC(ACC,RES)
    Y.ACC.ID = RES

    CALL F.READ.HISTORY(FN.ACC,Y.ACC.ID,R.ACC,F.ACC,ERRAC)
    CUSTOMER = R.ACC<AC.CUSTOMER>

    CALL F.READ(FN.CUS,CUSTOMER,R.CUS,F.CUS,ERC)
    CUS = R.CUS<EB.CUS.SHORT.NAME>

    COMI = CUS

END
