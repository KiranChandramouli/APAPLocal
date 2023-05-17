SUBROUTINE REDO.GET.INVENTORY.DETAIL(Y.FINAL.NAME)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.INVENTORY.DETAIL
* ODR NUMBER    : PACS00099482
*--------------------------------------------------------------------------------------
* Description   : This routine attached deal slip to print details
* In parameter  : none
* out parameter : none
*--------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE                      DESCRIPTION
* 05-08-2011      JEEVA T            B.42                             INTITAL DEV
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.H.ORDER.DETAILS
MAIN:

    GOSUB GET.DETAILS
    GOSUB PROCESS
    GOSUB PGM.END
RETURN

GET.DETAILS:

    Y.SERIES.FROM   = R.NEW(RE.ORD.SERIES.FROM)
    Y.SERIES.TO     = R.NEW(RE.ORD.SERIES.TO)

RETURN


PROCESS:

    Y.FINAL.NAME =Y.SERIES.FROM:' - ':Y.SERIES.TO
RETURN

PGM.END:

END
