SUBROUTINE REDO.V.VAL.PAY.AMT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.ADD.BEN
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it in R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2010-08-0031   Initial Creation
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_System
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FT.BULK.CREDIT.AC
    GOSUB INIT
RETURN
*---
INIT:
*---
    COMI.ENRI = ''
    T.ENRI<FT.BKCRAC.DR.ACCOUNT> = ''
    APPL.ARRAY           = 'ACCOUNT'
    FLD.ARRAY            = 'L.AC.AV.BAL'
    FLD.POS              = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.AC.BAL.POS = FLD.POS<1,1>
    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    Y.CUSTOMER=System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CUSTOMER = ""
    END
    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUSTOMER,R.CUST.ACC,F.CUSTOMER.ACCOUNT,ERR)
    Y.ACCOUNT=COMI
    LOCATE Y.ACCOUNT IN R.CUST.ACC SETTING Y.POS THEN
        F.ACCOUNT = ''
        FN.ACCOUNT = 'F.ACCOUNT'
        CALL OPF(FN.ACCOUNT,F.ACCOUNT)
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
        IF NOT(Y.AC.ERR) THEN
            Y.AC.AVAIL.BAL = R.ACCOUNT<AC.LOCAL.REF,L.AC.BAL.POS>
        END
        IF Y.AC.AVAIL.BAL THEN
            COMI.ENRI = Y.AC.AVAIL.BAL
            T.ENRI<FT.BKCRAC.DR.ACCOUNT> = COMI.ENRI
        END ELSE
            COMI.ENRI = '0.00'
            T.ENRI<FT.BKCRAC.DR.ACCOUNT> = COMI.ENRI
        END
    END
RETURN
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------
