* @ValidationCode : MjotNDYwMjE0ODI6Q3AxMjUyOjE2ODQyMjI4MDUxMjQ6SVRTUzotMTotMToyOTY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 296
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
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
