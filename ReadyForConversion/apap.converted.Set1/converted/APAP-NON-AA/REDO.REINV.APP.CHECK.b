SUBROUTINE REDO.REINV.APP.CHECK

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.APP.CHECK
*--------------------------------------------------------------------------------
* Description: This Validation routine is to check whether the selected APP is of type - REINVESTED
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE            DESCRIPTION
* 04-Jul-2011    H GANESH      PACS00072695-N.11   INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER=''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

    LOC.REF.APPLICATION="AZ.PRODUCT.PARAMETER":@FM:"ACCOUNT"
    LOC.REF.FIELDS='L.AZ.RE.INV.CAT':@VM:'L.APP.INT.LIQ':@FM:'L.AZ.APP'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AZ.RE.INV.CAT = LOC.REF.POS<1,1>
    POS.L.APP.INT.LIQ   = LOC.REF.POS<1,2>
    POS.L.AZ.APP        = LOC.REF.POS<2,1>

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    Y.CATEGORY = COMI

    IF COMI EQ '' THEN
        R.NEW(AC.LOCAL.REF)<1,POS.L.AZ.APP> = ''
        R.NEW(AC.INTEREST.LIQU.ACCT) = ''
        RETURN
    END

    SEL.CMD = "SELECT ":FN.AZ.PRODUCT.PARAMETER:" WITH ALLOWED.CATEG EQ ":COMI
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.APP.ID = SEL.LIST<1>
    CALL CACHE.READ(FN.AZ.PRODUCT.PARAMETER,Y.APP.ID,R.APP,APP.ERR)
    Y.REINV.CATEG = R.APP<AZ.APP.LOCAL.REF,POS.L.AZ.RE.INV.CAT>
    Y.INT.LIQ.ACC = R.APP<AZ.APP.LOCAL.REF,POS.L.APP.INT.LIQ>

    IF Y.INT.LIQ.ACC EQ '' THEN
        ETEXT = 'EB-REDO.INT.LIQ.MISS'
        CALL STORE.END.ERROR
        RETURN
    END
    IF Y.REINV.CATEG EQ '' THEN
        ETEXT = 'EB-REINV.CATEG'
        CALL STORE.END.ERROR
        RETURN
    END ELSE
        R.NEW(AC.LOCAL.REF)<1,POS.L.AZ.APP> = Y.APP.ID
        R.NEW(AC.INTEREST.LIQU.ACCT) = Y.INT.LIQ.ACC
    END

RETURN
END
