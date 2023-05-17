SUBROUTINE REDO.V.TEL.CUS.NAME
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.TELLER.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN : -NA-
* OUT : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.TEL.CUS.NAME
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*27-05-2011 Sudharsanan S PACS00062653 Initial Description
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.REDO.TT.GROUP.PARAM
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON

    IF OFS.VAL.ONLY EQ '1' AND MESSAGE EQ '' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
RETURN
*---
INIT:
*---
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    LREF.APPL = 'CUSTOMER'
    LREF.FIELDS = 'L.CU.TIPO.CL'
    LREF.POS = ''
    CALL GET.LOC.REF(LREF.APPL,LREF.FIELDS,LREF.POS)
    TIPO.CL.POS = LREF.POS
RETURN
*-------
PROCESS:
*-------
*To validate the fields and updates the value
    Y.CUSTOMER = COMI
    GOSUB CHECK.CUS.NAME
RETURN
*---------------------------------------------------------------------------------------
CHECK.CUS.NAME:
*-------------------------------------------------------------------------------------------
    R.CUSTOMER = '' ; CUS.ERR1 = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUS.ERR1)
    IF R.CUSTOMER THEN
        VAR.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS>
        BEGIN CASE
            CASE VAR.TIPO.CL EQ 'PERSONA FISICA'
                VAR.GIV.NAM = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
                VAR.FAM.NAM = R.CUSTOMER<EB.CUS.FAMILY.NAME>
                Y.CUS.NAME = VAR.GIV.NAM:" ":VAR.FAM.NAM
            CASE VAR.TIPO.CL EQ 'PERSONA JURIDICA'
                VAR.NAME1=R.CUSTOMER<EB.CUS.NAME.1>
                VAR.NAME2=R.CUSTOMER<EB.CUS.NAME.2>
                Y.CUS.NAME = VAR.NAME1:VAR.NAME2
            CASE OTHERWISE
                VAR.GIV.NAM = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
                VAR.FAM.NAM = R.CUSTOMER<EB.CUS.FAMILY.NAME>
                Y.CUS.NAME = VAR.GIV.NAM:" ":VAR.FAM.NAM
        END CASE
        R.NEW(TEL.PRO.CLIENT.NAME) = Y.CUS.NAME
    END
RETURN
*-------------------------------------------------------------------------------------------
END
