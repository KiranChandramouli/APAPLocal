SUBROUTINE LAPAP.CLOS.IDENT

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.CUSTOMER

    FN.ACC = "F.ACCOUNT$HIS"
    FV.ACC = ""
    CALL OPF(FN.ACC,FV.ACC)

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)

    FN.ACL = "F.ACCOUNT"
    F.ACL = ""
    CALL OPF(FN.ACL,F.ACL)

    ACC = COMI
    CALL LAPAP.VERIFY.ACC(ACC,RES)
    Y.ACC.ID = RES

    IF ACC NE Y.ACC.ID THEN

*CALL F.READ(FN.ACL,Y.ACC.ID,R.ACL,F.ACL,ERR.ACL)
        CALL EB.READ.HISTORY.REC(FV.ACC,Y.ACC.ID,R.ACL,ACC.ERR)
        customer = R.ACL<AC.CUSTOMER>

        CALL LAPAP.CUSTOMER.IDENT(customer,IDENT,IDENTYPE,NAME,LASTN,DEFV)
        COMI = IDENT

    END ELSE

        CALL EB.READ.HISTORY.REC(FV.ACC,Y.ACC.ID,R.ACC,ACC.ERR)
        customer = R.ACC<AC.CUSTOMER>

        CALL LAPAP.CUSTOMER.IDENT(customer,IDENT,IDENTYPE,NAME,LASTN,DEFV)
        COMI = IDENT

    END

RETURN

END
