*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.JSON.OUT

$INSERT T24.BP I_COMMON
$INSERT T24.BP I_EQUATE
$INSERT BP I_F.L.APAP.JSON.TO.OFS

GOSUB PROCESS
RETURN 

PROCESS: 
*----------

IF R.NEW(ST.JSON.OPERATION.TYPE) EQ "OUT" AND  R.NEW(ST.JSON.OBJECT) NE "NONE" THEN
    TEXT="L.APAP.OUT.JSON"
    CURR.NO=1
    CALL STORE.OVERRIDE(CURR.NO)
    RETURN
END 
RETURN
END
