SUBROUTINE REDO.V.VAL.STO.BEN.CARD
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.ACCOUNT.SEARCH
*---------------------------------------------------------------------------------
*Description        :Attached to STO version to check card belongs to beneficiary or not
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-nov-2010        Prabhu.N       ODR-2010-08-0031   Initial Creation
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDING.ORDER
    $INSERT I_System
    IF VAL.TEXT NE '' THEN
        RETURN
    END
    GOSUB INIT
RETURN

*---------
INIT:
*---------

    CUSTOMER.ID=System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CUSTOMER.ID = ""
    END
    Y.CARD.NO=COMI
    FN.CUS.BEN.LIST='F.CUS.BEN.LIST'
    F.CUS.BEN.LIST=''
    CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)
    CUS.BEN.LIST.ID = CUSTOMER.ID:'-OWN'
    CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)
    LOCATE COMI IN R.CUS.BEN.LIST SETTING Y.BEN.POS ELSE
        ETEXT = 'EB-INVALID.CARD'
        CALL STORE.END.ERROR
    END
RETURN
END
