*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE V.MB.SDB.DFLT.CUSTNO

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.MB.SDB.POST

    FN.CUST = 'F.CUSTOMER'
    F.CUST = ''
    CALL OPF(FN.CUST,F.CUST)

    MEMBR.NO = R.NEW(SDB.POST.CUSTOMER.NO)
    IF R.NEW(SDB.POST.HOLDER.NAME) EQ '' THEN
        FN.CUST = 'F.CUSTOMER' ; F.CUST = ''
        CALL OPF(FN.CUST,F.CUST)

        R.CUST = '' ; CUSTERR = ''
        CALL F.READ(FN.CUST,MEMBR.NO,R.CUST,F.CUST,CUSTERR)
        R.NEW(SDB.POST.HOLDER.NAME) = R.CUST<EB.CUS.SHORT.NAME>
    END

    RETURN

END



