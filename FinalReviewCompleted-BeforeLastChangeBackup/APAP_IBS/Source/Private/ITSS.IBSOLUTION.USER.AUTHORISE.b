$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>100</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ITSS.IBSOLUTION.USER.AUTHORISE
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE


    FN.ITSS.IBSOLUTION.USER.CUSTOMER = "F.ITSS.IBSOLUTION.USER.CUSTOMER"
    F.ITSS.IBSOLUTION.USER.CUSTOMER = ""
    CALL OPF(FN.ITSS.IBSOLUTION.USER.CUSTOMER,F.ITSS.IBSOLUTION.USER.CUSTOMER)

    Y.CUSTOMER.ID = R.NEW(6)

    READ R.ITSS.IBSOLUTION.USER.CUSTOMER FROM F.ITSS.IBSOLUTION.USER.CUSTOMER, Y.CUSTOMER.ID  ELSE
        R.ITSS.IBSOLUTION.USER.CUSTOMER = ''
    END

    LOCATE ID.NEW IN R.ITSS.IBSOLUTION.USER.CUSTOMER SETTING POS.LOGIN ELSE POS.LOGIN = -1

    IF POS.LOGIN EQ -1 THEN
        R.ITSS.IBSOLUTION.USER.CUSTOMER<-1> = ID.NEW
        CALL F.WRITE(FN.ITSS.IBSOLUTION.USER.CUSTOMER,Y.CUSTOMER.ID,R.ITSS.IBSOLUTION.USER.CUSTOMER)
    END



RETURN
