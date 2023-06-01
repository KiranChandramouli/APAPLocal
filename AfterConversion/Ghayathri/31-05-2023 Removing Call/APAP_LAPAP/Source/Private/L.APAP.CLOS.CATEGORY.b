* @ValidationCode : MjoxNDY1MTc1MTcwOkNwMTI1MjoxNjg1NTI5Mjc1MzE2OmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 16:04:35
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
SUBROUTINE L.APAP.CLOS.CATEGORY
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      CALL RTN FORMAT MODIFIED
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE

    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE ;*R22 Auto conversion - END

    FN.ACC = "F.ACCOUNT$HIS"
    FV.ACC = ""
    CALL OPF(FN.ACC,FV.ACC)

    FN.ACL = "F.ACCOUNT"
    F.ACL = ""
    CALL OPF(FN.ACL,F.ACL)

    ACC = COMI
*CALL LAPAP.VERIFY.ACC(ACC,RES)
    APAP.LAPAP.lapapVerifyAcc(ACC,RES) ;*R22 MANAUAL CODE CONVERSION
    Y.ACC.ID = RES

    IF ACC NE Y.ACC.ID THEN

        CALL F.READ(FN.ACL,Y.ACC.ID,R.ACL,F.ACL,ERR.ACL)
        CUSTOMER.CAT = R.ACL<AC.CATEGORY>
        COMI = CUSTOMER.CAT

    END ELSE

        CALL EB.READ.HISTORY.REC(FV.ACC,Y.ACC.ID,R.ACC,ACC.ERROR)
        CUSTOMER.CAT = R.ACC<AC.CATEGORY>
        COMI = CUSTOMER.CAT

    END

RETURN

END
