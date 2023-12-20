$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.REL.DESC

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.E.CNV.REL.DESC
*---------------------------------------------------------

* Description : This subroutine is attached as a conversion routine to THE ENQUIRY REPO.CU.VINCULADOS
* to populate the label NOMBRE/RAZON SOCIAL
* If the field L.CU.TIPO.CL has the value "PERSONA FISICA" OR "CLIENTE MENOR" then
* concat the "GIVEN.NAMES" field and "FAMILY.NAME" field from CUSTOMER application
* If the field L.CU.TIPO.CL has the value "PERSONA JURIDICA" then concat the
* "NAME.1" field and "NAME.2" field from CUSTOMER application

*----------------------------------------------------------
* Linked With : Enquiry REPO.CU.VINCULADOS
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
* Modification History:
*----------------------------------------------------------
*
* 31-May-2010 - HD1021443
* This section of routine will remove entries, which has RELATION.CODE specified not in range from 1 to 299
*
* 02-Jun-2010 - HD1021443
* Modification made on referring to gosub WITH.RG.1.299.ONLY section for the ENQUIRY REDO.CUST.RELATION.VINC only
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM , = to EQ , -- to -= and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*----------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.RELATION.CUSTOMER

    GOSUB INITIALIZE
    GOSUB OPENING
    GOSUB FIELD.CHECK

    IF ENQ.SELECTION<1> EQ "REDO.CUST.RELATION.VINC" THEN
        GOSUB WITH.RG.1.299.ONLY
    END

RETURN

INITIALIZE:
*------------------------------------------------------------
* The variables are initialized here
*------------------------------------------------------------

    REF.POS = ''
    CONCAT1 = ''

RETURN
*------------------------------------------------------------
OPENING:
*------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN

FIELD.CHECK:
*------------------------------------------------------------
* The local field L.CU.TIPO.CL value is checked here and based on the result,
* the values are concatenated
*------------------------------------------------------------

    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',REF.POS)
    CUSTOMER.ID = O.DATA
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    O.DATA = ''

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "CLIENTE MENOR" THEN
        O.DATA = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,REF.POS> EQ "PERSONA JURIDICA" THEN
            O.DATA = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
    END

RETURN

*------------------------------------------------------------
WITH.RG.1.299.ONLY:
*------------------------------------------------------------
* This section of routine will remove entries, which has RELATION.CODE specified not in range from 1 to 299

    IS.RELATIONS.CNT = DCOUNT(R.RECORD<EB.RCU.IS.RELATION>,@VM)

    IS.RELATION.NO = 1
    LOOP
    WHILE IS.RELATION.NO LE IS.RELATIONS.CNT
        IF R.RECORD<EB.RCU.IS.RELATION,IS.RELATION.NO> GE 1 AND R.RECORD<EB.RCU.IS.RELATION,IS.RELATION.NO> LE 299 ELSE
            DEL R.RECORD<EB.RCU.IS.RELATION,IS.RELATION.NO>
            DEL R.RECORD<EB.RCU.OF.CUSTOMER,IS.RELATION.NO>
            IS.RELATION.NO -= 1
            IS.RELATIONS.CNT -= 1
        END
        IS.RELATION.NO += 1
    REPEAT

    VM.COUNT = DCOUNT(R.RECORD<EB.RCU.IS.RELATION>,@VM)

RETURN

END
