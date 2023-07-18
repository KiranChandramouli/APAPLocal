
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.PURGAL.OFSREQUESTD.SELECT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT LAPAP.BP I_LAPAP.PURGAL.OFSREQUESTD.COMMON
    $INSERT T24.BP I_F.OFS.REQUEST.DETAIL


    SELECT.STATEMENT = "SELECT F.OFS.REQUEST.DETAIL WITH @ID UNLIKE ..." : Y.LAST.DAY : "..."
    PURGA.LIST = ""
    LIST.NAME = ""
    SELECTED = ""
    SYSTEM.RETURN.CODE = ""
    CALL EB.READLIST(SELECT.STATEMENT,PURGA.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    CALL BATCH.BUILD.LIST('',PURGA.LIST)

END
