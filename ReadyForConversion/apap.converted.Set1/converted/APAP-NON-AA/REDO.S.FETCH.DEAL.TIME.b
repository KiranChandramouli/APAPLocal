SUBROUTINE REDO.S.FETCH.DEAL.TIME(RES)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Prabhu N
*Program   Name    :REDO.S.FETCH.ADDRESS
*-------------------------------------------------------------------------------

*DESCRIPTION       :This subroutine is used to get the value of system time and will update the deal slip DCARD.RECEIPT
*
* ----------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* Revision History
*-------------------------
*    Date             Who               Reference       Description
* 23-MAY-2011        Prabhu.N           PACS00060198    Initial creation
*----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.CARD.ORDER
    RES=TIME()
    RES=OCONV(RES,"MTHS")
RETURN
END
