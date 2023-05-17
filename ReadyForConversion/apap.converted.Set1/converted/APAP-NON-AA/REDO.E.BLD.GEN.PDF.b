SUBROUTINE REDO.E.BLD.GEN.PDF(ENQ.DATA)

*----------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.E.BLD.REL.CU
*----------------------------------------------------------
* Description : This subroutine is attached as a build routine in the Enquiry REPO.CU.VINCULADOS
* to populate the label rel.code as per the relatione code range

* Linked with : Enquiry REPO.CU.VINCULADOS as build routine
* In Parameter : ENQ.DATA
* Out Parameter : ENQ.DATA
*-----------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.ISSUE.CLAIMS

    ENQ.DATA<2,-1> = '@ID'
    ENQ.DATA<3,-1> = 'EQ'

    FN.CUS.BEN.LIST = 'F.CUS.BEN.LIST'
    F.CUS.BEN.LIST  = ''
    CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)

    CUS.BEN.LIST.ID = R.NEW(ISS.CL.CUSTOMER.CODE):'-CLAIM'
    CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)

    ENQ.DATA<4,-1> = R.CUS.BEN.LIST

RETURN
*------------------------------------------------------------------------------
END
