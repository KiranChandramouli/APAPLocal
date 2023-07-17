$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CNV.CUST.DOC
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      FS-360       Manju.G          For enquiry REDO.CUSTOMER.VIEW
*
*  DATE             WHO                   REFERENCE 
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM 
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------------------------
*------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER

    GOSUB INITIALISE
    GOSUB PROCESS
*
RETURN

INITIALISE:
*************

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN

PROCESS:
**********

    LREF.FIELDS = 'L.CU.CIDENT':@VM:'L.CU.NOUNICO':@VM:'L.CU.RNC':@VM:'L.CU.ACTANAC':@VM:'L.CU.AGE':@VM:'L.CU.TIPO.CL'
    Y.LREF.POS = ''
    CALL MULTI.GET.LOC.REF('CUSTOMER',LREF.FIELDS,Y.LREF.POS)
    Y.L.CU.CIDENT.POS = Y.LREF.POS<1,1>
    Y.L.CU.NOUNICO.POS = Y.LREF.POS<1,2>
    Y.L.CU.RNC.POS = Y.LREF.POS<1,3>
    Y.L.CU.ACTANAC.POS = Y.LREF.POS<1,4>
    CUSTOMER.ID = O.DATA
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    O.DATA = ''
    Y.L.CU.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF><1,Y.L.CU.CIDENT.POS>
    Y.L.CU.NOUNICO = R.CUSTOMER<EB.CUS.LOCAL.REF><1,Y.L.CU.NOUNICO.POS>
    Y.L.CU.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF><1,Y.L.CU.RNC.POS>
    Y.L.CU.ACTANAC = R.CUSTOMER<EB.CUS.LOCAL.REF><1,Y.L.CU.ACTANAC.POS>
    Y.LEGAL.ID = R.CUSTOMER<EB.CUS.LEGAL.ID><1,1>

    BEGIN CASE
        CASE Y.L.CU.CIDENT
            O.DATA = Y.L.CU.CIDENT
        CASE Y.LEGAL.ID
            O.DATA = Y.LEGAL.ID
        CASE Y.L.CU.NOUNICO
            O.DATA = Y.L.CU.NOUNICO
        CASE Y.L.CU.ACTANAC
            O.DATA = Y.L.CU.ACTANAC
        CASE Y.L.CU.RNC
            O.DATA = Y.L.CU.RNC
    END CASE


RETURN
END
