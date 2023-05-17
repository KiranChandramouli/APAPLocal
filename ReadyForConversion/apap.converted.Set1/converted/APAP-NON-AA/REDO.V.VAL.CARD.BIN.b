SUBROUTINE REDO.V.VAL.CARD.BIN
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*------------------------------------------------------------------------------

*Description  : This routine is validation routine attached to version CARD.TYPE,REDO.CARD.TYPE to validate bin number entered
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : CARD.TYPE

*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 11-09-2010     SWAMINATHAN            ODR-2010-03-0400          Initial Creation
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.BIN

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    Y.BIN = COMI
    CALL F.READ(FN.REDO.CARD.BIN,Y.BIN,R.REDO.CARD.BIN,F.REDO.CARD.BIN,Y.ERR.BIN.CARD)
    IF R.REDO.CARD.BIN EQ '' THEN
        ETEXT= "EB-BIN.NO"
        CALL STORE.END.ERROR
    END
RETURN
END
