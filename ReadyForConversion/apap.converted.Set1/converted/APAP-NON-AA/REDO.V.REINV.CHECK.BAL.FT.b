SUBROUTINE REDO.V.REINV.CHECK.BAL.FT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.REINV.CHECK.BAL.FT
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
* This validation routine should be attached to the VERSION FUNDS.TRANSFER,REINV.WDL
* to populate check and compare the reinvested interest amount withdrawal. The system
* should permit to withdraw only the reinvested interest amount and it should not
* allow to overdraw
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 14-06-2010 SUJITHA.S ODR-2009-10-0332 INITIAL CREATION
* 05-04-2011 H GANESH N.11 - PACS00030247 Changes Made
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
* DEBUG
    GOSUB INIT
    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------------------

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    R.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.APPLICATION="FUNDS.TRANSFER":@FM:"ACCOUNT"
    LOC.REF.FIELDS='L.FT.AZ.ACC.REF':@FM:'L.AC.AV.BAL'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.FT.AZ.ACC.REF=LOC.REF.POS<1,1>
    POS.L.AC.AV.BAL=LOC.REF.POS<2,1>

    Y.ACC.REF = R.NEW(FT.LOCAL.REF)<1,POS.L.FT.AZ.ACC.REF>

    IF Y.ACC.REF EQ '' THEN
        RETURN
    END

RETURN

*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------

    Y.ACCOUNT.ID=R.NEW(FT.DEBIT.ACCT.NO)
    Y.AMOUNT=COMI
    IF Y.ACCOUNT.ID THEN
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
        Y.OUTSTDBAL=R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.AV.BAL>
    END
    IF Y.AMOUNT LT Y.OUTSTDBAL THEN
    END ELSE
        ETEXT="FT-REINV.WDL"
        CALL STORE.END.ERROR
    END
RETURN
END
