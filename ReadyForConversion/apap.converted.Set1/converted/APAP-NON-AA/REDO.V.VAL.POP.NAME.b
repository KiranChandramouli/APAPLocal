SUBROUTINE REDO.V.VAL.POP.NAME
****************************************************************************************************************
*Company Name : Asociaciopular de Ahorros y Pramos Bank
*Developed By : NARESH.CHAVADAPU(nareshc@temenos.com)
*Date : 28-10-2009
*Program Name : REDO.V.VAL.POP.NAME
*Reference Number : ODR-2009-10-0807
*----------------------------------------------------------------------------------------------------------------
*Description : This routine serves as a field level validation for the field L.CU.TIPO.CL
*Linked With : version CUSTOMER,REDO.OPEN.PROSP.PF.TEST,CUSTOMER,REDO.OPEN.CL.MINOR.TEST,CUSTOMER,REDO.OPEN.CLIENTE.PF.TEST,
* CUSTOMER,REDO.MOD.CL.MINOR.TEST,CUSTOMER,REDO.ACT.MOD.CL.PF.TEST
*In Parameter : NA
*Out Parameter : NA
*05-MAR-2011 Prabhu N HD1053255 Routine Modified as Validation routine and it will update the customer name based on given name and family name
*02072013 LAST
*------insert files-----------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*------------
OPEN.FILES:
*------------

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN
*--------
PROCESS:
*--------

    Y.GIVEN.NAMES = R.NEW(EB.CUS.GIVEN.NAMES)
    IF NOT(OFS$BROWSER) THEN
        Y.FAMILY.NAMES = R.NEW(EB.CUS.FAMILY.NAME)
    END ELSE
        Y.FAMILY.NAMES =COMI
    END

    FIELD.POS = ''
    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',FIELD.POS)
    Y.LOCAL.VAR = R.NEW(EB.CUS.LOCAL.REF)<1,FIELD.POS>
    IF Y.LOCAL.VAR NE 'PERSONA JURIDICA' AND Y.GIVEN.NAMES AND Y.FAMILY.NAMES THEN
        Y.NAME = Y.GIVEN.NAMES:" ":Y.FAMILY.NAMES
        Y.LEN = LEN(Y.NAME)
        IF Y.LEN GT '35' THEN
            R.NEW(EB.CUS.NAME.1) = Y.NAME[1,35]
            R.NEW(EB.CUS.NAME.2) = Y.NAME[36,35]
        END ELSE
            R.NEW(EB.CUS.NAME.1) = Y.NAME
        END
    END
RETURN
*---------------------------------------------------------------
END
