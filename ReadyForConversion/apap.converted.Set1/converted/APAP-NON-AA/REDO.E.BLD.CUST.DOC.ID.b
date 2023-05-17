SUBROUTINE REDO.E.BLD.CUST.DOC.ID(ENQ.DATA)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : RIYAS
* Program Name  : REDO.E.BLD.CUST.DOC.ID
*-------------------------------------------------------------------------

* Description : This is a Build routine which manipulate the customer account isd

* In parameter : ENQ.DATA
* out parameter : ENQ.DATA
* Linked with : Build routine for the enquiry ENQ.CERT.CHEQ.ACCT.NO
*-------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUST.DOCUMENT
    GOSUB PROCESS
RETURN
PROCESS:
***********

    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CUSTOMER.ID = ""
    END
    CUST.DOC.ID = CUSTOMER.ID:'*':'ACTDATOS'
    ENQ.DATA<2,1> = '@ID'
    ENQ.DATA<3,1> = 'EQ'
    ENQ.DATA<4,1> = CUST.DOC.ID



RETURN
************************************************************************
END
