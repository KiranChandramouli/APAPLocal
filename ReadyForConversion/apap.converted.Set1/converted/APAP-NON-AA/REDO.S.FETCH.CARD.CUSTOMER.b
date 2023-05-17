SUBROUTINE REDO.S.FETCH.CARD.CUSTOMER(IN.PARAM)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :KAVITHA
*Program   Name    :REDO.S.FETCH.CARD.CUSTOMER
*-------------------------------------------------------------------------------

*DESCRIPTION       :This subroutine is used to get the value of system time and will update the deal slip DCARD.RECEIPT
*
* ----------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* Revision History
*-------------------------
*    Date             Who               Reference       Description
* 01-JUL-2011        KAVITHA            PACS00062260    Initial creation
*----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.LATAM.CARD.ORDER

    FN.CUST='F.CUSTOMER'
    F.CUST=''
    CALL OPF(FN.CUST,F.CUST)

    Y.CUST.ID = R.NEW(CARD.IS.CUSTOMER.NO)<1,1>
    CALL F.READ(FN.CUST,Y.CUST.ID,R.CUSTOMER,F.CUST,CUS.ERROR)
    IF R.CUSTOMER THEN
        IN.PARAM = R.CUSTOMER<EB.CUS.NAME.1>
    END


RETURN
END
