* @ValidationCode : MjoxNTk1MjUyOTg3OkNwMTI1MjoxNjg1NTI5MzQxNjI0OmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 16:05:41
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
SUBROUTINE L.APAP.CLOS.OPENDATE
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      CALL method format changed
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - start
    $INSERT I_EQUATE

    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE ;*R22 Auto conversion - end

    FN.ACC = "F.ACCOUNT$HIS"
    FV.ACC = ""
    CALL OPF(FN.ACC,FV.ACC)

    FN.ACL = "F.ACCOUNT"
    F.ACL = ""
    CALL OPF(FN.ACL,F.ACL)

    ACC = COMI
*APAP.LAPAP.LAPAP.VERIFY.ACC(ACC,RES)
    APAP.LAPAP.lapapVerifyAcc(ACC,RES);* R22 Manual conversion - CALL method format changed
    Y.ACC.ID = RES



    IF ACC NE Y.ACC.ID THEN

        CALL EB.READ.HISTORY.REC(FV.ACC,Y.ACC.ID,R.ACL,ACC.ERROR)
        OPEND = R.ACL<AC.OPENING.DATE>
        COMI = OPEND

    END ELSE

        CALL EB.READ.HISTORY.REC(FV.ACC,Y.ACC.ID,R.ACC,ACC.ERROR)
        OPEND = R.ACC<AC.OPENING.DATE>
        COMI = OPEND

    END

RETURN

END
