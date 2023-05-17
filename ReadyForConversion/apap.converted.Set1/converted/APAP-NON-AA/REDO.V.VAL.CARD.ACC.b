SUBROUTINE REDO.V.VAL.CARD.ACC
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.CREDIT
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it in R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0536    Initial Creation
* 03-DEC-2010        Prabhu.N       ODR-2010-11-0211    Modified based on Sunnel
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    IF VAL.TEXT EQ '' THEN
        IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
            Y.ARRAY='BUSCAR_TARJETA_CUENTA.FT'
        END
        CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
        COMI=COMI[1,4]:'********':COMI[13,4]
        Y.CARD.CLIENT=Y.ARRAY<15>
        CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            CUSTOMER.ID = ""
        END
        IF CUSTOMER.ID NE Y.CARD.CLIENT THEN
            ETEXT="EB-INVALID.CARD"
            CALL STORE.END.ERROR
        END
    END
RETURN
END
