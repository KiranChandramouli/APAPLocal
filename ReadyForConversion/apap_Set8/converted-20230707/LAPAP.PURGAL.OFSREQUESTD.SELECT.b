SUBROUTINE LAPAP.PURGAL.OFSREQUESTD.SELECT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_LAPAP.PURGAL.OFSREQUESTD.COMMON
    $INSERT I_F.OFS.REQUEST.DETAIL


    SELECT.STATEMENT = "SELECT F.OFS.REQUEST.DETAIL WITH @ID UNLIKE ..." : Y.LAST.DAY : "..."
    PURGA.LIST = ""
    LIST.NAME = ""
    SELECTED = ""
    SYSTEM.RETURN.CODE = ""
    CALL EB.READLIST(SELECT.STATEMENT,PURGA.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    CALL BATCH.BUILD.LIST('',PURGA.LIST)

END
