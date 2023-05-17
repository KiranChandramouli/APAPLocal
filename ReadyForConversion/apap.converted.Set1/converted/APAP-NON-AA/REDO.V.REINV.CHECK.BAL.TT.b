SUBROUTINE REDO.V.REINV.CHECK.BAL.TT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.REINV.CHECK.BAL.TT
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*       This validation routine should be attached to the VERSION TELLER,REINV.WDL
* to populate check and compare the reinvested interest amount withdrawal. The system
* should permit to withdraw only the reinvested interest amount only and it should not
* allow to overdraw
*---------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 15-06-2010      SUJITHA.S   ODR-2009-10-0332  INITIAL CREATION
* 05-04-2011     H GANESH     N.11 - PACS00030247  Changes Made
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT

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


    LOC.REF.APPLICATION="TELLER":@FM:"ACCOUNT"
    LOC.REF.FIELDS='L.TT.AZ.ACC.REF':@FM:'L.AC.AV.BAL'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.TT.AZ.ACC.REF=LOC.REF.POS<1,1>
    POS.L.AC.AV.BAL=LOC.REF.POS<2,1>

    IF R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.AZ.ACC.REF> EQ '' THEN
        RETURN
    END

RETURN

*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

    Y.ACCOUNT.ID=R.NEW(TT.TE.ACCOUNT.2)
    Y.AMOUNT=COMI

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
    Y.OUTSTDBAL=R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.AV.BAL>

    IF Y.AMOUNT LT Y.OUTSTDBAL THEN
    END ELSE
        ETEXT="TT-REINV.WDL"
        CALL STORE.END.ERROR
    END
RETURN
END
