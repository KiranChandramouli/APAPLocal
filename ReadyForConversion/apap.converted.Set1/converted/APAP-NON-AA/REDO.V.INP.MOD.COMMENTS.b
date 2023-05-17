SUBROUTINE REDO.V.INP.MOD.COMMENTS
*--------------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is the subroutine, which checks the old value and new value for the field
* L.IM.COMMENTS. If the New value is null or if the new value is same as the old
* value of this field then error message should be displayed

* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*--------------------------------------------------------------------------------

* Revision History
* ----------------

* Date Name Reference Description
* ---- ---- --------- -----------

* 15-JUL-09 KARTHI.K.R(TEMENOS) ODR-2009-07-0064 Initial Version

*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.IM.DOCUMENT.IMAGE


    GOSUB LOC.REF.POS
    GOSUB PROCESS

RETURN

*--------------------------
PROCESS:
*--------------------------
    IF V$FUNCTION EQ 'R' THEN
        RETURN
    END

    Y.OLD.VALUE = R.OLD(IM.DOC.LOCAL.REF)<1, L.IM.COMMENTS.POS>
    Y.NEW.VALUE = R.NEW(IM.DOC.LOCAL.REF)<1, L.IM.COMMENTS.POS>

* Checking the new value, if its null then display error

    IF Y.OLD.VALUE EQ "" THEN
        IF Y.NEW.VALUE EQ "" THEN
            GOSUB DISPLAY.ERROR
        END
    END

* Comparing old and new value, if they are equal then display error

    IF Y.OLD.VALUE EQ Y.NEW.VALUE THEN
        GOSUB DISPLAY.ERROR
    END

RETURN

*--------------------------
DISPLAY.ERROR:
*--------------------------

    AF = IM.DOC.LOCAL.REF
    AV = L.IM.COMMENTS.POS
    ETEXT = "IM-COMM.ERROR"
    CALL STORE.END.ERROR

RETURN

*--------------------------
LOC.REF.POS:
*--------------------------

    L.IM.COMMENTS.POS = ""
    CALL GET.LOC.REF('IM.DOCUMENT.IMAGE','L.IM.COMMENTS',L.IM.COMMENTS.POS)

RETURN
*-----------------------------------------------------------------------------
END
*-----------------------------------------------------------------------------
