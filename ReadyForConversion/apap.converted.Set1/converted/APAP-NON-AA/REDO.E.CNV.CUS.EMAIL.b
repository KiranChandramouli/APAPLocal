SUBROUTINE REDO.E.CNV.CUS.EMAIL


* Revision History:
*------------------
*   Date               who           Reference            Description
* 10-JUL-2015        Prabhu.N        ISSUE IN MONITOR WS     Initial Creation
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON

    GOSUB INITIALISE
    GOSUB READ.AND.ASSIGN
RETURN

*----------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------


    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER =''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN
*-----------------------------------------------------------------
READ.AND.ASSIGN:
*-----------------------------------------------------------------


    Y.CUSTOMER.NO=O.DATA
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.NO,R.CUSTOMER,F.CUSTOMER,Y.ERR)
    O.DATA=R.CUSTOMER<EB.CUS.EMAIL.1><1,1>
RETURN
END
