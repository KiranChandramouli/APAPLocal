*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.CORR.CASTIG.SEQPROT.LOAD
*
* Client Name   : APAP
* Develop By    : Ashokkumar
* Description   : The routine to adjust the Insurance (SEGPROTFIN1) amount for the castigado prestamos.
*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_L.APAP.CORR.CASTIG.SEQPROT.COMMON


    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'; F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'; F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'; F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    CALL GET.LOC.REF('AA.PRD.DES.OVERDUE','L.LOAN.STATUS.1',L.LOAN.STATUS.1.POSN)
    RETURN
END
