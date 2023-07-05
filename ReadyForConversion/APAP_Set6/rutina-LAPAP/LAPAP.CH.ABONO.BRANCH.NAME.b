*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.CH.ABONO.BRANCH.NAME
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT T24.BP I_F.COMPANY

    Y.BRANCH.ID         = O.DATA

    FN.COMPANY = 'F.COMPANY';
    F.COMPANY = '';
    CALL OPF(FN.COMPANY, F.COMPANY)

    R.COMPANY.LIST = ''; COMPANY.ERR = '';
    CALL F.READ(FN.COMPANY,Y.BRANCH.ID,R.COMPANY.LIST,F.COMPANY,COMPANY.ERR)
    Y.BRANCH.NAME       = R.COMPANY.LIST<EB.COM.COMPANY.NAME>

    O.DATA                = Y.BRANCH.NAME
    RETURN
END
