SUBROUTINE REDO.V.VAL.ACTA.NAC
*-------------------------------------------------------------------------------
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : NARESH.CHAVADAPU(nareshc@temenos.com)
*Date              : 28-10-2009
*Program   Name    : REDO.V.VAL.ACTA.NAC
*Reference Number  : ODR-2009-10-0807
*-----------------------------------------------------------------------------------------------------------------
*Description       : This routine serves as a field level validation for the field l.cu.actanac***
*Linked With       : NA
*In  Parameter     : NA
*Out Parameter     : NA
*------insert files-----------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB PROCESS
RETURN

*---------
PROCESS:
*----------------------------------------------------------------------------------
* The local field value is checked for its length and error is thrown based on it
*-----------------------------------------------------------------------------------

    Y.TEMP.VAR=COMI
    Y.COUNT.VAR=LEN(Y.TEMP.VAR)
    LOC.REF.APPLICATION = 'CUSTOMER'
    LOC.REF.FIELDS='L.CU.ACTANAC'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.ACTANAC = LOC.REF.POS<1,1>
    IF Y.TEMP.VAR NE '' THEN
        IF Y.COUNT.VAR NE 20 THEN
            AF = EB.CUS.LOCAL.REF
            AV = POS.ACTANAC
            ETEXT='EB-REDO.INVALID.DOC.FORMAT'
            CALL STORE.END.ERROR
        END
    END
RETURN
*----------------------------------------------------------------------------
END
