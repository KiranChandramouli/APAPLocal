SUBROUTINE REDO.I.CARD.TYPE
**********************************************************************
* Company Name : ASOCIACISN POPULAR DE AHORROS Y PRISTAMOS
* Developed By : S.DHAMU
* Program Name : REDO.I.CARD.TYPE
************************************************************************
*Description : This routine is to restrict to assign same BIN for
* different CARD.TYPE
**************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.CARD.TYPE

    GOSUB INIT
    GOSUB PROCESS

RETURN
*-----
INIT:
*-----

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)


RETURN



*--------
PROCESS:
*--------

    Y.L.CT.BIN.POS = ''
    CALL GET.LOC.REF('CARD.TYPE','L.CT.BIN',Y.L.CT.BIN.POS)
    BIN.ID = R.NEW(CARD.TYPE.LOCAL.REF)<1,Y.L.CT.BIN.POS>
    CALL F.READ(FN.REDO.CARD.BIN,BIN.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,REDO.BIN.ERR)
    CARD.TYPE.VAL = ''
    CARD.TYPE.VAL = R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
    IF CARD.TYPE.VAL NE '' AND CARD.TYPE.VAL NE ID.NEW THEN
        AF = REDO.CARD.BIN.LOCAL.REF
        AV = Y.L.CT.BIN.POS
        ETEXT = "BIN-ALREADY ASSIGNED"
        CALL STORE.END.ERROR
    END

RETURN
*******************************
END
