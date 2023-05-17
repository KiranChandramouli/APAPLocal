SUBROUTINE REDO.V.VAL.LIMIT.CHECK

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.V.VAL.LIMIT.CHECK
*-------------------------------------------------------------------------
* Description: This routine is a validation routine which is attached to USER, LIMIT for L.US.APPROVE.LIM field
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2009-10-0334                 Initial Creation
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.REDO.APAP.CLEARING.INWARD

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
    LOC.APPLICATION = 'USER'
    LOC.FIELDS = 'L.US.TRANSIT.LI':@VM:'L.US.OD.LIM':@VM:'L.US.APPROV.LIM'
    LOC.POS = ''

RETURN

OPENFILES:

    FN.USER = 'F.USER'
    F.USER = ''
    CALL OPF(FN.USER,F.USER)

RETURN

PROCESS:
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    LOC.TRANSIT.LIM.POS = LOC.POS<1,1>
    LOC.OD.LIMT.POS = LOC.POS<1,2>
    LOC.APPROVE.LIM.POS = LOC.POS<1,3>

    VAR.TRANS.LIM = R.NEW(EB.USE.LOCAL.REF)<1,LOC.TRANSIT.LIM.POS>
    VAR.OD.LIMIT = R.NEW(EB.USE.LOCAL.REF)<1,LOC.OD.LIMT.POS>
    VAR.APPROVE.LIM = R.NEW(EB.USE.LOCAL.REF)<1,LOC.APPROVE.LIM.POS>

    VAR.TOT.TRANS.OD = VAR.TRANS.LIM  + VAR.OD.LIMIT
    IF VAR.TOT.TRANS.OD NE VAR.APPROVE.LIM THEN
        AF = EB.USE.LOCAL.REF
        AV = LOC.APPROVE.LIM.POS
        ETEXT = "EB-LIMIT.NOT.EQUAL"
        CALL STORE.END.ERROR
    END
    IF VAR.TRANS.LIM GT VAR.APPROVE.LIM THEN
        AF = EB.USE.LOCAL.REF
        AV = LOC.TRANSIT.LIM.POS
        ETEXT = "EB-GT.TRANSIT.LIMIT"
        CALL STORE.END.ERROR
    END
    IF VAR.OD.LIMIT GT VAR.APPROVE.LIM THEN
        AF = EB.USE.LOCAL.REF
        AV = LOC.OD.LIMT.POS
        ETEXT = "EB-GT.OD.LIMIT"
        CALL STORE.END.ERROR
    END
    IF VAR.APPROVE.LIM NE '' THEN
        IF VAR.TRANS.LIM EQ ''  THEN
            AF = EB.USE.LOCAL.REF
            AV = LOC.TRANSIT.LIM.POS
            ETEXT = "EB-INPUT.MISSING"
            CALL STORE.END.ERROR
        END
        IF VAR.OD.LIMIT EQ '' THEN
            AF = EB.USE.LOCAL.REF
            AV = LOC.OD.LIMT.POS
            ETEXT = "EB-INPUT.MISSING"
            CALL STORE.END.ERROR
        END
    END

RETURN
END
