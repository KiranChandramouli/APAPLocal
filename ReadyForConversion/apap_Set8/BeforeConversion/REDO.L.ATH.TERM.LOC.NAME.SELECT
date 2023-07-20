*-----------------------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.L.ATH.TERM.LOC.NAME.SELECT

    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_BATCH.FILES
    $INCLUDE TAM.BP I_F.REDO.ATH.SETTLMENT
    $INCLUDE TAM.BP I_REDO.L.ATH.TERM.LOC.NAME.COMMON

    GOSUB INIT
    GOSUB PROCESS
    RETURN

INIT:
*****
    SEL.ATH = ''; SEL.LIST = ''; NO.OF.RECS = ''; SEL.ERR = ''
    RETURN

PROCESS:
********
*   IF YSTART.DATE NE YEND.DATE THEN
*       SEL.ATH = "SELECT ":FN.REDO.ATH.SETTLMENT:" WITH PROCESS.DATE GE ":YSTART.DATE:" AND PROCESS.DATE LT ":YEND.DATE
*   END ELSE
* Updated to select and process all the record for extract purpose
    SEL.ATH = "SELECT ":FN.REDO.ATH.SETTLMENT:" WITH PROCESS.DATE GE ":YSTART.DATE
    CALL EB.READLIST(SEL.ATH,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
    RETURN
END
