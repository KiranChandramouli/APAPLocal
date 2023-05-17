SUBROUTINE REDO.V.INP.DFLT.PRIN.AMT
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.V.INP.DFLT.PRIN.AMT.DETAILS
*----------------------------------------------------------

* Description : This Routine Stores the amount in principal field into ORIG.DEP.AMT
* field when value entered in MATURITY.INSTR field is 'AUTOMATIC ROLLOVER'

* Linked with : NONE
* In Parameter : None
* Out Parameter: None
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*02/12/2009 - ODR-2009-10-0537
*Development for storing amount in principal field to ORIG.DEP.AMT field
*------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.AZ.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*----*
INIT:
*----*
    LREF.APP='AZ.ACCOUNT'
    LREF.FIELD='ORIG.DEP.AMT'
    LREF.POS=''
    Y.AZ.PRODUCT.PARAM.ID=''
    R.AZ.PRODUCT.PARAMETER=''
    FN.AZ.PRODUCT.PARAM='F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAM=''
    CALL OPF(FN.AZ.PRODUCT.PARAM,F.AZ.PRODUCT.PARAM)
    Y.AZ.APP.MATURITY.INSTR=''
RETURN
*-------*
PROCESS:
*-------*
    CALL GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    Y.AZ.PRODUCT.PARAM.ID=R.NEW(AZ.ALL.IN.ONE.PRODUCT)
    CALL CACHE.READ(FN.AZ.PRODUCT.PARAM,Y.AZ.PRODUCT.PARAM.ID,R.AZ.PRODUCT.PARAMETER,AZ.ERR)
    Y.AZ.APP.MATURITY.INSTR=R.AZ.PRODUCT.PARAMETER<AZ.APP.MATURITY.INSTR>
    Y.AZ.PRODUCT.TYPE=R.AZ.PRODUCT.PARAMETER<AZ.APP.LOAN.DEPOSIT>
    IF Y.AZ.APP.MATURITY.INSTR EQ "AUTOMATIC ROLLOVER" AND Y.AZ.PRODUCT.TYPE EQ "DEPOSIT" THEN
        IF R.NEW(AZ.CURR.NO) LE 1 AND R.NEW(AZ.PRINCIPAL) NE '' THEN
            R.NEW(AZ.LOCAL.REF)<1,LREF.POS>=R.NEW(AZ.PRINCIPAL)
        END
    END
RETURN
END
