SUBROUTINE REDO.GET.DEAL.NAME(Y.FINAL.NAME)
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

    GOSUB PROCESS
    GOSUB PGM.END
RETURN

PROCESS:

    Y.FINAL.NAME =FIELD(Y.FINAL.NAME,'_',2)
RETURN

PGM.END:

END
