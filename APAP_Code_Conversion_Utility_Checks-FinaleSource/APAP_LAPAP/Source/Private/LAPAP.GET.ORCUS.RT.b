* @ValidationCode : MjotMjA5Mzg2NzA2NzpDcDEyNTI6MTY5MTY2NjI1NDYwMDpJVFNTOi0xOi0xOjM3NzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Aug 2023 16:47:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 377
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.GET.ORCUS.RT
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*09/08/2023          Suresh            R22 Manual Conversion          T24.BP is removed
*----------------------------------------------------------------------------------------
    $INSERT I_EQUATE ;*R22 Manual Conversion - Start
    $INSERT I_COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT ;*R22 Manual Conversion - End

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
    Y.ACCOUNT.ID =  COMI      ;*R.NEW(FT.DEBIT.ACCT.NO)
    IF Y.ACCOUNT.ID EQ '' THEN
        Y.ACCOUNT.ID = R.NEW(FT.DEBIT.ACCT.NO)
    END

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    IF (R.ACCOUNT) THEN
        Y.CUST.ID = R.ACCOUNT<AC.CUSTOMER>
        GOSUB DO.READ.CUST
*
        Y.CEDULA = R.CUST<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT.POS>
        Y.NOMBRE = R.CUST<EB.CUS.NAME.1>
        Y.DIR1   = R.CUST<EB.CUS.STREET>
        Y.DIR2   = R.CUST<EB.CUS.TOWN.COUNTRY>
        Y.DIR3   = R.CUST<EB.CUS.COUNTRY>


        R.NEW(FT.ORDERING.CUST) = '/':Y.CEDULA:@VM:Y.NOMBRE:@VM:Y.DIR1:@VM:Y.DIR2         ;*:@VM: Y.DIR3
    END
RETURN

DO.READ.CUST:
    CALL F.READ(FN.CUSTOMER,Y.CUST.ID,R.CUST,F.CUSTOMER,CUSTOMER.ERR)


RETURN

END

