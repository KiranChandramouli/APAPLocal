* @ValidationCode : Mjo2NDUxNjI1NjpDcDEyNTI6MTY4NDIyMjgwODkyNTpJVFNTOi0xOi0xOjQ4NzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 487
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*Modification history
*Date                Who               Reference                  Description
*24-04-2023      conversion tool     R22 Auto code conversion     No changes
*24-04-2023      Mohanraj R          R22 Manual code conversion   CALL method format changed
SUBROUTINE LAPAP.FIND.JOINT.HOLDER2

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)

    FN.HIS = "F.ACCOUNT$HIS"
    F.HIS = ""
    CALL OPF(FN.HIS,F.HIS)

*-----------------------
* Verifying Account type
*-----------------------

    ACC = COMI
    APAP.LAPAP.lapapVerifyAcc(ACC,RES);* R22 Manual conversion
    Y.ACC.ID = RES

*-------------------------
* If Account is a reinvest
*-------------------------

    IF ACC NE Y.ACC.ID THEN

        CALL F.READ(FN.ACC,Y.ACC.ID,R.ACC,F.ACC,ERR)
        JOINT.HOLDER = R.ACC<AC.JOINT.HOLDER,2>
        RELATION.CODE = R.ACC<AC.RELATION.CODE,2>

        IF RELATION.CODE EQ 500 OR RELATION.CODE EQ 501 THEN
            COMI = JOINT.HOLDER
        END ELSE
            COMI = ""
        END

        RETURN

    END ELSE

*---------------------------
* If account is not reinvest
*---------------------------

        CALL F.READ(FN.ACC,ACC,R.ACC,F.ACC,ERR)
        JOINT.HOLDER = R.ACC<AC.JOINT.HOLDER,2>
        RELATION.CODE = R.ACC<AC.RELATION.CODE,2>

        IF RELATION.CODE EQ 500 OR RELATION.CODE EQ 501 THEN
            COMI = JOINT.HOLDER
        END ELSE
            COMI = ""
        END

        IF ERR THEN

*---------------------------------------------
* If account not reinvest is closed via teller
*---------------------------------------------

            CALL F.READ.HISTORY(FN.HIS,ACC,R.HIS,F.HIS,ERRH)
            JOINT.HOLDER.HIS = R.HIS<AC.JOINT.HOLDER,2>
            RELATION.CODE.HIS = R.HIS<AC.RELATION.CODE,2>

            IF RELATION.CODE.HIS EQ 500 OR RELATION.CODE.HIS EQ 501 THEN
                COMI = JOINT.HOLDER.HIS
            END ELSE
                COMI = ""
            END

        END

        RETURN

    END

END
