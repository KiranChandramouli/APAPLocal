SUBROUTINE REDO.CONV.PAY.MET.ESP
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Program   Name    :REDO.CONV.PAY.MET.ESP
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is a conversion routine used to fetch the description of EB.LOOKUP ID
* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 20-10-2011         MARIMUTHU S   PACS00126000        Initial Creation
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:


    Y.ID = O.DATA

    VAR.VIRTUAL.TABLE = 'PAYMENT.METHOD'
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
    VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part of @ID
    VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>      ;*Description field values
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS

    LOCATE Y.ID IN VIRTUAL.TABLE.IDS SETTING POS THEN
        TXN.FX.RCEP.METHOD = VIRTUAL.TABLE.VALUES<POS,LNGG>
    END

    O.DATA = TXN.FX.RCEP.METHOD

RETURN

PGM.END:

END
