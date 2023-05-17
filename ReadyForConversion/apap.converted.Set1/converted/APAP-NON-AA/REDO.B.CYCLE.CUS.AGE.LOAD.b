SUBROUTINE REDO.B.CYCLE.CUS.AGE.LOAD
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the initialisation of the batch job
* Programmer: M.MURALI (Temenos Application Management)
* Creation Date: 02 Jul 09
*--------------------------------------------------------------------------------
* Modification History:
*
*
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CYCLE.CUS.AGE.COMMON

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.CUSTOMER.DOB = 'F.CUSTOMER.DOB'
    F.CUSTOMER.DOB = ''
    CALL OPF(FN.CUSTOMER.DOB, F.CUSTOMER.DOB)

    CALL GET.LOC.REF('CUSTOMER', 'L.CU.AGE', Y.LR.CU.AGE.POS)


RETURN
*--------------------------------------------------------------------------------
END
*--------------------------------------------------------------------------------
