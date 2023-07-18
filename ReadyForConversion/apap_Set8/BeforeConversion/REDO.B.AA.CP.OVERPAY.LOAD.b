*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.AA.CP.OVERPAY.LOAD

*-------------------------------------------------
*Description: This batch routine is to post the FT OFS messages for overpayment
*             and also to credit the interest in loan..
* Dev by: V.P.Ashokkumar
* Date  : 10/10/2016
*-------------------------------------------------
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.DATES
    $INCLUDE LAPAP.BP I_F.REDO.AA.CP.OVERPAYMENT
    $INCLUDE TAM.BP I_F.REDO.AA.OVERPAYMENT
    $INCLUDE LAPAP.BP I_REDO.B.AA.OVERPAY.COMMON


    FN.AA.ARR.PS = 'F.AA.ARR.PAYMENT.SCHEDULE'; F.AA.ARR.PS = ''
    CALL OPF(FN.AA.ARR.PS,F.AA.ARR.PS)
    FN.REDO.AA.CP.OVERPAYMENT = 'F.REDO.AA.CP.OVERPAYMENT'; F.REDO.AA.CP.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.CP.OVERPAYMENT,F.REDO.AA.CP.OVERPAYMENT)
    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'; F.REDO.AA.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    RETURN
END
