* @ValidationCode : Mjo0NDA2ODE2ODk6Q3AxMjUyOjE2ODQyMjI4MDUyMzQ6SVRTUzotMTotMTozOTU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 395
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   CALL method format changed
SUBROUTINE LAPAP.CLOS.JOINT

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE

    FN.ACC = "F.ACCOUNT$HIS"
    FV.ACC = ""
    CALL OPF(FN.ACC,FV.ACC)

    FN.ACL = "F.ACCOUNT"
    F.ACL = ""
    CALL OPF(FN.ACL,F.ACL)

    ACC = COMI
    CALL APAP.LAPAP.lapapVerifyAcc(ACC,RES);* R22 Manual conversion
    Y.ACC.ID = RES

    IF ACC NE Y.ACC.ID THEN

        CALL F.READ(FN.ACL,Y.ACC.ID,R.ACL,F.ACL,ERR.ACL)
        CUSTOMER.ID = R.ACL<AC.JOINT.HOLDER,1>
        COMI = CUSTOMER.ID

    END ELSE

        CALL F.READ(FN.ACL,ACC,R.ACL,F.ACL,ERR.ACL)
        CUSTOMER.ID = R.ACL<AC.JOINT.HOLDER,1>
        COMI = CUSTOMER.ID

*CALL EB.READ.HISTORY.REC(FV.ACC,ACC.ID,R.ACC,ACC.ERROR2)
*CUSTOMER.ID = R.ACC<AC.JOINT.HOLDER,1>
*CRT CUSTOMER.ID ;* COMI = CUSTOMER.ID

    END

RETURN

END
