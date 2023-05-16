* @ValidationCode : Mjo1ODg2MzQ4MzY6Q3AxMjUyOjE2ODIwNzQ0NDU2Mzg6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:24:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MON.GET.AZ.EMPLOYEE.HIS

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE            WHO               REFERENCE               DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023   Narmadha V          R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER ;*R22 Auto conversion - END


    FN.ACC = "F.ACCOUNT$HIS"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)


    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)

    ID = COMI


    CALL F.READ.HISTORY(FN.ACC,ID,R.HIS,F.ACC,ERRH)
    CUSTOMER  = R.HIS<AC.CUSTOMER>
    CALL F.READ(FN.CUS,CUSTOMER,R.CUS,F.CUS,ERRCUS)
    FAX = R.CUS<EB.CUS.FAX.1>

    IF FAX NE '' THEN
        COMI = "S"
    END ELSE
        COMI = "N"
    END

RETURN



END
