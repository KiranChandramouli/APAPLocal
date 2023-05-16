$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.IDENT.ACH
*----------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER':@FM:'CUSTOMER'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    APPL.ARRAY = "FUNDS.TRANSFER":@FM:"CUSTOMER"
    FIELD.ARRAY = "L.COMMENTS":@FM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.NOUNICO":@VM:"L.CU.ACTANAC"
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
    Y.LOC.COMMENTS.POS = FIELD.POS<1,1>
    Y.L.CU.CIDENT.POS  = FIELD.POS<2,1>
    Y.L.CU.RNC.POS     = FIELD.POS<2,2>
    Y.L.CU.UNICO       = FIELD.POS<2,3>
    Y.L.CU.ACTANAC.POS     = FIELD.POS<2,4>

    CALL F.READ(FN.FUNDS.TRANSFER,COMI,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERR)
    Y.ACCT.NO       = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
    Y.TXN.TYPE      = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    CUSTOMER.NO = R.ACCOUNT<AC.CUSTOMER>


    IF CUSTOMER.NO THEN
        GOSUB PERSONAL.IDENTITY.PARA
    END ELSE
        IF Y.TXN.TYPE EQ 'AC25' THEN
            FILE.PROCESS.ID = R.FUNDS.TRANSFER<FT.LOCAL.REF,Y.LOC.COMMENTS.POS>
            Y.ACCT.NO = FIELD(FILE.PROCESS.ID,'.',5)
            CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
            CUSTOMER.NO = R.ACCOUNT<AC.CUSTOMER>
            GOSUB CORPORATE.IDENTITY.PARA
        END
    END

RETURN
*---------------------
PERSONAL.IDENTITY.PARA:
*---------------------
    L.CU.CIDENT = ''; LEGAL.ID = ''; L.CU.UNICO = ''; Y.L.CU.ACTANAC = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.NO,R.CUSTOMER,F.CUSTOMER,ERR)
    IF R.CUSTOMER THEN
        L.CU.CIDENT  = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT.POS>
        LEGAL.ID     = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
        L.CU.UNICO   = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.UNICO>
        Y.L.CU.ACTANAC = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.ACTANAC.POS>
        Y.REL.CUS = R.ACCOUNT<AC.JOINT.HOLDER,1>
        Y.REL.CODE = R.ACCOUNT<AC.RELATION.CODE,1>

        BEGIN CASE
            CASE L.CU.CIDENT NE ''
                COMI = L.CU.CIDENT
            CASE L.CU.UNICO NE ''
                COMI = L.CU.UNICO
            CASE LEGAL.ID NE ''
                COMI = LEGAL.ID
            CASE Y.L.CU.ACTANAC NE ''

                IF LEN(Y.L.CU.ACTANAC) GT 11 THEN
                    Y.START.POS = (LEN(Y.L.CU.ACTANAC) - 10)
                    COMI = SUBSTRINGS(Y.L.CU.ACTANAC, Y.START.POS, 11)
                END ELSE
                    COMI = Y.L.CU.ACTANAC
                END

        END CASE

* Fix for PACS00428443 [ACH BLANK RNC]

        IF COMI EQ '' THEN
            COMI = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.RNC.POS>
        END

* End of Fix
    END
*---------------PACS00459597-----------------------------------------
    IF COMI EQ "" AND Y.REL.CODE NE "" THEN

        R.CUS = ''
        CALL F.READ(FN.CUSTOMER,Y.REL.CUS,R.CUS,F.CUSTOMER,ERR)

        IF R.CUS THEN
            L.CU.CIDENT  = R.CUS<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT.POS>
            LEGAL.ID     = R.CUS<EB.CUS.LEGAL.ID,1>
            L.CU.UNICO   = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.UNICO>

            IF L.CU.CIDENT THEN
                COMI = L.CU.CIDENT
            END ELSE
                IF L.CU.UNICO THEN
                    COMI = L.CU.UNICO
                END ELSE
                    COMI = LEGAL.ID
                END
            END

        END
        IF COMI EQ '' THEN
            COMI = R.CUS<EB.CUS.LOCAL.REF,Y.L.CU.RNC.POS>
        END
    END
*-------------PACS00459597--------------------------------------------
RETURN
*----------------------
CORPORATE.IDENTITY.PARA:
*----------------------
    CALL F.READ(FN.CUSTOMER,CUSTOMER.NO,R.CUSTOMER,F.CUSTOMER,ERR)
    IF R.CUSTOMER THEN
        L.CU.RNC     = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.RNC.POS>
        LEGAL.ID     = R.CUSTOMER<EB.CUS.LEGAL.ID>
        IF L.CU.RNC THEN
            COMI = L.CU.RNC
        END ELSE
            COMI = LEGAL.ID
        END
    END
RETURN
*----------------------------------------------------------------------------
END
