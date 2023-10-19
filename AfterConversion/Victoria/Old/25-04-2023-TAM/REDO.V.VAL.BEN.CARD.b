$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.BEN.CARD
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.ACCOUNT.SEARCH
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it it R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0536   Initial Creation
* 03-DEC-2010        Prabhu.N       ODR-2010-11-0211    Modified based on Sunnel
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     IF BLOCK ADDED
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_System
    IF VAL.TEXT NE '' THEN
        RETURN
    END
    GOSUB INIT
RETURN

*---------
INIT:
*---------
    FN.CUS.BEN.LIST='F.CUS.BEN.LIST'
    F.CUS.BEN.LIST=''
    CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)
    LREF.APP=APPLICATION
    LREF.POS=''
    LREF.FIELDS='L.FT.CR.CARD.NO'
    CUSTOMER.ID=System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CONVERSION START
        CUSTOMER.ID = ""
    END ;*R22 AUTO CONVERSION END

    CUS.BEN.LIST.ID = CUSTOMER.ID:'-OWN'
    CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)
    LOCATE COMI IN R.CUS.BEN.LIST<1> SETTING Y.BEN.POS ELSE
        ETEXT = 'EB-INVALID.CARD'
        CALL STORE.END.ERROR
    END
    GOSUB PROCESS
    VAR.CARD.NO=R.NEW(FT.LOCAL.REF)<1,LREF.POS>
    VAR.CARD.NO=VAR.CARD.NO[1,6]:'******':VAR.CARD.NO[13,4]
    R.NEW(FT.LOCAL.REF)<1,LREF.POS>=VAR.CARD.NO

RETURN
*-------
PROCESS:
*-------
    CALL MULT.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    Y.ARRAY='BUSCAR_TARJETA_CUENTA.2'
    CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
RETURN
END
