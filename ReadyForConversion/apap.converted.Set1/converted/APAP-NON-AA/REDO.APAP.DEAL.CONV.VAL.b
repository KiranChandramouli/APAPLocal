SUBROUTINE REDO.APAP.DEAL.CONV.VAL(Y.VAL)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.APAP.DEAL.CONV.VAL
*Reference Number  :ODR-2007-10-0074
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to display N/A text if value is not present
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

OPENFILE:
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN

PROCESS:

    LOC.POS = ''
    CALL MULTI.GET.LOC.REF('CUSTOMER','L.CU.RNC',LOC.POS)
    VAR.RNC.POS = LOC.POS
    CALL F.READ(FN.CUSTOMER,Y.VAL,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
    VAR.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF><1,VAR.RNC.POS>

    IF VAR.RNC EQ '' THEN
        Y.VAL = 'N/A'
    END
    ELSE
        Y.VAL = VAR.RNC
    END
RETURN
END
