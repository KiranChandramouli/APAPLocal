SUBROUTINE REDO.APAP.GET.CLIENT.NAME
*-----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* This is Conversion Routine attached attached in Enquiry
* REDO.APAP.ENQ.MOD.CLIENT.RPT
* REDO.APAP.ER.MOD.CLIENT.RPT
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                 Reference
* 06-SEP-10    Kishore.SP            INITIALVERSION
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
*-----------------------------------------------------------------------------
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*----------
*
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-------
*
    CUSTOMER.ID = O.DATA
*
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    IF R.CUSTOMER NE '' THEN
        GOSUB FIND.MULTI.LOCAL.REF
        GOSUB GET.CUS.VAUES
        O.DATA = Y.CUS.NAME
    END ELSE
        O.DATA = ''
    END
*
RETURN
*-----------------------------------------------------------------------------
FIND.MULTI.LOCAL.REF:
*---------------------
    APPL.ARRAY = "CUSTOMER"
    FLD.ARRAY  = "L.CU.TIPO.CL"
    FLD.POS    = " "
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CU.TIPO.CL.POS =  FLD.POS<1,1>
RETURN
*-----------------------------------------------------------------------------
GET.CUS.VAUES:
*-------------
*
    Y.TIPO.CL    = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>
    Y.GVN.NAME   = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
    Y.FAM.NAME   = R.CUSTOMER<EB.CUS.FAMILY.NAME>
    Y.CUS.NAME1  = R.CUSTOMER<EB.CUS.NAME.1>
    Y.CUS.NAME2  = R.CUSTOMER<EB.CUS.NAME.2>
    Y.SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
*
    IF Y.TIPO.CL EQ 'PERSONA FISICA' OR Y.TIPO.CL EQ 'CLIENTE MENOR' THEN
        Y.CUS.NAME = Y.GVN.NAME:" ":Y.FAM.NAME
    END
*
    IF Y.TIPO.CL EQ 'PERSONA JURIDICA' THEN
        Y.CUS.NAME = Y.CUS.NAME1:" ":Y.CUS.NAME2
    END
*
    IF Y.TIPO.CL EQ '' THEN
        Y.CUS.NAME = Y.SHORT.NAME
    END
*
RETURN
