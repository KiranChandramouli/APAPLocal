*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.GEN.ACSTMT.FORM.RT.LOAD
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT BP I_F.ST.LAPAP.CONTROL.ESTADOS
    $INSERT LAPAP.BP I_LAPAP.GEN.ACSTMT.FORM.RT.COMMON

    FN.ACCOUNT = 'FBNK.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CE = 'FBNK.ST.LAPAP.CONTROL.ESTADOS'
    F.CE = ''
    CALL OPF(FN.CE,F.CE)

    FN.CAT = 'FBNK.ST.LAPAP.EC.CATEGORIA'
    F.CAT = ''
    CALL OPF(FN.CAT,F.CAT)

    FN.CUS = 'FBNK.CUSTOMER'
    F.CUS = ''
    CALL OPF(FN.CUS,F.CUS)

    FN.ES = "../bnk.interface/ESTADO"
    FV.ES = ""
    CALL OPF(FN.ES,FV.ES)


END
