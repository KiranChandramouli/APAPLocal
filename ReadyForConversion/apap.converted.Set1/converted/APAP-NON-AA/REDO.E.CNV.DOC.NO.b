SUBROUTINE REDO.E.CNV.DOC.NO

************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.E.CNV.DOC.NO
*----------------------------------------------------------

* Description : This subroutine is attached as a conversion routine in the Enquiry REPO.CU.VINC.CUSPROF
* to populate the label NO.DOCUMENTO
* Here,we read the CUSTOMER application and retrieve the necessary details and using the Loop
* check for the value in it and populate it in the enquiry

* Linked with : Enquiry REPO.CU.VINC.CUSPROF as conversion routine
* In Parameter : None
* Out Parameter : None

*-------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON

    GOSUB INITIALISE
    GOSUB OPENING
    GOSUB READ.AND.ASSIGN
    GOSUB CHECK.VALUES

RETURN

*----------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------

    PARAM1 = ''
    PARAM2 = ''
    PARAM3 = ''
    PARAM4 = ''
    PARAM5 = ''
    APP.ARR = ''
    FLD.ARR = ''
    POS.ARR = ''
    REF.POS1 = 0
    REF.POS2 = 0
    REF.POS3 = 0
    REF.POS4 = 0
    CUSTOMER.ID = ''

RETURN

*-----------------------------------------------------------------
OPENING:
*-----------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN

*-----------------------------------------------------------------
READ.AND.ASSIGN:
*-----------------------------------------------------------------
* Value of O.DATA is assigned to Customer ID to read the particular customer data
*-----------------------------------------------------------------

    CUSTOMER.ID = O.DATA
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)

*-----------------------------------------------------------------
* Here, we are getting the position of all the local reference fields using MULTI.GET.LOC.REF
*-----------------------------------------------------------------
    APP.ARR='CUSTOMER'
    FLD.ARR='L.CU.CIDENT':@VM:'L.CU.NOUNICO':@VM:'L.CU.RNC':@VM:'L.CU.ACTANAC'

    CALL MULTI.GET.LOC.REF(APP.ARR,FLD.ARR,POS.ARR)
    REF.POS1 = POS.ARR<1,1>
    REF.POS2 = POS.ARR<1,2>
    REF.POS3 = POS.ARR<1,3>
    REF.POS4 = POS.ARR<1,4>

    PARAM1 = R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS1>
    PARAM2 = R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS2>
    PARAM3 = R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS3>
    PARAM4 = R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS4>
    PARAM5 = R.CUSTOMER<EB.CUS.LEGAL.ID>
RETURN

*---------------------------------------------------------------------
CHECK.VALUES:
*---------------------------------------------------------------------

    BEGIN CASE
        CASE PARAM1 NE ""
            O.DATA = PARAM1
        CASE PARAM2 NE ""
            O.DATA = PARAM2
        CASE PARAM3 NE ""
            O.DATA = PARAM3
        CASE PARAM4 NE ""
            O.DATA = PARAM4
        CASE PARAM5 NE ""
            O.DATA = PARAM5
        CASE OTHERWISE
            O.DATA = ''
    END CASE

RETURN

END
