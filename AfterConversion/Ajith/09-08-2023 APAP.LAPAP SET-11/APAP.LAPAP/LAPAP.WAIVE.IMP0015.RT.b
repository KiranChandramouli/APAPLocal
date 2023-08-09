$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.WAIVE.IMP0015.RT
    $INSERT  I_COMMON
    $INSERT  I_EQUATE ;*R22 Manual Code Conversion
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER ;*R22 Manual Code Conversion
    $INSERT  I_F.CUSTOMER ;*R22 Manual Code Conversion
*---------------------------------------------
*By: J.Q. - APAP , on May 2nd 2023.
*Desc: This program check whether given unique beneficiary account belongs to the holder, if so, we waive IMP 0015...
*

*----------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
* Date                  Who                               Reference           Description
* ----                  ----                                ----                 ----
*09-08-2023         Ajith Kumar         R22 Manual Code Conversion     TAM.BP,LAPAP.BP,T24.BP IS REMOVED


* ----------------------------------------------------------------------------
    GOSUB PRELIM.CHECK

    IF(Y.SHOULD.CONTINUE EQ 1) THEN
        GOSUB DO.INI
        GOSUB DO.PROCESS
    END
RETURN

PRELIM.CHECK:
    Y.SHOULD.CONTINUE =0;

    IF (PGM.VERSION EQ ',L.APAP.ACH.UNI') OR (PGM.VERSION EQ ',L.APAP.LBTR.UNI') THEN
        Y.SHOULD.CONTINUE = 1;
    END

RETURN

DO.INI:
    FN.ACCOUNT  = 'FBNK.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'FBNK.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    Y.APPL.NAME = "FUNDS.TRANSFER" : @FM : "CUSTOMER"
    Y.FLD.NAME = "L.ACH.PART.ID" : @VM : "L.TT.WV.TAX" : @VM : "L.TT.WV.TAX" : @FM : "L.CU.CIDENT"
    CALL MULTI.GET.LOC.REF(Y.APPL.NAME,Y.FLD.NAME,FLD.POS.ARR)
    Y.L.ACH.PART.ID.POS = FLD.POS.ARR<1,1>
    Y.L.TT.WV.TAX.POS = FLD.POS.ARR<1,2>
    Y.L.CU.CIDENT.POS = FLD.POS.ARR<2,1>

RETURN

DO.PROCESS:
    Y.ACCOUNT.ID =  R.NEW(FT.DEBIT.ACCT.NO)

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    IF (R.ACCOUNT) THEN
        Y.CUST.ID = R.ACCOUNT<AC.CUSTOMER>
        GOSUB DO.READ.CUST
*
*Usar Multi Loc Ref mejor, por la premura lo hago asi...
*CALL GET.LOC.REF("FUNDS.TRANSFER","L.ACH.PART.ID",Y.L.ACH.PART.ID.POS)
*CALL GET.LOC.REF("FUNDS.TRANSFER","L.TT.WV.TAX",Y.L.TT.WV.TAX.POS)
        Y.BEN.CIDENT = R.NEW(FT.LOCAL.REF)<1,Y.L.ACH.PART.ID.POS>
        IF Y.BEN.CIDENT EQ '' THEN
            Y.BEN.CIDENT = R.NEW(FT.BEN.CUSTOMER)<1,2>
        END
        IF Y.BEN.CIDENT EQ Y.OWNING.CIDENT THEN
            R.NEW(FT.LOCAL.REF)<1,Y.L.TT.WV.TAX.POS> = 'No'
        END


    END
RETURN

DO.READ.CUST:
    CALL F.READ(FN.CUSTOMER,Y.CUST.ID,R.CUST,F.CUSTOMER,CUSTOMER.ERR)

*CALL GET.LOC.REF("CUSTOMER","L.CU.CIDENT",Y.L.CU.CIDENT.POS)
    Y.OWNING.CIDENT = R.CUST<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT.POS>

RETURN

END
