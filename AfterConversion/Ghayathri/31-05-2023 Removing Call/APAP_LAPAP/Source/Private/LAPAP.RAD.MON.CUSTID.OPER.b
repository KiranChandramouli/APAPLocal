* @ValidationCode : MjotMjA2MTczNTEwMDpDcDEyNTI6MTY4NTUzNDU0MzY1MTpoYWk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 17:32:23
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
SUBROUTINE LAPAP.RAD.MON.CUSTID.OPER

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                 REFERENCE                   DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion         BP is removed in Insert File, INCLUDE to INSERT
* 21-APR-2023    Narmadha V         R22 Manual Conversion       call routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER ;*R22 Auto conversion - END

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    Y.INIT = ''
    Y.CUST.CODE = COMI
    CALL F.READ(FN.CUSTOMER, Y.CUST.CODE, R.CUSTOMER, F.CUSTOMER, ERR.CUS)

    IF NOT(ERR.CUS) THEN

        CUS.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>

        APAP.LAPAP.drRegGetCustType(R.CUSTOMER, OUT.ARR);* R22 Manual conversion
        Y.CUS.ID = EREPLACE(OUT.ARR<2>, "-", "")

        APAP.LAPAP.lapapGetIdentificationType(R.CUSTOMER, OUT.ARR2) ;*Manual R22 conversion
        Y.ID.TYPE = OUT.ARR2

        IF Y.ID.TYPE EQ 'PAS' AND CUS.NATION NE '' THEN
            Y.INIT = 1 + LEN(CUS.NATION)
            Y.CUS.ID = Y.CUS.ID[Y.INIT,LEN(Y.CUS.ID)]
        END

        COMI = Y.CUS.ID : '@' : Y.ID.TYPE
    END

RETURN
END
