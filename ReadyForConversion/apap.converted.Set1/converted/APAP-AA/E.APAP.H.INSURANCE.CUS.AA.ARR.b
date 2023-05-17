SUBROUTINE E.APAP.H.INSURANCE.CUS.AA.ARR (ENQ.DATA)
*
*
*=====================================================================
* Subroutine Type : BUILD ROUTINE
* Attached to     :
* Attached as     :
* Primary Purpose :
*---------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : pgarzongavilanes
* Date            : 2011-07-07
*=====================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
*
************************************************************************
*


    CUSTOMER.LIST = R.NEW(INS.DET.CUSTOMER)
    CUSTOMER.LIST = CHANGE(CUSTOMER.LIST,@VM," ")

    ENQ.DATA<2,1> = "CUSTOMER"
    ENQ.DATA<3,1> = "EQ"
    ENQ.DATA<4,1> = CUSTOMER.LIST

RETURN



END
