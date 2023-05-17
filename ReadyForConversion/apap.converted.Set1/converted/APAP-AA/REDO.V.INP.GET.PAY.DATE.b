SUBROUTINE REDO.V.INP.GET.PAY.DATE
*-----------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.V.INP.GET.PAY.DATE
*-----------------------------------------------------------------
* Description : This routine will get trigger while lending-applypayment, to store the paid date
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017      17-MAR-2012          Initial draft
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON

    FN.REDO.GET.REPAID.DATE = 'F.REDO.GET.REPAID.DATE'
    F.REDO.GET.REPAID.DATE = ''
    CALL OPF(FN.REDO.GET.REPAID.DATE,F.REDO.GET.REPAID.DATE)

    Y.ARR.ID = c_aalocArrId
    Y.REPAY.DTE = c_aalocActivityEffDate

    CALL F.WRITE(FN.REDO.GET.REPAID.DATE,Y.ARR.ID,Y.REPAY.DTE)

RETURN

END
