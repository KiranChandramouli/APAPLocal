$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.LETTER.CUST
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH*
* PROGRAM NAME: REDO.VAL.LETTER.CUST
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Validation Routine for REDO.LETTER.ISSUE to
*default the value for the fields
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.03.2010  H GANESH     ODR-2009-10-0838   INITIAL CREATION

** 18-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 18-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.LETTER.ISSUE


    GOSUB INIT
    GOSUB OPENFILES
    GOSUB LOCAL.REF
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN
*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------

    LOC.REF.APPLICATION="CUSTOMER"
    LOC.REF.FIELDS='L.CU.TIPO.CL':@VM:'L.CU.RNC':@VM:'L.CU.CIDENT'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
RETURN


*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------


    POS.L.CU.TIPO.CL=LOC.REF.POS<1,1>
    POS.L.CU.RNC=LOC.REF.POS<1,2>
    POS.L.CU.CIDENT=LOC.REF.POS<1,3>
    Y.CUSTOMER.ID=COMI
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.NAME=R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TIPO.CL>

    GOSUB DEFAULT.NAME

RETURN

*----------------------------------------------------------------------
DEFAULT.NAME:
*----------------------------------------------------------------------

* It defaults the customer name as per the type of Customer

    IF Y.NAME EQ 'PERSONA FISICA' THEN
        R.NEW(REDO.LET.ISS.CU.NAME)=R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
        IF R.CUSTOMER<EB.CUS.LEGAL.ID,1> NE '' THEN
            R.NEW(REDO.LET.ISS.CU.IDENTITY)=R.CUSTOMER<EB.CUS.LEGAL.ID,1>
        END ELSE
            R.NEW(REDO.LET.ISS.CU.IDENTITY)=R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.CIDENT>
        END
    END

    IF Y.NAME EQ 'PERSONA JURIDICA' THEN
        R.NEW(REDO.LET.ISS.CU.NAME)=R.CUSTOMER<EB.CUS.NAME.1>
        R.NEW(REDO.LET.ISS.CU.IDENTITY)=R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.RNC>
    END
    Y.RNC   = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.RNC>
    Y.TYPE.OF.LETTER = R.NEW(REDO.LET.ISS.TYPE.OF.LETTER)
    IF  Y.TYPE.OF.LETTER EQ 'COMMERCIAL' AND NOT(Y.RNC) THEN
        ETEXT = 'EB-COMMERCIAL.LETTER.PJ'
        CALL STORE.END.ERROR
    END
RETURN
