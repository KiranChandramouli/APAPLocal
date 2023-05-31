* @ValidationCode : Mjo5MDU5MDk0MjA6Q3AxMjUyOjE2ODU1MzM1Mzk5NTU6aGFpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 17:15:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   Call Method Format Modified
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
    APAP.LAPAP.lapapVerifyAcc(ACC,RES);* R22 Manual conversion
    Y.ACC.ID = RES

    IF ACC NE Y.ACC.ID THEN

*CALL F.READ(FN.ACL,Y.ACC.ID,R.ACL,F.ACL,ERR.ACL)
        CALL EB.READ.HISTORY.REC(FV.ACC,Y.ACC.ID,R.ACL,ACC.ERR)
        customer = R.ACL<AC.CUSTOMER>

        APAP.LAPAP.lapapCustomerIdent(customer,IDENT,IDENTYPE,NAME,LASTN,DEFV) ;*R22 Manual Code Conversion-Call Method Format Modified
        COMI = IDENT

    END ELSE

        CALL EB.READ.HISTORY.REC(FV.ACC,Y.ACC.ID,R.ACC,ACC.ERR)
        customer = R.ACC<AC.CUSTOMER>

        APAP.LAPAP.lapapCustomerIdent(customer,IDENT,IDENTYPE,NAME,LASTN,DEFV) ;*R22 Manual Code Conversion-Call Method Format Modified
        COMI = IDENT

    END

RETURN

END
