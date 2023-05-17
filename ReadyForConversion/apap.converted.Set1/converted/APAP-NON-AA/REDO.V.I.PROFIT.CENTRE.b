SUBROUTINE REDO.V.I.PROFIT.CENTRE

*If no customer account is input at version value at PROFIT.CENTRE.DEPT should be 60199556002, VP TESORERIA.
*If there is a customer account at transaction,  then, PROFIT.CENTRE.CUST should  be automatically populated from customer account.
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_PROFIT.DEPT.COMMON

    IF R.NEW(FT.PROFIT.CENTRE.DEPT) THEN
        Y.PROFIT.DEPT = R.NEW(FT.PROFIT.CENTRE.DEPT)
    END
    IF Y.PROFIT.DEPT EQ '' OR Y.PROFIT.DEPT EQ 0 THEN
        RETURN
    END


    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    DBT.ACC=R.NEW(FT.DEBIT.ACCT.NO)
    CR.ACCT=R.NEW(FT.CREDIT.ACCT.NO)


    CALL F.READ(FN.ACCOUNT,DBT.ACC,R.DBT.ACCT,F.ACCOUNT,Y.ERR)
    CALL F.READ(FN.ACCOUNT,CR.ACCT,R.CRD.ACCT,F.ACCOUNT,Y.ERR)


    DR.CUS=R.DBT.ACCT<AC.CUSTOMER>
    CR.CUS=R.CRD.ACCT<AC.CUSTOMER>
    DR.NOSTRO.FLAG=R.DBT.ACCT<AC.LIMIT.REF>
    CR.NOSTRO.FLAG=R.CRD.ACCT<AC.LIMIT.REF>
    DR.INT.FLAG=0
    IF DR.CUS EQ '' THEN
        DR.INT.FLAG=1
    END




    IF DR.NOSTRO.FLAG EQ 'NOSTRO' OR (DR.INT.FLAG  AND CR.NOSTRO.FLAG EQ 'NOSTRO') THEN

        IF R.NEW(FT.PROFIT.CENTRE.DEPT) EQ '' THEN
            R.NEW(FT.PROFIT.CENTRE.DEPT) = Y.PROFIT.DEPT
        END
    END ELSE

        R.NEW(FT.PROFIT.CENTRE.DEPT) = ''
    END


*60199556002         *

RETURN

END
