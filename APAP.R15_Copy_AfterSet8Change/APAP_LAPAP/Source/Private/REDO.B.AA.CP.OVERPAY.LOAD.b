$PACKAGE APAP.LAPAP
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
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*20-07-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*20-07-2023       Samaran T               R22 Manual Code Conversion       INSERT FILE MODIFIED
*-------------------------------------------------------------------------------------------
    $INSERT  I_COMMON  ;*R22 MANUAL CODE CONVERSION.START
    $INSERT  I_EQUATE
    $INSERT  I_F.DATES
    $INSERT  I_F.REDO.AA.CP.OVERPAYMENT
    $INSERT  I_F.REDO.AA.OVERPAYMENT
    $INSERT  I_REDO.B.AA.OVERPAY.COMMON ;*R22 MANUAL CODE CONVERSION.END


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
